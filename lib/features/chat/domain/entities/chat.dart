import 'package:equatable/equatable.dart';
import 'message.dart';

class Chat extends Equatable {
  final String id;
  final String name;
  final String? avatarUrl;
  final Message? lastMessage;
  final int unreadCount;
  final bool isOnline;
  final DateTime? lastSeen;
  final List<String> participantIds;

  const Chat({
    required this.id,
    required this.name,
    this.avatarUrl,
    this.lastMessage,
    this.unreadCount = 0,
    this.isOnline = false,
    this.lastSeen,
    this.participantIds = const [],
  });

  @override
  List<Object?> get props => [
        id,
        name,
        avatarUrl,
        lastMessage,
        unreadCount,
        isOnline,
        lastSeen,
        participantIds,
      ];
}
