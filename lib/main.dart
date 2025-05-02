import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/locale_provider.dart';
import 'providers/theme_provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'screens/now_showing_screen.dart';
import 'screens/coming_soon_screen.dart';
import 'screens/events_screen.dart';
import 'screens/profile_screen.dart';

void main() {
  Intl.defaultLocale = 'el_GR';
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LocaleProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: const TexnopolisApp(),
    ),
  );
}

class TexnopolisApp extends StatelessWidget {
  const TexnopolisApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final localeProvider = Provider.of<LocaleProvider>(context);

    return MaterialApp(
      locale: localeProvider.locale, // locale: const Locale('el'),
      supportedLocales: const [
        Locale('en'),  // English
        Locale('el'),  // Greek
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        AppLocalizations.delegate,
      ],
      title: 'Texnopolis Cinema',
      theme: ThemeData(
        fontFamily: 'Manrope',
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFF62BB46),
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        fontFamily: 'Manrope',
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFF62BB46),
        brightness: Brightness.dark,
      ),
      themeMode: themeProvider.themeMode,
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  static final List<Widget> _screens = <Widget>[
    const NowShowingScreen(),
    const ComingSoonScreen(),
    const EventsScreen(),
    const ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onItemTapped,
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.movie),
            label: AppLocalizations.of(context)!.navNowShowing,
          ),
          NavigationDestination(
            icon: const Icon(Icons.upcoming),
            label: AppLocalizations.of(context)!.navComingSoon,
          ),
          NavigationDestination(
            icon: const Icon(Icons.event),
            label: AppLocalizations.of(context)!.navEvents,
          ),
          NavigationDestination(
            icon: const Icon(Icons.person),
            label: AppLocalizations.of(context)!.navMember,
          ),
        ],
      ),
    );
  }
}
