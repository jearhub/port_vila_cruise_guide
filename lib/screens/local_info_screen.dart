import 'package:VilaCruise/screens/foreign_currency_screen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

// Import your separated screens here
import 'emergency_numbers_screen.dart';
import 'local_customs_screen.dart';
import 'language_tips_screen.dart';
import 'transport_screen.dart';

class LocalInfoScreen extends StatelessWidget {
  const LocalInfoScreen({Key? key}) : super(key: key);

  final List<Map<String, dynamic>> infoItems = const [
    {
      'title': 'Emergency Numbers',
      'icon': FontAwesomeIcons.phone,
      //'color': Color(0xFFE3F2FD),
      'details': 'Police: 111\nFire: 22333\nAmbulance: 115',
    },
    {
      'title': 'Local Customs',
      'icon': FontAwesomeIcons.handsHelping,
      //'color': Color(0xFFFFF3E0),
      'details':
          'Respect traditional villages and dress modestly.\nTry kava, a traditional drink, but be mindful of cultural etiquette.',
    },
    {
      'title': 'Language Tips',
      'icon': FontAwesomeIcons.language,
      //'color': Color(0xFFE8F5E9),
      'details':
          'Bislama is the local language.\nCommon phrases:\n- Hello: Halo\n- Thank you: Tankiu tumas\n- Good bye: Ale Tata',
    },
    {
      'title': 'Transport Options',
      'icon': FontAwesomeIcons.car,
      //'color': Color(0xFFFFEBEE),
      'details':
          'Taxis are available at the port.\nCar rentals can be arranged locally.\nSome hotels offer shuttle services.',
    },
    {
      'title': 'Currency & Shopping',
      'icon': FontAwesomeIcons.bagShopping,
      //'color': Color(0xFFF3E5F5),
      'details':
          'The local currency is Vanuatu Vatu (VUV).\nDuty-free shopping is available closeby.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pushReplacementNamed('/main');
        return false;
      },
      child: Scaffold(
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
                'Local Info',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        body: SafeArea(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: infoItems.length,
            itemBuilder: (context, index) {
              final item = infoItems[index];
              return InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () {
                  Widget? screen;
                  switch (index) {
                    case 0:
                      screen = EmergencyNumbersScreen();
                      break;
                    case 1:
                      screen = LocalCustomsScreen();
                      break;
                    case 2:
                      screen = LanguageTipsScreen();
                      break;
                    case 3:
                      screen = TransportScreen();
                      break;
                    case 4:
                      screen = ForeignCurrencyScreen();
                      break;
                  }
                  if (screen != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => screen!),
                    );
                  }
                },
                child: Card(
                  color: item['color'],
                  surfaceTintColor: Colors.transparent,
                  elevation: 1,
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
                              color: Colors.teal.shade700,
                              size: 16,
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Text(
                                item['title'] ?? '',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                  fontFamily: GoogleFonts.poppins().fontFamily,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          item['details'] ?? '',
                          style: TextStyle(
                            fontSize: 14,
                            fontFamily: GoogleFonts.poppins().fontFamily,
                            color: Colors.grey[800],
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
      ),
    );
  }
}
