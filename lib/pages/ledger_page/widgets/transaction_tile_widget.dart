import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../bloc/transaction/transaction_bloc.dart';
import '../../../bloc/transaction/transaction_event.dart';
import '../../../data/models/recipent_model.dart';
import '../../../data/models/transaction_model.dart';

class TransactionTileWidget extends StatelessWidget {
  final TransactionModel transaction;
  final Recipient recipient;

  const TransactionTileWidget({
    Key? key,
    required this.transaction,
    required this.recipient,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isCredit = transaction.amount > 0;
    bool isSettled = transaction.settled;

    // Colors for different states
    Color creditColor = Colors.green.shade50;
    Color debitColor = Colors.red.shade50;
    Color settledColor = Colors.grey.shade200;

    // Background color for tile
    Color tileColor = isSettled ? settledColor : (isCredit ? creditColor : debitColor);

    // Text colors
    Color textColor = isSettled ? Colors.grey.shade700 : Colors.black;
    Color labelTextColor = isSettled ? Colors.grey.shade700 : (isCredit ? Colors.green[900]! : Colors.red[900]!);

    // Background color for the "Credit/Debit" label
    Color labelBackgroundColor = isSettled ? Colors.grey.shade400 : (isCredit ? Colors.green.shade100 : Colors.red.shade100);

    return AnimatedOpacity(
      duration: const Duration(milliseconds: 500),
      opacity: isSettled ? 0.6 : 1.0,
      child: Card(
        key: ValueKey(transaction.id),
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 1,
        color: tileColor,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          child: Row(
            children: [
              // Transaction Type Label (CREDIT/DEBIT) with Date below
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: labelBackgroundColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      isCredit ? "CREDIT" : "DEBIT",
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: labelTextColor,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    DateFormat('dd/MM/yyyy').format(transaction.transactionDate),
                    style: TextStyle(
                      fontSize: 10,
                      color: textColor.withOpacity(0.8),
                    ),
                  ),
                ],
              ),

              const SizedBox(width: 20),

              // Amount & Note
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '₹${transaction.amount.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: textColor,
                      ),
                    ),
                    if (transaction.note != null)
                      Text(
                        transaction.note!,
                        style: TextStyle(
                          fontSize: 12,
                          color: textColor.withOpacity(0.8),
                        ),
                      ),
                    Text(
                      'Due: ${transaction.dueDate != null ? DateFormat('dd/MM/yyyy').format(transaction.dueDate!) : "No due date"}',
                      style: TextStyle(
                        fontSize: 10,
                        color: textColor.withOpacity(0.8),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 10),

              // Settle Button
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: labelBackgroundColor,
                    ),
                    child: Center(
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        icon: Icon(
                          isSettled ? Icons.check_circle : Icons.hourglass_empty,
                          color: isSettled ? Colors.green[700] : Colors.black54,
                          size: 18,
                        ),
                        onPressed: () {
                          context.read<TransactionBloc>().add(
                            ToggleTransactionSettled(
                              recipientId: recipient.id,
                              transactionId: transaction.id,
                              currentStatus: transaction.settled,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 2),
                  SizedBox(
                    width: 70,
                    child: Text(
                      isSettled ? "Settled" : "Pending",
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 10,
                        color: Colors.black54,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}