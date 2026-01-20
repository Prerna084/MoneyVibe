import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/network/network_client.dart';

class AuthRepository {
  final NetworkClient _client;
  static const String _tokenKey = 'auth_token';

  AuthRepository(this._client);

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
  }

  Future<String> signup(String email, String password) async {
    try {
      final response = await _client.dio.post('auth/signup', data: {
        'email': email,
        'password': password,
      });
      final token = response.data['token'];
      await saveToken(token);
      return token;
    } on DioException catch (e) {
      if (e.response?.statusCode == 409) {
        // User already exists, fallback to login
        return login(email, password);
      }
      String? message;
      if (e.response?.data is Map) {
        message = e.response?.data['message'];
      } else if (e.response?.data is String) {
        message = e.response?.data;
      }
      throw Exception(message ?? 'Signup failed');
    }
  }

  Future<String> login(String email, String password) async {
    try {
      final response = await _client.dio.post('auth/login', data: {
        'email': email,
        'password': password,
      });
      final token = response.data['token'];
      await saveToken(token);
      return token;
    } on DioException catch (e) {
      String? message;
      if (e.response?.data is Map) {
        message = e.response?.data['message'];
      } else if (e.response?.data is String) {
        message = e.response?.data;
      }
      throw Exception(message ?? 'Login failed');
    }
  }
}
