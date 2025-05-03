import 'package:flutter/gestures.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../providers/locale_provider.dart';
import '../providers/theme_provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String userCardNumber = '54321'; // Will be dynamic later
  String userName = 'Guest'; // Editable later
  static const String githubUrl = 'https://github.com/giorgosioak/texnopolis';

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('userName') ?? 'Guest';
      userCardNumber = prefs.getString('userCardNumber') ?? '54321';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.settings),
        // title: const Text('My Profile'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildLoyaltyCard(context),
            const SizedBox(height: 30),
            _buildSettingButton(Icons.person, AppLocalizations.of(context)!.pageProfileEditProfile, () {
              _showEditProfile(context);
            }),
            _buildSettingButton(Icons.movie, AppLocalizations.of(context)!.pageProfileCinemaInfo, () {
              _showCinemaInfo(context);
            }),
            _buildSettingButton(Icons.language, AppLocalizations.of(context)!.pageProfileLanguage, () {
              _showLanguageDialog(context);
            }),
            _buildSettingButton(Icons.dark_mode, AppLocalizations.of(context)!.pageProfileTheme, () {
              _showThemeDialog(context);
            }),
            _buildSettingButton(Icons.info_outline, AppLocalizations.of(context)!.pageProfileAboutApp, () {
              _showAboutApp(context);
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildLoyaltyCard(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: isDark
            ? const LinearGradient(
                colors: [Color(0xFF1B5E20), Color(0xFF388E3C)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : const LinearGradient(
                // colors: [Color(0xFFE8F5E9), Color(0xFFC8E6C9)], // softer green for light mode
                colors: [
                  Color(0xFFC8E6C9),
                  Color(0xFFE8F5E9)
                ], // softer green for light mode
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Texnopolis Cinema',
            style: TextStyle(
              color: isDark ? Colors.white : Colors.black87,
              fontSize: 24,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            userName,
            style: TextStyle(
              color: isDark ? Colors.white70 : Colors.black54,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 30),
          Text(
            'Member Card',
            style: TextStyle(
              color: isDark ? Colors.white70 : Colors.black45,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            userCardNumber,
            style: TextStyle(
              color: isDark ? Colors.white : Colors.black87,
              fontSize: 26,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingButton(IconData icon, String title, VoidCallback onTap) {
    return Card(
      elevation: 0, // FLAT style
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.greenAccent.withOpacity(0.1),
          child: Icon(icon, color: Colors.green),
        ),
        title: Text(title, style: const TextStyle(fontSize: 16)),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }

  void _showEditProfile(BuildContext context) {
    final nameController = TextEditingController(text: userName);
    final cardController = TextEditingController(text: userCardNumber);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Profile'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: cardController,
              decoration:
                  const InputDecoration(labelText: 'Member Card Number'),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final prefs = await SharedPreferences.getInstance();
              await prefs.setString('userName', nameController.text.trim());
              await prefs.setString(
                  'userCardNumber', cardController.text.trim());

              setState(() {
                userName = nameController.text.trim();
                userCardNumber = cardController.text.trim();
              });

              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showCinemaInfo(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cinema Info'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Texnopolis Cinema is the leading cinema in town, offering the latest movies, snacks, and special events. 🎥🍿\n',
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Icon(Icons.public, size: 20),
                  const SizedBox(width: 8),
                  InkWell(
                    onTap: () =>
                        launchUrl(Uri.parse('https://www.texnopolis.net/')),
                    child: const Text(
                      'https://www.texnopolis.net/',
                      style: TextStyle(
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.email, size: 20),
                  const SizedBox(width: 8),
                  InkWell(
                    onTap: () =>
                        launchUrl(Uri.parse('mailto:info@texnopolis.net')),
                    child: const Text(
                      'info@texnopolis.net',
                      style: TextStyle(
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Row(
                children: [
                  Icon(Icons.location_on, size: 20),
                  SizedBox(width: 8),
                  Text(
                    'Cinema Locations:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              RichText(
                text: TextSpan(
                  style: DefaultTextStyle.of(context).style,
                  children: [
                    TextSpan(
                        text: '1. Τεχνόπολις\n',
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.primary)),
                    const WidgetSpan(
                      child: Icon(
                        Icons.location_on,
                        size: 16,
                      ),
                    ),
                    TextSpan(
                      text: ' Ανδρέα Παπανδρέου 116, Αμμουδάρα\n',
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.secondary),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          const String mapsUrl =
                              'https://maps.app.goo.gl/eTjxnkt1H9vBvz78A';
                          launchUrl(Uri.parse(mapsUrl));
                        },
                    ),
                    const WidgetSpan(
                      child: Icon(
                        Icons.phone,
                        size: 16,
                      ),
                    ),
                    TextSpan(
                      text: ' 2810 821400',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          const String phoneUrl =
                              'tel:+302810821400'; // Phone number with international dialing prefix
                          launchUrl(Uri.parse(phoneUrl));
                        },
                    ),
                    const TextSpan(text: ', '),
                    TextSpan(
                      text: '2810 823813',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          const String phoneUrl =
                              'tel:+302810823813'; // Phone number with international dialing prefix
                          launchUrl(Uri.parse(phoneUrl));
                        },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              RichText(
                text: TextSpan(
                  style: DefaultTextStyle.of(context).style,
                  children: [
                    TextSpan(
                        text: '2. Βιτσέντζος Κορνάρος\n',
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.primary)),
                    const WidgetSpan(
                      child: Icon(
                        Icons.location_on,
                        size: 16,
                      ),
                    ),
                    TextSpan(
                      text: ' Μαλικούτη 18 – 20, Κέντρο Ηρακλείου\n',
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.secondary),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          const String mapsUrl =
                              'https://maps.app.goo.gl/ejnRVwi6ufVghfYHA';
                          launchUrl(Uri.parse(mapsUrl));
                        },
                    ),
                    const WidgetSpan(
                      child: Icon(
                        Icons.phone,
                        size: 16,
                      ),
                    ),
                    TextSpan(
                      text: ' 2815 103102',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          const String phoneUrl =
                              'tel:+302815103102'; // Phone number with international dialing prefix
                          launchUrl(Uri.parse(phoneUrl));
                        },
                    ),
                    const TextSpan(text: ', '),
                    TextSpan(
                      text: '2810 821400',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          const String phoneUrl =
                              'tel:+302810821400'; // Phone number with international dialing prefix
                          launchUrl(Uri.parse(phoneUrl));
                        },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              RichText(
                text: TextSpan(
                  style: DefaultTextStyle.of(context).style,
                  children: [
                    TextSpan(
                        text: '3. Cine Studio\n',
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.primary)),
                    const WidgetSpan(
                      child: Icon(
                        Icons.location_on,
                        size: 16,
                      ),
                    ),
                    TextSpan(
                      text: ' Λεωφόρος Ικάρου και Ηροδότου, Νέα Αλικαρνασσός\n',
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.secondary),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          const String mapsUrl =
                              'https://maps.app.goo.gl/3wVcjeq66HcWNSTw5';
                          launchUrl(Uri.parse(mapsUrl));
                        },
                    ),
                    const WidgetSpan(
                      child: Icon(
                        Icons.phone,
                        size: 16,
                      ),
                    ),
                    TextSpan(
                      text: ' 2810 823813',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          const String phoneUrl =
                              'tel:+302810823813'; // Phone number with international dialing prefix
                          launchUrl(Uri.parse(phoneUrl));
                        },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showLanguageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Choose Language'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('🇬🇷 Greek (Ελληνικά) '),
              onTap: () {
                Provider.of<LocaleProvider>(context, listen: false)
                    .setLocale(const Locale('el'));
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('🇬🇧 English (Αγγλικά)'),
              onTap: () {
                Provider.of<LocaleProvider>(context, listen: false)
                    .setLocale(const Locale('en'));
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showThemeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Choose Theme'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('☀️ Light Mode'),
              onTap: () {
                Provider.of<ThemeProvider>(context, listen: false)
                    .setTheme(ThemeMode.light);
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('🌙 Dark Mode'),
              onTap: () {
                Provider.of<ThemeProvider>(context, listen: false)
                    .setTheme(ThemeMode.dark);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showAboutApp(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('About App'),
        content: const Text(
          'Texnopolis Cinema App\n\n'
          'This app helps you manage your cinema loyalty card and access important cinema information.\n\n'
          'Developed with ❤️ by Georgios Ioakeimidis.\n\n'
          'This project is open-source and available on GitHub.',
        ),
        actions: [
          TextButton(
            onPressed: () async {
              if (await canLaunchUrl(Uri.parse(githubUrl))) {
                await launchUrl(Uri.parse(githubUrl),
                    mode: LaunchMode.externalApplication);
              }
            },
            child: const Text('View on GitHub'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
