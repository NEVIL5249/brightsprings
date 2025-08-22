import 'user_role.dart';

class AppUser {
  final String uid;
  final String email;
  final String name;
  final UserRole role;
  final DateTime createdAt;
  final Map<String, dynamic>? additionalData;

  AppUser({
    required this.uid,
    required this.email,
    required this.name,
    required this.role,
    required this.createdAt,
    this.additionalData,
  });

  factory AppUser.fromMap(Map<String, dynamic> map) {
    return AppUser(
      uid: map['uid']?.toString() ?? '',
      email: map['email']?.toString() ?? '',
      name: map['name']?.toString() ?? '',
      role: UserRole.fromString(map['role']?.toString() ?? ''),
      createdAt: DateTime.fromMillisecondsSinceEpoch(
        map['createdAt'] is int ? map['createdAt'] : 0
      ),
      additionalData: map['additionalData'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'name': name,
      'role': role.name,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'additionalData': additionalData,
    };
  }

  AppUser copyWith({
    String? uid,
    String? email,
    String? name,
    UserRole? role,
    DateTime? createdAt,
    Map<String, dynamic>? additionalData,
  }) {
    return AppUser(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      name: name ?? this.name,
      role: role ?? this.role,
      createdAt: createdAt ?? this.createdAt,
      additionalData: additionalData ?? this.additionalData,
    );
  }
}
