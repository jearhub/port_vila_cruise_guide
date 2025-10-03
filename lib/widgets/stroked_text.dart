import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class StrokedText extends StatelessWidget {
  final String text;
  final double fontSize;
  final double strokeWidth;
  final Color color;
  final Color strokeColor;
  final FontWeight fontWeight;
  final TextAlign align;
  final TextStyle? style;

  const StrokedText({
    Key? key,
    required this.text,
    required this.fontSize,
    this.strokeWidth = 2,
    this.color = Colors.white,
    this.strokeColor = Colors.black,
    this.fontWeight = FontWeight.normal,
    required this.align,
    this.style,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: fontWeight,
            fontStyle: GoogleFonts.poppins().fontStyle,
            foreground:
                Paint()
                  ..style = PaintingStyle.stroke
                  ..strokeWidth = strokeWidth
                  ..color = strokeColor,
          ),
        ),
        Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: fontWeight,
            color: color,
            fontStyle: GoogleFonts.poppins().fontStyle,
          ),
        ),
      ],
    );
  }
}
