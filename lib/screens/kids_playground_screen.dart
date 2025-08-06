import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../data/playground_data.dart';
import '../widgets/activity_card.dart';
import 'activity_detail_screen.dart';
import 'package:google_fonts/google_fonts.dart';

class KidsPlaygroundScreen extends StatelessWidget {
  const KidsPlaygroundScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // App logo at the left
        title: Row(
          children: [
            Image.asset(
              'assets/images/port_vila_logo_trans.png', // <-- your logo image path
              height: 36,
              width: 36,
            ),
            const SizedBox(width: 14),
            Text(
              'Kids Playground',
              style: GoogleFonts.homemadeApple(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color:
                    Colors.teal.shade700, // Optional: match AppBar's foreground
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: MasonryGridView.count(
            crossAxisCount: 2,
            mainAxisSpacing: 16,
            crossAxisSpacing: 10,
            itemCount: ActivityList.length,
            itemBuilder: (context, index) {
              final activity = ActivityList[index];
              return ActivityCard(
                activity: activity,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ActivityDetailScreen(activity: activity),
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
