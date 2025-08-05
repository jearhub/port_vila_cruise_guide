import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../data/dining_data.dart';
import '../widgets/dining_card.dart';
import 'dining_detail_screen.dart';

class DiningScreen extends StatelessWidget {
  const DiningScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dining – Port Vila')),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: MasonryGridView.count(
            crossAxisCount: 2,
            mainAxisSpacing: 16,
            crossAxisSpacing: 10,
            itemCount: DiningList.length,
            itemBuilder: (context, index) {
              final dining = DiningList[index];
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
      ),
    );
  }
}
