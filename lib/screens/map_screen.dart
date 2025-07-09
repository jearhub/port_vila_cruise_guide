import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final Completer<GoogleMapController> _controller = Completer();

  static const LatLng _portVila = LatLng(-17.7333, 168.3167);

  // Example attractions - replace or extend with your actual data
  final List<Attraction> _attractions = [
    Attraction(
      name: 'Mele Cascades',
      latitude: -17.67573,
      longitude: 168.25960,
    ),
    Attraction(
      name: 'Port Vila Market',
      latitude: -17.740172,
      longitude: 168.314054,
    ),
    Attraction(
      name: 'Ekasup Village',
      latitude: -17.75906,
      longitude: 168.329340,
    ),
  ];

  final Set<Marker> _markers = {};

  LatLng? _currentPosition;

  @override
  void initState() {
    super.initState();
    _setAttractionMarkers();
    _determinePosition();
  }

  void _setAttractionMarkers() {
    final markers =
        _attractions.map((attraction) {
          return Marker(
            markerId: MarkerId(attraction.name),
            position: LatLng(attraction.latitude, attraction.longitude),
            infoWindow: InfoWindow(title: attraction.name),
            icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueAzure,
            ),
          );
        }).toSet();

    setState(() {
      _markers.addAll(markers);
    });
  }

  Future<void> _determinePosition() async {
    // Request location permission
    var status = await Permission.location.status;
    if (!status.isGranted) {
      status = await Permission.location.request();
      if (!status.isGranted) {
        // Permission denied, do not show user location
        return;
      }
    }

    // Check if location services are enabled
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled
      return;
    }

    // Get current position
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    setState(() {
      _currentPosition = LatLng(position.latitude, position.longitude);
      _markers.add(
        Marker(
          markerId: const MarkerId('user_location'),
          position: _currentPosition!,
          infoWindow: const InfoWindow(title: 'Your Location'),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        ),
      );
    });

    // Move camera to user location
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newLatLngZoom(_currentPosition!, 14));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Port Vila Attractions Map')),
      body: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: const CameraPosition(
          target: _portVila,
          zoom: 13,
        ),
        markers: _markers,
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
    );
  }
}

class Attraction {
  final String name;
  final double latitude;
  final double longitude;

  Attraction({
    required this.name,
    required this.latitude,
    required this.longitude,
  });
}
