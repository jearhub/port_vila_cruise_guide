import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../models/attraction.dart';
import '../widgets/modern_attraction_card.dart';
import 'attraction_detail_screen.dart';

// CategoryAttractionsScreen is a StatelessWidget! (MUST extend Widget)
class CategoryAttractionsScreen extends StatelessWidget {
  final String category;

  const CategoryAttractionsScreen({required this.category, Key? key})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '$category near Port Vila',
          style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: StreamBuilder<QuerySnapshot>(
            stream:
                FirebaseFirestore.instance
                    .collection('attractions')
                    .where('category', arrayContains: category)
                    .snapshots(),

            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }
              if (!snapshot.hasData ||
                  snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              final docs = snapshot.data!.docs;
              if (docs.isEmpty) {
                return const Center(
                  child: Text('No attractions found for this category.'),
                );
              }
              // Grid of filtered cards (expand to fill space)
              return MasonryGridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 10,
                itemCount: docs.length,
                itemBuilder: (context, index) {
                  final attraction = Attraction.fromFirestore(docs[index]);
                  return ModernAttractionCard(
                    attraction: attraction,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (_) => AttractionDetailScreen(
                                attraction: attraction,
                              ),
                        ),
                      );
                    },
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
