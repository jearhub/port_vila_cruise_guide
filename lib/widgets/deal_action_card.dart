import 'package:flutter/material.dart';

class DealActionCard extends StatelessWidget {
  final Widget title;
  final Widget description;
  final String backgroundImage;
  final VoidCallback? onTap;

  const DealActionCard({
    required this.title,
    required this.description,
    required this.backgroundImage,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 220,
        margin: const EdgeInsets.only(right: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          color: Colors.white,
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child:
                    backgroundImage.startsWith('http')
                        ? Image.network(backgroundImage, fit: BoxFit.cover)
                        : Image.asset(backgroundImage, fit: BoxFit.cover),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [title, const SizedBox(height: 4), description],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
