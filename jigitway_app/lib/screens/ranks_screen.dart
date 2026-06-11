import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../models.dart';
import '../localization.dart';
import '../state.dart';

class RanksScreen extends StatefulWidget {
  const RanksScreen({Key? key}) : super(key: key);

  @override
  State<RanksScreen> createState() => _RanksScreenState();
}

class _RanksScreenState extends State<RanksScreen> with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseScale;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    )..repeat(reverse: true);

    _pulseScale = Tween<double>(begin: 0.85, end: 1.15).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final state = DriverStateScope.of(context);
    final stats = state.stats;
    final lang = stats.currentLanguage;
    final currentRank = getCurrentRankInfo(stats.xp);

    return Scaffold(
      backgroundColor: const Color(0xFF101010),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          children: [
            // Top Clan Header
            Padding(
              padding: const EdgeInsets.only(top: 18, bottom: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        Localization.getText("rank_prog_title", lang).toUpperCase(),
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.4),
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.0,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Text(
                            currentRank.name.toUpperCase(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.black,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFFEAB308),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            child: Text(
                              "RANK ${currentRank.id}",
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        "CLAN",
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.4),
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.0,
                        ),
                      ),
                      Text(
                        stats.clanName.toUpperCase(),
                        style: const TextStyle(
                          color: Color(0xFF38BDF8),
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Digital Centerpiece glowing card representing vehicle artwork
            Container(
              height: 200,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF1A1A1A), Color(0xFF121212)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0x1AFFFFFF), width: 1),
              ),
              child: Stack(
                children: [
                  // Radial gold glow mapping behind the car
                  AnimatedBuilder(
                    animation: _pulseScale,
                    builder: (context, child) {
                      return Center(
                        child: Container(
                          width: 195 * _pulseScale.value,
                          height: 195 * _pulseScale.value,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: RadialGradient(
                              colors: [
                                const Color(0xFFEAB308).withOpacity(0.25 * _pulseScale.value),
                                Colors.transparent,
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),

                  // Sports car graphics representation (since local assets are missing, we use a beautifully painted vector silhouette)
                  Center(
                    child: HeroCarSilhouette(color: const Color(0xFFEAB308)),
                  ),

                  // Driver Avatar Tag overlap
                  Positioned(
                    bottom: 12,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xE6101010),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: const Color(0x1AFFFFFF), width: 1),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 16,
                              height: 16,
                              alignment: Alignment.center,
                              decoration: const BoxDecoration(
                                color: Color(0xFFEAB308),
                                shape: BoxShape.circle,
                              ),
                              child: Text(
                                stats.driverName.isNotEmpty ? stats.driverName.substring(0, 1).toUpperCase() : "J",
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 9,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              "${currentRank.name} (${stats.xp} XP)",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Current Rank Progress Card with Custom Gradient Progress Bar
            Container(
              padding: const EdgeInsets.all(18),
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
                    Localization.getText("current_rank_card", lang).toUpperCase(),
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.4),
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        currentRank.name.toUpperCase(),
                        style: const TextStyle(
                          color: Color(0xFFEAB308),
                          fontSize: 22,
                          fontWeight: FontWeight.black,
                        ),
                      ),
                      Text(
                        "${stats.xp} XP",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // Progress Bar Math & Animation Rendering
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final isMaxRank = currentRank.id == ranksList.length;
                      final double progressRatio = isMaxRank
                          ? 1.0
                          : (() {
                              final currentRankRange = currentRank.maxXp - currentRank.minXp + 1;
                              final activeProgress = stats.xp - currentRank.minXp;
                              return (activeProgress / currentRankRange).clamp(0.0, 1.0);
                            })();

                      return Stack(
                        children: [
                          Container(
                            height: 10,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(color: Colors.white.withOpacity(0.05), width: 0.5),
                            ),
                          ),
                          Container(
                            height: 10,
                            width: constraints.maxWidth * progressRatio,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFFEAB308), Color(0xFFFACC15)],
                              ),
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 8),

                  // Completion Help String
                  Builder(
                    builder: (context) {
                      final isMaxRank = currentRank.id == ranksList.length;
                      final helperText = isMaxRank
                          ? (lang == "Қазақша"
                              ? "МАКСИМАЛДЫ VIP ДӘРЕЖЕ"
                              : lang == "Русский"
                                  ? "МАКСИМАЛЬНЫЙ VIP РАНГ"
                                  : "MAXIMUM VIP STATS")
                          : (() {
                              final nextRank = ranksList[currentRank.id];
                              final missingXp = nextRank.minXp - stats.xp;
                              return "${Localization.getFormatted('xp_needed', lang, [missingXp.toString()])} (${nextRank.name})";
                            })();

                      return Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          helperText.toUpperCase(),
                          style: TextStyle(
                            color: isMaxRank ? const Color(0xFFEAB308) : Colors.white.withOpacity(0.4),
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Roadmap Path Header
            Padding(
              padding: const EdgeInsets.only(left: 4, right: 4, top: 10, bottom: 4),
              child: Text(
                lang == "Қазақша"
                    ? "Дәреже Тізімі"
                    : lang == "Русский"
                        ? "Боевой путь рангов"
                        : "Warriors Path Index",
                style: TextStyle(
                  color: Colors.white.withOpacity(0.4),
                  fontSize: 11,
                  fontWeight: FontWeight.black,
                  letterSpacing: 1.0,
                ),
              ),
            ),
            const SizedBox(height: 8),

            // Road ranks map
            ...ranksList.map((r) {
              final isUnlocked = stats.xp >= r.minXp;
              final isActive = currentRank.id == r.id;

              final itemAlpha = isActive
                  ? 1.0
                  : isUnlocked
                      ? 0.60
                      : 0.35;

              return Opacity(
                opacity: itemAlpha,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      gradient: isActive
                          ? const LinearGradient(colors: [Color(0x1CEAB308), Color(0x06EAB308)])
                          : const LinearGradient(colors: [Color(0xFF1A1A1A), Color(0xFF121212)]),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isActive
                            ? const Color(0x4DEAB308)
                            : isUnlocked
                                ? const Color(0x1AFFFFFF)
                                : Colors.white.withOpacity(0.05),
                        width: isActive ? 1 : 0.5,
                      ),
                    ),
                    child: Row(
                      children: [
                        // Check Circle / Locked Indicator
                        Container(
                          width: 34,
                          height: 34,
                          decoration: BoxDecoration(
                            color: isActive
                                ? const Color(0xFFEAB308)
                                : isUnlocked
                                    ? const Color(0x1AEAB308)
                                    : Colors.white.withOpacity(0.04),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            isUnlocked ? Icons.check : Icons.lock,
                            color: isActive
                                ? Colors.black
                                : isUnlocked
                                    ? const Color(0xFFEAB308)
                                    : Colors.grey,
                            size: isUnlocked ? 16 : 14,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    r.name.toUpperCase(),
                                    style: TextStyle(
                                      color: isActive ? const Color(0xFFEAB308) : Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.black,
                                    ),
                                  ),
                                  if (isActive) ...[
                                    const SizedBox(width: 8),
                                    Container(
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFEAB308),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                      child: const Text(
                                        "ACTIVE",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 8,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ]
                                ],
                              ),
                              const SizedBox(height: 2),
                              Text(
                                r.description[lang] ?? r.name,
                                style: TextStyle(
                                  color: isUnlocked ? Colors.white70 : Colors.grey,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          r.id == 5 ? "10K+ XP" : "${r.minXp}-${r.maxXp} XP",
                          style: TextStyle(
                            color: isActive
                                ? const Color(0xFFEAB308)
                                : isUnlocked
                                    ? Colors.white.withOpacity(0.7)
                                    : Colors.grey,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}

// Custom vehicle vector artwork drawer for high fidelity designs
class HeroCarSilhouette extends StatelessWidget {
  final Color color;

  const HeroCarSilhouette({Key? key, required this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      height: 100,
      child: CustomPaint(
        painter: CarPainter(color: color),
      ),
    );
  }
}

class CarPainter extends CustomPainter {
  final Color color;

  CarPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paintObj = Paint()
      ..color = color
      ..style = PaintingStyle.fill
      ..strokeWidth = 2;

    final glowPaint = Paint()
      ..color = color.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    final path = Path();
    // Sports racing coupe vector math styling coordinates
    path.moveTo(0, size.height * 0.7);
    path.quadraticBezierTo(size.width * 0.1, size.height * 0.65, size.width * 0.2, size.height * 0.5);
    path.quadraticBezierTo(size.width * 0.35, size.height * 0.2, size.width * 0.55, size.height * 0.2);
    path.lineTo(size.width * 0.72, size.height * 0.45);
    path.quadraticBezierTo(size.width * 0.88, size.height * 0.45, size.width * 0.95, size.height * 0.5);
    path.quadraticBezierTo(size.width, size.height * 0.6, size.width, size.height * 0.7);
    path.lineTo(size.width * 0.85, size.height * 0.7);
    // Wheel arches curves
    path.arcToPoint(Offset(size.width * 0.75, size.height * 0.7), radius: Radius.circular(10), clockwise: false);
    path.lineTo(size.width * 0.25, size.height * 0.7);
    path.arcToPoint(Offset(size.width * 0.15, size.height * 0.7), radius: Radius.circular(10), clockwise: false);
    path.lineTo(0, size.height * 0.7);
    path.close();

    canvas.drawPath(path, paintObj);
    canvas.drawPath(path, glowPaint);

    // Wheels drawing
    final wheelPaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;
    final rimPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    canvas.drawCircle(Offset(size.width * 0.2, size.height * 0.7), 12, wheelPaint);
    canvas.drawCircle(Offset(size.width * 0.2, size.height * 0.7), 12, rimPaint);
    canvas.drawCircle(Offset(size.width * 0.8, size.height * 0.7), 12, wheelPaint);
    canvas.drawCircle(Offset(size.width * 0.8, size.height * 0.7), 12, rimPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
