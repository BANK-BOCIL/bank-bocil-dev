import 'package:cloud_firestore/cloud_firestore.dart';

enum MissionStatus { active, completed, expired }

enum MissionType { daily, weekly, custom }

class Mission {
  final String? id;
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
  final Map<String, dynamic>? metadata;

  Mission({
    this.id,
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

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'parentId': parentId,
      'title': title,
      'description': description,
      'reward': reward,
      'type': type.name,
      'status': status.name,
      'createdAt': createdAt,
      'deadline': deadline,
      'completedAt': completedAt,
      'imageUrl': imageUrl,
      'iconName': iconName,
      'isRecurring': isRecurring,
      'metadata': metadata,
    };
  }

  factory Mission.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return Mission(
      id: doc.id,
      userId: data['userId'] as String,
      parentId: data['parentId'] as String,
      title: data['title'] as String,
      description: data['description'] as String,
      reward: (data['reward'] as num).toDouble(),
      type: MissionType.values.byName(data['type']),
      status: MissionStatus.values.byName(data['status']),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      deadline: (data['deadline'] as Timestamp?)?.toDate(),
      completedAt: (data['completedAt'] as Timestamp?)?.toDate(),
      imageUrl: data['imageUrl'] as String?,
      iconName: data['iconName'] as String?,
      isRecurring: data['isRecurring'] ?? false,
      metadata: data['metadata'] as Map<String, dynamic>?,
    );
  }
}
