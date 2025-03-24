import 'package:equatable/equatable.dart';

import '../../data/models/transaction_model.dart';

abstract class TransactionState extends Equatable {
  const TransactionState();

  @override
  List<Object?> get props => [];
}

class TransactionInitial extends TransactionState {}

class TransactionLoading extends TransactionState {}

class TransactionLoaded extends TransactionState {
  final List<TransactionModel> transactions;
  final double outstandingBalance; // ✅ Added

  TransactionLoaded({
    required this.transactions,
    required this.outstandingBalance,
  });
  @override
  List<Object?> get props => [transactions, outstandingBalance];
}

class TransactionError extends TransactionState {
  final String message;

  const TransactionError({required this.message});

  @override
  List<Object?> get props => [message];
}