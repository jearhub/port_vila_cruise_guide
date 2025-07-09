import 'package:flutter/material.dart';
import '../models/tour.dart';
import 'tour_detail_screen.dart';
import 'map_screen.dart'; // Adjust the path if needed

class CruiseGuideScreen extends StatelessWidget {
  const CruiseGuideScreen({Key? key}) : super(key: key);

  final List<Tour> thingsToDo = const [
    Tour(
      name: 'Beach Relaxation',
      description: 'Relax on pristine beaches with crystal clear water.',
      imageUrl: 'assets/images/beach_relaxation.jpg',
      openingHours: 'All day',
      entryFee: 'Free',
      duration: 'Flexible',
      skipLine: false,
      pickupAvailable: false,
      rating: 4.9,
      reviews: 150,
      price: 'Free',
    ),
    Tour(
      name: 'Cultural Village Tour',
      description: 'Experience the rich culture of Port Vila.',
      imageUrl: 'assets/images/cultural_village.jpg',
      openingHours: '10:00 AM - 4:00 PM',
      entryFee: '\$20',
      duration: '4 hours',
      skipLine: false,
      pickupAvailable: true,
      rating: 4.5,
      reviews: 98,
      price: '\VUV 5,000',
    ),
    Tour(
      name: 'Lagoon Cruise',
      description: 'Relax on a scenic lagoon cruise.',
      imageUrl: 'assets/images/lagoon_cruise.jpg',
      openingHours: '9:00 AM - 5:00 PM',
      entryFee: 'Included',
      duration: '3 hours',
      skipLine: true,
      pickupAvailable: true,
      rating: 4.7,
      reviews: 120,
      price: '\VUV 7,500',
    ),
    Tour(
      name: 'Waterfall Hike',
      description: 'Hike to stunning waterfalls surrounded by nature.',
      imageUrl: 'assets/images/waterfall_hike.jpg',
      openingHours: '8:00 AM - 3:00 PM',
      entryFee: 'Free',
      duration: '5 hours',
      skipLine: false,
      pickupAvailable: false,
      rating: 4.8,
      reviews: 75,
      price: 'Free',
    ),
    Tour(
      name: 'Market Shopping',
      description: 'Shop for local crafts and souvenirs at the market.',
      imageUrl: 'assets/images/market_shopping.jpg',
      openingHours: '7:00 AM - 6:00 PM',
      entryFee: 'Free',
      duration: '2 hours',
      skipLine: false,
      pickupAvailable: false,
      rating: 4.3,
      reviews: 60,
      price: 'Varies',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      /*appBar: AppBar(
        title: const Text('Port Vila Cruise Guide'),
        backgroundColor: Colors.teal,
        centerTitle: true,
        elevation: 4,
      ),*/
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        children: [
          // Ship info card
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'SHIP NAME',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Time in port: 8 hr 25 min',
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Return by 4:30 PM',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    children: const [
                      Icon(
                        Icons.wb_sunny_outlined,
                        size: 40,
                        color: Colors.orange,
                      ),
                      SizedBox(height: 4),
                      Text(
                        '28°',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text('Partly cloudy', textAlign: TextAlign.center),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Top 5 Things to Do - horizontal scroll
          const Text(
            'Top 5 Things to Do Today',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 220,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: thingsToDo.length,
              separatorBuilder: (_, __) => const SizedBox(width: 16),
              itemBuilder: (context, index) {
                final tour = thingsToDo[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => TourDetailScreen(tour: tour),
                      ),
                    );
                  },
                  child: Container(
                    width: size.width * 0.6,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                      image: DecorationImage(
                        image: AssetImage(tour.imageUrl),
                        fit: BoxFit.cover,
                        colorFilter: ColorFilter.mode(
                          Colors.black.withOpacity(0.25),
                          BlendMode.darken,
                        ),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            tour.name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              shadows: [
                                Shadow(blurRadius: 5, color: Colors.black87),
                              ],
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(
                                Icons.star,
                                color: Colors.amber,
                                size: 18,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                '${tour.rating} (${tour.reviews} reviews)',
                                style: const TextStyle(color: Colors.white70),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            tour.price,
                            style: const TextStyle(
                              color: Colors.tealAccent,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              shadows: [
                                Shadow(blurRadius: 5, color: Colors.black87),
                              ],
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

          const SizedBox(height: 24),

          // --- Tappable Map Image ---
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const MapScreen()),
                );
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  'assets/images/sample_map.png', // Use your map preview image asset
                  height: 160,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),

          // Deals & Discounts card
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 3,
            child: ListTile(
              leading: Container(
                decoration: BoxDecoration(
                  color: Colors.teal.shade50,
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.all(12),
                child: const Icon(Icons.percent, color: Colors.teal, size: 30),
              ),
              title: const Text('Deals & Discounts'),
              trailing: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                /*child: Image.asset(
                  'assets/images/sample_map.png',
                  width: 90,
                  height: 60,
                  fit: BoxFit.cover,
                ),*/
              ),
              onTap: () {
                // TODO: Navigate to deals screen or show deals
              },
            ),
          ),

          const SizedBox(height: 16),

          // Self-Guided Walking Tours card
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 3,
            child: ListTile(
              leading: Container(
                decoration: BoxDecoration(
                  color: Colors.teal.shade50,
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.all(12),
                child: const Icon(
                  Icons.directions_walk,
                  color: Colors.teal,
                  size: 30,
                ),
              ),
              title: const Text('Self-Guided Walking Tours'),
              onTap: () {
                // TODO: Navigate to walking tours screen
              },
            ),
          ),

          const SizedBox(height: 16),

          // Safety & Practical Info card
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 3,
            child: ListTile(
              leading: Container(
                decoration: BoxDecoration(
                  color: Colors.teal.shade50,
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.all(12),
                child: const Icon(Icons.shield, color: Colors.teal, size: 30),
              ),
              title: const Text('Safety & Practical Info'),
              onTap: () {
                // TODO: Navigate to safety info screen
              },
            ),
          ),
        ],
      ),
    );
  }
}
