import 'package:flutter/material.dart';
import '../models/tour.dart';

class ModernTourCard extends StatelessWidget {
  final Tour tour;
  final VoidCallback? onTap;

  const ModernTourCard({Key? key, required this.tour, this.onTap})
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
                tour.imageUrl,
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
                    tour.name,
                    style: const TextStyle(
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
                        tour.duration,
                        style: const TextStyle(
                          color: Colors.black54,
                          fontSize: 13,
                        ),
                      ),
                      if (tour.skipLine)
                        const Text(
                          '• Skip the line',
                          style: TextStyle(color: Colors.black54, fontSize: 13),
                        ),
                      if (tour.pickupAvailable)
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
                        tour.rating.toStringAsFixed(1),
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(width: 2),
                      Text(
                        '(${tour.reviews})',
                        style: const TextStyle(
                          fontSize: 11,
                          color: Colors.black45,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'From ${tour.price}',
                    style: const TextStyle(
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
