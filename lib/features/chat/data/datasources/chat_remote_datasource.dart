import 'package:dio/dio.dart';
import '../../../../core/network/api_client.dart';
import '../models/chat_model.dart';
import '../models/message_model.dart';
import '../../domain/entities/message.dart';

abstract class ChatRemoteDataSource {
  Future<List<ChatModel>> getChats();
  Future<ChatModel> getChatById(String chatId);
  Future<List<MessageModel>> getMessages(String chatId);
  Future<MessageModel> sendMessage({
    required String chatId,
    required String content,
    MessageType type = MessageType.text,
    String? replyToId,
    bool isDissolving = false,
    Duration? dissolveDuration,
  });
  Future<void> markAsRead(String chatId, String messageId);
  Future<void> addReaction(String messageId, String reaction);
  Future<void> deleteMessage(String messageId);
}

class ChatRemoteDataSourceImpl implements ChatRemoteDataSource {
  final ApiClient apiClient;

  ChatRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<List<ChatModel>> getChats() async {
    try {
      final response = await apiClient.dio.get('/chats');
      final List<dynamic> data = response.data['chats'] ?? [];
      return data.map((json) => ChatModel.fromJson(json)).toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<ChatModel> getChatById(String chatId) async {
    try {
      final response = await apiClient.dio.get('/chats/$chatId');
      return ChatModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<List<MessageModel>> getMessages(String chatId) async {
    try {
      final response = await apiClient.dio.get('/chats/$chatId/messages');
      final List<dynamic> data = response.data['messages'] ?? [];
      return data.map((json) => MessageModel.fromJson(json)).toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<MessageModel> sendMessage({
    required String chatId,
    required String content,
    MessageType type = MessageType.text,
    String? replyToId,
    bool isDissolving = false,
    Duration? dissolveDuration,
  }) async {
    try {
      final response = await apiClient.dio.post(
        '/chats/$chatId/messages',
        data: {
          'content': content,
          'type': type.toString().split('.').last,
          'reply_to_id': replyToId,
          'is_dissolving': isDissolving,
          'dissolve_duration': dissolveDuration?.inSeconds,
        },
      );
      return MessageModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<void> markAsRead(String chatId, String messageId) async {
    try {
      await apiClient.dio.post('/chats/$chatId/messages/$messageId/read');
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<void> addReaction(String messageId, String reaction) async {
    try {
      await apiClient.dio.post(
        '/messages/$messageId/reactions',
        data: {'reaction': reaction},
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<void> deleteMessage(String messageId) async {
    try {
      await apiClient.dio.delete('/messages/$messageId');
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Exception _handleError(DioException e) {
    if (e.response != null) {
      final message = e.response?.data['error'] ?? 'Server Error';
      return Exception(message);
    } else {
      return Exception('Network Error');
    }
  }
}
