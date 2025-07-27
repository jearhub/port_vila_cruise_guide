import 'package:flutter/material.dart';

class DealsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Deals & Discounts'),
        backgroundColor: Colors.teal,
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          DealCard(
            title: 'Summer Savings',
            description: 'Up to 25% off selected buggy routes until August 31!',
            imagePath: 'assets/images/buggy_adventure.jpg',
          ),
          SizedBox(height: 16),
          DealCard(
            title: 'Buy 1 Get 1 Free',
            description: 'On all coffee beverages this weekend.',
            imagePath: 'assets/images/bogo.png',
          ),
          // Add more DealCard widgets here for additional deals
        ],
      ),
    );
  }
}

class DealCard extends StatelessWidget {
  final String title;
  final String description;
  final String imagePath;

  const DealCard({
    required this.title,
    required this.description,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.asset(
            imagePath,
            width: 52,
            height: 52,
            fit: BoxFit.cover,
          ),
        ),
        title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(description),
      ),
    );
  }
}
