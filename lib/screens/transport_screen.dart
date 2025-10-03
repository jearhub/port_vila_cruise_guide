import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

// --------------- Transport info card -----------------
class TransportRentalCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String description;
  final String openStatus;
  final String tip;
  final VoidCallback? onTap;
  final Widget? actionButton;

  const TransportRentalCard({
    Key? key,
    required this.imageUrl,
    required this.title,
    required this.description,
    required this.openStatus,
    required this.tip,
    this.onTap,
    this.actionButton,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cardContent = Card(
      margin: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 1,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Image.asset(
              imageUrl,
              height: 140,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 2),
            child: Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                fontFamily: GoogleFonts.poppins().fontFamily,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
            child: Text(
              description,
              style: TextStyle(
                fontSize: 14,
                fontFamily: GoogleFonts.poppins().fontFamily,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
            child: Text(
              openStatus,
              style: TextStyle(
                color: Colors.teal,
                fontSize: 13,
                fontFamily: GoogleFonts.poppins().fontFamily,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 2, 16, 8),
            child: Text(
              tip,
              style: TextStyle(
                fontSize: 13,
                fontFamily: GoogleFonts.poppins().fontFamily,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
          if (actionButton != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
              child: actionButton!,
            ),
        ],
      ),
    );
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: cardContent,
    );
  }
}

// --------------- Tapable card for external company link -----------
class CarRentalLinkCard extends StatelessWidget {
  final String imageUrl;
  final String website;

  const CarRentalLinkCard({
    Key? key,
    required this.imageUrl,
    required this.website,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      elevation: 1,
      child: InkWell(
        onTap: () async {
          final uri = Uri.parse(website);
          if (await canLaunchUrl(uri)) {
            await launchUrl(uri, mode: LaunchMode.externalApplication);
          } else {
            throw 'Could not launch $website';
          }
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: Stack(
            children: [
              // Full-size image
              Positioned.fill(child: Image.asset(imageUrl, fit: BoxFit.cover)),
            ],
          ),
        ),
      ),
    );
  }
}

// --------------- EBike Details Modal ------------------------
class EBikeDetailsModal extends StatelessWidget {
  const EBikeDetailsModal({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Use actual coordinates for the eBike rental location.
    final LatLng ebikeLocation = LatLng(
      -17.746745,
      168.314667,
    ); // Example: Port Vila Waterfront

    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Close Button Row
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: Icon(Icons.close, size: 26),
                    tooltip: 'Close',
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              Text(
                'E-Bike Hire Locations',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 8),
              Text(
                '• eBikes Vanuatu\nKumul Hwy\nbetween ASCO & Melanesian\nPort Vila',
                style: GoogleFonts.poppins(fontSize: 14),
              ),
              SizedBox(height: 14),
              Text(
                'Contact Details',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Phone: (+678) 750 0360',
                style: GoogleFonts.poppins(fontSize: 14),
              ),
              Text(
                'Email: ride@ebikesvanuatu.com',
                style: GoogleFonts.poppins(fontSize: 14),
              ),
              SizedBox(height: 14),
              Text(
                'Map Location',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 8),
              Container(
                height: 180,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: ebikeLocation,
                      zoom: 16,
                    ),
                    markers: {
                      Marker(
                        markerId: MarkerId('ebike-location'),
                        position: ebikeLocation,
                        infoWindow: InfoWindow(title: 'eBikes Vanuatu'),
                      ),
                    },
                    myLocationButtonEnabled: false,
                    zoomControlsEnabled: false,
                  ),
                ),
              ),
              SizedBox(height: 14),
              Text(
                'Booking Tip',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  fontStyle: FontStyle.italic,
                ),
              ),
              Text(
                'Book ahead during peak cruise days!',
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontStyle: FontStyle.italic,
                  color: Colors.teal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// --------------- Helper: bullet point style -----------------
Widget bulletPoint(String text) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 2.0),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '• ',
          style: TextStyle(
            fontSize: 14,
            fontFamily: GoogleFonts.poppins().fontFamily,
          ),
        ),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 14,
              fontFamily: GoogleFonts.poppins().fontFamily,
            ),
          ),
        ),
      ],
    ),
  );
}

// --------------- MAIN Transport Screen -----------------------------
class TransportScreen extends StatefulWidget {
  const TransportScreen({Key? key}) : super(key: key);

  @override
  State createState() => _TransportScreenState();
}

class _TransportScreenState extends State<TransportScreen> {
  final List categories = [
    'All',
    'Car Hire',
    'E-Bikes',
    'Taxis',
    'Minibuses',
    'Water Taxi',
  ];

