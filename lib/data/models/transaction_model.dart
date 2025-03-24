
import 'package:cloud_firestore/cloud_firestore.dart';

class TransactionModel {
  final String id;
  final double amount;
  final DateTime transactionDate;
  final DateTime? dueDate;
  final String? note;
  final bool settled;

  TransactionModel({
    required this.id,
    required this.amount,
    required this.transactionDate,
    this.dueDate,
    this.note,
    required this.settled,
  });

  factory TransactionModel.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return TransactionModel(
      id: doc.id,
      amount: (data['amount'] as num).toDouble(),
      transactionDate: (data['transactionDate'] as Timestamp).toDate(),
      dueDate: data['due_date'] != null
          ? (data['due_date'] as Timestamp).toDate()
          : null,
      note: data['note'],
      settled: data['settled'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'amount': amount,
      'transactionDate': Timestamp.fromDate(transactionDate),
      'due_date': dueDate != null ? Timestamp.fromDate(dueDate!) : null,
      'note': note,
      'settled': settled,
    };
  }

  // ✅ Add this method to fix the error
  TransactionModel copyWith({
    String? id,
    double? amount,
    DateTime? transactionDate,
    DateTime? dueDate,
    String? note,
    bool? settled,
  }) {
    return TransactionModel(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      transactionDate: transactionDate ?? this.transactionDate,
      dueDate: dueDate ?? this.dueDate,
      note: note ?? this.note,
      settled: settled ?? this.settled,
    );
  }
}
