import 'package:flutter/material.dart';
import '../data/attractions_data.dart';
import '../widgets/modern_attraction_card.dart';
import 'attraction_detail_screen.dart';

class AttractionsScreen extends StatelessWidget {
  const AttractionsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Attractions')),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: ListView.builder(
          padding: const EdgeInsets.only(top: 8, bottom: 8),
          itemCount: attractions.length,
          itemBuilder: (context, index) {
            final attraction = attractions[index];
            return ModernAttractionCard(
              attraction: attraction,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (_) => AttractionDetailScreen(attraction: attraction),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
