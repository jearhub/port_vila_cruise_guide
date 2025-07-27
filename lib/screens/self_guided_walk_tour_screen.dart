import 'package:flutter/material.dart';
import '../widgets/walk_stop_card.dart';
import '../data/walk_stops_data.dart';

class SelfGuidedWalkTourScreen extends StatelessWidget {
  const SelfGuidedWalkTourScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Self-Guided Walking Tour')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const Text(
              'Explore at your own pace! Visit each highlight, tap for more info.',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ...walkStops.map((stop) => WalkStopCard(stop: stop)).toList(),
          ],
        ),
      ),
    );
  }
}
