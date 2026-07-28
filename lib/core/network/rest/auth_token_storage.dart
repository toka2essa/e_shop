import 'package:shared_preferences/shared_preferences.dart';

class AuthTokenStorage {
  static const _tokenKey = 'access_token';

  Future<void> save(String token) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(_tokenKey, token);
  }

  Future<String?> read() async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.getString(_tokenKey);
  }
}
