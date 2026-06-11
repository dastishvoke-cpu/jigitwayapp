import 'package:dio/dio.dart';
import '../../core/network/dio_client.dart';
import '../../models.dart';

class DriverDataRepository {
  final Dio _dio = DioClient().dio;

  Future<DriverStats> getDriverStats(int driverId) async {
    try {
      // Mock network response, structure ready for endpoint swap
      // final response = await _dio.get('/api/driver/$driverId/stats');
      // return DriverStats.fromJson(response.data);
      await Future.delayed(const Duration(seconds: 1));
      return DriverStats(
        id: driverId,
        driverName: "Шыңғысхан",
        clanName: "Uly Júz",
        balance: 53230.0,
        xp: 710,
        successfulRides: 71,
        referralIncome: 15400.0,
        referralCount: 3,
        currentLanguage: "Қазақша",
        lastSyncTime: DateTime.now(),
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<List<PaymentTransaction>> getTransactions(int driverId) async {
    try {
      // Mock network response
      await Future.delayed(const Duration(seconds: 1));
      return [
        PaymentTransaction(
          id: 1,
          title: "Ride completed #341",
          subtitle: "Almaty, Shymbulak Route",
          amount: 4800.0,
          isIncome: true,
          timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        ),
        PaymentTransaction(
          id: 2,
          title: "Kaspi.kz Cashout",
          subtitle: "Payout to Card **4400",
          amount: 12000.0,
          isIncome: false,
          timestamp: DateTime.now().subtract(const Duration(days: 1)),
        ),
        PaymentTransaction(
          id: 3,
          title: "Ride completed #340",
          subtitle: "Abay Ave to Dostyk Ave",
          amount: 2600.0,
          isIncome: true,
          timestamp: DateTime.now().subtract(const Duration(days: 1, hours: 2)),
        ),
        PaymentTransaction(
          id: 4,
          title: "Partner Referral Commission",
          subtitle: "From driver Arman S.",
          amount: 1500.0,
          isIncome: true,
          timestamp: DateTime.now().subtract(const Duration(days: 2)),
        ),
      ];
    } catch (e) {
      rethrow;
    }
  }

  Future<void> syncYandexRides() async {
     try {
        // final response = await _dio.post('/api/driver/sync_yandex');
        await Future.delayed(const Duration(seconds: 2));
     } catch (e) {
        rethrow;
     }
  }
}
