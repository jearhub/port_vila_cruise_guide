//import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:port_vila_cruise_guide/main.dart'; // Ensure correct import

void main() {
  testWidgets('Verify app title', (WidgetTester tester) async {
    // Build our app and trigger a frame.

    await tester.pumpWidget(
      const PortVilaCruiseGuideApp(),
    ); // Correct Class Name

    // Verify that the app title is correct.
    expect(find.text('Port Vila Cruise Guide'), findsOneWidget);
  });
}
