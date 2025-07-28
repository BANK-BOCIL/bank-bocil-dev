enum UserRole {
  parent,
  child,
}

class AuthUser {
  final String id;
  final String email;
  final String? password; // Only for parents
  final String name;
  final UserRole role;
  final String? parentId; // Only for children
  final String? childCode; // Only for parents, code that children use to login
  final DateTime createdAt;
  final DateTime? lastLoginAt;

  const AuthUser({
    required this.id,
    required this.email,
    this.password,
    required this.name,
    required this.role,
    this.parentId,
    this.childCode,
    required this.createdAt,
    this.lastLoginAt,
  });

  AuthUser copyWith({
    String? id,
    String? email,
    String? password,
    String? name,
    UserRole? role,
    String? parentId,
    String? childCode,
    DateTime? createdAt,
    DateTime? lastLoginAt,
  }) {
    return AuthUser(
      id: id ?? this.id,
      email: email ?? this.email,
      password: password ?? this.password,
      name: name ?? this.name,
      role: role ?? this.role,
      parentId: parentId ?? this.parentId,
      childCode: childCode ?? this.childCode,
      createdAt: createdAt ?? this.createdAt,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'password': password,
      'name': name,
      'role': role.toString(),
      'parentId': parentId,
      'childCode': childCode,
      'createdAt': createdAt.toIso8601String(),
      'lastLoginAt': lastLoginAt?.toIso8601String(),
    };
  }

  factory AuthUser.fromJson(Map<String, dynamic> json) {
    return AuthUser(
      id: json['id'],
      email: json['email'],
      password: json['password'],
      name: json['name'],
      role: UserRole.values.firstWhere(
        (role) => role.toString() == json['role'],
        orElse: () => UserRole.child,
      ),
      parentId: json['parentId'],
      childCode: json['childCode'],
      createdAt: DateTime.parse(json['createdAt']),
      lastLoginAt: json['lastLoginAt'] != null
          ? DateTime.parse(json['lastLoginAt'])
          : null,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AuthUser && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'AuthUser(id: $id, email: $email, name: $name, role: $role)';
  }
}
