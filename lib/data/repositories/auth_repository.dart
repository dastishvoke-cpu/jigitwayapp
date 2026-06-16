import 'package:dio/dio.dart';

class AuthRepository {
  final Dio _dio;

  AuthRepository()
      : _dio = Dio(
          BaseOptions(
            baseUrl: 'http://89.207.254.4:8080',
            connectTimeout: const Duration(seconds: 10),
            receiveTimeout: const Duration(seconds: 10),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
          ),
        );

  Future<bool> sendCode(String phone) async {
    try {
      final response = await _dio.post(
        '/api/send-code',
        data: {'phone': phone},
      );
      if (response.statusCode == 200 && response.data['status'] == 'success') {
        return true;
      }
      return false;
    } catch (e) {
      rethrow;
    }
  }

  Future<String?> verifyOtp(String phone, String code) async {
    try {
      final response = await _dio.post(
        '/api/verify-code',
        data: {'phone': phone, 'code': code},
      );
      if (response.statusCode == 200 && response.data['status'] == 'success') {
        return response.data['token'] as String?;
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> logout() async {
    // Optionally call a backend logout endpoint if needed
  }
}
