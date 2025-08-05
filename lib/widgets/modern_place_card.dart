import 'package:flutter/material.dart';
import '../models/place.dart';

class ModernPlaceCard extends StatelessWidget {
  final Place place;
  final VoidCallback onTap;

  const ModernPlaceCard({required this.place, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: InkWell(
        onTap: onTap,
        child: Row(
          children: [
            if (place.imageUrl.isNotEmpty)
              Container(
                width: 100,
                height: 80,
                child: Image.network(place.imageUrl, fit: BoxFit.cover),
              ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      place.name,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      place.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.star, color: Colors.orange, size: 18),
                        Text(' ${place.rating} (${place.reviews})'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
