import 'package:flutter/material.dart';

class BusinessCard extends StatelessWidget {
  final String name;
  final String category;
  final String address;
  final String imageUrl;
  final String? website;
  final VoidCallback? onTap;

  const BusinessCard({
    Key? key,
    required this.name,
    required this.category,
    required this.address,
    required this.imageUrl,
    this.website,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
        elevation: 10,
        margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
        child: Container(
          height: 180,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            image: DecorationImage(
              image: AssetImage(imageUrl),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.22),
                BlendMode.darken,
              ),
            ),
          ),
          child: Stack(
            children: [
              // Gradient overlay for readability
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(22),
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
              ),
              // Business card content (no icons)
              Positioned(
                left: 24,
                bottom: 24,
                right: 24,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        shadows: [Shadow(blurRadius: 8, color: Colors.black87)],
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      category,
                      style: const TextStyle(
                        color: Colors.tealAccent,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        shadows: [Shadow(blurRadius: 4, color: Colors.black54)],
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      address,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                        shadows: [Shadow(blurRadius: 2, color: Colors.black)],
                      ),
                    ),
                    if (website != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          website!,
                          style: const TextStyle(
                            color: Colors.blueAccent,
                            fontSize: 13,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
