import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'dart:ui';
import 'package:google_fonts/google_fonts.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({Key? key}) : super(key: key);

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _logoController;
  late Animation<double> _logoScale;

  @override
  void initState() {
    super.initState();
    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);

    _logoScale = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.easeInOut),
    );

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/main');
      }
    });
  }

  @override
  void dispose() {
    _logoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Responsive logo width: 35% of screen width, max 160px
    double logoWidth = MediaQuery.of(context).size.width * 0.35;
    double maxLogoWidth = 160;
    double displayLogoWidth =
        logoWidth > maxLogoWidth ? maxLogoWidth : logoWidth;

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Optionally, add a background image or gradient here

          // Centered logo and text
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ScaleTransition(
                  scale: _logoScale,
                  child: Image.asset(
                    'assets/images/port_vila_logo_transparent.png',
                    width: displayLogoWidth,
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: 4),
                SizedBox(
                  height: 24,
                  width: 300,
                  child: Center(
                    child: AnimatedTextKit(
                      animatedTexts: [
                        TyperAnimatedText(
                          'VilaCruise',
                          textStyle: GoogleFonts.poppins(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: const Color.fromARGB(255, 0, 95, 105),
                          ),
                          textAlign: TextAlign.center, // <---- Center the text!
                          speed: const Duration(milliseconds: 85),
                        ),
                      ],
                      isRepeatingAnimation: false,
                      displayFullTextOnTap: true,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
