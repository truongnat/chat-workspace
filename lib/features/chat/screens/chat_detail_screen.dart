import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../theme/app_colors.dart';
import '../../../widgets/chat_bubble.dart';
import '../../../widgets/common_input.dart';

class ChatDetailScreen extends StatefulWidget {
  final String contactId;
  final String contactName;

  const ChatDetailScreen({
    super.key,
    required this.contactId,
    required this.contactName,
  });

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  final _messageController = TextEditingController();
  final List<Map<String, dynamic>> _messages = [
    {'message': 'Hey! How are you?', 'time': '10:30 AM', 'isSent': false},
    {'message': 'I\'m good! Thanks for asking.', 'time': '10:32 AM', 'isSent': true, 'isRead': true},
    {'message': 'What are you up to?', 'time': '10:33 AM', 'isSent': false},
    {'message': 'Just working on a new project. It\'s pretty exciting!', 'time': '10:35 AM', 'isSent': true, 'isRead': true},
    {'message': 'That sounds great!', 'time': '10:36 AM', 'isSent': false},
  ];

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;
    
    setState(() {
      _messages.add({
        'message': _messageController.text,
        'time': 'Now',
        'isSent': true,
        'isRead': false,
      });
      _messageController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => context.pop(),
        ),
        title: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  widget.contactName[0],
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.contactName,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Text(
                    'Online',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.success,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(LucideIcons.phone),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(LucideIcons.video),
            onPressed: () {
              context.push('/video-call/${widget.contactId}/${widget.contactName}');
            },
          ),
          IconButton(
            icon: const Icon(LucideIcons.moreVertical),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                return ChatBubble(
                  message: msg['message'],
                  time: msg['time'],
                  isSent: msg['isSent'],
                  isRead: msg['isRead'] ?? false,
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(LucideIcons.plus),
                  onPressed: () {},
                ),
                Expanded(
                  child: CustomTextField(
                    hintText: 'Type a message...',
                    controller: _messageController,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(LucideIcons.send, color: Colors.white),
                    onPressed: _sendMessage,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
