enum UserType { child, parent }

enum AgeTier { tingkat1, tingkat2, tingkat3 }

class User {
  final String id;
  final String name;
  final UserType type;
  final AgeTier? ageTier; // null for parents
  final int? age; // null for parents
  final String? parentId; // null for parents
  final String profileImageUrl;
  final DateTime createdAt;

  User({
    required this.id,
    required this.name,
    required this.type,
    this.ageTier,
    this.age,
    this.parentId,
    this.profileImageUrl = '',
    required this.createdAt,
  });

  bool get isTingkat1 => ageTier == AgeTier.tingkat1;
  bool get isTingkat2 => ageTier == AgeTier.tingkat2;
  bool get isTingkat3 => ageTier == AgeTier.tingkat3;
  bool get isParent => type == UserType.parent;

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'type': type.name,
        'ageTier': ageTier?.name,
        'age': age,
        'parentId': parentId,
        'profileImageUrl': profileImageUrl,
        'createdAt': createdAt.toIso8601String(),
      };

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json['id'],
        name: json['name'],
        type: UserType.values.byName(json['type']),
        ageTier: json['ageTier'] != null
            ? AgeTier.values.byName(json['ageTier'])
            : null,
        age: json['age'],
        parentId: json['parentId'],
        profileImageUrl: json['profileImageUrl'] ?? '',
        createdAt: DateTime.parse(json['createdAt']),
      );
}
