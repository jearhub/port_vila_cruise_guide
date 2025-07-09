import 'package:flutter/material.dart';
import 'cruise_guide_screen.dart';
import 'attractions_screen.dart';
import 'tours_screen.dart';
import 'local_info_screen.dart';
import 'settings_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  static const List<String> _titles = [
    'Cruise Guide',
    'Attractions',
    'Tours',
    'Local Info',
  ];

  static final List<Widget> _screens = [
    const CruiseGuideScreen(),
    const AttractionsScreen(),
    const ToursScreen(),
    const LocalInfoScreen(),
  ];

  void _onSelectItem(int index) {
    setState(() {
      _selectedIndex = index;
    });
    Navigator.pop(context); // Close drawer after selection
  }

  void _openSettings() {
    Navigator.pop(context); // Close drawer first
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SettingsScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_titles[_selectedIndex])),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(color: Colors.teal),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  CircleAvatar(
                    radius: 32,
                    backgroundImage: AssetImage(
                      'assets/images/port_vila_logo.png',
                    ),
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Port Vila Cruise Guide',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Explore the best of Port Vila',
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.directions_boat),
              title: const Text('Cruise Guide'),
              selected: _selectedIndex == 0,
              onTap: () => _onSelectItem(0),
            ),
            ListTile(
              leading: const Icon(Icons.place),
              title: const Text('Attractions'),
              selected: _selectedIndex == 1,
              onTap: () => _onSelectItem(1),
            ),
            ListTile(
              leading: const Icon(Icons.tour),
              title: const Text('Tours'),
              selected: _selectedIndex == 2,
              onTap: () => _onSelectItem(2),
            ),
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text('Local Info'),
              selected: _selectedIndex == 3,
              onTap: () => _onSelectItem(3),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: _openSettings,
            ),
          ],
        ),
      ),
      body: _screens[_selectedIndex],
    );
  }
}
