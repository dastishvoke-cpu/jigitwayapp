import 'package:dio/dio.dart';
import '../../core/network/dio_client.dart';

class KaspiPayoutRepository {
  final Dio _dio = DioClient().dio;

  Future<bool> processPayout(double amount) async {
    try {
      // Mock network response, structure ready for endpoint swap
      // final response = await _dio.post('/api/payout/kaspi', data: {'amount': amount});
      // return response.statusCode == 200;
      await Future.delayed(const Duration(milliseconds: 1800));
      return true;
    } catch (e) {
      rethrow;
    }
  }
}
