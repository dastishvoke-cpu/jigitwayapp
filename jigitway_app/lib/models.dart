import 'dart:math' as math;

enum PayoutProgress { idle, loading, success, error }
enum SyncProgress { idle, syncing, success }

class DriverStats {
  final int id;
  final String driverName;
  final String clanName;
  final double balance;
  final int xp;
  final int successfulRides;
  final double referralIncome;
  final int referralCount;
  final String currentLanguage; // "Қазақша" | "Русский" | "English"
  final DateTime lastSyncTime;

  DriverStats({
    this.id = 1,
    this.driverName = "Шыңғысхан",
    this.clanName = "Uly Júz",
    this.balance = 53230.0,
    this.xp = 710,
    this.successfulRides = 71,
    this.referralIncome = 15400.0,
    this.referralCount = 3,
    this.currentLanguage = "Қазақша",
    required this.lastSyncTime,
  });

  DriverStats copyWith({
    int? id,
    String? driverName,
    String? clanName,
    double? balance,
    int? xp,
    int? successfulRides,
    double? referralIncome,
    int? referralCount,
    String? currentLanguage,
    DateTime? lastSyncTime,
  }) {
    return DriverStats(
      id: id ?? this.id,
      driverName: driverName ?? this.driverName,
      clanName: clanName ?? this.clanName,
      balance: balance ?? this.balance,
      xp: xp ?? this.xp,
      successfulRides: successfulRides ?? this.successfulRides,
      referralIncome: referralIncome ?? this.referralIncome,
      referralCount: referralCount ?? this.referralCount,
      currentLanguage: currentLanguage ?? this.currentLanguage,
      lastSyncTime: lastSyncTime ?? this.lastSyncTime,
    );
  }
}

class PaymentTransaction {
  final int id;
  final String title;
  final String subtitle;
  final double amount;
  final bool isIncome;
  final DateTime timestamp;

  PaymentTransaction({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.isIncome,
    required this.timestamp,
  });
}

class RankInfo {
  final int id;
  final String name;
  final int minXp;
  final int maxXp;
  final Map<String, String> description;
  final Map<String, String> characterTitle;

  const RankInfo({
    required this.id,
    required this.name,
    required this.minXp,
    required this.maxXp,
    required this.description,
    required this.characterTitle,
  });
}

final List<RankInfo> ranksList = [
  const RankInfo(
    id: 1,
    name: "Jolayshy",
    minXp: 0,
    maxXp: 499,
    description: {
      "Қазақша": "Жолаушы — Саяхатшы. Алғашқы қадамдар.",
      "Русский": "Жолаушы — Путешественник. Первые шаги.",
      "English": "Jolayshy — Traveler. First steps."
    },
    characterTitle: {
      "Қазақша": "Бастаушы жолаушы",
      "Русский": "Начинающий странник",
      "English": "Novice Wanderer"
    },
  ),
  const RankInfo(
    id: 2,
    name: "Sarbaz",
    minXp: 500,
    maxXp: 1999,
    description: {
      "Қазақша": "Сарбаз — Ержүрек жауынгер.",
      "Русский": "Сарбаз — Смелый воин.",
      "English": "Sarbaz — Brave warrior."
    },
    characterTitle: {
      "Қазақша": "Сенімді жауынгер",
      "Русский": "Надежный боец",
      "English": "Trusted Fighter"
    },
  ),
  const RankInfo(
    id: 3,
    name: "Shabandóz",
    minXp: 2000,
    maxXp: 4999,
    description: {
      "Қазақша": "Шабандоз — Епті атқарушы.",
      "Русский": "Шабандоз — Искусный наездник.",
      "English": "Shabandóz — Skilled rider."
    },
    characterTitle: {
      "Қазақша": "Дала пырағы",
      "Русский": "Степной всадник",
      "English": "Steppe Rider"
    },
  ),
  const RankInfo(
    id: 4,
    name: "Suńqar",
    minXp: 5000,
    maxXp: 9999,
    description: {
      "Қазақша": "Сұңқар — Қыран көзді падишаһ.",
      "Русский": "Сункар — Сокол степей.",
      "English": "Suńqar — Falcon of the steppes."
    },
    characterTitle: {
      "Қазақша": "Көк Аспан Сұңқары",
      "Русский": "Небесный Сокол",
      "English": "Heavenly Falcon"
    },
  ),
  const RankInfo(
    id: 5,
    name: "Jigit",
    minXp: 10000,
    maxXp: 2147483647, // Int Max
    description: {
      "Қазақша": "Жігіт — Ұлы даланың нағыз серісі! (VIP мәртебесі)",
      "Русский": "Жигит — Настоящий рыцарь степи! (VIP)",
      "English": "Jigit — True warrior of the steppe! (VIP)"
    },
    characterTitle: {
      "Қазақша": "Ұлы Жігіт (VIP Сұлтаны)",
      "Русский": "Великий Жигит (VIP)",
      "English": "Grand Jigit (VIP)"
    },
  ),
];

RankInfo getCurrentRankInfo(int xp) {
  return ranksList.firstWhere(
    (r) => xp >= r.minXp && xp <= r.maxXp,
    orElse: () => ranksList.last,
  );
}
