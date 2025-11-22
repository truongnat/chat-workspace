import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/user_model.dart';

abstract class AuthLocalDataSource {
  Future<void> cacheUser(UserModel user);
  Future<UserModel> getCachedUser();
  Future<void> clearCache();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SharedPreferences sharedPreferences;
  static const String cachedUserKey = 'CACHED_USER';

  AuthLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<void> cacheUser(UserModel user) async {
    await sharedPreferences.setString(
      cachedUserKey,
      jsonEncode(user.toJson()),
    );
  }

  @override
  Future<UserModel> getCachedUser() async {
    final jsonString = sharedPreferences.getString(cachedUserKey);
    if (jsonString != null) {
      return UserModel.fromJson(jsonDecode(jsonString));
    } else {
      throw Exception('No cached user found');
    }
  }

  @override
  Future<void> clearCache() async {
    await sharedPreferences.remove(cachedUserKey);
  }
}
