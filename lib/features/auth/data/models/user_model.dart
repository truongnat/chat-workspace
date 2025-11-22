import '../../domain/entities/user.dart';

class UserModel extends User {
  const UserModel({
    required super.id,
    required super.phoneNumber,
    required super.name,
    super.username,
    super.bio,
    super.avatarUrl,
    required super.createdAt,
    super.lastSeen,
    super.isOnline,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      phoneNumber: json['phoneNumber'] as String,
      name: json['name'] as String,
      username: json['username'] as String?,
      bio: json['bio'] as String?,
      avatarUrl: json['avatarUrl'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      lastSeen: json['lastSeen'] != null
          ? DateTime.parse(json['lastSeen'] as String)
          : null,
      isOnline: json['isOnline'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'phoneNumber': phoneNumber,
      'name': name,
      'username': username,
      'bio': bio,
      'avatarUrl': avatarUrl,
      'createdAt': createdAt.toIso8601String(),
      'lastSeen': lastSeen?.toIso8601String(),
      'isOnline': isOnline,
    };
  }

  factory UserModel.fromEntity(User user) {
    return UserModel(
      id: user.id,
      phoneNumber: user.phoneNumber,
      name: user.name,
      username: user.username,
      bio: user.bio,
      avatarUrl: user.avatarUrl,
      createdAt: user.createdAt,
      lastSeen: user.lastSeen,
      isOnline: user.isOnline,
    );
  }
}
