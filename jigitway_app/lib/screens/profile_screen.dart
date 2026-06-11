import 'package:flutter/material.dart';
import '../models.dart';
import '../localization.dart';
import '../state.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController _amountController = TextEditingController();
  DriverStateNotifier? _stateNotifier;
  String? _cashoutErrorText;
  bool _showSuccessDialog = false;
  double _successWithdrawnAmount = 0.0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final state = DriverStateScope.of(context);
    if (_stateNotifier != state) {
      _stateNotifier?.removeListener(_onStateChanged);
      _stateNotifier = state;
      _stateNotifier?.addListener(_onStateChanged);
    }
  }

  @override
  void dispose() {
    _stateNotifier?.removeListener(_onStateChanged);
    _amountController.dispose();
    super.dispose();
  }

  void _onStateChanged() {
    if (!mounted || _stateNotifier == null) return;
    final state = _stateNotifier!;

    if (state.payoutStatus == PayoutProgress.success) {
      final amt = state.successPayoutAmount;
      state.clearPayoutStatus();
      _amountController.clear();
      setState(() {
        _successWithdrawnAmount = amt;
        _showSuccessDialog = true;
        _cashoutErrorText = null;
      });
      _triggerSuccessDialog();
    } else if (state.payoutStatus == PayoutProgress.error) {
      final err = state.payoutErrorMessage;
      state.clearPayoutStatus();
      setState(() {
        _cashoutErrorText = err;
      });
    }
  }

  void _triggerSuccessDialog() {
    final lang = _stateNotifier?.stats.currentLanguage ?? "Қазақша";

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext ctx) {
        return AlertDialog(
          backgroundColor: const Color(0xFF151515),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
            side: const BorderSide(color: Color(0x3322C55E), width: 1),
          ),
          title: Text(
            lang == "Қазақша" ? "Аударым сәтті өтті!" : "Выплата успешно проведена!",
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.black,
              fontSize: 18,
            ),
            textAlign: TextAlign.center,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 54,
                height: 54,
                decoration: const BoxDecoration(
                  color: Color(0xFFE31E24),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 34,
                ),
              ),
              const SizedBox(height: 14),
              Text(
                formatTenge(_successWithdrawnAmount),
                style: const TextStyle(
                  color: Color(0xFF22C55E),
                  fontSize: 32,
                  fontWeight: FontWeight.black,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                lang == "Қазақша"
                    ? "Сәттілік! Қаражат Сіздің Kaspi Gold картаңызға түсті."
                    : "Поздравляем! Средства моментально отправлены на вашу карту Kaspi Gold.",
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actions: [
            Center(
              child: SizedBox(
                width: 120,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(ctx).pop();
                    setState(() {
                      _showSuccessDialog = false;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF22C55E),
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "OK",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  String formatTenge(double value) {
    String str = value.toInt().toString();
    RegExp reg = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
    String formatted = str.replaceAllMapped(reg, (Match m) => "${m[1]},");
    return "$formatted ₸";
  }

  @override
  Widget build(BuildContext context) {
    final state = DriverStateScope.of(context);
    final stats = state.stats;
    final lang = stats.currentLanguage;

    final mockPartners = [
      "Арман С. (Sarbaz)",
      "Данияр К. (Jolayshy)",
      "Тимур Е. (Sarbaz)",
      "Әділет М. (Suńqar)",
      "Нұрсұлтан Т. (Shabandóz)"
    ].take(stats.referralCount).toList();

    return Scaffold(
      backgroundColor: const Color(0xFF101010),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          children: [
            // Driver Profile Brief Metircs
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF1A1A1A), Color(0xFF121212)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0x1AFFFFFF), width: 1),
              ),
              child: Row(
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      color: Color(0xFFEAB308),
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      stats.driverName.isNotEmpty ? stats.driverName.substring(0, 1).toUpperCase() : "J",
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 22,
                        fontWeight: FontWeight.black,
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          stats.driverName.toUpperCase(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.black,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 2),
                        const Text(
                          "YANDEX FLEET PARTNER • ID: 742119",
                          style: TextStyle(
                            color: Colors.white60,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Kaspi Gold instant Paut card
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF1A1A1A), Color(0xFF121212)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0x3322C55E), width: 1), // Glowing emerald thin border
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        Localization.getText("payout_section", lang).toUpperCase(),
                        style: const TextStyle(
                          color: Color(0xFF22C55E),
                          fontSize: 11,
                          fontWeight: FontWeight.black,
                          letterSpacing: 0.5,
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFE31E24),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        child: const Text(
                          "KASPI.KZ",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    lang == "Қазақша"
                        ? "Жедел балансты Kaspi Gold-қа секунд ішінде шығару."
                        : lang == "Русский"
                            ? "Моментальные выплаты на Kaspi Gold 24/7."
                            : "Instant payouts to Kaspi Gold 24/7.",
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.6),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _amountController,
                    onChanged: (val) {
                      if (_cashoutErrorText != null) {
                        setState(() {
                          _cashoutErrorText = null;
                        });
                      }
                    },
                    style: const TextStyle(color: Colors.white),
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: Localization.getText("amount_label", lang).toUpperCase(),
                      labelStyle: TextStyle(
                        color: Colors.white.withOpacity(0.4),
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                      filled: true,
                      fillColor: const Color(0xFF121212),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.white.withOpacity(0.1), width: 1),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Color(0xFF22C55E), width: 1),
                      ),
                    ),
                  ),
                  if (_cashoutErrorText != null) ...[
                    const SizedBox(height: 6),
                    Text(
                      _cashoutErrorText!,
                      style: const TextStyle(
                        color: Colors.redAccent,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: state.payoutStatus == PayoutProgress.loading
                          ? null
                          : () {
                              final amt = double.tryParse(_amountController.text);
                              if (amt == null || amt <= 0) {
                                setState(() {
                                  _cashoutErrorText = lang == "Қазақша" ? "Дұрыс соманы жазыңыз" : "Введите корректную сумму";
                                });
                              } else {
                                state.payoutToKaspi(amt);
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF22C55E),
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: state.payoutStatus == PayoutProgress.loading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(color: Colors.black, strokeWidth: 2),
                            )
                          : Text(
                              Localization.getText("withdraw_btn", lang).toUpperCase(),
                              style: const TextStyle(
                                fontWeight: FontWeight.black,
                                fontSize: 14,
                                letterSpacing: 1.0,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Referral list Section
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF1A1A1A), Color(0xFF121212)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0x3338BDF8), width: 1), // Glowing cyan boundary
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "REFERRAL NETWORK",
                    style: TextStyle(
                      color: Color(0xFF38BDF8),
                      fontSize: 11,
                      fontWeight: FontWeight.black,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    Localization.getFormatted(
                      "referral_stats",
                      lang,
                      [stats.referralCount.toString(), formatTenge(stats.referralIncome)],
                    ),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),

                  if (mockPartners.isEmpty)
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.03),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: const Color(0x1AFFFFFF), width: 0.5),
                      ),
                      padding: const EdgeInsets.all(12),
                      alignment: Alignment.center,
                      child: Text(
                        lang == "Қазақша" ? "Серіктес шақырылмаған" : "Вы ещё не пригласили партнеров",
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.4),
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  else
                    ...mockPartners.map((partner) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.03),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: const Color(0x1AFFFFFF), width: 0.5),
                          ),
                          padding: const EdgeInsets.all(10),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.account_box,
                                color: Color(0xFF38BDF8),
                                size: 16,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                partner,
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.8),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const Spacer(),
                              const Text(
                                "+1.5% commission",
                                style: TextStyle(
                                  color: Color(0xFF22C55E),
                                  fontSize: 10,
                                  fontWeight: FontWeight.black,
                                  letterSpacing: 0.2,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),

                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: OutlinedButton(
                      onPressed: () {
                        final names = ["Бауыржан К.", "Жандос С.", "Олжас А.", "Марат Б.", "Канат Х."];
                        final nextName = names[stats.referralCount % names.length];
                        state.addMockReferral(nextName);
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF38BDF8),
                        side: BorderSide(color: const Color(0xFF38BDF8).withOpacity(0.3), width: 1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: Text(
                        Localization.getText("add_referral_btn", lang).toUpperCase(),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Settings Section
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF1A1A1A), Color(0xFF121212)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0x1AFFFFFF), width: 1),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    Localization.getText("settings_section", lang).toUpperCase(),
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.4),
                      fontSize: 11,
                      fontWeight: FontWeight.black,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Language Chips Custom Selector
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        Localization.getText("lang_caption", lang).toUpperCase(),
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.4),
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: ["Қазақша", "Русский", "English"].map((langChip) {
                          final isSelected = stats.currentLanguage == langChip;
                          return Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 4),
                              child: GestureDetector(
                                onTap: () => state.changeLanguage(langChip),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                  decoration: BoxDecoration(
                                    color: isSelected ? const Color(0xFFEAB308) : const Color(0xFF121212),
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color: isSelected ? const Color(0xFFEAB308) : Colors.white.withOpacity(0.05),
                                      width: 1,
                                    ),
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    langChip,
                                    style: TextStyle(
                                      color: isSelected ? Colors.black : Colors.white.withOpacity(0.6),
                                      fontSize: 12,
                                      fontWeight: FontWeight.black,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Theme Lock Indicator Widget
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            (lang == "Қазақша" ? "Қолданба Тақырыбы" : "Тема оформления").toUpperCase(),
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.4),
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(height: 2),
                          const Text(
                            "BRUTAL DEEP DARK MODE",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.black,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0x1F22C55E),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        child: const Text(
                          "ACTIVE",
                          style: TextStyle(
                            color: Color(0xFF22C55E),
                            fontSize: 9,
                            fontWeight: FontWeight.black,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Reset button
                  SizedBox(
                    width: double.infinity,
                    height: 46,
                    child: ElevatedButton(
                      onPressed: () => state.resetStats(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0x22EF4444),
                        foregroundColor: const Color(0xFFFCA5A5),
                        side: const BorderSide(color: Color(0x33EF4444), width: 1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        Localization.getText("reset_btn", lang).toUpperCase(),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
