import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_tracker/data/models/recipent_model.dart';
import '../../../bloc/transaction/transaction_bloc.dart';
import '../../../bloc/transaction/transaction_state.dart';

class TransactionChartWidget extends StatelessWidget {
  final Recipient recipient;
  const TransactionChartWidget({Key? key, required this.recipient}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TransactionBloc, TransactionState>(
      builder: (context, state) {
        if (state is TransactionLoaded) {
          double totalCredit = state.transactions.where((t) => t.amount > 0).fold(0.0, (sum, t) => sum + t.amount);
          double totalDebit = state.transactions.where((t) => t.amount < 0).fold(0.0, (sum, t) => sum + t.amount.abs());

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: ExpansionTile(
              title: const Text("Transaction Breakdown"),
              children: [
                SizedBox(
                  height: 200,
                  child: PieChart(
                    PieChartData(
                      sections: [
                        PieChartSectionData(
                          color: Colors.green,
                          value: totalCredit,
                          title: "Credit",
                          radius: 50,
                          titleStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        PieChartSectionData(
                          color: Colors.red,
                          value: totalDebit,
                          title: "Debit",
                          radius: 50,
                          titleStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ],
                      sectionsSpace: 2,
                      centerSpaceRadius: 40,
                      borderData: FlBorderData(show: false),
                    ),
                  ),
                ),
              ],
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}