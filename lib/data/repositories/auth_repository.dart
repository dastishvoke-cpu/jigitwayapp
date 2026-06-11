import 'package:dio/dio.dart';
import '../../core/network/dio_client.dart';

class AuthRepository {
  final Dio _dio = DioClient().dio;

  Future<bool> login(String username, String password) async {
    try {
      // Mock login for now, structure ready for endpoint swap
      // final response = await _dio.post('/api/auth/login', data: {'username': username, 'password': password});
      // return response.statusCode == 200;
      await Future.delayed(const Duration(seconds: 1));
      return true;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> logout() async {
    // Mock logout
  }
}
