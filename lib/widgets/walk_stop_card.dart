import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/walk_stop.dart';
import '../screens/walk_stop_detail_screen.dart';
import '../screens/map_screen.dart';
import '../utils.dart';
import 'package:url_launcher/url_launcher.dart';

class WalkStopCard extends StatelessWidget {
  final WalkStop stop;
  final WalkStop? nextStop;
  final bool visited;
  final VoidCallback onToggleVisited;

  const WalkStopCard({
    required this.stop,
    required this.visited,
    required this.onToggleVisited,
    this.nextStop,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String timeToNext = '';
    bool canShowDirections =
        nextStop != null &&
        stop.latitude != null &&
        stop.longitude != null &&
        nextStop!.latitude != null &&
        nextStop!.longitude != null;

    if (canShowDirections) {
      final dist = calculateDistanceKm(
        stop.latitude!,
        stop.longitude!,
        nextStop!.latitude!,
        nextStop!.longitude!,
      );
      timeToNext = estimatedMinutes(dist);
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => WalkStopDetailScreen(stop: stop)),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(18),
              ),
              child: Image.asset(
                stop.imageUrl,
                height: 160,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          stop.name,
                          style: TextStyle(
                            fontSize: 18,
                            fontFamily: GoogleFonts.poppins().fontFamily,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          visited
                              ? Icons.check_circle
                              : Icons.radio_button_unchecked,
                          color: visited ? Colors.teal : Colors.grey,
                        ),
                        tooltip: visited ? 'Visited' : 'Mark as visited',
                        onPressed: onToggleVisited,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    stop.description,
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: GoogleFonts.poppins().fontFamily,
                    ),
                  ),
                  if (stop.openHours != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Text(
                        'Open: ${stop.openHours!}',
                        style: TextStyle(
                          fontSize: 13,
                          fontFamily: GoogleFonts.poppins().fontFamily,
                          color: Colors.teal,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  if (stop.tip != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Text(
                        'Tip: ${stop.tip!}',
                        style: TextStyle(
                          fontSize: 13,
                          fontFamily: GoogleFonts.poppins().fontFamily,
                          fontStyle: FontStyle.italic,
                          color: Colors.teal,
                        ),
                      ),
                    ),
                  if (canShowDirections)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Row(
                        children: [
                          // "Next Stop" label before the schedule icon
                          Text(
                            'Next Stop:',
                            style: TextStyle(
                              fontSize: 13,
                              fontFamily: GoogleFonts.poppins().fontFamily,
                              color: Colors.teal,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Icon(
                            Icons.schedule,
                            size: 16,
                            color: Colors.teal,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            timeToNext,
                            style: TextStyle(
                              fontSize: 13,
                              fontFamily: GoogleFonts.poppins().fontFamily,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(width: 24),
                          IconButton(
                            icon: const Icon(
                              Icons.map_outlined,
                              color: Colors.orange,
                              size: 20,
                            ),
                            tooltip: 'View on Map',
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (_) => MapScreen(
                                        latitude: stop.latitude!,
                                        longitude: stop.longitude!,
                                        stopName: stop.name,
                                      ),
                                ),
                              );
                            },
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.directions_walk,
                              color: Colors.teal,
                              size: 20,
                            ),
                            tooltip: 'Directions to next stop',
                            onPressed: () async {
                              final url =
                                  'https://www.google.com/maps/dir/?api=1&origin=${stop.latitude},${stop.longitude}&destination=${nextStop!.latitude},${nextStop!.longitude}&travelmode=walking';
                              final uri = Uri.parse(url);
                              if (await canLaunchUrl(uri)) {
                                await launchUrl(
                                  uri,
                                  mode: LaunchMode.externalApplication,
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Could not launch Maps'),
                                  ),
                                );
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
