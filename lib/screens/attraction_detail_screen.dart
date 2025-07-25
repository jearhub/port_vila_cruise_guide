import 'package:flutter/material.dart';
import '../models/attraction.dart';

class AttractionDetailScreen extends StatelessWidget {
  final Attraction attraction;

  const AttractionDetailScreen({Key? key, required this.attraction})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Transparent app bar over image for modern look
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Image with Hero animation and gradient overlay
          Stack(
            children: [
              Hero(
                tag: 'attraction-image-${attraction.name}',
                child: Image.asset(
                  attraction.imageUrl,
                  height: 300,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              ),
              Container(
                height: 300,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.black.withOpacity(0.6),
                      Colors.transparent,
                      Colors.transparent,
                      Colors.black.withOpacity(0.6),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
              Positioned(
                bottom: 24,
                left: 16,
                right: 16,
                child: Text(
                  attraction.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        blurRadius: 6,
                        color: Colors.black87,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // Scrollable content below image
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Description
                  Text(
                    attraction.description,
                    style: const TextStyle(fontSize: 16, height: 1.4),
                  ),
                  const SizedBox(height: 24),

                  // Opening hours and entry fee info cards
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _InfoCard(
                        icon: Icons.access_time,
                        label: 'Opening Hours',
                        value: attraction.openingHours,
                      ),
                      _InfoCard(
                        icon: Icons.attach_money,
                        label: 'Entry Fee',
                        value: attraction.entryFee,
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Additional details (optional)
                  Text(
                    'Duration: ${attraction.duration}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  if (attraction.skipLine)
                    const Text(
                      'Skip the line available',
                      style: TextStyle(fontSize: 16),
                    ),
                  if (attraction.pickupAvailable)
                    const Text(
                      'Pickup service available',
                      style: TextStyle(fontSize: 16),
                    ),
                  const SizedBox(height: 24),

                  // Rating and reviews
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
                        return Icon(icon, color: Colors.amber, size: 24);
                      }),
                      const SizedBox(width: 8),
                      Text(
                        '${attraction.rating} (${attraction.reviews} reviews)',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Reusable info card widget for opening hours and entry fee
class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoCard({
    Key? key,
    required this.icon,
    required this.label,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        margin: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.teal.shade50,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.teal.shade100.withValues(alpha: 0.5),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, color: Colors.teal.shade700, size: 32),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                color: Colors.teal.shade900,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(color: Colors.teal.shade700, fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
