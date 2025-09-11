import 'package:flutter/material.dart';
import '../services/places_api_service.dart';
import '../models/place.dart';
import 'package:google_fonts/google_fonts.dart';

class PlaceDetailScreen extends StatefulWidget {
  final String placeId;
  const PlaceDetailScreen({required this.placeId});
  @override
  _PlaceDetailScreenState createState() => _PlaceDetailScreenState();
}

class _PlaceDetailScreenState extends State<PlaceDetailScreen> {
  final PlacesApiService apiService = PlacesApiService();
  late Future<Place> futurePlace;

  @override
  void initState() {
    super.initState();
    // Uses placeId for the ACTUAL attraction
    futurePlace = apiService.fetchPlaceDetail(widget.placeId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // App logo at the left
        title: Row(
          children: [
            const SizedBox(width: 14),
            Text(
              'Place Details',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
      body: FutureBuilder<Place>(
        future: futurePlace,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return Center(child: CircularProgressIndicator());
          if (snapshot.hasError)
            return Center(child: Text('Failed to load details'));
          if (!snapshot.hasData)
            return Center(child: Text('No details found.'));
          final attraction = snapshot.data!;
          return SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (attraction.imageUrl.isNotEmpty)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      attraction.imageUrl,
                      fit: BoxFit.cover,
                    ),
                  ),
                SizedBox(height: 16),
                Text(
                  attraction.name,
                  style: TextStyle(
                    fontSize: 24,
                    fontFamily: GoogleFonts.poppins().fontFamily,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 12),
                Row(
                  children: [
                    Icon(Icons.star, color: Colors.orange, size: 20),
                    Text(
                      ' ${attraction.rating} (${attraction.reviews} Reviews)',
                    ),
                  ],
                ),
                SizedBox(height: 16),
                if (attraction.description.isNotEmpty)
                  Text(
                    attraction.description,
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: GoogleFonts.poppins().fontFamily,
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
