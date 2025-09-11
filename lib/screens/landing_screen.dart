import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({Key? key}) : super(key: key);

  @override
  State createState() => _LandingScreenState();
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

    Future.delayed(const Duration(seconds: 2), () async {
      if (!mounted) return;
      var user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        Navigator.pushReplacementNamed(context, '/main');
      } else {
        Navigator.pushReplacementNamed(context, '/auth');
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
    double logoWidth = MediaQuery.of(context).size.width * 0.35;
    double maxLogoWidth = 160;
    double displayLogoWidth =
        logoWidth > maxLogoWidth ? maxLogoWidth : logoWidth;
    return Scaffold(
      //backgroundColor: const Color(0xFF008080),
      body: Stack(
        fit: StackFit.expand,
        children: [
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
                  height: 65,
                  width: 300,
                  child: Center(
                    child: AnimatedTextKit(
                      animatedTexts: [
                        TyperAnimatedText(
                          'VilaCruise',
                          textStyle: GoogleFonts.poppins(
                            fontSize: 34,
                            fontWeight: FontWeight.w500,
                            color: const Color.fromARGB(255, 0, 112, 125),
                            //color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                          speed: const Duration(milliseconds: 65),
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
