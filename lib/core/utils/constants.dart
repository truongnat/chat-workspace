class AppConstants {
  // API
  static const String baseUrl = 'https://api.securechat.app';
  static const String apiVersion = 'v1';
  
  // Storage Keys
  static const String themeKey = 'app_theme';
  static const String userKey = 'user_data';
  static const String tokenKey = 'auth_token';
  
  // Timeouts
  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  
  // Pagination
  static const int defaultPageSize = 20;
  
  // Message
  static const int maxMessageLength = 1000;
  static const Duration messageDestructTimer = Duration(seconds: 10);
  
  // Video Call
  static const int maxCallDuration = 3600; // 1 hour in seconds
  
  // File Upload
  static const int maxFileSize = 10 * 1024 * 1024; // 10MB
}
