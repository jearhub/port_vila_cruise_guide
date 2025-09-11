import 'package:flutter/material.dart';

class SmallRectCard extends StatelessWidget {
  final String imagePath; // Image asset or network path
  final String label;

  const SmallRectCard({Key? key, required this.imagePath, required this.label})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
      elevation: 1,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 0).copyWith(right: 16),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AspectRatio(
              aspectRatio: 1, // 1:1 square for icons
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: buildImage(
                  imagePath,
                  width: 32,
                  height: 32,
                  fit: BoxFit.cover,
                ),
              ),
            ),

            const SizedBox(width: 14),
            Text(
              label,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildImage(String path, {double? height, double? width, BoxFit? fit}) {
    if (path.startsWith('http')) {
      return Image.network(path, height: height, width: width, fit: fit);
    } else {
      return Image.asset(path, height: height, width: width, fit: fit);
    }
  }
}
