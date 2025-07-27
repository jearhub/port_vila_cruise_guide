import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../models/activity.dart';
import '../data/beauty_care_data.dart';
import '../widgets/activity_card.dart';
import 'activity_detail_screen.dart';

class BeautyCareScreen extends StatelessWidget {
  const BeautyCareScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Beauty & Care – Port Vila')),
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
