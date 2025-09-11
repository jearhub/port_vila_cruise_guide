import 'package:flutter/material.dart';
import 'cruise_guide_screen.dart';
import 'places_screen.dart';
//import 'tours_screen.dart';
import 'local_info_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  //  static const int toursTabIndex = 2;

  Widget _getBody() {
    /* if (_selectedIndex == toursTabIndex) {
      return ListView.builder(
        itemCount: tours.length,
        itemBuilder: (context, index) {
          final tour = tours[index];
          return ListTile(
            leading: const Icon(Icons.tour),
            title: Text(tour.name),
            subtitle: Text(tour.description),
          );
        },
      );
    }*/
    return _screens[_selectedIndex];
  }

  static final List<Widget> _screens = [
    const CruiseGuideScreen(),
    PlacesScreen(),
    // const ToursScreen(),
    const LocalInfoScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _getBody(),
      // Optional: Add Drawer or BottomNavigationBar
    );
  }
}
