import 'package:flutter/material.dart';
import 'models.dart';

class DriverStateNotifier extends ChangeNotifier {
  late DriverStats _stats;
  List<PaymentTransaction> _transactions = [];
  PayoutProgress _payoutStatus = PayoutProgress.idle;
  SyncProgress _syncStatus = SyncProgress.idle;
  double _successPayoutAmount = 0.0;
  String? _payoutErrorMessage;

  DriverStats get stats => _stats;
  List<PaymentTransaction> get transactions => _transactions;
  PayoutProgress get payoutStatus => _payoutStatus;
  SyncProgress get syncStatus => _syncStatus;
  double get successPayoutAmount => _successPayoutAmount;
  String? get payoutErrorMessage => _payoutErrorMessage;

  int _nextTxId = 100;

  DriverStateNotifier() {
    _initializeData();
  }

  void _initializeData() {
    _stats = DriverStats(
      id: 1,
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

    _transactions = [
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
  }

  void completeRide() {
    final int newRides = _stats.successfulRides + 1;
    final double earnedAmount = 1450.0;
    final int newXp = _stats.xp + 10;
    final double newBalance = _stats.balance + earnedAmount;

    _stats = _stats.copyWith(
      successfulRides: newRides,
      balance: newBalance,
      xp: newXp,
    );

    _transactions.insert(
      0,
      PaymentTransaction(
        id: _nextTxId++,
        title: "Ride completed #${newRides + 341}",
        subtitle: "Almaty Center Area ride, +10 XP",
        amount: earnedAmount,
        isIncome: true,
        timestamp: DateTime.now(),
      ),
    );

    notifyListeners();
  }

  Future<void> syncWithYandex() async {
    if (_syncStatus == SyncProgress.syncing) return;

    _syncStatus = SyncProgress.syncing;
    notifyListeners();

    // Simulate networking delay of 2 seconds
    await Future.delayed(const Duration(seconds: 2));

    const int ridesAdded = 4;
    const int xpAdded = ridesAdded * 10;
    const double earnedAmount = 7200.0;

    _stats = _stats.copyWith(
      successfulRides: _stats.successfulRides + ridesAdded,
      balance: _stats.balance + earnedAmount,
      xp: _stats.xp + xpAdded,
      lastSyncTime: DateTime.now(),
    );

    _transactions.insert(
      0,
      PaymentTransaction(
        id: _nextTxId++,
        title: "Yandex Portal Synced",
        subtitle: "Synced $ridesAdded rides, +$xpAdded XP boost",
        amount: earnedAmount,
        isIncome: true,
        timestamp: DateTime.now(),
      ),
    );

    _syncStatus = SyncProgress.success;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 1500));
    _syncStatus = SyncProgress.idle;
    notifyListeners();
  }

  Future<void> payoutToKaspi(double amount) async {
    if (_payoutStatus == PayoutProgress.loading) return;

    if (amount <= 0) {
      _payoutErrorMessage = "Жарамсыз сома / Некорректная сумма";
      _payoutStatus = PayoutProgress.error;
      notifyListeners();
      return;
    }

    if (amount > _stats.balance) {
      _payoutErrorMessage = "Жеткіліксіз қаражат / Недостаточно средств";
      _payoutStatus = PayoutProgress.error;
      notifyListeners();
      return;
    }

    _payoutStatus = PayoutProgress.loading;
    _payoutErrorMessage = null;
    notifyListeners();

    // Simulate Kaspi payouts instant network time
    await Future.delayed(const Duration(milliseconds: 1800));

    _stats = _stats.copyWith(balance: _stats.balance - amount);

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
    notifyListeners();
  }

  void clearPayoutStatus() {
    _payoutStatus = PayoutProgress.idle;
    _payoutErrorMessage = null;
    notifyListeners();
  }

  void addMockReferral(String name) {
    const double commission = 4500.0;

    _stats = _stats.copyWith(
      referralCount: _stats.referralCount + 1,
      referralIncome: _stats.referralIncome + commission,
      balance: _stats.balance + commission,
    );

    _transactions.insert(
      0,
      PaymentTransaction(
        id: _nextTxId++,
        title: "Referral Commission Recieved",
        subtitle: "From new driver: $name",
        amount: commission,
        isIncome: true,
        timestamp: DateTime.now(),
      ),
    );

    notifyListeners();
  }

  void changeLanguage(String lang) {
    _stats = _stats.copyWith(currentLanguage: lang);
    notifyListeners();
  }

  void resetStats() {
    _initializeData();
    _payoutStatus = PayoutProgress.idle;
    _syncStatus = SyncProgress.idle;
    _payoutErrorMessage = null;
    notifyListeners();
  }
}

class DriverStateScope extends InheritedNotifier<DriverStateNotifier> {
  const DriverStateScope({
    Key? key,
    required DriverStateNotifier notifier,
    required Widget child,
  }) : super(key: key, notifier: notifier, child: child);

  static DriverStateNotifier of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<DriverStateScope>();
    assert(scope != null, 'No DriverStateScope found in context');
    return scope!.notifier!;
  }
}
