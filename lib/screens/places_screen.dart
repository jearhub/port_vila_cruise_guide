import 'package:flutter/material.dart';
import '../services/places_api_service.dart';
import '../models/place.dart';
import '../widgets/modern_place_card.dart';
import 'place_detail_screen.dart';
import 'package:google_fonts/google_fonts.dart';

class PlacesScreen extends StatefulWidget {
  @override
  _PlacesScreenState createState() => _PlacesScreenState();
}

class _PlacesScreenState extends State<PlacesScreen> {
  final PlacesApiService apiService = PlacesApiService();
  late Future<List<Place>> futurePlaces;

  @override
  void initState() {
    super.initState();
    // Change "Port Vila" to the city you want!
    futurePlaces = apiService.fetchPlaces(cityName: "Port Vila");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // App logo at the left
        title: Row(
          children: [
            Image.asset(
              'assets/images/port_vila_logo_trans.png', // <-- your logo image path
              height: 36,
              width: 36,
            ),
            const SizedBox(width: 14),
            Text(
              'Google Places',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color:
                    Colors.teal.shade700, // Optional: match AppBar's foreground
              ),
            ),
          ],
        ),
      ),
      body: FutureBuilder<List<Place>>(
        future: futurePlaces,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return Center(child: CircularProgressIndicator());
          if (snapshot.hasError)
            return Center(child: Text('Failed to load places'));

          if (!snapshot.hasData || snapshot.data!.isEmpty)
            return Center(child: Text('No places found.'));

          final places = snapshot.data!;
          return ListView.builder(
            itemCount: places.length,
            itemBuilder: (context, index) {
              final place = places[index];
              return ModernPlaceCard(
                place: place,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => PlaceDetailScreen(placeId: place.id),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
