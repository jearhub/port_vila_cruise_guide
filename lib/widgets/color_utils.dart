import 'package:flutter/material.dart';

Color parseColor(String rgba) {
  final regExp = RegExp(r'rgba?\((\d+),(\d+),(\d+),([0-9.]+)\)');
  final match = regExp.firstMatch(rgba);
  if (match != null) {
    int r = int.parse(match.group(1)!);
    int g = int.parse(match.group(2)!);
    int b = int.parse(match.group(3)!);
    double a = double.parse(match.group(4)!);
    return Color.fromRGBO(r, g, b, a);
  }
  return Colors.grey;
}
