import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_tracker/bloc/transaction/transaction_event.dart';
import 'package:money_tracker/bloc/transaction/transaction_state.dart';

import '../../data/models/transaction_model.dart';

class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  final FirebaseFirestore firestore;
  final String userId;

  TransactionBloc({required this.firestore, required this.userId})
      : super(TransactionInitial()) {
    on<LoadTransactions>(_onLoadTransactions);
    on<AddTransaction>(_onAddTransaction);
    on<ToggleTransactionSettled>(_onToggleTransactionSettled);
    on<DeleteTransaction>(_onDeleteTransaction);
  }

  /// Load transactions for a recipient
  Future<void> _onLoadTransactions(
      LoadTransactions event, Emitter<TransactionState> emit) async {
    emit(TransactionLoading());
    try {
      QuerySnapshot transactionSnapshot = await firestore
          .collection('users')
          .doc(userId)
          .collection('recipients')
          .doc(event.recipientId)
          .collection('transactions')
          .orderBy('transactionDate', descending: true)
          .get();

      List<TransactionModel> transactions = transactionSnapshot.docs
          .map((doc) => TransactionModel.fromFirestore(doc))
          .toList();

      double outstandingBalance = transactions
          .where((t) => !t.settled)
          .fold(0.0, (sum, t) => sum + t.amount);

      emit(TransactionLoaded(
        transactions: transactions,
        outstandingBalance: outstandingBalance,
      ));
    } catch (e) {
      emit(TransactionError(message: 'Failed to load transactions: $e'));
    }
  }

  /// Add a new transaction
  Future<void> _onAddTransaction(
      AddTransaction event, Emitter<TransactionState> emit) async {
    if (state is! TransactionLoaded) return;
    final currentState = state as TransactionLoaded;

    DocumentReference newTransactionRef = firestore
        .collection('users')
        .doc(userId)
        .collection('recipients')
        .doc(event.recipientId)
        .collection('transactions')
        .doc();

    TransactionModel newTransaction = TransactionModel(
      id: newTransactionRef.id,
      amount: event.amount,
      transactionDate: event.transactionDate,
      dueDate: event.dueDate, // ✅ Keep dueDate nullable
      note: event.note,
      settled: false,
    );

    emit(TransactionLoaded(
      transactions: [...currentState.transactions, newTransaction],
      outstandingBalance: currentState.outstandingBalance + event.amount,
    ));

    await newTransactionRef.set(newTransaction.toMap());
    await _updateOutstandingBalance(event.recipientId);
  }

  /// Toggle a transaction as settled/unsettled
  Future<void> _onToggleTransactionSettled(
      ToggleTransactionSettled event, Emitter<TransactionState> emit) async {
    if (state is! TransactionLoaded) return;
    final currentState = state as TransactionLoaded;

    List<TransactionModel> updatedTransactions = currentState.transactions.map((t) {
      if (t.id == event.transactionId) {
        return t.copyWith(settled: !event.currentStatus);
      }
      return t;
    }).toList();

    double newBalance = updatedTransactions
        .where((t) => !t.settled)
        .fold(0.0, (sum, t) => sum + t.amount);

    emit(TransactionLoaded(
      transactions: updatedTransactions,
      outstandingBalance: newBalance,
    ));

    await firestore
        .collection('users')
        .doc(userId)
        .collection('recipients')
        .doc(event.recipientId)
        .collection('transactions')
        .doc(event.transactionId)
        .update({'settled': !event.currentStatus});

    await _updateOutstandingBalance(event.recipientId);
  }

  /// Delete a transaction
  Future<void> _onDeleteTransaction(
      DeleteTransaction event, Emitter<TransactionState> emit) async {
    if (state is! TransactionLoaded) return;
    final currentState = state as TransactionLoaded;

    List<TransactionModel> updatedTransactions =
    currentState.transactions.where((t) => t.id != event.transactionId).toList();

    double newBalance = updatedTransactions
        .where((t) => !t.settled)
        .fold(0.0, (sum, t) => sum + t.amount);

    emit(TransactionLoaded(
      transactions: updatedTransactions,
      outstandingBalance: newBalance,
    ));

    await firestore
        .collection('users')
        .doc(userId)
        .collection('recipients')
        .doc(event.recipientId)
        .collection('transactions')
        .doc(event.transactionId)
        .delete();

    await _updateOutstandingBalance(event.recipientId);
  }

  /// Update outstanding balance for a recipient
  Future<void> _updateOutstandingBalance(String recipientId) async {
    QuerySnapshot transactionSnapshot = await firestore
        .collection('users')
        .doc(userId)
        .collection('recipients')
        .doc(recipientId)
        .collection('transactions')
        .where('settled', isEqualTo: false)
        .get();

    double outstandingBalance = transactionSnapshot.docs
        .map((doc) => (doc.data() as Map<String, dynamic>)['amount'] as num)
        .fold(0.0, (sum, amount) => sum + amount.toDouble());

    await firestore
        .collection('users')
        .doc(userId)
        .collection('recipients')
        .doc(recipientId)
        .update({'outstanding_balance': outstandingBalance});
  }
}