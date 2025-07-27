import 'package:flutter/material.dart';
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
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(backgroundImage, fit: BoxFit.cover),
          Container(decoration: BoxDecoration(gradient: gradient)),
          Align(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 60.0,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  StrokedText(
                    text: title,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    strokeWidth: 6,
                  ),
                  const SizedBox(height: 32),
                  StrokedText(text: description, fontSize: 18, strokeWidth: 3),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
