import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/chat.dart';
import '../entities/message.dart';

abstract class ChatRepository {
  Future<Either<Failure, List<Chat>>> getChats();
  Future<Either<Failure, Chat>> getChatById(String chatId);
  Future<Either<Failure, List<Message>>> getMessages(String chatId);
  Future<Either<Failure, Message>> sendMessage({
    required String chatId,
    required String content,
    MessageType type = MessageType.text,
    String? replyToId,
    bool isDissolving = false,
    Duration? dissolveDuration,
  });
  Future<Either<Failure, void>> markAsRead(String chatId, String messageId);
  Future<Either<Failure, void>> addReaction(String messageId, String reaction);
  Future<Either<Failure, void>> deleteMessage(String messageId);
}
