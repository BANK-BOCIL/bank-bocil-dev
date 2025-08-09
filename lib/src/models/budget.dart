import 'package:cloud_firestore/cloud_firestore.dart';

class Budget {
  final String? id;
  final String userId;
  final String name;
  final double amount;
  final String category;
  final bool isActive;
  final DateTime startDate;
  final DateTime? endDate;

  Budget({
    this.id,
    required this.userId,
    required this.name,
    required this.amount,
    required this.category,
    this.isActive = true,
    required this.startDate,
    this.endDate,
  });

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'name': name,
      'amount': amount,
      'category': category,
      'isActive': isActive,
      'startDate': startDate,
      'endDate': endDate,
    };
  }

  factory Budget.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return Budget(
      id: doc.id,
      userId: data['userId'] as String,
      name: data['name'] as String,
      amount: (data['amount'] as num).toDouble(),
      category: data['category'] as String,
      isActive: data['isActive'] ?? true,
      startDate: (data['startDate'] as Timestamp).toDate(),
      endDate: (data['endDate'] as Timestamp?)?.toDate(),
    );
  }
}
