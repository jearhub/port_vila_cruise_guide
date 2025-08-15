import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

// --------------- Dining-style transport info card -----------------
class TransportRentalCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String description;
  final String openStatus;
  final String tip;

  const TransportRentalCard({
    Key? key,
    required this.imageUrl,
    required this.title,
    required this.description,
    required this.openStatus,
    required this.tip,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Image
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
                color: Colors.black87,
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
            padding: const EdgeInsets.fromLTRB(16, 2, 16, 12),
            child: Text(
              tip,
              style: TextStyle(
                color: Colors.black54,
                fontSize: 13,
                fontFamily: GoogleFonts.poppins().fontFamily,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ],
      ),
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
      elevation: 2,
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
              Positioned.fill(
                child: Image.asset(
                  imageUrl,
                  fit: BoxFit.cover, // Fills the whole card
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// --------------- TransportScreen MAIN -----------------------------
class TransportScreen extends StatefulWidget {
  const TransportScreen({Key? key}) : super(key: key);

  @override
  State<TransportScreen> createState() => _TransportScreenState();
}

class _TransportScreenState extends State<TransportScreen> {
  final List<String> categories = [
    'All',
    'Taxis',
    'Minibuses',
    'Car Hire',
    'E-Bikes',
    'Water Taxi',
  ];
  final List<IconData> categoryIcons = [
    Icons.apps,
    Icons.local_taxi,
    Icons.directions_bus,
    Icons.car_rental,
    Icons.electric_bike,
    Icons.directions_boat,
  ];

  String selectedCategory = 'All';

  // Each tab's bullet intro(s)
  final Map<String, List<String>> bulletIntros = {
    'All': [
      'Taxis: Plentiful, fixed fare for most in-town rides.',
      'Minibuses: Safe, shared, cheapest for city trips.',
      'Car & Scooter Hire: Freedom to explore further.',
      'E-Bikes: Eco-friendly, fun way to see the sights.',
      'Water Taxis: Cross the harbour or visit Iririki Island.',
    ],
    'Taxis': ['Taxis: Plentiful, fixed fare for most in-town rides.'],
    'Minibuses': ['Minibuses: Safe, shared, cheapest for city trips.'],
    'Car Hire': ['Car & Scooter Hire: Freedom to explore further.'],
    'E-Bikes': ['E-Bikes: Eco-friendly, fun way to see the sights.'],
    'Water Taxi': ['Water Taxis: Cross the harbour or visit Iririki Island.'],
  };

  // Transport items.
  final List<Map<String, String>> transportItems = [
    // If you want to include the other transport types, add similar cards with other categories:
    {
      'imageUrl': 'assets/images/taxi.jpg',
      'title': 'Vanuatu Taxi Association',
      'category': 'Taxis',
      'description':
          'Cabs with taxi sign. Typical fare (port to town): 500–700 Vatu. Always confirm price before boarding.',
      'openStatus': 'Open all day',
      'tip': 'Agree on fare before boarding.',
    },
    {
      'imageUrl': 'assets/images/minibus.jpg',
      'title': 'Port Vila Minibus',
      'category': 'Minibuses',
      'description':
          'Shared ride: flag one down, pay 150–300 Vatu per ride. Tell driver your destination.',
      'openStatus': 'Daytime',
      'tip': 'Just wave down a minibus with a "B" plate.',
    },
    {
      'imageUrl': 'assets/images/car_rental.jpg',
      'title': 'Car Rentals',
      'category': 'Car Hire',
      'description':
          'Book car, scooter, or 4WD hire. Valid driver\'s license required (international ok).',
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
      'website': 'https://www.facebook.com/BudgetVanuatu/',
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

  // Helper: bullet point style
  Widget bulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 2.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '• ',
            style: TextStyle(
              fontSize: 13,
              fontFamily: GoogleFonts.poppins().fontFamily,
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 13,
                fontFamily: GoogleFonts.poppins().fontFamily,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

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
        title: Row(
          children: [
            Image.asset(
              'assets/images/port_vila_logo_trans.png',
              height: 36,
              width: 36,
            ),
            const SizedBox(width: 14),
            Text(
              'Transport',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.teal.shade700,
              ),
            ),
          ],
        ),
        backgroundColor: Colors.white,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 8),
          children: [
            // MENU BAR WITH ICONS
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
                    child: Container(
                      width: 80,
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.teal.shade600 : Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: const Color.fromARGB(255, 171, 194, 192),
                          width: 1.2,
                        ),
                        boxShadow:
                            isSelected
                                ? [
                                  BoxShadow(
                                    color: Colors.teal.withOpacity(0.1),
                                    blurRadius: 3,
                                    offset: Offset(0, 1),
                                  ),
                                ]
                                : [],
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
                              //fontWeight: FontWeight.w600,
                              fontSize: 13,
                              fontFamily: GoogleFonts.poppins().fontFamily,
                            ),
                          ),
                        ],
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
                    : selectedCategory, // or a friendlier subtitle
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  fontFamily: GoogleFonts.poppins().fontFamily,
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey.shade300, width: 1.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (final intro in bulletIntros[selectedCategory] ?? [])
                    bulletPoint(intro),
                ],
              ),
            ),

            // FILTERED TRANSPORT/RENTAL CARDS
            ...filteredItems.map(
              (item) => TransportRentalCard(
                imageUrl: item['imageUrl']!,
                title: item['title']!,
                description: item['description']!,
                openStatus: item['openStatus']!,
                tip: item['tip']!,
              ),
            ),

            // Tapable Car Rental Link Cards (below car rental cards, only if Car Hire tab)
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
                              width: 120, // Fixed card width for consistency
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

            // Divider and general tips
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
                color: Colors.yellow[50],
                border: Border.all(color: Colors.grey.shade300, width: 1.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  bulletPoint(
                    'Agree on taxi and water taxi fares before ride.',
                  ),
                  bulletPoint(
                    'Minibuses run daytime only; late night service is rare, but can be arranged.',
                  ),
                  bulletPoint(
                    'Drive on the right. Local conditions can be busy when ships are in port.',
                  ),
                  bulletPoint(
                    'E-bike rentals are popular; book ahead during peak season.',
                  ),
                  bulletPoint(
                    'Keep receipts for rentals and check vehicles before returning. Some roads may have potholes.',
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
