import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../data/tours_data.dart';
import '../widgets/modern_tour_card.dart';
import 'tour_detail_screen.dart';

class ToursScreen extends StatelessWidget {
  const ToursScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tours')),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: MasonryGridView.count(
            crossAxisCount: 2,
            mainAxisSpacing: 16,
            crossAxisSpacing: 10,
            itemCount: tours.length,
            itemBuilder: (context, index) {
              final tour = tours[index];
              return ModernTourCard(
                tour: tour,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => TourDetailScreen(tour: tour),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
