import 'package:flutter/material.dart';
import '../models/tour.dart';

class TourDetailScreen extends StatelessWidget {
  final Tour tour;

  const TourDetailScreen({Key? key, required this.tour}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(tour.name),
        backgroundColor: Colors.teal,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tour image
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset(
                tour.imageUrl,
                width: double.infinity,
                height: 220,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 16),

            // Tour name
            Text(
              tour.name,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.teal,
              ),
            ),
            const SizedBox(height: 12),

            // Description
            Text(
              tour.description,
              style: const TextStyle(fontSize: 16, height: 1.5),
            ),
            const SizedBox(height: 20),

            // Details section
            _buildDetailRow(Icons.access_time, 'Duration', tour.duration),
            _buildDetailRow(Icons.schedule, 'Opening Hours', tour.openingHours),
            _buildDetailRow(Icons.attach_money, 'Entry Fee', tour.entryFee),
            _buildDetailRow(
              Icons.star,
              'Rating',
              '${tour.rating} (${tour.reviews} reviews)',
            ),
            _buildDetailRow(Icons.local_offer, 'Price', tour.price),
            _buildDetailRow(
              Icons.skip_next,
              'Skip the Line',
              tour.skipLine ? 'Yes' : 'No',
            ),
            _buildDetailRow(
              Icons.directions_bus,
              'Pickup Available',
              tour.pickupAvailable ? 'Yes' : 'No',
            ),

            const SizedBox(height: 24),

            // Book Now button (example)
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 14,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onPressed: () {
                  // TODO: Implement booking action
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Booking feature coming soon!'),
                    ),
                  );
                },
                child: const Text('Book Now', style: TextStyle(fontSize: 18)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, color: Colors.teal, size: 24),
          const SizedBox(width: 12),
          Text(
            '$label:',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(width: 8),
          Expanded(child: Text(value, style: const TextStyle(fontSize: 16))),
        ],
      ),
    );
  }
}
