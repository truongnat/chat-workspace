import 'dart:async';
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;

class WebSocketService {
  static final WebSocketService _instance = WebSocketService._internal();
  final _storage = const FlutterSecureStorage();
  
  WebSocketChannel? _channel;
  final _controller = StreamController<Map<String, dynamic>>.broadcast();
  
  Stream<Map<String, dynamic>> get messages => _controller.stream;
  
  bool _isConnected = false;
  bool get isConnected => _isConnected;

  factory WebSocketService() {
    return _instance;
  }

  WebSocketService._internal();

  Future<void> connect() async {
    if (_isConnected) return;

    final token = await _storage.read(key: 'auth_token');
    if (token == null) {
      print('WebSocket: No auth token found');
      return;
    }

    try {
      // Use 10.0.2.2 for Android Emulator, localhost for iOS Simulator
      final wsUrl = Uri.parse('ws://10.0.2.2:8080/ws?token=$token');
      
      _channel = WebSocketChannel.connect(wsUrl);
      _isConnected = true;
      print('WebSocket: Connected');

      _channel!.stream.listen(
        (message) {
          try {
            final decoded = jsonDecode(message);
            _controller.add(decoded);
          } catch (e) {
            print('WebSocket: Failed to decode message: $e');
          }
        },
        onDone: () {
          print('WebSocket: Connection closed');
          _isConnected = false;
          _reconnect();
        },
        onError: (error) {
          print('WebSocket: Error: $error');
          _isConnected = false;
          _reconnect();
        },
      );
    } catch (e) {
      print('WebSocket: Connection failed: $e');
      _isConnected = false;
      _reconnect();
    }
  }

  void disconnect() {
    _channel?.sink.close(status.goingAway);
    _isConnected = false;
  }

  void send(String eventType, Map<String, dynamic> payload) {
    if (!_isConnected || _channel == null) {
      print('WebSocket: Not connected, cannot send message');
      return;
    }

    final message = jsonEncode({
      'type': eventType,
      'payload': payload,
    });

    _channel!.sink.add(message);
  }

  void _reconnect() {
    // Simple exponential backoff or fixed delay could be implemented here
    Future.delayed(const Duration(seconds: 5), () {
      print('WebSocket: Attempting to reconnect...');
      connect();
    });
  }
}
