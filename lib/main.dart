import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/driver_provider.dart';
import 'data/repositories/driver_data_repository.dart';
import 'data/repositories/kaspi_payout_repository.dart';
import 'screens/home_screen.dart';
import 'screens/ranks_screen.dart';
import 'screens/profile_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => DriverProvider(
            driverDataRepository: DriverDataRepository(),
            kaspiPayoutRepository: KaspiPayoutRepository(),
          ),
        ),
      ],
      child: const JigitWayApp(),
    ),
  );
}

class JigitWayApp extends StatelessWidget {
  const JigitWayApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'JigitWay',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF101010),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFFEAB308),
          secondary: Color(0xFF38BDF8),
          surface: Color(0xFF1A1A1A),
        ),
        textTheme: const TextTheme(
          displayLarge: TextStyle(fontFamily: 'Roboto', fontWeight: FontWeight.w900),
          titleLarge: TextStyle(fontFamily: 'Roboto', fontWeight: FontWeight.bold),
          bodyMedium: TextStyle(fontFamily: 'Roboto'),
        ),
        useMaterial3: true,
      ),
      home: const MainNavigationShell(),
    );
  }
}

class MainNavigationShell extends StatefulWidget {
  const MainNavigationShell({Key? key}) : super(key: key);

  @override
  State<MainNavigationShell> createState() => _MainNavigationShellState();
}

class _MainNavigationShellState extends State<MainNavigationShell> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final state = context.watch<DriverProvider>();
    final lang = state.stats.currentLanguage;

    final String homeLabel = lang == "Қазақша"
        ? "Басты"
        : lang == "Русский"
            ? "Главная"
            : "Home";

    final String ranksLabel = lang == "Қазақша"
        ? "Дәрежелер"
        : lang == "Русский"
            ? "Ранги"
            : "Ranks";

    final String profileLabel = lang == "Қазақша"
        ? "Қаржы"
        : lang == "Русский"
            ? "Выплаты"
            : "Payouts";

    final List<Widget> screens = [
      HomeScreen(
        onNavigateToRanks: () {
          setState(() {
            _currentIndex = 1; // Direct screen mapping transition helper
          });
        },
      ),
      const RanksScreen(),
      const ProfileScreen(),
    ];

    if (state.isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(color: Color(0xFFEAB308)),
        ),
      );
    }

    return Scaffold(
      body: screens[_currentIndex],
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(color: Color(0x1AFFFFFF), width: 1),
          ),
        ),
        child: NavigationBar(
          selectedIndex: _currentIndex,
          onDestinationSelected: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          backgroundColor: const Color(0xFF1A1A1A),
          elevation: 8,
          indicatorColor: const Color(0xFFEAB308),
          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
          destinations: [
            NavigationDestination(
              icon: Icon(
                _currentIndex == 0 ? Icons.home : Icons.home_outlined,
                color: _currentIndex == 0 ? Colors.black : Colors.grey,
              ),
              label: homeLabel,
            ),
            NavigationDestination(
              icon: Icon(
                _currentIndex == 1 ? Icons.star : Icons.star_border,
                color: _currentIndex == 1 ? Colors.black : Colors.grey,
              ),
              label: ranksLabel,
            ),
            NavigationDestination(
              icon: Icon(
                _currentIndex == 2 ? Icons.account_box : Icons.account_box_outlined,
                color: _currentIndex == 2 ? Colors.black : Colors.grey,
              ),
              label: profileLabel,
            ),
          ],
        ),
      ),
    );
  }
}
