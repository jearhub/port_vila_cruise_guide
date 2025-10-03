import 'package:VilaCruise/widgets/stroked_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/stroked_text.dart';

class DealsCard extends StatelessWidget {
  final String title;
  final String description;
  final String imageUrl;
  final VoidCallback? onTap;

  const DealsCard({
    Key? key,
    required this.title,
    required this.description,
    required this.imageUrl,
    this.onTap,
  }) : super(key: key);

  Widget buildDealImage(String imageUrl) {
    if (imageUrl.startsWith('http')) {
      return Image.network(imageUrl, fit: BoxFit.cover);
    } else {
      return Image.asset(imageUrl, fit: BoxFit.cover);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 120,
        margin: const EdgeInsets.only(right: 16),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(18)),
        child: Stack(
          children: [
            Positioned.fill(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: buildDealImage(imageUrl),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                gradient: LinearGradient(
                  colors: [
                    Colors.black.withOpacity(0.08),
                    Colors.teal.withOpacity(0.20),
                    Colors.black.withOpacity(0.36),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 0,
                  vertical: 18,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    StrokedText(
                      text: title,
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      align: TextAlign.center,
                      strokeWidth: 4,
                    ),
                    const SizedBox(height: 4),
                    StrokedText(
                      text: description,
                      fontSize: 13,
                      color: Colors.white,
                      align: TextAlign.center,
                      strokeWidth: 4,
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
