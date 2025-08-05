import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'theme/theme_notifier.dart';
import 'screens/landing_screen.dart';
import 'screens/main_screen.dart';
import 'screens/cruise_guide_screen.dart';
import 'screens/tours_screen.dart';
import 'screens/map_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeNotifier(),
      child: const PortVilaCruiseGuideApp(),
    ),
  );
}

class PortVilaCruiseGuideApp extends StatelessWidget {
  const PortVilaCruiseGuideApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeNotifier>(
      builder: (context, themeNotifier, _) {
        return MaterialApp(
          title: 'Vilacruise',
          debugShowCheckedModeBanner: false, // Removes debug banner
          theme: themeNotifier.currentTheme, // Applies dynamic theme
          initialRoute: '/',
          routes: {
            '/': (context) => const LandingScreen(),
            '/main': (context) => const MainScreen(),
            '/cruiseGuide': (context) => const CruiseGuideScreen(),
            '/tours': (context) => const ToursScreen(),
            '/map': (context) => const MapScreen(),
          },
        );
      },
    );
  }
}
