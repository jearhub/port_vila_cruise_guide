import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/walk_stop.dart';

class WalkStopDetailScreen extends StatelessWidget {
  final WalkStop stop;

  const WalkStopDetailScreen({required this.stop, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 4.0),
              child: Image.asset(
                'assets/images/port_vila_logo_trans.png',
                height: 36,
                width: 36,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                stop.name,
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color:
                      Colors
                          .teal
                          .shade700, // Optional: match AppBar's foreground
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.asset(stop.imageUrl, fit: BoxFit.cover, height: 200),
          ),
          const SizedBox(height: 18),
          Text(
            stop.description,
            style: TextStyle(
              fontFamily: GoogleFonts.poppins().fontFamily,
              fontSize: 16,
            ),
          ),
          if (stop.openHours != null) ...[
            const SizedBox(height: 12),
            Text(
              'Open: ${stop.openHours!}',
              style: TextStyle(
                fontFamily: GoogleFonts.poppins().fontFamily,
                color: Colors.teal,
              ),
            ),
          ],
          if (stop.tip != null) ...[
            const SizedBox(height: 12),
            Text(
              'Tip: ${stop.tip!}',
              style: TextStyle(
                fontFamily: GoogleFonts.poppins().fontFamily,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
          const SizedBox(height: 24),
          if (stop.latitude != null && stop.longitude != null)
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.map_outlined),
                    label: const Text('View on Map'),
                    style: ElevatedButton.styleFrom(
                      textStyle: TextStyle(
                        fontFamily: GoogleFonts.poppins().fontFamily,
                        fontSize: 14,
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
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.directions_walk),
                    label: const Text('Directions'),
                    style: ElevatedButton.styleFrom(
                      textStyle: TextStyle(
                        fontFamily: GoogleFonts.poppins().fontFamily,
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
