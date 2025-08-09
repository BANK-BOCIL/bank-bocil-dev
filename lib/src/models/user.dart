// lib/src/models/user.dart
import 'package:cloud_firestore/cloud_firestore.dart';

// Enum untuk membedakan tipe pengguna
enum UserType { parent, child }

// Enum untuk tingkatan usia
enum AgeTier { tingkat1, tingkat2, tingkat3 }

class User {
  final String id;
  final String name;
  final UserType type;
  final AgeTier? ageTier;
  final String? childCode;
  final String? parentId;
  final int age;
  final DateTime createdAt;
  final DateTime? lastLoginAt;

  User({
    required this.id,
    required this.name,
    required this.type,
    this.ageTier,
    this.childCode,
    this.parentId,
    required this.age,
    required this.createdAt,
    this.lastLoginAt,
  });

  // PERBAIKAN: Validasi data yang lebih ketat.
  // Melemparkan error jika field penting tidak ada, mencegah bug tersembunyi.
  factory User.fromFirestore(Map<String, dynamic> data) {
    if (data['id'] == null || data['name'] == null || data['role'] == null) {
      throw FormatException(
          "Data pengguna tidak lengkap: 'id', 'name', atau 'role' tidak ditemukan.");
    }

    final userTypeString = data['role'] as String;
    final userType =
        userTypeString.contains('parent') ? UserType.parent : UserType.child;

    AgeTier? ageTier;
    final ageTierString = data['ageTier'] as String?;
    if (ageTierString != null && ageTierString.isNotEmpty) {
      // Menggunakan try-catch untuk keamanan ekstra jika enum tidak cocok
      try {
        ageTier =
            AgeTier.values.firstWhere((e) => e.toString() == ageTierString);
      } catch (e) {
        // Bisa dicatat (log) sebagai error data, namun tidak menghentikan aplikasi
        print('Error parsing ageTier: $e');
        ageTier = null;
      }
    }

    return User(
      id: data['id'] as String,
      name: data['name'] as String,
      type: userType,
      ageTier: ageTier,
      childCode: data['childCode'] as String?,
      parentId: data['parentId'] as String?,
      age: data['age'] as int? ?? 0,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      lastLoginAt: (data['lastLoginAt'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'name': name,
      'role': type.toString(),
      'ageTier': ageTier?.toString(),
      'childCode': childCode,
      'parentId': parentId,
      'age': age,
      'createdAt': createdAt,
      'lastLoginAt': lastLoginAt,
    };
  }

  User copyWith({
    String? id,
    String? name,
    UserType? type,
    // Menggunakan ValueGetter untuk memungkinkan null secara eksplisit
    AgeTier? Function()? ageTier,
    String? Function()? childCode,
    String? Function()? parentId,
    int? age,
    DateTime? createdAt,
    DateTime? Function()? lastLoginAt,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      ageTier: ageTier != null ? ageTier() : this.ageTier,
      childCode: childCode != null ? childCode() : this.childCode,
      parentId: parentId != null ? parentId() : this.parentId,
      age: age ?? this.age,
      createdAt: createdAt ?? this.createdAt,
      lastLoginAt: lastLoginAt != null ? lastLoginAt() : this.lastLoginAt,
    );
  }
}
