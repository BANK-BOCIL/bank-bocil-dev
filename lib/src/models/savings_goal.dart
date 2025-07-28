enum GoalStatus { active, completed, paused }

class SavingsGoal {
  final String id;
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
  final bool isShortTerm; // true for daily/weekly goals, false for long-term

  SavingsGoal({
    required this.id,
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

  double get progressPercentage =>
      targetAmount > 0 ? (currentAmount / targetAmount * 100).clamp(0, 100) : 0;

  double get remainingAmount =>
      (targetAmount - currentAmount).clamp(0, double.infinity);

  bool get isCompleted =>
      status == GoalStatus.completed || currentAmount >= targetAmount;

  int get daysRemaining {
    if (targetDate == null) return 0;
    final now = DateTime.now();
    final difference = targetDate!.difference(now).inDays;
    return difference > 0 ? difference : 0;
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'userId': userId,
        'name': name,
        'description': description,
        'targetAmount': targetAmount,
        'currentAmount': currentAmount,
        'imageUrl': imageUrl,
        'iconName': iconName,
        'status': status.name,
        'createdAt': createdAt.toIso8601String(),
        'targetDate': targetDate?.toIso8601String(),
        'completedAt': completedAt?.toIso8601String(),
        'isShortTerm': isShortTerm,
      };

  factory SavingsGoal.fromJson(Map<String, dynamic> json) => SavingsGoal(
        id: json['id'],
        userId: json['userId'],
        name: json['name'],
        description: json['description'],
        targetAmount: json['targetAmount'].toDouble(),
        currentAmount: json['currentAmount']?.toDouble() ?? 0.0,
        imageUrl: json['imageUrl'],
        iconName: json['iconName'],
        status: GoalStatus.values.byName(json['status']),
        createdAt: DateTime.parse(json['createdAt']),
        targetDate: json['targetDate'] != null
            ? DateTime.parse(json['targetDate'])
            : null,
        completedAt: json['completedAt'] != null
            ? DateTime.parse(json['completedAt'])
            : null,
        isShortTerm: json['isShortTerm'] ?? true,
      );

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
}
