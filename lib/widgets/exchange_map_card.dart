import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';
import '../models/money_exchange_location.dart';

class ExchangeMapCard extends StatelessWidget {
  final List<MoneyExchangeLocation> locations;
  const ExchangeMapCard({required this.locations});

  @override
  Widget build(BuildContext context) {
    final Set<Marker> markers =
        locations
            .map(
              (loc) => Marker(
                markerId: MarkerId(loc.name),
                position: LatLng(loc.lat, loc.lng),
                infoWindow: InfoWindow(title: loc.name, snippet: loc.address),
              ),
            )
            .toSet();

    // Centered on Port Vila
    final CameraPosition initialCameraPosition = CameraPosition(
      target: LatLng(-17.7333, 168.3273),
      zoom: 13,
    );

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 3,
      child: SizedBox(
        height: 250,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: GoogleMap(
            initialCameraPosition: initialCameraPosition,
            markers: markers,
            mapType: MapType.normal,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: true,
          ),
        ),
      ),
    );
  }
}
