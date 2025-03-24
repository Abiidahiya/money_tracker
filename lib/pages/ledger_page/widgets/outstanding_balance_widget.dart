import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../bloc/transaction/transaction_bloc.dart';
import '../../../bloc/transaction/transaction_state.dart';
import '../../../data/models/recipent_model.dart';

class OutstandingBalanceWidget extends StatelessWidget {
  final Recipient recipient;
  const OutstandingBalanceWidget({Key? key, required this.recipient}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: BlocBuilder<TransactionBloc, TransactionState>(
        builder: (context, state) {
          double outstandingBalance = 0.0;
          if (state is TransactionLoaded) {
            outstandingBalance = state.outstandingBalance;
          }

          return Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: LinearGradient(
                colors: [Colors.blueAccent.withOpacity(0.55), Colors.lightBlueAccent.withOpacity(0.6)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Outstanding Balance',
                  style: TextStyle(color: isDarkMode ? Colors.white : Colors.black45, fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 18),
                Text(
                  '₹${outstandingBalance.toStringAsFixed(2)}',
                  style: TextStyle(color: isDarkMode ? Colors.white : Colors.black54, fontSize: 45, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
              ],
            ),
          );
        },
      ),
    );
  }
}