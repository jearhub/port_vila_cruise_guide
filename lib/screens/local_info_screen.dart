import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LocalInfoScreen extends StatelessWidget {
  const LocalInfoScreen({Key? key}) : super(key: key);

  final List<Map<String, dynamic>> infoItems = const [
    {
      'title': 'Emergency Numbers',
      'details': 'Police: 111\nFire: 22333\nAmbulance: 115',
      'icon': FontAwesomeIcons.phone,
      'color': Color(0xFFE3F2FD), // Light Blue
    },
    {
      'title': 'Local Customs',
      'details':
          'Respect traditional villages and dress modestly.\nTry kava, a traditional drink, but be mindful of cultural etiquette.',
      'icon': FontAwesomeIcons.handsHelping,
      'color': Color(0xFFFFF3E0), // Light Orange
    },
    {
      'title': 'Language Tips',
      'details':
          'Bislama is the local language.\nCommon phrases:\n- Hello: Halo\n- Thank you: Tankiu tumas\n- Good bye: Ale Tata',
      'icon': FontAwesomeIcons.language,
      'color': Color(0xFFE8F5E9), // Light Green
    },
    {
      'title': 'Transport Options',
      'details':
          'Taxis are available at the port.\nCar rentals can be arranged locally.\nSome hotels offer shuttle services.',
      'icon': FontAwesomeIcons.car,
      'color': Color(0xFFFFEBEE), // Light Red
    },
    {
      'title': 'Currency & Shopping',
      'details':
          'The local currency is Vanuatu Vatu (VUV).\nDuty-free shopping is available near the port.',
      'icon': FontAwesomeIcons.bagShopping,
      'color': Color(0xFFF3E5F5), // Light Purple
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: const Text('Local Info')),
      body: SafeArea(
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: infoItems.length,
          itemBuilder: (context, index) {
            final item = infoItems[index];

            return Card(
              color: item['color'],
              surfaceTintColor:
                  Colors.transparent, // Avoid Material 3 elevation tint
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              margin: const EdgeInsets.only(bottom: 16),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          item['icon'],
                          color: Theme.of(context).primaryColor,
                          size: 32,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            item['title']!,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      item['details']!,
                      style: TextStyle(fontSize: 16, color: Colors.grey[800]),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
