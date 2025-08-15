import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../data/tours_data.dart'; // Your tours data
import '../widgets/modern_tour_card.dart'; // Your custom TourCard widget
import 'tour_detail_screen.dart'; // For detail view
import 'package:google_fonts/google_fonts.dart';

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

  @override
  Widget build(BuildContext context) {
    final filteredTours =
        _selectedCategory == null
            ? tours
            : tours
                .where(
                  (tour) => (tour.category ?? []).any(
                    (c) => c.toLowerCase() == _selectedCategory!.toLowerCase(),
                  ),
                )
                .toList();

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset(
              'assets/images/port_vila_logo_trans.png',
              height: 36,
              width: 36,
            ),
            const SizedBox(width: 14),
            Text(
              'Tours',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.teal.shade700,
              ),
            ),
          ],
        ),
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
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
              // Grid of filtered tours
              Expanded(
                child: MasonryGridView.count(
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
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Reusable rectangle filter card with highlight
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
              child: Image.asset(
                imagePath,
                height: 30,
                width: 30,
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
