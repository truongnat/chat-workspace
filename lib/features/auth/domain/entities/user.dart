import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String phoneNumber;
  final String name;
  final String? username;
  final String? bio;
  final String? avatarUrl;
  final DateTime createdAt;
  final DateTime? lastSeen;
  final bool isOnline;

  const User({
    required this.id,
    required this.phoneNumber,
    required this.name,
    this.username,
    this.bio,
    this.avatarUrl,
    required this.createdAt,
    this.lastSeen,
    this.isOnline = false,
  });

  @override
  List<Object?> get props => [
        id,
        phoneNumber,
        name,
        username,
        bio,
        avatarUrl,
        createdAt,
        lastSeen,
        isOnline,
      ];
}
