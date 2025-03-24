import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_tracker/data/models/recipent_model.dart';
import 'package:money_tracker/pages/ledger_page/widgets/transaction_tile_widget.dart';

import '../../../bloc/transaction/transaction_bloc.dart';
import '../../../bloc/transaction/transaction_state.dart';


class TransactionListWidget extends StatelessWidget {
  final Recipient recipient;
  const TransactionListWidget({Key? key, required this.recipient}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TransactionBloc, TransactionState>(
      builder: (context, state) {
        if (state is TransactionLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is TransactionLoaded) {
          final transactions = state.transactions;
          if (transactions.isEmpty) {
            return const Center(child: Text("No transactions yet."));
          }
          return ListView.builder(
            itemCount: transactions.length,
            padding: const EdgeInsets.all(8.0),
            itemBuilder: (context, index) {
              return TransactionTileWidget(transaction: transactions[index], recipient: recipient,);
            },
          );
        } else if (state is TransactionError) {
          return Center(child: Text('Error: ${state.message}'));
        }
        return const Center(child: Text("No transactions found."));
      },
    );
  }
}