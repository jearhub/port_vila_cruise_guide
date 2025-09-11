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

final List<Map<String, String>> beautyCare = [
  {'image': 'assets/images/beauty/beauty.jpg', 'label': 'Beauty Salon'},
  {'image': 'assets/images/beauty/spa.jpg', 'label': 'Spa'},
  {'image': 'assets/images/beauty/makeup.jpg', 'label': 'Makeup'},
  {'image': 'assets/images/beauty/nail.jpg', 'label': 'Nail Art'},
  {'image': 'assets/images/beauty/hair.jpg', 'label': 'Hair Care'},
  {'image': 'assets/images/beauty/massage.jpg', 'label': 'Massage'},
  {'image': 'assets/images/beauty/yoga2.jpg', 'label': 'Yoga'},
  {'image': 'assets/images/beauty/tattoo.jpg', 'label': 'Tattoo'},
  {'image': 'assets/images/beauty/barber.jpg', 'label': 'Barber'},
];

class BeautyCareScreen extends StatefulWidget {
  const BeautyCareScreen({Key? key}) : super(key: key);

  @override
  State createState() => _BeautyCareScreenState();
}

class _BeautyCareScreenState extends State<BeautyCareScreen> {
  String? _selectedTag;

  Query get _activityQuery {
    // FIXED collection name:
    final baseQuery = FirebaseFirestore.instance.collection('beauty_care');
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
              'Beauty Care',
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
                    ...beautyCare.map(
                      (tag) => Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: GestureDetector(
                          onTap:
                              () => setState(() => _selectedTag = tag['label']),
                          child: SmallRectCard(
                            imagePath: tag['image']!,
                            label: tag['label']!,
                            isSelected: _selectedTag == tag['label'],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
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
              child: buildImage(
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
