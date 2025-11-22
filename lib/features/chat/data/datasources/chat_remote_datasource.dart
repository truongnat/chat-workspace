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
  @override
  Future<List<ChatModel>> getChats() async {
    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 500));
    // Mock data
    return [
      ChatModel(
        id: 'chat_1',
        name: 'Alice Johnson',
        isOnline: true,
        unreadCount: 2,
        lastMessage: MessageModel(
          id: 'msg_1',
          chatId: 'chat_1',
          senderId: 'user_2',
          content: 'Hey! How are you?',
          timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
          isSent: false,
        ),
      ),
      ChatModel(
        id: 'chat_2',
        name: 'Bob Smith',
        isOnline: false,
        unreadCount: 0,
        lastSeen: DateTime.now().subtract(const Duration(hours: 2)),
        lastMessage: MessageModel(
          id: 'msg_2',
          chatId: 'chat_2',
          senderId: 'user_1',
          content: 'See you tomorrow!',
          timestamp: DateTime.now().subtract(const Duration(hours: 3)),
          isSent: true,
          isRead: true,
        ),
      ),
    ];
  }

  @override
  Future<ChatModel> getChatById(String chatId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return ChatModel(
      id: chatId,
      name: 'Alice Johnson',
      isOnline: true,
    );
  }

  @override
  Future<List<MessageModel>> getMessages(String chatId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return [
      MessageModel(
        id: 'msg_1',
        chatId: chatId,
        senderId: 'user_2',
        content: 'Hey! How are you?',
        timestamp: DateTime.now().subtract(const Duration(minutes: 10)),
        isSent: false,
      ),
      MessageModel(
        id: 'msg_2',
        chatId: chatId,
        senderId: 'user_1',
        content: 'I\'m good! Thanks for asking.',
        timestamp: DateTime.now().subtract(const Duration(minutes: 8)),
        isSent: true,
        isRead: true,
      ),
    ];
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
    await Future.delayed(const Duration(milliseconds: 500));
    return MessageModel(
      id: 'msg_${DateTime.now().millisecondsSinceEpoch}',
      chatId: chatId,
      senderId: 'user_1',
      content: content,
      timestamp: DateTime.now(),
      isSent: true,
      type: type,
      replyToId: replyToId,
      isDissolving: isDissolving,
      dissolveDuration: dissolveDuration,
    );
  }

  @override
  Future<void> markAsRead(String chatId, String messageId) async {
    await Future.delayed(const Duration(milliseconds: 200));
  }

  @override
  Future<void> addReaction(String messageId, String reaction) async {
    await Future.delayed(const Duration(milliseconds: 200));
  }

  @override
  Future<void> deleteMessage(String messageId) async {
    await Future.delayed(const Duration(milliseconds: 300));
  }
}
