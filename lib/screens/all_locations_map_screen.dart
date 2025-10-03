import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class AllLocationsMapScreen extends StatefulWidget {
  const AllLocationsMapScreen({Key? key}) : super(key: key);

  @override
  State createState() => _AllLocationsMapScreenState();
}

class _AllLocationsMapScreenState extends State<AllLocationsMapScreen> {
  late GoogleMapController _mapController;
  Set<Marker> _markers = {};
  final LatLng portvilaCenter = const LatLng(-17.7383, 168.3133);

  BitmapDescriptor? attractionIcon;
  BitmapDescriptor? shoppingIcon;
  BitmapDescriptor? diningIcon;
  BitmapDescriptor? beautyCareIcon;
  BitmapDescriptor? tourIcon;
  BitmapDescriptor? walkStopIcon;
  BitmapDescriptor? exchangeIcon;

  // Style to hide all default POIs
  final String _hidePoiStyle = '''
  [
    {
      "featureType": "poi",
      "elementType": "all",
      "stylers": [{ "visibility": "off" }]
    }
  ]
  ''';

  @override
  void initState() {
    super.initState();
    _loadMarkerIcons();
  }

  Future<void> _loadMarkerIcons() async {
    attractionIcon = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(size: Size(48, 48)),
      'assets/markers/photography_marker.png',
    );
    shoppingIcon = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(size: Size(48, 48)),
      'assets/markers/bag_marker.png',
    );
    diningIcon = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(size: Size(48, 48)),
      'assets/markers/restaurant_marker.png',
    );
    beautyCareIcon = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(size: Size(48, 48)),
      'assets/markers/b&w_marker.png',
    );
    tourIcon = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(size: Size(48, 48)),
      'assets/markers/bus.png',
    );
    walkStopIcon = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(size: Size(48, 48)),
      'assets/markers/walkstop_marker.png',
    );
    exchangeIcon = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(size: Size(48, 48)),
      'assets/markers/bank.png',
    );
    setState(() {});
    await _loadAllLocations();
  }

  Future<void> _loadAllLocations() async {
    Set<Marker> allMarkers = {};
    Future<void> fetchCollection(
      String name,
      String type,
      BitmapDescriptor? icon,
    ) async {
      try {
        QuerySnapshot snapshot =
            await FirebaseFirestore.instance.collection(name).get();
        for (var doc in snapshot.docs) {
          final data = doc.data() as Map;
          final lat = data['latitude'];
          final lng = data['longitude'];
          if (lat != null && lng != null && lat is num && lng is num) {
            allMarkers.add(
              Marker(
                markerId: MarkerId('${type}_${doc.id}'),
                position: LatLng(lat.toDouble(), lng.toDouble()),
                infoWindow: InfoWindow(
                  title: data['name'] ?? type,
                  snippet: data['address'] ?? '',
                ),
                icon: icon ?? BitmapDescriptor.defaultMarker,
              ),
            );
          }
        }
      } catch (e) {
        print('Error fetching $name: $e');
      }
    }

    await Future.wait([
      fetchCollection('attractions', 'Attraction', attractionIcon),
      fetchCollection('shopping', 'Shopping', shoppingIcon),
      fetchCollection('dining', 'Dining', diningIcon),
      fetchCollection('beauty_care', 'BeautyCare', beautyCareIcon),
      fetchCollection('tours', 'Tour', tourIcon),
      fetchCollection('walk_stops', 'WalkStop', walkStopIcon),
      fetchCollection('money_exchange_location', 'Exchange', exchangeIcon),
    ]);

    setState(() {
      _markers = allMarkers;
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    _mapController.setMapStyle(_hidePoiStyle);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'All Locations Map',
          style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500),
        ),
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(target: portvilaCenter, zoom: 14),
        onMapCreated: _onMapCreated,
        markers: _markers,
        mapType: MapType.normal,
        myLocationButtonEnabled: false,
        zoomControlsEnabled: true,
      ),
    );
  }
}
