import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _darkMode = false;
  bool _notificationsEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          const SizedBox(height: 16),
          SwitchListTile(
            title: const Text('Dark Mode'),
            subtitle: const Text('Enable dark theme for the app'),
            value: _darkMode,
            onChanged: (bool value) {
              setState(() {
                _darkMode = value;
              });
              // TODO: Add logic to apply dark mode in the app
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
              // TODO: Add logic to enable/disable notifications
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
