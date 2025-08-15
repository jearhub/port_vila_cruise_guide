import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../data/dining_data.dart';
import '../widgets/dining_card.dart';
import 'dining_detail_screen.dart';
import 'package:google_fonts/google_fonts.dart';

class DiningScreen extends StatefulWidget {
  const DiningScreen({Key? key}) : super(key: key);

  @override
  State<DiningScreen> createState() => _DiningScreenState();
}

class _DiningScreenState extends State<DiningScreen> {
  String? _selectedDish;

  final List<Map<String, String>> dishCards = [
    {'image': 'assets/images/fish_curry.jpg', 'label': 'Fish Curry'},
    {'image': 'assets/images/grilled_chicken.jpg', 'label': 'Grilled Chicken'},
    {'image': 'assets/images/pizza.jpg', 'label': 'Pizza'},
    {'image': 'assets/images/pasta.jpg', 'label': 'Pasta'},
    {'image': 'assets/images/toast.jpg', 'label': 'Avocado Toast'},
    // Add more as needed
  ];

  @override
  Widget build(BuildContext context) {
    // Filter restaurants by selected dish if any
    final filteredList =
        _selectedDish == null
            ? DiningList
            : DiningList.where(
              (dining) => dining.menu
                  .map((e) => e.toLowerCase())
                  .contains(_selectedDish!.toLowerCase()),
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
              'Dining',
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
              // Filter Cards Row with Clear Icon
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                child: Row(
                  children: [
                    if (_selectedDish != null) ...[
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
                    ],
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
              // Restaurant grid (filtered)
              Expanded(
                child: MasonryGridView.count(
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
                            builder: (_) => DiningDetailScreen(dining: dining),
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

// Make sure your SmallRectCard supports selection highlighting:
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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
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
                fontSize: 13,
                fontFamily: GoogleFonts.poppins().fontFamily,
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
