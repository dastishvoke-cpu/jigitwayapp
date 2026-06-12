import 'package:dio/dio.dart';
import '../../core/network/dio_client.dart';

class AuthRepository {
  final Dio _dio = DioClient().dio;

  Future<bool> sendCode(String phone) async {
    try {
      // Mock network response
      await Future.delayed(const Duration(seconds: 1));
      return true;
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> verifyOtp(String phone, String code) async {
    try {
      // Mock OTP check: only accept '0000'
      await Future.delayed(const Duration(seconds: 1));
      if (code == '0000') {
        return true;
      }
      return false;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 500));
  }
}
