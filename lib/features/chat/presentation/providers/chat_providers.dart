import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/chat_remote_datasource.dart';
import '../../data/repositories/chat_repository_impl.dart';
import '../../domain/repositories/chat_repository.dart';
import '../../domain/usecases/get_chats.dart';
import '../../domain/usecases/get_messages.dart';
import '../../domain/usecases/send_message.dart';

// Data Sources
final chatRemoteDataSourceProvider = Provider<ChatRemoteDataSource>((ref) {
  return ChatRemoteDataSourceImpl();
});

// Repository
final chatRepositoryProvider = Provider<ChatRepository>((ref) {
  return ChatRepositoryImpl(
    remoteDataSource: ref.watch(chatRemoteDataSourceProvider),
  );
});

// Use Cases
final getChatsUseCaseProvider = Provider<GetChats>((ref) {
  return GetChats(ref.watch(chatRepositoryProvider));
});

final getMessagesUseCaseProvider = Provider<GetMessages>((ref) {
  return GetMessages(ref.watch(chatRepositoryProvider));
});

final sendMessageUseCaseProvider = Provider<SendMessage>((ref) {
  return SendMessage(ref.watch(chatRepositoryProvider));
});
