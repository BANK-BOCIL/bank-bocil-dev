enum TransactionType { income, expense, allowance, mission_reward, transfer }

enum TransactionStatus { pending, approved, rejected, completed }

class Transaction {
  final String id;
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
    required this.id,
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

  bool get isPending => status == TransactionStatus.pending;
  bool get isApproved => status == TransactionStatus.approved;
  bool get isCompleted => status == TransactionStatus.completed;
  bool get needsApproval => type == TransactionType.expense && isPending;

  Map<String, dynamic> toJson() => {
        'id': id,
        'userId': userId,
        'parentId': parentId,
        'type': type.name,
        'amount': amount,
        'description': description,
        'category': category,
        'status': status.name,
        'createdAt': createdAt.toIso8601String(),
        'approvedAt': approvedAt?.toIso8601String(),
        'missionId': missionId,
        'savingsGoalId': savingsGoalId,
      };

  factory Transaction.fromJson(Map<String, dynamic> json) => Transaction(
        id: json['id'],
        userId: json['userId'],
        parentId: json['parentId'],
        type: TransactionType.values.byName(json['type']),
        amount: json['amount'].toDouble(),
        description: json['description'],
        category: json['category'],
        status: TransactionStatus.values.byName(json['status']),
        createdAt: DateTime.parse(json['createdAt']),
        approvedAt: json['approvedAt'] != null
            ? DateTime.parse(json['approvedAt'])
            : null,
        missionId: json['missionId'],
        savingsGoalId: json['savingsGoalId'],
      );
}
