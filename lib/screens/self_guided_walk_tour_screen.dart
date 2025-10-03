import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../widgets/walk_stop_card.dart';
import '../models/walk_stop.dart';
import 'map_screen.dart';

class SelfGuidedWalkTourScreen extends StatefulWidget {
  const SelfGuidedWalkTourScreen({super.key});

  @override
  State<SelfGuidedWalkTourScreen> createState() =>
      _SelfGuidedWalkTourScreenState();
}

class _SelfGuidedWalkTourScreenState extends State<SelfGuidedWalkTourScreen> {
  List<bool> visited = []; // Initial value avoids LateInitializationError

  void _initVisited(int len) {
    if (visited.length != len) visited = List<bool>.filled(len, false);
  }

  void toggleVisited(int idx) {
    setState(() {
      visited[idx] = !visited[idx];
    });
  }

  int get visitedCount => visited.where((x) => x).length;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
        actions: [
          IconButton(
            icon: const Icon(Icons.map_outlined),
            tooltip: "View all stops on map",
            onPressed: () async {
              final query = FirebaseFirestore.instance
                  .collection('walk_stops')
                  .orderBy('order');
              final snapshot = await query.get();
              final stops =
                  snapshot.docs
                      .map((doc) => WalkStop.fromFirestore(doc.id, doc.data()))
                      .toList();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => MapScreen(stops: stops)),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: StreamBuilder<QuerySnapshot>(
          stream:
              FirebaseFirestore.instance.collection('walk_stops').snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            final stops =
                snapshot.data!.docs
                    .map(
                      (doc) => WalkStop.fromFirestore(
                        doc.id,
                        doc.data() as Map<String, dynamic>,
                      ),
                    )
                    .toList();
            _initVisited(stops.length);

            return ListView(
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
                LinearProgressIndicator(
                  value: stops.isNotEmpty ? visitedCount / stops.length : 0,
                  backgroundColor: Colors.grey.shade300,
                  color: Colors.teal,
                  minHeight: 8,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    stops.isNotEmpty
                        ? '$visitedCount of ${stops.length} stops visited'
                        : 'No stops found',
                    style: TextStyle(
                      fontSize: 15,
                      fontFamily: GoogleFonts.poppins().fontFamily,
                      fontWeight: FontWeight.w500,
                      color: Colors.teal[700],
                    ),
                  ),
                ),
                const SizedBox(height: 22),
                ...stops.asMap().entries.map((entry) {
                  final i = entry.key;
                  final stop = entry.value;
                  WalkStop? nextStop =
                      i < stops.length - 1 ? stops[i + 1] : null;
                  return WalkStopCard(
                    stop: stop,
                    nextStop: nextStop,
                    visited: visited[i],
                    onToggleVisited: () => toggleVisited(i),
                  );
                }).toList(),
              ],
            );
          },
        ),
      ),
    );
  }
}
