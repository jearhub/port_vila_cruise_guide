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
                position: LatLng(loc.latitude, loc.longitude),
                infoWindow: InfoWindow(
                  title: loc.name,
                  snippet:
                      loc.note != null && loc.note!.isNotEmpty
                          ? '${loc.address}\n${loc.note}'
                          : loc.address,
                ),
              ),
            )
            .toSet();

    // Center map on the first location if available, otherwise default
    final CameraPosition initialCameraPosition = CameraPosition(
      target:
          locations.isNotEmpty
              ? LatLng(locations[0].latitude, locations[0].longitude)
              : LatLng(-17.7333, 168.3273),
      zoom: 13,
    );

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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
