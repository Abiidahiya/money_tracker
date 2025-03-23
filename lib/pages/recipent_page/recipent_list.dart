import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/recipents/recipent_bloc.dart';
import '../../bloc/recipents/recipent_event.dart';
import '../../bloc/recipents/recipent_state.dart';
import '../../data/models/recipent_model.dart';
import '../../data/repositories/recipent_repository.dart';
import '../ledger_page/ledger_page.dart';

class RecipientList extends StatefulWidget {
  @override
  _RecipientListState createState() => _RecipientListState();
}

class _RecipientListState extends State<RecipientList> with TickerProviderStateMixin {
  late List<Recipient> localRecipients;
  String? deletingRecipientId;

  @override
  void initState() {
    super.initState();
    localRecipients = [];
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RecipientBloc, RecipientState>(
      listener: (context, state) {
        if (state is RecipientLoaded) {
          setState(() {
            localRecipients = List.from(state.recipients);
          });
        }
      },
      child: ReorderableListView.builder(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        itemCount: localRecipients.length,
        onReorder: (oldIndex, newIndex) {
          if (newIndex > oldIndex) newIndex--;
          final movedItem = localRecipients.removeAt(oldIndex);
          localRecipients.insert(newIndex, movedItem);
          setState(() {});

          context.read<RecipientBloc>().add(ReorderRecipients(
            oldIndex: oldIndex,
            newIndex: newIndex,
          ));
        },
        itemBuilder: (context, index) {
          final recipient = localRecipients[index];

          return AnimatedContainer(
            key: ValueKey(recipient.id),
            duration: Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            margin: EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 6,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: ListTile(
              contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              leading: CircleAvatar(
                backgroundColor: Colors.blueAccent,
                child: Icon(Icons.person, color: Colors.white),
              ),
              title: Text(
                recipient.name,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              subtitle: Text(
                'Outstanding: ₹${recipient.outstandingBalance.toStringAsFixed(2)}',
                style: TextStyle(fontSize: 14, color: Colors.blueGrey[600]),
              ),
              trailing: deletingRecipientId == recipient.id
                  ? SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
                  : IconButton(
                icon: Icon(Icons.delete_outline, color: Colors.redAccent, size: 28),
                onPressed: () => _showDeleteConfirmationDialog(context, recipient.id),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LedgerPage(recipient: recipient),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context, String recipientId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          title: Text(
            'Delete Recipient?',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Text('Are you sure you want to delete this recipient?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel', style: TextStyle(color: Colors.grey)),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _deleteRecipient(context, recipientId);
              },
              child: Text('Delete', style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteRecipient(BuildContext context, String recipientId) async {
    setState(() {
      deletingRecipientId = recipientId;
    });

    try {
      context.read<RecipientBloc>().add(DeleteRecipient(recipientId));

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Recipient deleted successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete recipient: $e')),
      );
    }

    setState(() {
      deletingRecipientId = null;
    });
  }
}