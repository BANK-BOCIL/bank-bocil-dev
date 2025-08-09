import 'package:cloud_firestore/cloud_firestore.dart';

enum GoalStatus { active, completed, paused }

class SavingsGoal {
  final String? id;
  final String userId;
  final String name;
  final String description;
  final double targetAmount;
  final double currentAmount;
  final String? imageUrl;
  final String? iconName;
  final GoalStatus status;
  final DateTime createdAt;
  final DateTime? targetDate;
  final DateTime? completedAt;
  final bool isShortTerm;

  SavingsGoal({
    this.id,
    required this.userId,
    required this.name,
    required this.description,
    required this.targetAmount,
    this.currentAmount = 0.0,
    this.imageUrl,
    this.iconName,
    this.status = GoalStatus.active,
    required this.createdAt,
    this.targetDate,
    this.completedAt,
    this.isShortTerm = true,
  });

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'name': name,
      'description': description,
      'targetAmount': targetAmount,
      'currentAmount': currentAmount,
      'imageUrl': imageUrl,
      'iconName': iconName,
      'status': status.name,
      'createdAt': createdAt,
      'targetDate': targetDate,
      'completedAt': completedAt,
      'isShortTerm': isShortTerm,
    };
  }
  double get progressPercentage {
    if (targetAmount == 0) return 0;
    return (currentAmount / targetAmount) * 100;
  }

  factory SavingsGoal.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return SavingsGoal(
      id: doc.id,
      userId: data['userId'] as String,
      name: data['name'] as String,
      description: data['description'] as String,
      targetAmount: (data['targetAmount'] as num).toDouble(),
      currentAmount: (data['currentAmount'] as num).toDouble(),
      imageUrl: data['imageUrl'] as String?,
      iconName: data['iconName'] as String?,
      status: GoalStatus.values.byName(data['status']),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      targetDate: (data['targetDate'] as Timestamp?)?.toDate(),
      completedAt: (data['completedAt'] as Timestamp?)?.toDate(),
      isShortTerm: data['isShortTerm'] ?? true,
    );
  }
}
