import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/walk_stop.dart';

class WalkStopDetailScreen extends StatelessWidget {
  final WalkStop stop;

  const WalkStopDetailScreen({required this.stop, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(stop.name)),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.asset(stop.imageUrl, fit: BoxFit.cover, height: 200),
          ),
          const SizedBox(height: 18),
          Text(stop.description, style: const TextStyle(fontSize: 16)),
          if (stop.openHours != null) ...[
            const SizedBox(height: 12),
            Text(
              'Open: ${stop.openHours!}',
              style: const TextStyle(color: Colors.teal),
            ),
          ],
          if (stop.tip != null) ...[
            const SizedBox(height: 12),
            Text(
              'Tip: ${stop.tip!}',
              style: const TextStyle(fontStyle: FontStyle.italic),
            ),
          ],
          const SizedBox(height: 24),
          if (stop.latitude != null && stop.longitude != null)
            Row(
              children: [
                // Map Button (as before)
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.map_outlined),
                    label: const Text('View on Map'),
                    style: ElevatedButton.styleFrom(
                      textStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                      backgroundColor: Colors.teal,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 3,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        '/map',
                        arguments: {
                          'latitude': stop.latitude,
                          'longitude': stop.longitude,
                          'name': stop.name,
                        },
                      );
                    },
                  ),
                ),
                const SizedBox(width: 14),
                // Directions Button styled the same as Map Button
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.directions_walk),
                    label: const Text('Directions'),
                    style: ElevatedButton.styleFrom(
                      textStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                      backgroundColor: Colors.teal,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 3,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
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
                ),
              ],
            ),
        ],
      ),
    );
  }
}
