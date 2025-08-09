import 'package:cloud_firestore/cloud_firestore.dart';

enum TransactionType { income, expense, allowance, mission_reward, transfer }

enum TransactionStatus { pending, approved, rejected, completed }

class Transaction {
  final String? id;
  final String userId;
  final String? parentId;
  final TransactionType type;
  final double amount;
  final String description;
  final String? category;
  final TransactionStatus status;
  final DateTime createdAt;
  final DateTime? approvedAt;
  final String? missionId;
  final String? savingsGoalId;

  Transaction({
    this.id,
    required this.userId,
    this.parentId,
    required this.type,
    required this.amount,
    required this.description,
    this.category,
    this.status = TransactionStatus.completed,
    required this.createdAt,
    this.approvedAt,
    this.missionId,
    this.savingsGoalId,
  });

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'parentId': parentId,
      'type': type.name,
      'amount': amount,
      'description': description,
      'category': category,
      'status': status.name,
      'createdAt': createdAt,
      'approvedAt': approvedAt,
      'missionId': missionId,
      'savingsGoalId': savingsGoalId,
    };
  }

  factory Transaction.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return Transaction(
      id: doc.id,
      userId: data['userId'] as String,
      parentId: data['parentId'] as String?,
      type: TransactionType.values.byName(data['type']),
      amount: (data['amount'] as num).toDouble(),
      description: data['description'] as String,
      category: data['category'] as String?,
      status: TransactionStatus.values.byName(data['status']),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      approvedAt: (data['approvedAt'] as Timestamp?)?.toDate(),
      missionId: data['missionId'] as String?,
      savingsGoalId: data['savingsGoalId'] as String?,
    );
  }
}
