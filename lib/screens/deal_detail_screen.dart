import 'dart:ui';
import 'package:flutter/material.dart';
import 'dart:ui'; // For ImageFilter
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../widgets/stroked_text.dart';

class DealDetailScreen extends StatelessWidget {
  final String title;
  final String description;
  final String backgroundImage;
  final Gradient gradient;

  const DealDetailScreen({
    Key? key,
    required this.title,
    required this.description,
    required this.backgroundImage,
    required this.gradient,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite_border, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Permanent background gradient (not image)
          Container(decoration: BoxDecoration(gradient: gradient)),
          // Optional: Slight overlay for contrast
          Container(color: Colors.black.withOpacity(0.3)),
          // FLASH DEAL LABEL, TIMER, DISCOUNT CHIP (unchanged)
          Positioned(
            top: 80,
            left: 24,
            right: 24,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // ... same as before for chips ...
                // (omitted for brevity, copy previous response)
              ],
            ),
          ),
          // GLASSMORPHIC DETAILS PANEL
          Align(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(32),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.19),
                      borderRadius: BorderRadius.circular(32),
                      border: Border.all(color: Colors.white30),
                    ),
                    padding: const EdgeInsets.fromLTRB(18, 36, 18, 24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Image as a floating/hero card above content
                        Align(
                          alignment: Alignment.center,
                          child: Container(
                            width: 150,
                            height: 150,
                            margin: const EdgeInsets.only(bottom: 12),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 12,
                                  spreadRadius: 1,
                                  offset: Offset(0, 6),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image.asset(
                                backgroundImage,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        // Title with stroke
                        StrokedText(
                          text: title,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          strokeWidth: 7,
                        ),
                        const SizedBox(height: 18),
                        // Description
                        Text(
                          description,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                            color: Colors.white70,
                          ),
                        ),
                        const SizedBox(height: 28),
                        // Pricing
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "\VT1,500",
                              style: TextStyle(
                                color: Colors.redAccent,
                                fontSize: 23,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.lineThrough,
                                letterSpacing: 1,
                              ),
                            ),
                            const SizedBox(width: 12),
                            StrokedText(
                              text: "\VT1,000",
                              fontSize: 38,
                              strokeWidth: 5,
                              fontWeight: FontWeight.bold,
                              color: Colors.lightGreenAccent,
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        // CTA Button
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            elevation: 10,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 45,
                              vertical: 16,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(32),
                            ),
                            backgroundColor: Colors.deepPurpleAccent.shade400,
                          ),
                          onPressed: () {},
                          icon: const Icon(
                            FontAwesomeIcons.cartShopping,
                            color: Colors.white,
                            size: 22,
                          ),
                          label: const Text(
                            "GRAB DEAL",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
