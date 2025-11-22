import '../../domain/entities/message.dart';

class MessageModel extends Message {
  const MessageModel({
    required super.id,
    required super.chatId,
    required super.senderId,
    required super.content,
    required super.timestamp,
    super.isRead,
    super.isSent,
    super.type,
    super.replyToId,
    super.reactions,
    super.isDissolving,
    super.dissolveDuration,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['id'] as String,
      chatId: json['chatId'] as String,
      senderId: json['senderId'] as String,
      content: json['content'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      isRead: json['isRead'] as bool? ?? false,
      isSent: json['isSent'] as bool? ?? true,
      type: MessageType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => MessageType.text,
      ),
      replyToId: json['replyToId'] as String?,
      reactions: (json['reactions'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      isDissolving: json['isDissolving'] as bool? ?? false,
      dissolveDuration: json['dissolveDuration'] != null
          ? Duration(seconds: json['dissolveDuration'] as int)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'chatId': chatId,
      'senderId': senderId,
      'content': content,
      'timestamp': timestamp.toIso8601String(),
      'isRead': isRead,
      'isSent': isSent,
      'type': type.name,
      'replyToId': replyToId,
      'reactions': reactions,
      'isDissolving': isDissolving,
      'dissolveDuration': dissolveDuration?.inSeconds,
    };
  }

  factory MessageModel.fromEntity(Message message) {
    return MessageModel(
      id: message.id,
      chatId: message.chatId,
      senderId: message.senderId,
      content: message.content,
      timestamp: message.timestamp,
      isRead: message.isRead,
      isSent: message.isSent,
      type: message.type,
      replyToId: message.replyToId,
      reactions: message.reactions,
      isDissolving: message.isDissolving,
      dissolveDuration: message.dissolveDuration,
    );
  }
}
