import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../models/attraction.dart';
import 'booking_screen.dart';

class AttractionDetailScreen extends StatelessWidget {
  final Attraction attraction;

  const AttractionDetailScreen({Key? key, required this.attraction})
    : super(key: key);

  // Universal image builder, uses cached network image for performance
  Widget buildImage(
    String imageUrl, {
    BoxFit fit = BoxFit.cover,
    double? width,
    double? height,
  }) {
    const String placeholderPath = 'assets/images/placeholder_bg.png';
    if (imageUrl.startsWith('http')) {
      return CachedNetworkImage(
        imageUrl: imageUrl,
        fit: fit,
        width: width ?? double.infinity,
        height: height ?? double.infinity,
        placeholder:
            (context, url) => Image.asset(
              placeholderPath,
              fit: fit,
              width: width ?? double.infinity,
              height: height ?? double.infinity,
            ),
        errorWidget:
            (context, url, error) => Image.asset(
              placeholderPath,
              fit: fit,
              width: width ?? double.infinity,
              height: height ?? double.infinity,
            ),
        memCacheWidth: 600,
        memCacheHeight: 400,
      );
    } else {
      return Image.asset(
        imageUrl,
        fit: fit,
        width: width ?? double.infinity,
        height: height ?? double.infinity,
        errorBuilder:
            (context, error, stackTrace) => Image.asset(
              placeholderPath,
              fit: fit,
              width: width ?? double.infinity,
              height: height ?? double.infinity,
            ),
      );
    }
  }

  void _openMap(double lat, double lng) async {
    final googleMapsUrl = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=$lat,$lng',
    );
    if (await canLaunchUrl(googleMapsUrl)) {
      await launchUrl(googleMapsUrl, mode: LaunchMode.externalApplication);
    }
  }

  void _callPhone(String phone) async {
    final Uri telUri = Uri(scheme: 'tel', path: phone);
    if (await canLaunchUrl(telUri)) {
      await launchUrl(telUri);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
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
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    /*Icon(
                      Icons.attach_money,
                      color: Colors.teal.shade700,
                      size: 20,
                    ),*/
                    const SizedBox(width: 4),
                    Text(
                      attraction.entryFee,
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
                      builder: (_) => BookingScreen(attraction: attraction),
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
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              pinned: true,
              expandedHeight: 300,
              backgroundColor: Colors.transparent,
              elevation: 0,
              automaticallyImplyLeading: false,
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    AspectRatio(
                      aspectRatio:
                          16 /
                          9, // or another value that matches your image layout
                      child: Hero(
                        tag: 'attraction-image-${attraction.name}',
                        child: buildImage(
                          attraction.imageUrl,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),

                    Container(
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
                        attraction.name,
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
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 24,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Description
                    Text(
                      attraction.description,
                      style: TextStyle(
                        fontFamily: GoogleFonts.poppins().fontFamily,
                        fontSize: 16,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Opening Hours
                    Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          color: Colors.teal.shade700,
                          size: 20,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          attraction.openingHours,
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
                      'Duration: ${attraction.duration}',
                      style: TextStyle(
                        fontFamily: GoogleFonts.poppins().fontFamily,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Optional services
                    if (attraction.skipLine)
                      const Text(
                        'Skip the line available',
                        style: TextStyle(fontSize: 16),
                      ),
                    if (attraction.pickupAvailable)
                      const Text(
                        'Pickup service available',
                        style: TextStyle(fontSize: 16),
                      ),
                    const SizedBox(height: 24),
                    // Rating + reviews
                    Row(
                      children: [
                        ...List.generate(5, (i) {
                          double diff = attraction.rating - i;
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
                          '${attraction.rating} (${attraction.reviews} reviews)',
                          style: TextStyle(
                            fontFamily: GoogleFonts.poppins().fontFamily,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    // LOCATION BLOCK: map, address, phone inside card box
                    Container(
                      margin: const EdgeInsets.only(bottom: 24),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          color: Colors.teal.shade100,
                          width: 1.5,
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [BoxShadow(color: Colors.teal.shade50)],
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 1,
                            child: SizedBox(
                              height: 120,
                              child: Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Opacity(
                                      opacity: 0.7,
                                      child: GoogleMap(
                                        initialCameraPosition: CameraPosition(
                                          target: LatLng(
                                            attraction.latitude,
                                            attraction.longitude,
                                          ),
                                          zoom: 14,
                                        ),
                                        markers: {
                                          Marker(
                                            markerId: const MarkerId(
                                              'attraction-location',
                                            ),
                                            position: LatLng(
                                              attraction.latitude,
                                              attraction.longitude,
                                            ),
                                            infoWindow: InfoWindow(
                                              title: attraction.name,
                                              snippet: attraction.address,
                                            ),
                                          ),
                                        },
                                        zoomControlsEnabled: false,
                                        myLocationButtonEnabled: false,
                                        liteModeEnabled: false,
                                      ),
                                    ),
                                  ),
                                  Positioned.fill(
                                    child: Material(
                                      color: Colors.transparent,
                                      child: InkWell(
                                        borderRadius: BorderRadius.circular(12),
                                        splashColor: Colors.teal.withAlpha(30),
                                        onTap:
                                            () => _openMap(
                                              attraction.latitude,
                                              attraction.longitude,
                                            ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            flex: 1,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.location_on,
                                      color: Colors.teal.shade700,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 4),
                                    Flexible(
                                      child: Text(
                                        attraction.address,
                                        style: TextStyle(
                                          fontFamily:
                                              GoogleFonts.poppins().fontFamily,
                                          fontSize: 14,
                                          color: Colors.teal.shade900,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.phone,
                                      color: Colors.teal.shade700,
                                      size: 18,
                                    ),
                                    const SizedBox(width: 4),
                                    Flexible(
                                      child: GestureDetector(
                                        onTap:
                                            () => _callPhone(
                                              attraction.phoneNumber,
                                            ),
                                        child: Text(
                                          attraction.phoneNumber,
                                          style: TextStyle(
                                            fontFamily:
                                                GoogleFonts.poppins()
                                                    .fontFamily,
                                            fontSize: 14,
                                            color: Colors.teal.shade900,
                                            decoration:
                                                TextDecoration.underline,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
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
