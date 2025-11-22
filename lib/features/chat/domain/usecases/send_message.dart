import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/message.dart';
import '../repositories/chat_repository.dart';

class SendMessage implements UseCase<Message, SendMessageParams> {
  final ChatRepository repository;

  SendMessage(this.repository);

  @override
  Future<Either<Failure, Message>> call(SendMessageParams params) async {
    return await repository.sendMessage(
      chatId: params.chatId,
      content: params.content,
      type: params.type,
      replyToId: params.replyToId,
      isDissolving: params.isDissolving,
      dissolveDuration: params.dissolveDuration,
    );
  }
}

class SendMessageParams {
  final String chatId;
  final String content;
  final MessageType type;
  final String? replyToId;
  final bool isDissolving;
  final Duration? dissolveDuration;

  SendMessageParams({
    required this.chatId,
    required this.content,
    this.type = MessageType.text,
    this.replyToId,
    this.isDissolving = false,
    this.dissolveDuration,
  });
}
