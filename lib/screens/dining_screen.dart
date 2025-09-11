import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../widgets/dining_card.dart';
import 'dining_detail_screen.dart';
import '../models/dining.dart';

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

// Dish card data
final List<Map<String, String>> dishCards = [
  {'image': 'assets/images/salad.jpg', 'label': 'Salad'},
  {'image': 'assets/images/fries.jpg', 'label': 'Fries'},
  {'image': 'assets/images/pizza.jpg', 'label': 'Pizza'},
  {'image': 'assets/images/pasta.jpg', 'label': 'Pasta'},
  {'image': 'assets/images/burger.jpg', 'label': 'Burger'},
  {'image': 'assets/images/sushi.jpg', 'label': 'Sushi'},
  {'image': 'assets/images/sandwich.jpg', 'label': 'Sandwich'},
  {'image': 'assets/images/toast.jpg', 'label': 'Avocado Toast'},
  {'image': 'assets/images/coffee.jpg', 'label': 'Coffee'},
  {'image': 'assets/images/fish_curry.jpg', 'label': 'Fish Curry'},
  {'image': 'assets/images/stonegrill.jpg', 'label': 'Grilled Steak'},
  {'image': 'assets/images/grilled_chicken.jpg', 'label': 'Grilled Chicken'},
  {'image': 'assets/images/noodle.jpg', 'label': 'Noodle'},
];

class DiningScreen extends StatefulWidget {
  const DiningScreen({Key? key}) : super(key: key);

  @override
  State createState() => _DiningScreenState();
}

class _DiningScreenState extends State<DiningScreen> {
  String? _selectedDish;

  Query get _diningQuery {
    final baseQuery = FirebaseFirestore.instance.collection('dining');
    if (_selectedDish == null) {
      return baseQuery;
    } else {
      // 'menu' is an array field in Firestore
      return baseQuery.where('menu', arrayContains: _selectedDish);
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
              'Dining',
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
                    if (_selectedDish != null)
                      Padding(
                        padding: const EdgeInsets.only(right: 12.0),
                        child: GestureDetector(
                          onTap: () => setState(() => _selectedDish = null),
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
                    ...dishCards.map(
                      (dish) => Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedDish = dish['label'];
                            });
                          },
                          child: SmallRectCard(
                            imagePath: dish['image']!,
                            label: dish['label']!,
                            isSelected: _selectedDish == dish['label'],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              // Dining grid, filtered and live from Firestore
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: _diningQuery.snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    final filteredList =
                        snapshot.data!.docs.map((doc) {
                          // You MUST define Dining.fromFirestore(doc)
                          return Dining.fromFirestore(doc);
                        }).toList();

                    if (filteredList.isEmpty) {
                      return const Center(
                        child: Text('No dining spots found.'),
                      );
                    }

                    return MasonryGridView.count(
                      crossAxisCount: 2,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 10,
                      itemCount: filteredList.length,
                      itemBuilder: (context, index) {
                        final dining = filteredList[index];
                        return DiningCard(
                          dining: dining,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (_) => DiningDetailScreen(dining: dining),
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
        padding: const EdgeInsets.symmetric(vertical: 0).copyWith(right: 16),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.horizontal(
                left: Radius.circular(14),
                right: Radius.circular(32),
              ),
              child: Image.asset(
                imagePath,
                height: 42,
                width: 70,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 14),
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
