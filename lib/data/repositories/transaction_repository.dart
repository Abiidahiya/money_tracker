import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/transaction_model.dart';

class TransactionRepository {
  final FirebaseFirestore firestore;
  final String userId;

  TransactionRepository({required this.firestore, required this.userId});

  /// Stream transactions, ordered by transaction date (descending)
  Stream<List<TransactionModel>> getTransactions(String recipientId) {
    return firestore
        .collection('users')
        .doc(userId)
        .collection('recipients')
        .doc(recipientId)
        .collection('transactions')
        .orderBy('transactionDate', descending: true) // ✅ Fixed orderBy field
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => TransactionModel.fromFirestore(doc)).toList();
    });
  }

  /// Add a new transaction
  Future<void> addTransaction(
      String recipientId,
      double amount,
      {String? note, DateTime? dueDate}
      ) async {
    DocumentReference newTransactionRef = firestore
        .collection('users')
        .doc(userId)
        .collection('recipients')
        .doc(recipientId)
        .collection('transactions')
        .doc();

    TransactionModel newTransaction = TransactionModel(
      id: newTransactionRef.id,
      amount: amount,
      transactionDate: DateTime.now(),  // ✅ Auto-set current date
      dueDate: dueDate ?? DateTime.now().add(Duration(days: 30)), // ✅ Default due date to 30 days later
      note: note,
      settled: false,
    );

    await newTransactionRef.set(newTransaction.toMap());
  }

  /// Toggle a transaction as settled/unsettled
  Future<void> toggleTransactionSettled(String recipientId, String transactionId, bool currentStatus) async {
    await firestore
        .collection('users')
        .doc(userId)
        .collection('recipients')
        .doc(recipientId)
        .collection('transactions')
        .doc(transactionId)
        .update({'settled': !currentStatus});
  }

  /// Delete a transaction
  Future<void> deleteTransaction(String recipientId, String transactionId) async {
    await firestore
        .collection('users')
        .doc(userId)
        .collection('recipients')
        .doc(recipientId)
        .collection('transactions')
        .doc(transactionId)
        .delete();
  }

  /// Calculate outstanding balance for a recipient
  Future<double> getOutstandingBalance(String recipientId) async {
    final querySnapshot = await firestore
        .collection('users')
        .doc(userId)
        .collection('recipients')
        .doc(recipientId)
        .collection('transactions')
        .where('settled', isEqualTo: false)
        .get();

    double totalBalance = querySnapshot.docs.fold(0.0, (sum, doc) {
      return sum + (doc['amount'] as num).toDouble();
    });

    // ✅ Update outstanding balance in Firestore
    await firestore
        .collection('users')
        .doc(userId)
        .collection('recipients')
        .doc(recipientId)
        .update({'outstanding_balance': totalBalance});

    return totalBalance;
  }
}