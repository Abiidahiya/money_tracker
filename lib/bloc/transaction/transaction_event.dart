import 'package:equatable/equatable.dart';



abstract class TransactionEvent extends Equatable {
  const TransactionEvent();

  @override
  List<Object?> get props => [];
}

class LoadTransactions extends TransactionEvent {
  final String recipientId;

  const LoadTransactions({required this.recipientId});

  @override
  List<Object?> get props => [recipientId];
}

class AddTransaction extends TransactionEvent {
  final String recipientId;
  final double amount;
  final String type;
  final String? note;
  final DateTime? dueDate;
  final DateTime transactionDate;

  const AddTransaction({
    required this.recipientId,
    required this.amount,
    required this.type,
    this.note,
    this.dueDate,
    required this.transactionDate,
  });

  @override
  List<Object?> get props => [recipientId, amount, note, dueDate];
}

class ToggleTransactionSettled extends TransactionEvent {
  final String recipientId;
  final String transactionId;
  final bool currentStatus;

  const ToggleTransactionSettled({
    required this.recipientId,
    required this.transactionId,
    required this.currentStatus,
  });

  @override
  List<Object?> get props => [recipientId, transactionId, currentStatus];
}

class DeleteTransaction extends TransactionEvent {
  final String recipientId;
  final String transactionId;

  const DeleteTransaction({
    required this.recipientId,
    required this.transactionId,
  });

  @override
  List<Object?> get props => [recipientId, transactionId];
}