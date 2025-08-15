import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/tour.dart';
import 'tour_booking_screen.dart';

class TourDetailScreen extends StatelessWidget {
  final Tour tour;

  const TourDetailScreen({Key? key, required this.tour}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),

      // Bottom bar: Entry Fee + Book Now
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 6,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: Row(
            children: [
              // Entry Fee on left
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.attach_money,
                      color: Colors.teal.shade700,
                      size: 20,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      tour.entryFee,
                      style: TextStyle(
                        fontFamily: GoogleFonts.poppins().fontFamily,
                        fontSize: 16,
                        color: Colors.teal.shade900,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              // Book Now button
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 14,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => TourBookingScreen(tour: tour),
                    ),
                  );
                },
                child: Text(
                  'Book Now',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

      body: SafeArea(
        top: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // IMAGE HEADER
            Stack(
              children: [
                Hero(
                  tag: 'tour-image-${tour.name}',
                  child: Image.asset(
                    tour.imageUrl,
                    height: 300,
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                ),
                Container(
                  height: 300,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.black.withOpacity(0.6),
                        Colors.transparent,
                        Colors.transparent,
                        Colors.black.withOpacity(0.6),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 24,
                  left: 16,
                  right: 16,
                  child: Text(
                    tour.name,
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: GoogleFonts.poppins().fontFamily,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(
                          blurRadius: 6,
                          color: Colors.black87,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // SCROLLABLE BODY
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 24,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Description
                    Text(
                      tour.description,
                      style: TextStyle(
                        fontFamily: GoogleFonts.poppins().fontFamily,
                        fontSize: 16,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Opening Hours (text + icon)
                    Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          color: Colors.teal.shade700,
                          size: 20,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          tour.openingHours,
                          style: TextStyle(
                            fontFamily: GoogleFonts.poppins().fontFamily,
                            fontSize: 14,
                            color: Colors.teal.shade900,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Duration
                    Text(
                      'Duration: ${tour.duration}',
                      style: TextStyle(
                        fontFamily: GoogleFonts.poppins().fontFamily,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Optional services
                    if (tour.skipLine)
                      const Text(
                        'Skip the line available',
                        style: TextStyle(fontSize: 16),
                      ),
                    if (tour.pickupAvailable)
                      const Text(
                        'Pickup service available',
                        style: TextStyle(fontSize: 16),
                      ),
                    const SizedBox(height: 24),

                    // Rating + reviews
                    Row(
                      children: [
                        ...List.generate(5, (i) {
                          double diff = tour.rating - i;
                          IconData icon;
                          if (diff >= 1) {
                            icon = Icons.star;
                          } else if (diff >= 0.5) {
                            icon = Icons.star_half;
                          } else {
                            icon = Icons.star_border;
                          }
                          return Icon(icon, color: Colors.amber, size: 24);
                        }),
                        const SizedBox(width: 8),
                        Text(
                          '${tour.rating} (${tour.reviews} reviews)',
                          style: TextStyle(
                            fontFamily: GoogleFonts.poppins().fontFamily,
                            fontSize: 16,
                          ),
                        ),
                      ],
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
