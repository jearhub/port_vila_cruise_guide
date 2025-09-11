import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';

class ShipDetailScreen extends StatelessWidget {
  final Map shipData;

  const ShipDetailScreen({Key? key, required this.shipData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Format date for display
    String displayDate;
    try {
      final dt = DateTime.parse(shipData['date'] ?? '');
      displayDate =
          '${dt.day.toString().padLeft(2, '0')}-${dt.month.toString().padLeft(2, '0')}-${dt.year}';
    } catch (_) {
      displayDate = shipData['date'] ?? '--';
    }

    final double statusBarHeight = MediaQuery.of(context).padding.top;

    return Scaffold(
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          // Image and floating badge & back arrow (no SafeArea here, image flush to top)
          Stack(
            children: [
              // The image fills all the way to the top edge!
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(32),
                  bottomRight: Radius.circular(32),
                ),
                child:
                    (shipData['imageUrl'] != null &&
                            (shipData['imageUrl'] as String).isNotEmpty)
                        ? CachedNetworkImage(
                          imageUrl: shipData['imageUrl'],
                          width: double.infinity,
                          height:
                              300 + statusBarHeight, // Now includes status bar
                          fit: BoxFit.cover,
                          placeholder:
                              (context, url) => Image.asset(
                                'assets/images/placeholder_bg.png',
                                width: double.infinity,
                                height: 300 + statusBarHeight,
                                fit: BoxFit.cover,
                              ),
                          errorWidget:
                              (context, url, error) => Image.asset(
                                'assets/images/placeholder_bg.png',
                                width: double.infinity,
                                height: 300 + statusBarHeight,
                                fit: BoxFit.cover,
                              ),
                        )
                        : Image.asset(
                          'assets/images/placeholder_bg.png',
                          width: double.infinity,
                          height: 300 + statusBarHeight,
                          fit: BoxFit.cover,
                        ),
              ),
              // Back arrow icon at top left (inside status bar height)
              Positioned(
                top: statusBarHeight + 10,
                left: 14,
                child: IconButton(
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                    size: 28,
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                  tooltip: 'Back',
                  splashRadius: 24,
                ),
              ),
              // Floating details at bottom of image
              Positioned(
                left: 24,
                right: 24,
                bottom: 24,
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.52),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        displayDate,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.tealAccent,
                          fontWeight: FontWeight.bold,
                          fontFamily: GoogleFonts.poppins().fontFamily,
                          shadows: const [
                            Shadow(color: Colors.black87, blurRadius: 4),
                          ],
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        shipData['shipName'] ?? 'Unknown Ship',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontFamily: GoogleFonts.poppins().fontFamily,
                          shadows: const [
                            Shadow(color: Colors.black87, blurRadius: 4),
                          ],
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        shipData['cruiseLine'] ?? 'Cruise Line unavailable',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white70,
                          fontFamily: GoogleFonts.poppins().fontFamily,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Arrives: ${shipData['arrivalTime'] ?? '--'} Departs: ${shipData['departureTime'] ?? '--'}',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                          fontFamily: GoogleFonts.poppins().fontFamily,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          // The rest of the content is now safely within the interactive area
          SafeArea(
            top: false,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 4,
                  ),
                  child: Text(
                    shipData['description'] ?? 'No description available.',
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: GoogleFonts.poppins().fontFamily,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 4,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Details of the ship include:',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          fontFamily: GoogleFonts.poppins().fontFamily,
                        ),
                      ),
                      if (shipData['details'] != null &&
                          shipData['details'] is List) ...[
                        const SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              for (final detail in shipData['details'])
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Icon(
                                      Icons.check_circle,
                                      size: 18,
                                      color: Colors.teal,
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        detail,
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontFamily:
                                              GoogleFonts.poppins().fontFamily,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 4,
                  ),
                  child: Text(
                    shipData['source'] ?? 'No source available.',
                    style: TextStyle(
                      fontSize: 14,
                      fontStyle: FontStyle.italic,
                      color: Colors.grey[700],
                      fontFamily: GoogleFonts.poppins().fontFamily,
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
