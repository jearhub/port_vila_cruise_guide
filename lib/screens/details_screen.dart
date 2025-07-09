import 'package:flutter/material.dart';

class DetailsScreen extends StatelessWidget {
  final String title;
  final String description;
  final String imagePath;

  const DetailsScreen({
    Key? key,
    required this.title,
    required this.description,
    required this.imagePath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              imagePath,
              width: double.infinity,
              height: 240,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(description, style: const TextStyle(fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }
}
