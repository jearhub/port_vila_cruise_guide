import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EsimScreen extends StatelessWidget {
  const EsimScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'eSIM Info',
          style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "About eSIM in Vanuatu",
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "eSIM lets you activate mobile data without a physical SIM card. Perfect for instant connection on Vanuatu’s 4G networks.",
              style: GoogleFonts.poppins(fontSize: 14),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              child: Text(
                'See Local Providers',
                style: GoogleFonts.poppins(fontSize: 14, color: Colors.teal),
              ),
              onPressed: () => Navigator.pushNamed(context, '/providers'),
            ),
          ],
        ),
      ),
    );
  }
}
