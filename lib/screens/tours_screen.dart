import 'package:flutter/material.dart';
import '../models/tour.dart';
import '/widgets/modern_tour_card.dart';
import 'tour_detail_screen.dart';

class ToursScreen extends StatelessWidget {
  const ToursScreen({Key? key}) : super(key: key);

  // Sample tours data; replace with your actual data source
  final List<Tour> tours = const [
    Tour(
      name: 'Lagoon Cruise',
      description: 'Enjoy a relaxing cruise through the beautiful lagoon.',
      imageUrl: 'assets/images/lagoon_cruise.jpg',
      openingHours: '9:00 AM - 5:00 PM',
      entryFee: 'Included',
      duration: '3 hours',
      skipLine: true,
      pickupAvailable: true,
      rating: 4.7,
      reviews: 120,
      price: '\$75',
      isFavorite: true,
    ),
    Tour(
      name: 'Cultural Village Tour',
      description: 'Experience the rich culture of Port Vila.',
      imageUrl: 'assets/images/cultural_village.jpg',
      openingHours: '10:00 AM - 4:00 PM',
      entryFee: '\$20',
      duration: '4 hours',
      skipLine: false,
      pickupAvailable: true,
      rating: 4.5,
      reviews: 98,
      price: '\$50',
    ),
    // Add more tours as needed...
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /* appBar: AppBar(
        title: const Text('Tours'),
        backgroundColor: Colors.teal,
        centerTitle: true,
      ),*/
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 16),
        itemCount: tours.length,
        itemBuilder: (context, index) {
          final tour = tours[index];
          return ModernTourCard(
            tour: tour,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => TourDetailScreen(tour: tour)),
              );
            },
          );
        },
      ),
    );
  }
}
