import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoflutterfire_plus/geoflutterfire_plus.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:async/async.dart';

import '../models/attraction.dart';
import '../models/activity.dart';
import 'booking_screen.dart';
import 'activity_detail_screen.dart';

class NearbyPlace {
  final String id;
  final String name;
  final String category;
  final String address;
  final String description;
  final String imageUrl;
  final String openingHours;
  final double rating;
  final int reviews;
  final String phoneNumber;
  final double latitude;
  final double longitude;
  final String price;
  final List<dynamic> tags;
  final bool isFavorite;

  NearbyPlace({
    required this.id,
    required this.name,
    required this.category,
    required this.address,
    required this.description,
    required this.imageUrl,
    required this.openingHours,
    required this.rating,
    required this.reviews,
    required this.phoneNumber,
    required this.latitude,
    required this.longitude,
    required this.price,
    required this.tags,
    this.isFavorite = false,
  });
}

class AttractionDetailScreen extends StatelessWidget {
  final Attraction attraction;

  const AttractionDetailScreen({Key? key, required this.attraction})
    : super(key: key);

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

  Stream<List<NearbyPlace>> getNearbyFromCollection(
    String collection,
    double lat,
    double lng,
    double radiusMeters,
  ) {
    final ref = FirebaseFirestore.instance.collection(collection);
    final geoRef = GeoCollectionReference(ref);
    final center = GeoFirePoint(GeoPoint(lat, lng));
    return geoRef
        .subscribeWithin(
          center: center,
          radiusInKm: radiusMeters / 1000.0,
          field: 'geo',
          geopointFrom: (data) => (data['geo'] as Map)['geopoint'] as GeoPoint,
          strictMode: true,
        )
        .map(
          (snapList) =>
              snapList.map((doc) {
                final data = doc.data() as Map;
                return NearbyPlace(
                  id: doc.id,
                  name: data['name'] ?? '',
                  imageUrl: data['imageUrl'] ?? data['image_url'] ?? '',
                  address: data['address'] ?? '',
                  price: data['price'] ?? '',
                  category: data['category'] ?? '',
                  description: data['description'] ?? '',
                  openingHours: data['openingHours'] ?? '',
                  rating:
                      (data['rating'] is int)
                          ? (data['rating'] as int).toDouble()
                          : (data['rating'] ?? 0.0),
                  reviews: data['reviews'] ?? 0,
                  phoneNumber:
                      data['phoneNumber'] ?? data['phone_number'] ?? '',
                  latitude: data['latitude'] ?? 0.0,
                  longitude: data['longitude'] ?? 0.0,
                  tags: List.from(data['tags'] ?? []),
                  isFavorite: data['isFavorite'] ?? false,
                );
              }).toList(),
        );
  }

  Stream<List<NearbyPlace>> getAllNearby(
    double lat,
    double lng,
    double radiusMeters,
  ) async* {
    final streams = [
      getNearbyFromCollection("dining", lat, lng, radiusMeters),
      getNearbyFromCollection("shopping", lat, lng, radiusMeters),
      getNearbyFromCollection("beauty_care", lat, lng, radiusMeters),
    ];
    await for (var values in StreamZip(streams)) {
      yield values.expand((e) => e).toList();
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
                offset: Offset(0, -2),
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
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
                      builder: (_) => BookingScreen(item: attraction),
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
                      aspectRatio: 16 / 9,
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
                    Text(
                      attraction.description,
                      style: TextStyle(
                        fontFamily: GoogleFonts.poppins().fontFamily,
                        fontSize: 16,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 16),
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
                    Text(
                      'Duration: ${attraction.duration}',
                      style: TextStyle(
                        fontFamily: GoogleFonts.poppins().fontFamily,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    if (attraction.skipLine)
                      Text(
                        'Skip the line available',
                        style: GoogleFonts.poppins(fontSize: 15),
                      ),
                    if (attraction.pickupAvailable)
                      Text(
                        'Pickup service available',
                        style: GoogleFonts.poppins(fontSize: 15),
                      ),
                    const SizedBox(height: 24),
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
                    // Map/Location block
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
                    // --- Masonry Grid Section for Nearby ---
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        "Nearby Activities & Services",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          fontFamily: GoogleFonts.poppins().fontFamily,
                        ),
                      ),
                    ),
                    StreamBuilder<List<NearbyPlace>>(
                      stream: getAllNearby(
                        attraction.latitude,
                        attraction.longitude,
                        1000, // extended to 1 km
                      ),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Center(child: CircularProgressIndicator());
                        }
                        final places = snapshot.data!;
                        if (places.isEmpty) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Text(
                              'No nearby activities.',
                              style: TextStyle(
                                fontFamily: GoogleFonts.poppins().fontFamily,
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          );
                        }
                        // Show only 6 if there are more than 6 activities
                        final displayedPlaces =
                            places.length > 6 ? places.sublist(0, 6) : places;
                        return MasonryGridView.count(
                          crossAxisCount: 2,
                          mainAxisSpacing: 8,
                          crossAxisSpacing: 8,
                          itemCount: displayedPlaces.length,
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          padding: EdgeInsets.only(top: 12.0),
                          itemBuilder: (context, i) {
                            final place = displayedPlaces[i];
                            return InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (context) => ActivityDetailScreen(
                                          activity: Activity(
                                            name: place.name,
                                            imageUrl: place.imageUrl,
                                            address: place.address,
                                            price: place.price,
                                            category: place.category,
                                            description: place.description,
                                            openingHours: place.openingHours,
                                            rating: place.rating,
                                            reviews: place.reviews,
                                            phoneNumber: place.phoneNumber,
                                            latitude: place.latitude,
                                            longitude: place.longitude,
                                            tags: place.tags,
                                            isFavorite: place.isFavorite,
                                          ),
                                        ),
                                  ),
                                );
                              },
                              child: Card(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    place.imageUrl.isNotEmpty
                                        ? buildImage(place.imageUrl, height: 80)
                                        : Container(
                                          height: 80,
                                          color: Colors.grey,
                                        ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0,
                                      ),
                                      child: Text(
                                        place.name,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontFamily:
                                              GoogleFonts.poppins().fontFamily,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0,
                                      ),
                                      child: Text(
                                        place.address,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontFamily:
                                              GoogleFonts.poppins().fontFamily,
                                          fontSize: 12,
                                          color: Colors.grey[700],
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0,
                                        vertical: 6.0,
                                      ),
                                      child: Text(
                                        'Price: ${place.price}',
                                        style: TextStyle(
                                          fontFamily:
                                              GoogleFonts.poppins().fontFamily,
                                          fontSize: 12,
                                          color: Colors.teal.shade900,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                    // --- End Masonry Grid Section ---
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
