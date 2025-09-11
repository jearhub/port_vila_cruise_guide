import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../widgets/modern_tour_card.dart';
import 'tour_detail_screen.dart';
import '../models/tour.dart';

// Universal image builder function with caching and placeholder
Widget buildImage(
  String imageUrl, {
  BoxFit fit = BoxFit.cover,
  double? width,
  double? height,
}) {
  const String placeholderPath = 'assets/images/placeholder_bg.png';
  if (imageUrl.startsWith('http')) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      fit: fit,
      width: width,
      height: height,
      placeholder:
          (context, url) => Image.asset(
            placeholderPath,
            fit: fit,
            width: width,
            height: height,
          ),
      errorWidget:
          (context, url, error) => Image.asset(
            placeholderPath,
            fit: fit,
            width: width,
            height: height,
          ),
      memCacheWidth: 400,
      memCacheHeight: 300,
    );
  } else {
    return Image.asset(
      imageUrl,
      fit: fit,
      width: width,
      height: height,
      errorBuilder:
          (context, error, stackTrace) => Image.asset(
            placeholderPath,
            fit: fit,
            width: width,
            height: height,
          ),
    );
  }
}

final List<Map<String, String>> tourCategories = [
  {'image': 'assets/icons/water.png', 'label': 'Water'},
  {'image': 'assets/icons/adventure.png', 'label': 'Adventure'},
  {'image': 'assets/icons/sightseeing.png', 'label': 'Sightseeing'},
  {'image': 'assets/icons/culture.png', 'label': 'Culture'},
  {'image': 'assets/icons/history.png', 'label': 'History'},
  {'image': 'assets/icons/food.png', 'label': 'Food'},
  {'image': 'assets/icons/family.png', 'label': 'Family'},
];

class ToursScreen extends StatefulWidget {
  const ToursScreen({Key? key}) : super(key: key);

  @override
  State<ToursScreen> createState() => _ToursScreenState();
}

class _ToursScreenState extends State<ToursScreen> {
  String? _selectedCategory;

  Query get _tourQuery {
    final baseQuery = FirebaseFirestore.instance.collection('tours');
    if (_selectedCategory == null) {
      return baseQuery;
    } else {
      // 'category' is an array field in Firestore
      return baseQuery.where('category', arrayContains: _selectedCategory);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const SizedBox(width: 14),
            Text(
              'Tours',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Scrollable Filter Row
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                child: Row(
                  children: [
                    if (_selectedCategory != null)
                      Padding(
                        padding: const EdgeInsets.only(right: 12.0),
                        child: GestureDetector(
                          onTap: () => setState(() => _selectedCategory = null),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              shape: BoxShape.circle,
                            ),
                            child: const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Icon(
                                Icons.clear,
                                color: Colors.redAccent,
                                size: 24,
                                semanticLabel: 'Clear filter',
                              ),
                            ),
                          ),
                        ),
                      ),
                    ...tourCategories.map(
                      (cat) => Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: GestureDetector(
                          onTap:
                              () => setState(
                                () => _selectedCategory = cat['label'],
                              ),
                          child: SmallRectCard(
                            imagePath: cat['image']!,
                            label: cat['label']!,
                            isSelected: _selectedCategory == cat['label'],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              // Grid of filtered cards
              Expanded(
                child: StreamBuilder(
                  stream: _tourQuery.snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData)
                      return const Center(child: CircularProgressIndicator());
                    final filteredTours =
                        snapshot.data!.docs
                            .map((doc) => Tour.fromFirestore(doc))
                            .toList();
                    return MasonryGridView.count(
                      crossAxisCount: 2,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 10,
                      itemCount: filteredTours.length,
                      itemBuilder: (context, index) {
                        final tour = filteredTours[index];
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
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Example SmallRectCard with selection highlight and new buildImage usage
class SmallRectCard extends StatelessWidget {
  final String imagePath;
  final String label;
  final bool isSelected;
  const SmallRectCard({
    Key? key,
    required this.imagePath,
    required this.label,
    this.isSelected = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
      elevation: isSelected ? 5 : 2,
      color: isSelected ? Colors.teal[50] : Colors.white,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: buildImage(
                imagePath,
                width: 32,
                height: 32,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 10),
            Text(
              label,
              style: TextStyle(
                fontFamily: GoogleFonts.poppins().fontFamily,
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.teal : Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
