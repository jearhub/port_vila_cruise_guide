import 'package:flutter/material.dart';
import '../models/attraction.dart';

class ModernAttractionCard extends StatelessWidget {
  final Attraction attraction;
  final VoidCallback? onTap;

  const ModernAttractionCard({Key? key, required this.attraction, this.onTap})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      elevation: 3,
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image with heart overlay
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(
                      attraction.imageUrl,
                      width: 90,
                      height: 90,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    top: 6,
                    right: 6,
                    child: Icon(
                      attraction.isFavorite
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color: attraction.isFavorite ? Colors.red : Colors.white,
                      size: 22,
                      shadows: const [
                        Shadow(
                          blurRadius: 4,
                          color: Colors.black26,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 16),
              // Main content and price
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title and price in a row
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title
                        Expanded(
                          child: Text(
                            attraction.name,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 17,
                              color: Color(0xFF232B3E),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        // Price
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Text(
                              'From',
                              style: TextStyle(
                                color: Colors.black54,
                                fontSize: 13,
                              ),
                            ),
                            Text(
                              attraction.price,
                              style: const TextStyle(
                                color: Color(0xFF232B3E),
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    // Subtitle row (duration, skip line, pickup)
                    Wrap(
                      spacing: 6,
                      runSpacing: 2,
                      children: [
                        Text(
                          attraction.duration,
                          style: const TextStyle(
                            color: Colors.black54,
                            fontSize: 13,
                          ),
                        ),
                        if (attraction.skipLine)
                          const Text(
                            '• Skip the line',
                            style: TextStyle(
                              color: Colors.black54,
                              fontSize: 13,
                            ),
                          ),
                        if (attraction.pickupAvailable)
                          const Text(
                            '• Pickup available',
                            style: TextStyle(
                              color: Colors.black54,
                              fontSize: 13,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    // Rating row
                    Row(
                      children: [
                        ...List.generate(5, (i) {
                          double diff = attraction.rating - i;
                          IconData icon;
                          if (diff >= 1) {
                            icon = Icons.star;
                          } else if (diff >= 0.5) {
                            icon = Icons.star_half;
                          } else {
                            icon = Icons.star_border;
                          }
                          return Icon(icon, color: Colors.amber, size: 18);
                        }),
                        const SizedBox(width: 4),
                        Text(
                          '${attraction.rating}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: Colors.black87,
                          ),
                        ),
                        Text(
                          ' (${attraction.reviews})',
                          style: const TextStyle(
                            color: Colors.black54,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
