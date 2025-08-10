// lib/src/models/account.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class Account {
  final String userId; // This will be the same as the User ID
  final double balance;
  final DateTime lastUpdated;

  Account({
    required this.userId,
    required this.balance,
    required this.lastUpdated,
  });

  factory Account.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return Account(
      userId: doc.id,
      balance: (data['balance'] as num).toDouble(),
      lastUpdated: (data['lastUpdated'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'balance': balance,
      'lastUpdated': lastUpdated,
    };
  }
}
