import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/dining.dart';
import '../screens/dining_screen.dart';

class DiningCard extends StatelessWidget {
  final Dining dining;
  final VoidCallback? onTap;

  const DiningCard({Key? key, required this.dining, this.onTap})
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
            AspectRatio(
              aspectRatio:
                  16 / 9, // or the best aspect ratio for your grid images
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: buildImage(dining.imageUrl, fit: BoxFit.cover),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    dining.name,
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: GoogleFonts.poppins().fontFamily,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  // Rating and reviews row
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.orange, size: 15),
                      const SizedBox(width: 2),
                      Text(
                        dining.rating.toStringAsFixed(1),
                        style: TextStyle(
                          fontSize: 13,
                          fontFamily: GoogleFonts.poppins().fontFamily,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(width: 2),
                      Text(
                        '(${dining.reviews})',
                        style: TextStyle(
                          fontSize: 11,
                          fontFamily: GoogleFonts.poppins().fontFamily,
                          color: Colors.black45,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'From ${dining.price}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13.5,
                      fontFamily: GoogleFonts.poppins().fontFamily,
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
