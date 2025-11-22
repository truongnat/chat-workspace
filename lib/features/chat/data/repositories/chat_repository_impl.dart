import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/chat.dart';
import '../../domain/entities/message.dart';
import '../../domain/repositories/chat_repository.dart';
import '../datasources/chat_remote_datasource.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatRemoteDataSource remoteDataSource;

  ChatRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<Chat>>> getChats() async {
    try {
      final chats = await remoteDataSource.getChats();
      return Right(chats);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Chat>> getChatById(String chatId) async {
    try {
      final chat = await remoteDataSource.getChatById(chatId);
      return Right(chat);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Message>>> getMessages(String chatId) async {
    try {
      final messages = await remoteDataSource.getMessages(chatId);
      return Right(messages);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Message>> sendMessage({
    required String chatId,
    required String content,
    MessageType type = MessageType.text,
    String? replyToId,
    bool isDissolving = false,
    Duration? dissolveDuration,
  }) async {
    try {
      final message = await remoteDataSource.sendMessage(
        chatId: chatId,
        content: content,
        type: type,
        replyToId: replyToId,
        isDissolving: isDissolving,
        dissolveDuration: dissolveDuration,
      );
      return Right(message);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> markAsRead(
    String chatId,
    String messageId,
  ) async {
    try {
      await remoteDataSource.markAsRead(chatId, messageId);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> addReaction(
    String messageId,
    String reaction,
  ) async {
    try {
      await remoteDataSource.addReaction(messageId, reaction);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteMessage(String messageId) async {
    try {
      await remoteDataSource.deleteMessage(messageId);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
