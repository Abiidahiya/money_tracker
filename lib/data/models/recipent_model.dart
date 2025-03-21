import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Recipient {
  final String id;
  final String name;
  final double outstandingBalance;
  final int order; // Ensure order is included

  Recipient({
    required this.id,
    required this.name,
    required this.outstandingBalance,
    required this.order, // Add order field
  });

  // Add this method 👇
  Recipient copyWith({
    String? id,
    String? name,
    double? outstandingBalance,
    int? order,
  }) {
    return Recipient(
      id: id ?? this.id,
      name: name ?? this.name,
      outstandingBalance: outstandingBalance ?? this.outstandingBalance,
      order: order ?? this.order, // Preserve existing order if not provided
    );
  }

  // Convert to Firestore map
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'outstanding_balance': outstandingBalance,
      'order': order, // Ensure order is stored
    };
  }

  // Factory method to create a Recipient from Firestore
  factory Recipient.fromMap(Map<String, dynamic> map, String id) {
    return Recipient(
      id: id,
      name: map['name'] ?? '',
      outstandingBalance: (map['outstanding_balance'] ?? 0).toDouble(),
      order: map['order'] ?? 0, // Default order to 0 if missing
    );
  }
}
