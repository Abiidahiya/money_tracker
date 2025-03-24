import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_tracker/pages/ledger_page/widgets/addtransaction_bottom_sheet.dart';
import 'package:money_tracker/pages/ledger_page/widgets/outstanding_balance_widget.dart';
import 'package:money_tracker/pages/ledger_page/widgets/transaction_chart_widget.dart';
import 'package:money_tracker/pages/ledger_page/widgets/transaction_list_widget.dart';

import '../../bloc/transaction/transaction_bloc.dart';
import '../../bloc/transaction/transaction_event.dart';
import '../../data/models/recipent_model.dart';

class LedgerPage extends StatelessWidget {
  final Recipient recipient;

  const LedgerPage({Key? key, required this.recipient}) : super(key: key);

  void _showAddTransactionBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => AddTransactionBottomSheet(
        onTransactionAdded: (double amount, String type, String? note, DateTime? dueDate) {
          context.read<TransactionBloc>().add(
            AddTransaction( // ✅ Using the existing AddTransaction event
              recipientId: recipient.id,
              amount: amount,
              type: type,
              note: note,
              dueDate: dueDate, transactionDate: DateTime.now(),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Load transactions when the page is built
    context.read<TransactionBloc>().add(LoadTransactions(recipientId: recipient.id));

    return Scaffold(
      appBar: AppBar(title: Text(recipient.name)),
      body: Column(
        children: [
          OutstandingBalanceWidget(recipient: recipient),
          TransactionChartWidget(recipient: recipient),
          Expanded(child: TransactionListWidget(recipient: recipient)),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat, // ✅ Moves FAB above bottom edge
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton.extended(
            onPressed: () => _showAddTransactionBottomSheet(context),
            icon: const Icon(Icons.add),
            label: const Text("Add Transaction"),
          ),
          const SizedBox(height: 20), // ✅ Adds extra space below FAB
        ],
      ),
    );
  }
}