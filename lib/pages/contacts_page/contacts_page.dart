import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../bloc/contacts/contacts_page_event.dart';
import '../../bloc/contacts/contacts_page_state.dart';
import '../../bloc/contacts/contacts_page_bloc.dart';

class ContactsPage extends StatelessWidget {
  const ContactsPage({Key? key}) : super(key: key);

  Future<void> _onContactTap(BuildContext context, String contactName) async {
    final firestore = FirebaseFirestore.instance;
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      print("No authenticated user found!");
      return;
    }

    final userId = user.uid;
    final recipientsCollection = firestore.collection('users').doc(userId).collection('recipients');

    try {
      // Check if the contact already exists in this user's recipients
      final querySnapshot = await recipientsCollection
          .where('name', isEqualTo: contactName)
          .limit(1)
          .get();

      String recipientId;

      if (querySnapshot.docs.isNotEmpty) {
        // Contact already exists, get the existing recipientId
        recipientId = querySnapshot.docs.first.id;
      } else {
        // Contact does not exist, create a new one
        final countQuery = await recipientsCollection.get();
        final nextOrder = countQuery.size; // Assign the next order

        final newRecipientRef = await recipientsCollection.add({
          'name': contactName,
          'outstanding_balance': 0.0, // Initial balance set to 0
          'order': nextOrder,
        });

        recipientId = newRecipientRef.id;
      }

      // Navigate to RecipientProfilePage with the recipientId
      Navigator.popAndPushNamed(
        context,
        '/page1', // Ensure this route leads to RecipientProfilePage
        arguments: recipientId,
      );
    } catch (e) {
      print("Error accessing Firestore: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    context.read<ContactBloc>().add(LoadContactsEvent());
    return Scaffold(
      appBar: AppBar(
        title: const Text("Contacts", style: TextStyle(fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<ContactBloc>().add(RefreshContactsEvent());
            },
          ),
        ],
      ),
      body: BlocBuilder<ContactBloc, ContactState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state.contacts.isEmpty) {
            return const Center(child: Text("No contacts found.", style: TextStyle(fontSize: 16)));
          }

          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            itemCount: state.contacts.length,
            itemBuilder: (context, index) {
              final contactName = state.contacts[index];
              return GestureDetector(
                onTap: () => _onContactTap(context, contactName),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor, // Use theme card color
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.blueGrey[300],
                      child: Text(
                        contactName.isNotEmpty ? contactName[0].toUpperCase() : '?',
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                    title: Text(
                      contactName,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).textTheme.bodyLarge?.color, // Use theme text color
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}