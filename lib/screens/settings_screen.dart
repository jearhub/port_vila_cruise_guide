import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../theme/theme_notifier.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Import your legal screens (update paths if needed)
import 'privacy_policy_screen.dart';
import 'terms_and_conditions_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool notificationsEnabled = false;

  @override
  void initState() {
    super.initState();
    loadNotificationPreference();
  }

  Future<void> loadNotificationPreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      notificationsEnabled = prefs.getBool('notifications_enabled') ?? false;
    });

    // If notifications are enabled, ensure FCM is set up and print the token
    if (notificationsEnabled) {
      await FirebaseMessaging.instance.requestPermission();
      String? token = await FirebaseMessaging.instance.getToken();
      print('FCM Token: $token');
      await FirebaseMessaging.instance.subscribeToTopic('cruise_updates');
    }
  }

  Future<void> toggleNotifications(bool value) async {
    setState(() {
      notificationsEnabled = value;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notifications_enabled', value);

    if (value) {
      NotificationSettings settings =
          await FirebaseMessaging.instance.requestPermission();
      print('Permission status: ${settings.authorizationStatus}');
      String? token = await FirebaseMessaging.instance.getToken();
      print('FCM Token: $token');
      await FirebaseMessaging.instance.subscribeToTopic('cruise_updates');

      if (settings.authorizationStatus == AuthorizationStatus.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Notifications permission was denied.')),
        );
      }
    } else {
      await FirebaseMessaging.instance.unsubscribeFromTopic('cruise_updates');
      await FirebaseMessaging.instance.deleteToken();
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Settings',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w500, fontSize: 16),
        ),
      ),
      body: ListView(
        children: [
          const SizedBox(height: 16),
          SwitchListTile(
            title: Text('Dark Mode', style: GoogleFonts.poppins()),
            subtitle: Text(
              'Enable dark theme for the app',
              style: GoogleFonts.poppins(fontSize: 13),
            ),
            value: themeNotifier.isDarkMode,
            onChanged: (bool value) => themeNotifier.toggleTheme(value),
            secondary: const Icon(Icons.dark_mode),
          ),
          SwitchListTile(
            title: Text('Notifications', style: GoogleFonts.poppins()),
            subtitle: Text(
              'Receive notifications and updates',
              style: GoogleFonts.poppins(fontSize: 13),
            ),
            value: notificationsEnabled,
            onChanged: toggleNotifications,
            secondary: const Icon(Icons.notifications_active),
          ),
          const Divider(height: 32),
          ListTile(
            leading: const Icon(Icons.info_outlined),
            title: Text('About', style: GoogleFonts.poppins()),
            subtitle: Text(
              'Version 1.0.0',
              style: GoogleFonts.poppins(fontSize: 13),
            ),
            onTap: () {
              showAboutDialog(
                context: context,
                applicationName: 'VilaCruise',
                applicationVersion: '1.0.0',
                applicationIcon: const Icon(Icons.directions_boat, size: 24),
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Text(
                      'This app provides cruise visitors with local guides, tours, and information about Port Vila.',
                      style: GoogleFonts.poppins(),
                    ),
                  ),
                ],
              );
            },
          ),
          // --- LEGAL LINKS ADDED BELOW ---
          ListTile(
            leading: const Icon(Icons.privacy_tip),
            title: Text('Privacy Policy', style: GoogleFonts.poppins()),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PrivacyPolicyScreen(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.policy),
            title: Text('Terms & Conditions', style: GoogleFonts.poppins()),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const TermsAndConditionsScreen(),
                ),
              );
            },
          ),
          // --- END LEGAL LINKS ---
        ],
      ),
    );
  }
}
