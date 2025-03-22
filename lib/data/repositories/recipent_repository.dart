import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/recipent_model.dart';

class RecipientRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Get reference to the recipients collection under the authenticated user
  CollectionReference get _recipientsCollection {
    final userId = _auth.currentUser?.uid;
    if (userId == null) {
      throw Exception("User not authenticated");
    }
    return _firestore.collection('users').doc(userId).collection('recipients');
  }

  // Get a specific recipient reference
  DocumentReference getRecipientRef(String recipientId) {
    return _recipientsCollection.doc(recipientId);
  }

  // Fetch recipients as a stream
  Stream<List<Recipient>> getRecipients() {
    return _recipientsCollection
        .orderBy('order')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return Recipient.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    });
  }

  // Update all recipient orders
  Future<void> updateRecipientOrders() async {
    final querySnapshot = await _recipientsCollection.get();

    for (var i = 0; i < querySnapshot.docs.length; i++) {
      final doc = querySnapshot.docs[i];
      await doc.reference.update({'order': i});
    }
  }

  // Update a specific recipient's order
  Future<void> updateRecipientOrder(String id, int order) async {
    await _recipientsCollection.doc(id).update({'order': order});
  }

  // Add a new recipient
  Future<void> addRecipient(Recipient recipient) async {
    final querySnapshot = await _recipientsCollection.get();
    final nextOrder = querySnapshot.size;

    await _recipientsCollection.add({
      ...recipient.toMap(),
      'order': nextOrder,
    });
  }

  // Delete a recipient
  Future<void> deleteRecipient(String recipientId) async {
    await _recipientsCollection.doc(recipientId).delete();
  }
}
