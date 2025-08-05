import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/theme_notifier.dart'; // Make sure this path is correct for your project

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true; // Still local for now

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          const SizedBox(height: 16),
          SwitchListTile(
            title: const Text('Dark Mode'),
            subtitle: const Text('Enable dark theme for the app'),
            value: themeNotifier.isDarkMode,
            onChanged: (bool value) {
              themeNotifier.toggleTheme(value);
            },
            secondary: const Icon(Icons.dark_mode),
          ),
          SwitchListTile(
            title: const Text('Notifications'),
            subtitle: const Text('Receive notifications and updates'),
            value: _notificationsEnabled,
            onChanged: (bool value) {
              setState(() {
                _notificationsEnabled = value;
              });
              // TODO: Implement notification toggle persistence if desired
            },
            secondary: const Icon(Icons.notifications),
          ),
          const Divider(height: 32),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('About'),
            subtitle: const Text('Version 1.0.0'),
            onTap: () {
              showAboutDialog(
                context: context,
                applicationName: 'Port Vila Cruise Guide',
                applicationVersion: '1.0.0',
                applicationIcon: const Icon(Icons.directions_boat, size: 48),
                children: const [
                  Padding(
                    padding: EdgeInsets.only(top: 16),
                    child: Text(
                      'This app provides cruise visitors with local guides, tours, and information about Port Vila.',
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
