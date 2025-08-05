import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/attraction.dart';

class ModernAttractionCard extends StatelessWidget {
  final Attraction attraction;
  final VoidCallback? onTap;

  const ModernAttractionCard({Key? key, required this.attraction, this.onTap})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        color: Colors.white,
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(15),
              ),
              child: Image.asset(
                attraction.imageUrl,
                height: 100,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    attraction.name,
                    style: TextStyle(
                      fontFamily: GoogleFonts.poppins().fontFamily,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  // Subtitle row (duration, skip line, pickup)
                  Wrap(
                    spacing: 6,
                    runSpacing: 2,
                    children: [
                      Text(
                        attraction.duration,
                        style: TextStyle(
                          color: Colors.black54,
                          fontFamily: GoogleFonts.poppins().fontFamily,
                          fontSize: 13,
                        ),
                      ),
                      if (attraction.skipLine)
                        const Text(
                          '• Skip the line',
                          style: TextStyle(color: Colors.black54, fontSize: 13),
                        ),
                      if (attraction.pickupAvailable)
                        const Text(
                          '• Pickup available',
                          style: TextStyle(color: Colors.black54, fontSize: 13),
                        ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.orange, size: 15),
                      const SizedBox(width: 2),
                      Text(
                        attraction.rating.toStringAsFixed(1),
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(width: 2),
                      Text(
                        '(${attraction.reviews})',
                        style: TextStyle(
                          fontFamily: GoogleFonts.poppins().fontFamily,
                          fontSize: 11,
                          color: Colors.black45,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'From ${attraction.price}',
                    style: TextStyle(
                      fontFamily: GoogleFonts.poppins().fontFamily,
                      fontWeight: FontWeight.bold,
                      fontSize: 13.5,
                      color: Colors.black87,
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
