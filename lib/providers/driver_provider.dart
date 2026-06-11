import 'package:flutter/foundation.dart';
import '../models.dart';
import '../data/repositories/driver_data_repository.dart';
import '../data/repositories/kaspi_payout_repository.dart';

class DriverProvider extends ChangeNotifier {
  final DriverDataRepository _driverDataRepository;
  final KaspiPayoutRepository _kaspiPayoutRepository;

  DriverStats? _stats;
  List<PaymentTransaction> _transactions = [];
  PayoutProgress _payoutStatus = PayoutProgress.idle;
  SyncProgress _syncStatus = SyncProgress.idle;
  double _successPayoutAmount = 0.0;
  String? _payoutErrorMessage;

  int _nextTxId = 100;
  bool _isLoading = true;

  DriverProvider({
    required DriverDataRepository driverDataRepository,
    required KaspiPayoutRepository kaspiPayoutRepository,
  })  : _driverDataRepository = driverDataRepository,
        _kaspiPayoutRepository = kaspiPayoutRepository {
    _initData();
  }

  DriverStats get stats => _stats ?? DriverStats(
    id: 0,
    driverName: "Loading...",
    clanName: "",
    balance: 0,
    xp: 0,
    successfulRides: 0,
    referralIncome: 0,
    referralCount: 0,
    currentLanguage: "Қазақша",
    lastSyncTime: DateTime.now(),
  );

  List<PaymentTransaction> get transactions => _transactions;
  PayoutProgress get payoutStatus => _payoutStatus;
  SyncProgress get syncStatus => _syncStatus;
  double get successPayoutAmount => _successPayoutAmount;
  String? get payoutErrorMessage => _payoutErrorMessage;
  bool get isLoading => _isLoading;

  Future<void> _initData() async {
    _isLoading = true;
    notifyListeners();

    try {
      _stats = await _driverDataRepository.getDriverStats(1);
      _transactions = await _driverDataRepository.getTransactions(1);
    } catch (e) {
      debugPrint("Error loading data: \$e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> syncWithYandex() async {
    if (_syncStatus == SyncProgress.syncing || _stats == null) return;

    _syncStatus = SyncProgress.syncing;
    notifyListeners();

    try {
      await _driverDataRepository.syncYandexRides();

      const int ridesAdded = 4;
      const int xpAdded = ridesAdded * 10;
      const double earnedAmount = 7200.0;

      _stats = _stats!.copyWith(
        successfulRides: _stats!.successfulRides + ridesAdded,
        balance: _stats!.balance + earnedAmount,
        xp: _stats!.xp + xpAdded,
        lastSyncTime: DateTime.now(),
      );

      _transactions.insert(
        0,
        PaymentTransaction(
          id: _nextTxId++,
          title: "Yandex Portal Synced",
          subtitle: "Synced \$ridesAdded rides, +\$xpAdded XP boost",
          amount: earnedAmount,
          isIncome: true,
          timestamp: DateTime.now(),
        ),
      );

      _syncStatus = SyncProgress.success;
      notifyListeners();

      await Future.delayed(const Duration(milliseconds: 1500));
    } catch (e) {
      debugPrint("Error syncing: \$e");
    } finally {
      _syncStatus = SyncProgress.idle;
      notifyListeners();
    }
  }

  Future<void> payoutToKaspi(double amount) async {
    if (_payoutStatus == PayoutProgress.loading || _stats == null) return;

    if (amount <= 0) {
      _payoutErrorMessage = "Жарамсыз сома / Некорректная сумма";
      _payoutStatus = PayoutProgress.error;
      notifyListeners();
      return;
    }

    if (amount > _stats!.balance) {
      _payoutErrorMessage = "Жеткіліксіз қаражат / Недостаточно средств";
      _payoutStatus = PayoutProgress.error;
      notifyListeners();
      return;
    }

    _payoutStatus = PayoutProgress.loading;
    _payoutErrorMessage = null;
    notifyListeners();

    try {
      bool success = await _kaspiPayoutRepository.processPayout(amount);
      if (success) {
        _stats = _stats!.copyWith(balance: _stats!.balance - amount);

        _transactions.insert(
          0,
          PaymentTransaction(
            id: _nextTxId++,
            title: "Kaspi.kz Cashout Processed",
            subtitle: "Transferred to Kaspi Gold Card",
            amount: amount,
            isIncome: false,
            timestamp: DateTime.now(),
          ),
        );

        _successPayoutAmount = amount;
        _payoutStatus = PayoutProgress.success;
      }
    } catch (e) {
      _payoutErrorMessage = "Сервер қатесі / Ошибка сервера";
      _payoutStatus = PayoutProgress.error;
    } finally {
      notifyListeners();
    }
  }

  void completeRide() {
    if (_stats == null) return;

    final int newRides = _stats!.successfulRides + 1;
    final double earnedAmount = 1450.0;
    final int newXp = _stats!.xp + 10;
    final double newBalance = _stats!.balance + earnedAmount;

    _stats = _stats!.copyWith(
      successfulRides: newRides,
      balance: newBalance,
      xp: newXp,
    );

    _transactions.insert(
      0,
      PaymentTransaction(
        id: _nextTxId++,
        title: "Ride completed #\${newRides + 341}",
        subtitle: "Almaty Center Area ride, +10 XP",
        amount: earnedAmount,
        isIncome: true,
        timestamp: DateTime.now(),
      ),
    );

    notifyListeners();
  }

  void addMockReferral(String name) {
    if (_stats == null) return;
    const double commission = 4500.0;

    _stats = _stats!.copyWith(
      referralCount: _stats!.referralCount + 1,
      referralIncome: _stats!.referralIncome + commission,
      balance: _stats!.balance + commission,
    );

    _transactions.insert(
      0,
      PaymentTransaction(
        id: _nextTxId++,
        title: "Referral Commission Recieved",
        subtitle: "From new driver: \$name",
        amount: commission,
        isIncome: true,
        timestamp: DateTime.now(),
      ),
    );

    notifyListeners();
  }

  void clearPayoutStatus() {
    _payoutStatus = PayoutProgress.idle;
    _payoutErrorMessage = null;
    notifyListeners();
  }

  void changeLanguage(String lang) {
    if (_stats == null) return;
    _stats = _stats!.copyWith(currentLanguage: lang);
    notifyListeners();
  }

  void resetStats() {
    _initData();
    _payoutStatus = PayoutProgress.idle;
    _syncStatus = SyncProgress.idle;
    _payoutErrorMessage = null;
    notifyListeners();
  }
}
