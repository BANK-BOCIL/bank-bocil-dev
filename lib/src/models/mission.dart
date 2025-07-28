enum MissionStatus { active, completed, expired }

enum MissionType { daily, weekly, custom }

class Mission {
  final String id;
  final String userId;
  final String parentId;
  final String title;
  final String description;
  final double reward;
  final MissionType type;
  final MissionStatus status;
  final DateTime createdAt;
  final DateTime? deadline;
  final DateTime? completedAt;
  final String? imageUrl;
  final String? iconName;
  final bool isRecurring;
  final Map<String, dynamic>? metadata; // For storing additional mission data

  Mission({
    required this.id,
    required this.userId,
    required this.parentId,
    required this.title,
    required this.description,
    required this.reward,
    this.type = MissionType.custom,
    this.status = MissionStatus.active,
    required this.createdAt,
    this.deadline,
    this.completedAt,
    this.imageUrl,
    this.iconName,
    this.isRecurring = false,
    this.metadata,
  });

  bool get isCompleted => status == MissionStatus.completed;
  bool get isActive => status == MissionStatus.active;
  bool get isExpired => status == MissionStatus.expired;

  bool get isOverdue {
    if (deadline == null) return false;
    return DateTime.now().isAfter(deadline!) && !isCompleted;
  }

  int get daysUntilDeadline {
    if (deadline == null) return 0;
    final now = DateTime.now();
    final difference = deadline!.difference(now).inDays;
    return difference > 0 ? difference : 0;
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'userId': userId,
        'parentId': parentId,
        'title': title,
        'description': description,
        'reward': reward,
        'type': type.name,
        'status': status.name,
        'createdAt': createdAt.toIso8601String(),
        'deadline': deadline?.toIso8601String(),
        'completedAt': completedAt?.toIso8601String(),
        'imageUrl': imageUrl,
        'iconName': iconName,
        'isRecurring': isRecurring,
        'metadata': metadata,
      };

  factory Mission.fromJson(Map<String, dynamic> json) => Mission(
        id: json['id'],
        userId: json['userId'],
        parentId: json['parentId'],
        title: json['title'],
        description: json['description'],
        reward: json['reward'].toDouble(),
        type: MissionType.values.byName(json['type']),
        status: MissionStatus.values.byName(json['status']),
        createdAt: DateTime.parse(json['createdAt']),
        deadline:
            json['deadline'] != null ? DateTime.parse(json['deadline']) : null,
        completedAt: json['completedAt'] != null
            ? DateTime.parse(json['completedAt'])
            : null,
        imageUrl: json['imageUrl'],
        iconName: json['iconName'],
        isRecurring: json['isRecurring'] ?? false,
        metadata: json['metadata'],
      );

  Mission copyWith({
    String? id,
    String? userId,
    String? parentId,
    String? title,
    String? description,
    double? reward,
    MissionType? type,
    MissionStatus? status,
    DateTime? createdAt,
    DateTime? deadline,
    DateTime? completedAt,
    String? imageUrl,
    String? iconName,
    bool? isRecurring,
    Map<String, dynamic>? metadata,
  }) {
    return Mission(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      parentId: parentId ?? this.parentId,
      title: title ?? this.title,
      description: description ?? this.description,
      reward: reward ?? this.reward,
      type: type ?? this.type,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      deadline: deadline ?? this.deadline,
      completedAt: completedAt ?? this.completedAt,
      imageUrl: imageUrl ?? this.imageUrl,
      iconName: iconName ?? this.iconName,
      isRecurring: isRecurring ?? this.isRecurring,
      metadata: metadata ?? this.metadata,
    );
  }
}