  final List categoryIcons = [
    Icons.apps,
    Icons.car_rental,
    Icons.electric_bike,
    Icons.local_taxi,
    Icons.directions_bus,
    Icons.directions_boat,
  ];

  String selectedCategory = 'All';

  final Map<String, List<String>> bulletIntros = {
    'All': [
      'Car & Scooter Hire: Freedom to explore further.',
      'E-Bikes: Eco-friendly, fun way to see the sights.',
      'Taxis: Plentiful, fixed fare for most in-town rides.',
      'Minibuses: Safe, shared, cheapest for city trips.',
      'Water Taxis: Cross the harbour or visit Iririki Island.',
      'Walking in the town center is safe, but traffic is heavy on cruise days.',
    ],
    'Car Hire': ['Car & Scooter Hire: Freedom to explore further.'],
    'E-Bikes': ['E-Bikes: Eco-friendly, fun way to see the sights.'],
    'Taxis': ['Taxis: Plentiful, fixed fare for most in-town rides.'],
    'Minibuses': ['Minibuses: Safe, shared, cheapest for city trips.'],
    'Water Taxi': ['Water Taxis: Cross the harbour or visit Iririki Island.'],
  };

  final List<Map<String, String>> transportItems = [
    {
      'imageUrl': 'assets/images/car_rental.jpg',
      'title': 'Car Rentals',
      'category': 'Car Hire',
      'description':
          "Book car, scooter, or 4WD hire. Valid driver's license required (international ok).",
      'openStatus': 'Business hours',
      'tip': 'Inspect vehicles before returning.',
    },
    {
      'imageUrl': 'assets/images/ebike.jpg',
      'title': 'E-Bike Rentals',
      'category': 'E-Bikes',
      'description':
          'Explore Port Vila with ease and speed. Electric bikes for all ages, with helmet and lock included. Flexible hourly and full-day rates.',
      'openStatus': '9:00 AM - 5:00 PM',
      'tip': 'Book in advance during peak season.',
    },
    {
      'imageUrl': 'assets/images/taxi.jpg',
      'title': 'Vanuatu Taxi Association',
      'category': 'Taxis',
      'description':
          'Cabs with "T" plates are everywhere. Typical fare (port to town): 500–700 vatu. Always confirm price before boarding.',
      'openStatus': 'Open all day',
      'tip': 'Be reminded to agree on fare before boarding.',
    },
    {
      'imageUrl': 'assets/images/minibus.jpg',
      'title': 'Port Vila Minibus',
      'category': 'Minibuses',
      'description':
          'Shared ride: flag one down, pay 150–300 Vatu per ride. \nTell driver your destination.',
      'openStatus': 'Daytime',
      'tip': 'Just wave down a minibus with a "B" plate.',
    },
    {
      'imageUrl': 'assets/images/water_taxi.jpg',
      'title': 'Ifira Water Taxi',
      'category': 'Water Taxi',
      'description':
          'Quick shuttles across the bay or to resorts. Agree fare before departure.',
      'openStatus': 'As scheduled',
      'tip': 'Confirm return times and price.',
    },
  ];

  final List<Map<String, String>> carRentalLinks = [
    {
      'imageUrl': 'assets/images/budget.png',
      'website': 'https://www.rentalcarsvanuatu.com/',
    },
    {
      'imageUrl': 'assets/images/avis.png',
      'website': 'https://www.avis.com/en/locations/nh/port-vila',
    },
    {
      'imageUrl': 'assets/images/europacar.jpg',
      'website': 'https://www.europcar.vu',
    },
    {
      'imageUrl': 'assets/images/onwheels.png',
      'website': 'https://www.onwheelsrental.com/',
    },
    {
      'imageUrl': 'assets/images/hertz.png',
      'website': 'https://www.carhirevanuatu.com/',
    },
  ];

