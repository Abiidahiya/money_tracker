import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/recipent_model.dart';

class RecipientRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get a reference to a specific recipient document
  DocumentReference getRecipientRef(String recipientId) {
    return _firestore.collection('recipients').doc(recipientId);
  }

  // Fetch all recipients as a stream, ordered by the 'order' field
  Stream<List<Recipient>> getRecipients() {
    return _firestore
        .collection('recipients')
        .orderBy('order') // Ensures recipients load in correct order
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return Recipient.fromMap(doc.data(), doc.id);
      }).toList();
    });
  }

  // Update the order of all recipients
  Future<void> updateRecipientOrders() async {
    final querySnapshot = await _firestore.collection('recipients').get();

    for (var i = 0; i < querySnapshot.docs.length; i++) {
      final doc = querySnapshot.docs[i];
      await doc.reference.update({'order': i});
    }
  }

  // Update the order of a specific recipient
  Future<void> updateRecipientOrder(String id, int order) async {
    print('Updating recipient $id with order $order');
    await _firestore.collection('recipients').doc(id).update({
      'order': order,
    });
  }

  // Add a new recipient with an automatically assigned order
  Future<void> addRecipient(Recipient recipient) async {
    // Get the current number of recipients to assign the next order
    final querySnapshot = await _firestore.collection('recipients').get();
    final nextOrder = querySnapshot.size;

    // Add the recipient with the assigned order
    await _firestore.collection('recipients').add({
      ...recipient.toMap(),
      'order': nextOrder, // Assign the next order
    });
  }
  Future<void> deleteRecipient(String recipientId) async {
    await _firestore.collection('recipients').doc(recipientId).delete();
  }
}