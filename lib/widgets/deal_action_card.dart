import 'package:flutter/material.dart';

class DealActionCard extends StatelessWidget {
  final Widget title;
  final Widget description;
  final Gradient gradient;
  final VoidCallback onTap;
  final String? backgroundImage; // New optional parameter

  const DealActionCard({
    Key? key,
    required this.title,
    required this.description,
    required this.gradient,
    required this.onTap,
    this.backgroundImage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        image:
            backgroundImage != null
                ? DecorationImage(
                  image: AssetImage(backgroundImage!),
                  fit: BoxFit.cover,
                )
                : null,
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [title, const SizedBox(height: 8), description],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
