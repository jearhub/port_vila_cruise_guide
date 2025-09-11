import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';

class BookingConfirmationScreen extends StatelessWidget {
  final String bookingId;
  final String attractionName;
  final String imageUrl;
  final DateTime date;
  final int ticketCount;
  final double totalPaid;
  final String? packageName;

  const BookingConfirmationScreen({
    Key? key,
    required this.bookingId,
    required this.attractionName,
    required this.imageUrl,
    required this.date,
    required this.ticketCount,
    required this.totalPaid,
    this.packageName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Booking Confirmed",
          style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Congratulations!',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 14),
              Text(
                'Your booking is successful.',
                style: GoogleFonts.poppins(fontSize: 16),
              ),
              SizedBox(height: 24),
              Text(
                'Booking Details:',
                style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 8),
              Text('Attraction: $attractionName', style: GoogleFonts.poppins()),
              Text(
                'Date: ${date.toLocal().toString().split(' ')[0]}',
                style: GoogleFonts.poppins(),
              ),
              if (packageName != null && packageName != '')
                Text('Package: $packageName', style: GoogleFonts.poppins()),
              Text('Tickets: $ticketCount', style: GoogleFonts.poppins()),
              Text(
                'Total Paid: VT ${totalPaid.round()}',
                style: GoogleFonts.poppins(),
              ),
              Text('Booking ID: $bookingId', style: GoogleFonts.poppins()),
              Spacer(),
              SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    '/user_bookings',
                    arguments: {
                      'userId': FirebaseAuth.instance.currentUser!.uid,
                    },
                  );
                },
                child: Text(
                  "View my Bookings",
                  style: GoogleFonts.poppins(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
