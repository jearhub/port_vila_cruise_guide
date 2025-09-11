import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../widgets/activity_card.dart';
import 'activity_detail_screen.dart';
import '../models/activity.dart';

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

final List<Map<String, String>> shopFilters = [
  {'icon': 'assets/icons/electronics.png', 'label': 'Electronics'},
  {'icon': 'assets/icons/souvenirs.png', 'label': 'Souvenirs'},
  {'icon': 'assets/icons/jewelry.png', 'label': 'Jewelry'},
  {'icon': 'assets/icons/art.png', 'label': 'Art'},
  {'icon': 'assets/icons/dutyfree.png', 'label': 'Duty Free'},
  {'icon': 'assets/icons/kids.png', 'label': 'Kids'},
  {'icon': 'assets/icons/travel.png', 'label': 'Travel'},
];

class ShoppingScreen extends StatefulWidget {
  const ShoppingScreen({Key? key}) : super(key: key);

  @override
  State<ShoppingScreen> createState() => _ShoppingScreenState();
}

class _ShoppingScreenState extends State<ShoppingScreen> {
  String? _selectedTag;

  Query get _activityQuery {
    // FIXED collection name:
    final baseQuery = FirebaseFirestore.instance.collection('shopping');
    if (_selectedTag == null) {
      return baseQuery;
    } else {
      return baseQuery.where('tags', arrayContains: _selectedTag);
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
              'Shopping',
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
            children: [
              // Tag filter bar
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                child: Row(
                  children: [
                    if (_selectedTag != null)
                      Padding(
                        padding: const EdgeInsets.only(right: 12.0),
                        child: GestureDetector(
                          onTap: () => setState(() => _selectedTag = null),
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
                    ...shopFilters.map(
                      (tag) => Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: GestureDetector(
                          onTap:
                              () => setState(() => _selectedTag = tag['label']),
                          child: Card(
                            // Slightly highlight if selected
                            color:
                                _selectedTag == tag['label']
                                    ? Colors.teal[50]
                                    : Colors.white,
                            elevation: _selectedTag == tag['label'] ? 5 : 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(22),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 8,
                                horizontal: 12,
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  // If you use icon assets
                                  buildImage(
                                    tag['icon']!,
                                    height: 30,
                                    width: 30,
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    tag['label']!,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                      fontFamily:
                                          GoogleFonts.poppins().fontFamily,
                                      color:
                                          _selectedTag == tag['label']
                                              ? Colors.teal
                                              : Colors.black87,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              // Main shopping grid
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: _activityQuery.snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData)
                      return const Center(child: CircularProgressIndicator());
                    final filteredList =
                        snapshot.data!.docs.map((doc) {
                          return Activity.fromFirestore(doc);
                        }).toList();
                    if (filteredList.isEmpty) {
                      return const Center(
                        child: Text('No beauty & care spots found.'),
                      );
                    }
                    return MasonryGridView.count(
                      crossAxisCount: 2,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 10,
                      itemCount: filteredList.length,
                      itemBuilder: (context, index) {
                        final activity = filteredList[index];
                        return ActivityCard(
                          activity: activity,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (_) => ActivityDetailScreen(
                                      activity: activity,
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
            ],
          ),
        ),
      ),
    );
  }
}
