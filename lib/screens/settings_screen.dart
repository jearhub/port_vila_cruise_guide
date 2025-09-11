import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../theme/theme_notifier.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = false;

  @override
  void initState() {
    super.initState();
    _loadNotificationPreference();
  }

  Future<void> _loadNotificationPreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _notificationsEnabled = prefs.getBool('notifications_enabled') ?? false;
    });
    // If notifications are enabled, ensure FCM is set up and print the token
    if (_notificationsEnabled) {
      await FirebaseMessaging.instance.requestPermission();
      String? token = await FirebaseMessaging.instance.getToken();
      print('FCM Token: $token');
      await FirebaseMessaging.instance.subscribeToTopic('cruise_updates');
    }
  }

  Future<void> _toggleNotifications(bool value) async {
    setState(() {
      _notificationsEnabled = value;
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
        title: const Text(
          'Settings',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w500,
            fontSize: 16,
          ),
        ),
      ),
      body: ListView(
        children: [
          const SizedBox(height: 16),
          SwitchListTile(
            title: Text('Dark Mode', style: GoogleFonts.poppins()),
            subtitle: Text(
              'Enable dark theme for the app',
              style: GoogleFonts.poppins(),
            ),
            value: themeNotifier.isDarkMode,
            onChanged: (bool value) {
              themeNotifier.toggleTheme(value);
            },
            secondary: const Icon(Icons.dark_mode),
          ),
          SwitchListTile(
            title: Text('Notifications', style: GoogleFonts.poppins()),
            subtitle: Text(
              'Receive notifications and updates',
              style: GoogleFonts.poppins(),
            ),
            value: _notificationsEnabled,
            onChanged: _toggleNotifications,
            secondary: const Icon(Icons.notifications),
          ),
          const Divider(height: 32),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: Text('About', style: GoogleFonts.poppins()),
            subtitle: Text('Version 1.0.0', style: GoogleFonts.poppins()),
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
        ],
      ),
    );
  }
}
