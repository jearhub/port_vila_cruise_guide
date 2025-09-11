import 'package:flutter/material.dart';
import '../widgets/walk_stop_card.dart';
import '../data/walk_stops_data.dart';
import 'package:google_fonts/google_fonts.dart';

class SelfGuidedWalkTourScreen extends StatelessWidget {
  const SelfGuidedWalkTourScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // App logo at the left
        title: Row(
          children: [
            const SizedBox(width: 14),
            Text(
              'Self-Guided Walk',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(
              'Explore at your own pace! Visit each highlight, tap for more info.',
              style: TextStyle(
                fontSize: 16,
                fontFamily: GoogleFonts.poppins().fontFamily,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            ...walkStops.map((stop) => WalkStopCard(stop: stop)).toList(),
          ],
        ),
      ),
    );
  }
}
