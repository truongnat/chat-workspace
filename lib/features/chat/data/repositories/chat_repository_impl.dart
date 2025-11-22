import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/chat.dart';
import '../../domain/entities/message.dart';
import '../../domain/repositories/chat_repository.dart';
import '../datasources/chat_remote_datasource.dart';
import '../../../../core/services/crypto_service.dart';
import '../../../auth/domain/repositories/auth_repository.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatRemoteDataSource remoteDataSource;
  final AuthRepository authRepository;
  final CryptoService cryptoService;

  ChatRepositoryImpl({
    required this.remoteDataSource,
    required this.authRepository,
    required this.cryptoService,
  });

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
      
      // Decrypt messages
      final decryptedMessages = await Future.wait(messages.map((msg) async {
        // If message is text and looks encrypted (Base64), try to decrypt.
        // We need the SENDER'S public key to decrypt.
        if (msg.type == MessageType.text) {
           final senderKeyResult = await authRepository.getUserPublicKey(msg.senderId);
           return senderKeyResult.fold(
             (failure) => msg.copyWith(content: 'Error fetching key'), // Fallback
             (senderPublicKey) async {
               if (senderPublicKey == null) return msg.copyWith(content: 'Sender key not found');
               try {
                 final decrypted = await cryptoService.decryptFromUser(msg.content, senderPublicKey);
                 return msg.copyWith(content: decrypted);
               } catch (e) {
                 // Decryption failed (maybe it wasn't encrypted or wrong key)
                 return msg.copyWith(content: 'Decryption failed');
               }
             },
           );
        }
        return msg;
      }));

      return Right(decryptedMessages);
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
      // 1. Get Chat details to find recipient
      final chatResult = await getChatById(chatId);
      return chatResult.fold(
        (failure) => Left(failure),
        (chat) async {
          // Assuming 1-on-1 chat for MVP.
          // We need to find the "other" user.
          // Since we don't have "my" ID easily accessible here without fetching current user,
          // we might need to rely on the fact that the chat name or participant list helps.
          // For now, let's assume the `chatId` IS the recipient ID (common in some designs) OR
          // we fetch the participants.
          // If `chat.participantIds` is available, pick the one that is NOT me.
          // But I don't have "me".
          // Let's assume for this MVP that we can get the recipient ID from the chat object or passed in.
          // If `chatId` is a conversation ID, we need to know who we are talking to.
          
          // HACK: For MVP, let's assume we can get the recipient ID.
          // If the chat is 1-on-1, the `chat.id` might be the conversation ID.
          // We need to fetch the participants.
          // Let's assume we have a way to get the recipient.
          // For now, I'll try to use `chat.participantIds` and filter out "me".
          // I need "me".
          
          final meResult = await authRepository.getCurrentUser();
          return meResult.fold(
            (failure) => Left(failure),
            (me) async {
               final recipientId = chat.participantIds.firstWhere(
                (id) => id != me.id,
                orElse: () => '', // Should not happen in 1-on-1
              );
              
              if (recipientId.isEmpty) {
                 return Left(const ServerFailure('Recipient not found'));
              }

              // 2. Get Recipient's Public Key
              final keyResult = await authRepository.getUserPublicKey(recipientId);
              return keyResult.fold(
                (failure) => Left(failure),
                (recipientPublicKey) async {
                  if (recipientPublicKey == null) {
                    return Left(const ServerFailure('Recipient has no public key'));
                  }

                  // 3. Encrypt Content
                  final encryptedContent = await cryptoService.encryptForUser(
                    content,
                    recipientPublicKey,
                  );

                  // 4. Send Encrypted Message
                  final message = await remoteDataSource.sendMessage(
                    chatId: chatId,
                    content: encryptedContent,
                    type: type,
                    replyToId: replyToId,
                    isDissolving: isDissolving,
                    dissolveDuration: dissolveDuration,
                  );
                  
                  // Return the message with CLEARTEXT content for the UI to display immediately
                  // (The backend stored the encrypted one, but locally we want to show what we sent)
                  return Right(message.copyWith(content: content));
                },
              );
            },
          );
        },
      );
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
