import 'package:flutter/material.dart';
import 'screens/landing_screen.dart';
import 'screens/main_screen.dart';
import 'screens/cruise_guide_screen.dart';
import 'screens/tours_screen.dart';

void main() {
  runApp(const PortVilaCruiseGuideApp());
}

class PortVilaCruiseGuideApp extends StatelessWidget {
  const PortVilaCruiseGuideApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Port Vila Cruise Guide',
      debugShowCheckedModeBanner:
          false, // <-- Add this line to remove debug banner
      theme: ThemeData(primarySwatch: Colors.teal),
      initialRoute: '/',
      routes: {
        '/': (context) => const LandingScreen(),
        '/main': (context) => const MainScreen(),
        '/cruiseGuide': (context) => const CruiseGuideScreen(),
        '/tours': (context) => const ToursScreen(),
      },
    );
  }
}
