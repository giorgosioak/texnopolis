import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart';
import 'screens/now_showing_screen.dart';
import 'screens/coming_soon_screen.dart';
import 'screens/events_screen.dart';
import 'screens/profile_screen.dart';

void main() {
  Intl.defaultLocale = 'el_GR';
  runApp(const TexnopolisApp());
}

class TexnopolisApp extends StatelessWidget {
  const TexnopolisApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: const Locale('el', 'GR'),  // Set default locale to Greek
      supportedLocales: const [
        Locale('en', 'US'),  // English
        Locale('el', 'GR'),  // Greek
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      title: 'Texnopolis Cinema',
      theme: ThemeData(
        fontFamily: 'Manrope',
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFF62BB46),
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  static final List<Widget> _screens = <Widget>[
    NowShowingScreen(),
    ComingSoonScreen(),
    EventsScreen(),
    ProfileScreen(),
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
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.movie),
            label: 'Now Showing',
          ),
          NavigationDestination(
            icon: Icon(Icons.upcoming),
            label: 'Coming Soon',
          ),
          NavigationDestination(
            icon: Icon(Icons.event),
            label: 'Events',
          ),
          NavigationDestination(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
