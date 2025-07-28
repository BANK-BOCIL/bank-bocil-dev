class Budget {
  final String id;
  final String userId;
  final String category;
  final double budgetAmount;
  final double spentAmount;
  final DateTime startDate;
  final DateTime endDate;
  final bool isActive;

  Budget({
    required this.id,
    required this.userId,
    required this.category,
    required this.budgetAmount,
    this.spentAmount = 0.0,
    required this.startDate,
    required this.endDate,
    this.isActive = true,
  });

  double get remainingAmount =>
      (budgetAmount - spentAmount).clamp(0, double.infinity);
  double get usagePercentage =>
      budgetAmount > 0 ? (spentAmount / budgetAmount * 100).clamp(0, 100) : 0;
  bool get isOverspent => spentAmount > budgetAmount;
  bool get isNearLimit => usagePercentage >= 80;

  Map<String, dynamic> toJson() => {
        'id': id,
        'userId': userId,
        'category': category,
        'budgetAmount': budgetAmount,
        'spentAmount': spentAmount,
        'startDate': startDate.toIso8601String(),
        'endDate': endDate.toIso8601String(),
        'isActive': isActive,
      };

  factory Budget.fromJson(Map<String, dynamic> json) => Budget(
        id: json['id'],
        userId: json['userId'],
        category: json['category'],
        budgetAmount: json['budgetAmount'].toDouble(),
        spentAmount: json['spentAmount']?.toDouble() ?? 0.0,
        startDate: DateTime.parse(json['startDate']),
        endDate: DateTime.parse(json['endDate']),
        isActive: json['isActive'] ?? true,
      );
}
