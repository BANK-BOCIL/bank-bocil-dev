// lib/src/models/account.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class Account {
  final String userId;
  final double balance;
  final DateTime lastUpdated;

  Account({
    required this.userId,
    required this.balance,
    required this.lastUpdated,
  });

  factory Account.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? {};

    final balanceNum = data['balance'];
    final balance = (balanceNum is num) ? balanceNum.toDouble() : 0.0;

    final lu = data['lastUpdated'];
    final DateTime lastUpdated = switch (lu) {
      Timestamp ts => ts.toDate(),
      DateTime dt => dt,
      _ => DateTime.now(), // fallback while server timestamp resolves
    };

    return Account(
      userId: (data['userId'] as String?) ?? doc.id,
      balance: balance,
      lastUpdated: lastUpdated,
    );
  }

  Map<String, dynamic> toFirestore() => {
    'userId': userId,
    'balance': balance,
    'lastUpdated': Timestamp.fromDate(lastUpdated),
  };
}
