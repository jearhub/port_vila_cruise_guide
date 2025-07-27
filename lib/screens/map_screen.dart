import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

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

class MapScreen extends StatefulWidget {
  final double? latitude;
  final double? longitude;
  final String? stopName;

  const MapScreen({Key? key, this.latitude, this.longitude, this.stopName})
    : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final Completer<GoogleMapController> _controller = Completer();
  static const LatLng _portVila = LatLng(-17.7333, 168.3167);

  final List<Attraction> _attractions = [
    Attraction(
      name: 'Mele Cascades',
      latitude: -17.67573,
      longitude: 168.25960,
    ),
    /* Attraction(
      name: 'Port Vila Market',
      latitude: -17.740172,
      longitude: 168.314054,
    ), */
    Attraction(
      name: 'Ekasup Village',
      latitude: -17.75906,
      longitude: 168.329340,
    ),
  ];

  final Set<Marker> _markers = {};
  LatLng? _currentPosition;
  bool _movedToStop = false;

  @override
  void initState() {
    super.initState();
    _setAttractionMarkers();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _setStopMarker();
      _determinePosition();
    });
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

  void _setStopMarker() {
    if (widget.latitude != null && widget.longitude != null) {
      setState(() {
        _markers.add(
          Marker(
            markerId: MarkerId(widget.stopName ?? 'walk_stop'),
            position: LatLng(widget.latitude!, widget.longitude!),
            infoWindow: InfoWindow(title: widget.stopName ?? 'Tour Stop'),
            icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueGreen,
            ),
          ),
        );
      });
    }
  }

  Future<void> _determinePosition() async {
    var status = await Permission.location.status;
    if (!status.isGranted) {
      status = await Permission.location.request();
      if (!status.isGranted) {
        return;
      }
    }

    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return;
    }

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

    final GoogleMapController controller = await _controller.future;

    // Center on the walk stop if provided, else on user
    if (widget.latitude != null && widget.longitude != null && !_movedToStop) {
      _movedToStop = true;
      await controller.animateCamera(
        CameraUpdate.newLatLngZoom(
          LatLng(widget.latitude!, widget.longitude!),
          15,
        ),
      );
    } else {
      await controller.animateCamera(
        CameraUpdate.newLatLngZoom(_currentPosition!, 14),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final LatLng initialTarget =
        (widget.latitude != null && widget.longitude != null)
            ? LatLng(widget.latitude!, widget.longitude!)
            : _portVila;

    return Scaffold(
      body: SafeArea(
        child: GoogleMap(
          mapType: MapType.normal,
          initialCameraPosition: CameraPosition(
            target: initialTarget,
            zoom: 13,
          ),
          markers: _markers,
          myLocationEnabled: true,
          myLocationButtonEnabled: true,
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
          },
        ),
      ),
    );
  }
}
