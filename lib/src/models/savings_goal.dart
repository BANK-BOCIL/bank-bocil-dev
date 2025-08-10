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

  // ---------- NEW: copyWith ----------
  SavingsGoal copyWith({
    String? id,
    String? userId,
    String? name,
    String? description,
    double? targetAmount,
    double? currentAmount,
    String? imageUrl,
    String? iconName,
    GoalStatus? status,
    DateTime? createdAt,
    DateTime? targetDate,
    DateTime? completedAt,
    bool? isShortTerm,
  }) {
    return SavingsGoal(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      description: description ?? this.description,
      targetAmount: targetAmount ?? this.targetAmount,
      currentAmount: currentAmount ?? this.currentAmount,
      imageUrl: imageUrl ?? this.imageUrl,
      iconName: iconName ?? this.iconName,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      targetDate: targetDate ?? this.targetDate,
      completedAt: completedAt ?? this.completedAt,
      isShortTerm: isShortTerm ?? this.isShortTerm,
    );
  }

  Map<String, dynamic> toFirestore() {
    Timestamp? _ts(DateTime? d) => d == null ? null : Timestamp.fromDate(d);
    return {
      'userId': userId,
      'name': name,
      'description': description,
      'targetAmount': targetAmount,
      'currentAmount': currentAmount,
      'imageUrl': imageUrl,
      'iconName': iconName,
      'status': status.name,
      'createdAt': _ts(createdAt),
      'targetDate': _ts(targetDate),
      'completedAt': _ts(completedAt),
      'isShortTerm': isShortTerm,
    };
  }

  double get progressPercentage =>
      targetAmount == 0 ? 0 : (currentAmount / targetAmount) * 100;

  // allow Timestamp or DateTime in Firestore
  static DateTime? _toDate(dynamic v) {
    if (v == null) return null;
    if (v is Timestamp) return v.toDate();
    if (v is DateTime) return v;
    return null;
  }

  factory SavingsGoal.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
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
      status: GoalStatus.values.byName(data['status'] as String),
      createdAt: _toDate(data['createdAt']) ?? DateTime.now(),
      targetDate: _toDate(data['targetDate']),
      completedAt: _toDate(data['completedAt']),
      isShortTerm: (data['isShortTerm'] as bool?) ?? true,
    );
  }
}
