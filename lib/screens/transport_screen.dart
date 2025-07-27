import 'package:flutter/material.dart';
import '../widgets/transport_card.dart';

class TransportScreen extends StatelessWidget {
  const TransportScreen({Key? key}) : super(key: key);

  // Helper method to create a bullet point widget
  Widget bulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• ', style: TextStyle(fontSize: 13)),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 13, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: AppBar(title: const Text('Transport - Port Vila')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 8),
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 6),
              child: Text(
                'Getting Around Port Vila',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey.shade300, width: 1.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  bulletPoint(
                    'Taxis: Plentiful, fixed fare for most in-town rides.',
                  ),
                  bulletPoint(
                    'Minibuses: Safe, shared, cheapest for city trips.',
                  ),
                  bulletPoint(
                    'Car & Scooter Hire: Freedom to explore further.',
                  ),
                  bulletPoint(
                    'Water Taxis: Cross the harbour or visit Iririki Island.',
                  ),
                ],
              ),
            ),

            // TRANSPORT CARDS
            TransportCard(
              imageUrl: 'assets/images/taxi.jpg',
              title: 'Vanuatu Taxi Association',
              description:
                  'Cabs with taxi sign. Typical fare (port to town): 500–700 Vatu. Always confirm price before boarding.',
              openStatus: 'Open all day',
              tip: 'Agree on fare before boarding.',
            ),
            TransportCard(
              imageUrl: 'assets/images/minibus.jpg',
              title: 'Port Vila Minibus',
              description:
                  'Shared ride: flag one down, pay 150–300 Vatu per ride. Tell driver your destination.',
              openStatus: 'Daytime',
              tip: 'Just wave down a minibus with a "B" plate.',
            ),
            TransportCard(
              imageUrl: 'assets/images/car_rental.jpg',
              title: 'World Car Rentals Vanuatu',
              description:
                  'Book car, scooter, or 4WD hire. Valid driver\'s license required (international ok).',
              openStatus: 'Business hours',
              tip: 'Inspect vehicles before returning.',
            ),
            TransportCard(
              imageUrl: 'assets/images/water_taxi.jpg',
              title: 'Ifira Water Taxi',
              description:
                  'Quick shuttles across the bay or to resorts. Agree fare before departure.',
              openStatus: 'As scheduled',
              tip: 'Confirm return times and price.',
            ),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 18, vertical: 14),
              child: Divider(height: 2, color: Colors.teal, thickness: 2),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 2),
              child: Text(
                'Tips for Travelers',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
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
