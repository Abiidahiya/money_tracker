import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/recipents/recipent_bloc.dart';
import '../../bloc/recipents/recipent_event.dart';
import '../../bloc/recipents/recipent_state.dart';
import '../../data/models/recipent_model.dart';
import '../../data/repositories/recipent_repository.dart';

class RecipientList extends StatefulWidget {
  @override
  _RecipientListState createState() => _RecipientListState();
}

class _RecipientListState extends State<RecipientList> with TickerProviderStateMixin {
  late List<Recipient> localRecipients; // Local list for smooth transitions

  @override
  void initState() {
    super.initState();
    localRecipients = []; // Initialize empty list
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RecipientBloc, RecipientState>(
      listener: (context, state) {
        if (state is RecipientLoaded) {
          setState(() {
            localRecipients = List.from(state.recipients); // Only update when necessary
          });
        }
      },
      child: ReorderableListView.builder(
        itemCount: localRecipients.length,
        onReorder: (oldIndex, newIndex) {
          if (newIndex > oldIndex) newIndex--;

          final movedItem = localRecipients.removeAt(oldIndex);
          localRecipients.insert(newIndex, movedItem);

          setState(() {}); // Update UI instantly for smooth effect

          // Dispatch event to update Firestore order
          context.read<RecipientBloc>().add(ReorderRecipients(
            oldIndex: oldIndex,
            newIndex: newIndex,
          ));
        },
        proxyDecorator: (child, index, animation) {
          return AnimatedOpacity(
            opacity: 0.85,
            duration: Duration(milliseconds: 200),
            child: Transform.scale(
              scale: 1.05,
              child: Material(
                elevation: 6,
                color: Colors.transparent,
                child: child,
              ),
            ),
          );
        },
        itemBuilder: (context, index) {
          final recipient = localRecipients[index];

          return AnimatedContainer(
            key: ValueKey(recipient.id), // Unique key
            duration: Duration(milliseconds: 300), // Smooth transition
            curve: Curves.easeInOut,
            margin: EdgeInsets.symmetric(vertical: 6, horizontal: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: ListTile(
              leading: Icon(Icons.person, color: Colors.blue),
              title: Text(
                recipient.name,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                'Outstanding: ₹${recipient.outstandingBalance.toStringAsFixed(2)}',
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
              trailing: Icon(Icons.drag_handle, color: Colors.grey),
            ),
          );
        },
      ),
    );
  }
}
  // Method to delete a recipient
  Future<void> _deleteRecipient(BuildContext context, String recipientId) async {
    print('_deleteRecipient called with recipientId: $recipientId'); // Debug log
    final recipientRepository = context.read<RecipientRepository>();

    try {
      print('Attempting to delete recipient...'); // Debug log
      await recipientRepository.deleteRecipient(recipientId); // Delete from Firestore
      print('Recipient deleted successfully'); // Debug log

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Recipient deleted successfully')),
      );

      // Refresh the list of recipients
      context.read<RecipientBloc>().add(FetchRecipients());
    } catch (e) {
      print('Error deleting recipient: $e'); // Debug log
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete recipient: $e')),
      );
    }
  }
