import 'package:flutter/material.dart';

class TransportCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String description;
  final String openStatus;
  final String tip;

  const TransportCard({
    Key? key,
    required this.imageUrl,
    required this.title,
    required this.description,
    required this.openStatus,
    required this.tip,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      elevation: 8,
      margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Rectangular header image
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(18),
              topRight: Radius.circular(18),
            ),
            child: Image.asset(
              imageUrl,
              height: 165,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 15, 18, 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 7),
                Text(
                  description,
                  style: const TextStyle(fontSize: 15, color: Colors.black87),
                ),
                const SizedBox(height: 10),
                Text(
                  'Open: $openStatus',
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.teal,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Tip: $tip',
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.teal,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
