import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../data/shopping_data.dart';
import '../widgets/activity_card.dart';
import 'activity_detail_screen.dart';
import 'package:google_fonts/google_fonts.dart';

// Example filter data for shopping types:
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

  @override
  Widget build(BuildContext context) {
    // FILTER: show only activities with selected tag, or all if no filter
    final filteredList =
        _selectedTag == null
            ? ActivityList
            : ActivityList.where(
              (a) => (a.tags ?? [])
                  .map((e) => e.toLowerCase())
                  .contains(_selectedTag!.toLowerCase()),
            ).toList();

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
              'Shopping',
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
            children: [
              // Scrollable filter cards (optional)
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                child: Row(
                  children: [
                    if (_selectedTag != null) ...[
                      // Clear filter icon
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
                    ],
                    ...shopFilters.map(
                      (filter) => Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: GestureDetector(
                          onTap:
                              () => setState(
                                () => _selectedTag = filter['label'],
                              ),
                          child: Card(
                            // Slightly highlight if selected
                            color:
                                _selectedTag == filter['label']
                                    ? Colors.teal[50]
                                    : Colors.white,
                            elevation: _selectedTag == filter['label'] ? 5 : 2,
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
                                  Image.asset(
                                    filter['icon']!,
                                    height: 30,
                                    width: 30,
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    filter['label']!,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                      fontFamily:
                                          GoogleFonts.poppins().fontFamily,
                                      color:
                                          _selectedTag == filter['label']
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
                child: MasonryGridView.count(
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
                                (_) => ActivityDetailScreen(activity: activity),
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
