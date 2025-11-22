import '../../domain/entities/chat.dart';
import 'message_model.dart';

class ChatModel extends Chat {
  const ChatModel({
    required super.id,
    required super.name,
    super.avatarUrl,
    super.lastMessage,
    super.unreadCount,
    super.isOnline,
    super.lastSeen,
    super.participantIds,
  });

  factory ChatModel.fromJson(Map<String, dynamic> json) {
    return ChatModel(
      id: json['id'] as String,
      name: json['name'] as String,
      avatarUrl: json['avatarUrl'] as String?,
      lastMessage: json['lastMessage'] != null
          ? MessageModel.fromJson(json['lastMessage'] as Map<String, dynamic>)
          : null,
      unreadCount: json['unreadCount'] as int? ?? 0,
      isOnline: json['isOnline'] as bool? ?? false,
      lastSeen: json['lastSeen'] != null
          ? DateTime.parse(json['lastSeen'] as String)
          : null,
      participantIds: (json['participantIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'avatarUrl': avatarUrl,
      'lastMessage': lastMessage != null
          ? MessageModel.fromEntity(lastMessage!).toJson()
          : null,
      'unreadCount': unreadCount,
      'isOnline': isOnline,
      'lastSeen': lastSeen?.toIso8601String(),
      'participantIds': participantIds,
    };
  }

  factory ChatModel.fromEntity(Chat chat) {
    return ChatModel(
      id: chat.id,
      name: chat.name,
      avatarUrl: chat.avatarUrl,
      lastMessage: chat.lastMessage,
      unreadCount: chat.unreadCount,
      isOnline: chat.isOnline,
      lastSeen: chat.lastSeen,
      participantIds: chat.participantIds,
    );
  }
}
