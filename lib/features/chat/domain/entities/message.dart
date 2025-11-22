import 'package:equatable/equatable.dart';

class Message extends Equatable {
  final String id;
  final String chatId;
  final String senderId;
  final String content;
  final DateTime timestamp;
  final bool isRead;
  final bool isSent;
  final MessageType type;
  final String? replyToId;
  final List<String> reactions;
  final bool isDissolving;
  final Duration? dissolveDuration;

  const Message({
    required this.id,
    required this.chatId,
    required this.senderId,
    required this.content,
    required this.timestamp,
    this.isRead = false,
    this.isSent = true,
    this.type = MessageType.text,
    this.replyToId,
    this.reactions = const [],
    this.isDissolving = false,
    this.dissolveDuration,
  });

  @override
  List<Object?> get props => [
        id,
        chatId,
        senderId,
        content,
        timestamp,
        isRead,
        isSent,
        type,
        replyToId,
        reactions,
        isDissolving,
        dissolveDuration,
      ];
}

enum MessageType {
  text,
  image,
  video,
  audio,
  file,
}
