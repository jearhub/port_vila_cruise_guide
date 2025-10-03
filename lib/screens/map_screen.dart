import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../models/walk_stop.dart';
import 'package:google_fonts/google_fonts.dart';

class MapScreen extends StatelessWidget {
  final List<WalkStop> stops;
  final double? latitude;
  final double? longitude;
  final String? stopName;

  const MapScreen({
    Key? key,
    this.stops = const [],
    this.latitude,
    this.longitude,
    this.stopName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final markers = <Marker>{};

    if (stops.isNotEmpty) {
      for (var stop in stops) {
        if (stop.latitude != null && stop.longitude != null) {
          markers.add(
            Marker(
              markerId: MarkerId(stop.name),
              position: LatLng(stop.latitude!, stop.longitude!),
              infoWindow: InfoWindow(title: stop.name),
            ),
          );
        }
      }
    } else if (latitude != null && longitude != null && stopName != null) {
      markers.add(
        Marker(
          markerId: MarkerId(stopName!),
          position: LatLng(latitude!, longitude!),
          infoWindow: InfoWindow(title: stopName),
        ),
      );
    }

    LatLng center;
    if (latitude != null && longitude != null) {
      center = LatLng(latitude!, longitude!);
    } else if (stops.isNotEmpty &&
        stops.first.latitude != null &&
        stops.first.longitude != null) {
      center = LatLng(stops.first.latitude!, stops.first.longitude!);
    } else {
      center = LatLng(-17.7383, 168.3133);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          stopName ?? 'Map - All Stops',
          style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500),
        ),
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(target: center, zoom: 15),
        markers: markers,
        myLocationButtonEnabled: true,
        myLocationEnabled: true,
      ),
    );
  }
}
