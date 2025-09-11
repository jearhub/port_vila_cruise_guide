import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CruiseScheduleCard extends StatelessWidget {
  final VoidCallback onTap;

  const CruiseScheduleCard({Key? key, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      //elevation: 1,
      color: Colors.teal[50],
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Icon(Icons.calendar_today, size: 30, color: Colors.teal[700]),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'View Cruise Schedule',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontFamily: GoogleFonts.poppins().fontFamily,
                      ),
                    ),
                    Text(
                      'Arrivals and Departures',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.black,
                        fontFamily: GoogleFonts.poppins().fontFamily,
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
