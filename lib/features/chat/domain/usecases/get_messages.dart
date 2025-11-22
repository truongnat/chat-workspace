import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/message.dart';
import '../repositories/chat_repository.dart';

class GetMessages implements UseCase<List<Message>, GetMessagesParams> {
  final ChatRepository repository;

  GetMessages(this.repository);

  @override
  Future<Either<Failure, List<Message>>> call(GetMessagesParams params) async {
    return await repository.getMessages(params.chatId);
  }
}

class GetMessagesParams {
  final String chatId;

  GetMessagesParams({required this.chatId});
}
