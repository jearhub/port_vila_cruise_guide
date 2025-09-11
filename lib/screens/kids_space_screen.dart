import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../data/playground_data.dart';
import '../widgets/activity_card.dart';
import 'activity_detail_screen.dart';
import 'package:google_fonts/google_fonts.dart';

class KidsSpaceScreen extends StatelessWidget {
  const KidsSpaceScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // App logo at the left
        title: Row(
          children: [
            const SizedBox(width: 14),
            Text(
              'Kids Space',
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
