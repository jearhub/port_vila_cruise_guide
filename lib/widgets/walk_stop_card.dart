import 'package:flutter/material.dart';
import '../models/walk_stop.dart';
import '../screens/walk_stop_detail_screen.dart';
import '../screens/map_screen.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher.dart' show LaunchMode;

class WalkStopCard extends StatelessWidget {
  final WalkStop stop;
  const WalkStopCard({required this.stop, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      elevation: 3,
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
                  Text(
                    stop.name,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    stop.description,
                    style: const TextStyle(fontSize: 15, color: Colors.black87),
                  ),
                  // Open hours with Map and Directions icons inline
                  if (stop.openHours != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 6.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Open: ${stop.openHours!}',
                              style: const TextStyle(
                                fontSize: 13,
                                color: Colors.teal,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          if (stop.latitude != null &&
                              stop.longitude != null) ...[
                            IconButton(
                              icon: const Icon(
                                Icons.map_outlined,
                                color: Colors.teal,
                                size: 20,
                              ),
                              tooltip: 'View on Map',
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (_) => MapScreen(
                                          latitude: stop.latitude,
                                          longitude: stop.longitude,
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
                              tooltip: 'Directions',
                              onPressed: () async {
                                final url =
                                    'https://www.google.com/maps/dir/?api=1&destination=${stop.latitude},${stop.longitude}&travelmode=walking';
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
                        ],
                      ),
                    ),
                  // Tip appears below
                  if (stop.tip != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 6.0),
                      child: Text(
                        'Tip: ${stop.tip!}',
                        style: const TextStyle(
                          fontSize: 13,
                          fontStyle: FontStyle.italic,
                          color: Colors.teal,
                        ),
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
