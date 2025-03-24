import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../bloc/transaction/transaction_bloc.dart';
import '../../../bloc/transaction/transaction_event.dart';

class AddTransactionBottomSheet extends StatefulWidget {
  final Function(double amount, String type, String? note, DateTime? dueDate) onTransactionAdded;

  const AddTransactionBottomSheet({Key? key, required this.onTransactionAdded}) : super(key: key);

  @override
  _AddTransactionBottomSheetState createState() => _AddTransactionBottomSheetState();
}

class _AddTransactionBottomSheetState extends State<AddTransactionBottomSheet> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  String _selectedType = "Credit"; // Default to Credit
  DateTime? _selectedDueDate;

  void _pickDueDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      setState(() {
        _selectedDueDate = pickedDate;
      });
    }
  }

  void _submitTransaction() {
    String amountText = _amountController.text.trim();
    if (amountText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Amount is required")));
      return;
    }

    double? amount = double.tryParse(amountText);
    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Enter a valid amount")));
      return;
    }

    if (_selectedType == "Debit") {
      amount = -amount; // Make negative if Debit
    }

    widget.onTransactionAdded(
      amount,
      _selectedType,
      _noteController.text.trim().isEmpty ? null : _noteController.text.trim(),
      _selectedDueDate,
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom, // Adjust for keyboard
        top: 16,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Add Transaction", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),

            Row(
              children: [
                Expanded(
                  child: RadioListTile<String>(
                    title: const Text("Credit"),
                    value: "Credit",
                    groupValue: _selectedType,
                    onChanged: (value) => setState(() => _selectedType = value!),
                  ),
                ),
                Expanded(
                  child: RadioListTile<String>(
                    title: const Text("Debit"),
                    value: "Debit",
                    groupValue: _selectedType,
                    onChanged: (value) => setState(() => _selectedType = value!),
                  ),
                ),
              ],
            ),

            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "Amount", border: OutlineInputBorder()),
            ),

            const SizedBox(height: 10),

            TextField(
              controller: _noteController,
              decoration: const InputDecoration(labelText: "Note (optional)", border: OutlineInputBorder()),
            ),

            const SizedBox(height: 10),

            Row(
              children: [
                Text(_selectedDueDate == null ? "No Due Date" : "Due: ${DateFormat('dd/MM/yyyy').format(_selectedDueDate!)}"),
                const Spacer(),
                TextButton(
                  onPressed: _pickDueDate,
                  child: const Text("Select Due Date"),
                ),
              ],
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity, // Full width
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue, // Change to your preferred color
                  foregroundColor: Colors.white, // Text color
                  padding: const EdgeInsets.symmetric(vertical: 14), // Bigger button
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12), // Rounded corners
                  ),
                ),
                onPressed: _submitTransaction,
                child: const Text(
                  "Add Transaction",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}