  List<Map<String, String>> get filteredItems {
    if (selectedCategory == 'All') return transportItems;
    return transportItems
        .where((item) => item['category'] == selectedCategory)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pushReplacementNamed('/main');
          },
        ),
        title: Row(
          children: [
            const SizedBox(width: 14),
            Text(
              'Transport',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 8),
          children: [
            // ---------------------- MENU BAR WITH ICONS --------------------------
            SizedBox(
              height: 82,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                itemCount: categories.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, idx) {
                  final cat = categories[idx];
                  final bool isSelected = cat == selectedCategory;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedCategory = cat;
                      });
                    },
                    child: Material(
                      elevation: isSelected ? 5 : 2, // Elevated effect
                      borderRadius: BorderRadius.circular(18),
                      color: isSelected ? Colors.teal.shade600 : Colors.white,
                      child: Container(
                        width: 80,
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color:
                                  isSelected
                                      ? Colors.teal.withOpacity(0.24)
                                      : Colors.grey.withOpacity(0.08),
                              blurRadius: isSelected ? 10 : 3,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              categoryIcons[idx],
                              color: isSelected ? Colors.white : Colors.teal,
                              size: 24,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              cat,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: isSelected ? Colors.white : Colors.teal,
                                fontSize: 13,
                                fontFamily: GoogleFonts.poppins().fontFamily,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            // HEADING & BULLET INTRO (only relevant bullet(s) for tab)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              child: Text(
                selectedCategory == 'All'
                    ? 'Getting Around Port Vila'
                    : selectedCategory,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  fontFamily: GoogleFonts.poppins().fontFamily,
                ),
              ),
            ),
            Card(
              elevation: 1,
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (final intro in bulletIntros[selectedCategory] ?? [])
                      bulletPoint(intro),
                  ],
                ),
              ),
            ),

            // FILTERED TRANSPORT/RENTAL CARDS
            ...filteredItems.map((item) {
              if (item['category'] == 'E-Bikes') {
                void showEbikeModal() {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(18),
                      ),
                    ),
                    builder: (_) => const EBikeDetailsModal(),
                  );
                }

                void openWebsite() async {
                  final uri = Uri.parse(
                    'https://www.ebikesvanuatu.com',
                  ); // Replace with actual
                  if (await canLaunchUrl(uri)) {
                    await launchUrl(uri, mode: LaunchMode.externalApplication);
                  }
                }

                return TransportRentalCard(
                  imageUrl: item['imageUrl']!,
                  title: item['title']!,
                  description: item['description']!,
                  openStatus: item['openStatus']!,
                  tip: item['tip']!,
                  onTap: showEbikeModal,
                  actionButton: Row(
                    children: [
                      ElevatedButton.icon(
                        icon: Icon(
                          Icons.info_outline,
                          color: Color(0xFFFFFFFF),
                        ),
                        label: Text(
                          'More Info',
                          style: TextStyle(color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          padding: EdgeInsets.symmetric(horizontal: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          textStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontFamily: GoogleFonts.poppins().fontFamily,
                            fontSize: 13,
                          ),
                        ),
                        onPressed: showEbikeModal,
                      ),
                      SizedBox(width: 8),
                      ElevatedButton.icon(
                        icon: Icon(Icons.public, color: Color(0xFFFFFFFF)),
                        label: Text(
                          'Hire Now',
                          style: TextStyle(color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                          padding: EdgeInsets.symmetric(horizontal: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          textStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontFamily: GoogleFonts.poppins().fontFamily,
                            fontSize: 13,
                          ),
                        ),
                        onPressed: openWebsite,
                      ),
                    ],
                  ),
                );
              }
              return TransportRentalCard(
                imageUrl: item['imageUrl']!,
                title: item['title']!,
                description: item['description']!,
                openStatus: item['openStatus']!,
                tip: item['tip']!,
              );
            }),
            // Tapable Car Rental Link Cards (for Car Hire)
            if (selectedCategory == 'Car Hire') ...[
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                child: Text(
                  "Book Direct with Local Providers",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    fontFamily: GoogleFonts.poppins().fontFamily,
                  ),
                ),
              ),
              Container(
                height: 80,
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children:
                        carRentalLinks.map((link) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 4),
                            child: SizedBox(
                              width: 120,
                              child: CarRentalLinkCard(
                                imageUrl: link['imageUrl']!,
                                website: link['website']!,
                              ),
                            ),
                          );
                        }).toList(),
                  ),
                ),
              ),
            ],
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 18, vertical: 14),
              child: Divider(height: 2, color: Colors.teal, thickness: 2),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 2),
              child: Text(
                'Tips for Travelers',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  fontFamily: GoogleFonts.poppins().fontFamily,
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.teal.shade200, width: 1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  bulletPoint(
                    'Keep receipts for rentals and check vehicles before returning. Some roads may have potholes.',
                  ),
                  bulletPoint(
                    'E-bike rentals are popular; book ahead during peak season.',
                  ),
                  bulletPoint(
                    'Agree on taxi and water taxi fares before ride.',
                  ),
                  bulletPoint(
                    'Minibuses run daytime only; late night service is rare, but can be arranged.',
                  ),
                  bulletPoint(
                    'Drive on the right. Local conditions can be busy when ships are in port.',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
