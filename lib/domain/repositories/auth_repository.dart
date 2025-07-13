import 'package:dio/dio.dart';

class AuthRepository {
  final Dio _dio;

  AuthRepository([Dio? dio]) : _dio = dio ?? Dio(BaseOptions(baseUrl: 'https://api.skinsense.com'));

  Future<void> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    final res = await _dio.post('/auth/register', data: {
      'name': name,
      'email': email,
      'password': password,
    });
    if (res.statusCode != 200) {
      throw Exception(res.data['message'] ?? 'Registration failed');
    }
  }

  Future<String> signIn({
    required String email,
    required String password,
  }) async {
    final res = await _dio.post('/auth/login', data: {
      'email': email,
      'password': password,
    });
    if (res.statusCode == 200 && res.data['token'] != null) {
      return res.data['token'] as String;
    }
    throw Exception(res.data['message'] ?? 'Login failed');
  }
}
