import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../models/money_exchange_location.dart';
import '../data/money_exchange_location_data.dart';

// ------------- FULL SCREEN MAP PAGE -------------
class FullScreenMapPage extends StatelessWidget {
  final Set<Marker> markers;
  final CameraPosition initialCameraPosition;

  const FullScreenMapPage({
    required this.markers,
    required this.initialCameraPosition,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // App logo at the left
        title: Row(
          children: [
            Image.asset(
              'assets/images/port_vila_logo_trans.png', // <-- your logo image path
              height: 36,
              width: 36,
            ),
            const SizedBox(width: 14),
            Text(
              'Exchange Locations Map',
              style: GoogleFonts.homemadeApple(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color:
                    Colors.teal.shade700, // Optional: match AppBar's foreground
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: GoogleMap(
          initialCameraPosition: initialCameraPosition,
          markers: markers,
          mapType: MapType.normal,
          zoomControlsEnabled: true,
          myLocationButtonEnabled: false,
        ),
      ),
    );
  }
}

// ------------- MAP CARD WIDGET -------------
class ExchangeMapCard extends StatelessWidget {
  final List<MoneyExchangeLocation> locations;
  const ExchangeMapCard({required this.locations});

  @override
  Widget build(BuildContext context) {
    final Set<Marker> markers =
        locations
            .map(
              (loc) => Marker(
                markerId: MarkerId(loc.name),
                position: LatLng(loc.lat, loc.lng),
                infoWindow: InfoWindow(title: loc.name, snippet: loc.address),
              ),
            )
            .toSet();

    final CameraPosition initialCameraPosition = CameraPosition(
      target: LatLng(-17.7333, 168.3273),
      zoom: 13,
    );

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 3,
      child: SizedBox(
        height: 250,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: GoogleMap(
            initialCameraPosition: initialCameraPosition,
            markers: markers,
            mapType: MapType.normal,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: true,
            // This is where the map tap expands to full screen
            onTap: (_) {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder:
                      (_) => FullScreenMapPage(
                        markers: markers,
                        initialCameraPosition: initialCameraPosition,
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

// ------------- MAIN SCREEN -------------
class ForeignCurrencyScreen extends StatefulWidget {
  @override
  _ForeignCurrencyScreenState createState() => _ForeignCurrencyScreenState();
}

class _ForeignCurrencyScreenState extends State<ForeignCurrencyScreen> {
  final List<Map<String, String>> currencies = [
    {'code': 'VUV', 'name': 'Vanuatu Vatu'},
    {'code': 'USD', 'name': 'US Dollar'},
    {'code': 'AUD', 'name': 'Australian Dollar'},
    {'code': 'NZD', 'name': 'NZ Dollar'},
    {'code': 'EUR', 'name': 'Euro'},
    {'code': 'GBP', 'name': 'British Pound'},
    {'code': 'CNY', 'name': 'Chinese Yuan'},
  ];

  final Map<String, double> exchangeRates = {
    'VUV': 1.0,
    'USD': 0.0085,
    'AUD': 0.013,
    'NZD': 0.014,
    'EUR': 0.0078,
    'GBP': 0.0067,
    'CNY': 0.059,
  };

  String fromCurr = 'VUV';
  String toCurr = 'USD';
  String amount = '';
  String converted = '';
  final _formatter = NumberFormat('#,##0.00');

  @override
  void initState() {
    super.initState();
    convert();
  }

  void convert() {
    double? amt = double.tryParse(amount);
    if (amt == null) {
      setState(
        () => converted = amount.isNotEmpty ? 'Enter a valid number' : '',
      );
      return;
    }
    double vuvAmount =
        fromCurr == 'VUV' ? amt : amt * (1 / exchangeRates[fromCurr]!);
    double result =
        toCurr == 'VUV' ? vuvAmount : vuvAmount * exchangeRates[toCurr]!;
    setState(() => converted = _formatter.format(result));
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> samplePrices = [
      {'item': 'Coffee', 'price': 400},
      {'item': 'Taxi (city center)', 'price': 1000},
      {'item': 'Souvenir', 'price': 1500},
    ];
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.all(16),
          children: [
            CurrencyRatesCard(
              currencies: currencies,
              exchangeRates: exchangeRates,
            ),
            SizedBox(height: 16),
            CurrencyConverterCard(
              currencies: currencies,
              fromCurr: fromCurr,
              toCurr: toCurr,
              amount: amount,
              converted: converted,
              onAmountChanged: (val) {
                amount = val;
                convert();
              },
              onFromChanged: (val) {
                fromCurr = val ?? 'VUV';
                convert();
              },
              onToChanged: (val) {
                toCurr = val ?? 'USD';
                convert();
              },
            ),
            SizedBox(height: 16),
            SectionHeader('Where to Exchange Money'),
            ExchangeMapCard(locations: exchangeLocations),
            SizedBox(height: 16),
            ...exchangeLocations
                .map((loc) => ExchangeLocationCard(loc: loc))
                .toList(),
            SizedBox(height: 16),
            SectionHeader('Sample Prices (Estimated)'),
            SamplePricesCard(
              samplePrices: samplePrices,
              exchangeRates: exchangeRates,
            ),
            SizedBox(height: 16),
            SectionHeader('Useful Tips'),
            TipsCard(),
          ],
        ),
      ),
    );
  }
}

class SectionHeader extends StatelessWidget {
  final String title;
  const SectionHeader(this.title);
  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.symmetric(vertical: 8),
    child: Text(
      title,
      style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 18),
    ),
  );
}

class CurrencyRatesCard extends StatelessWidget {
  final List<Map<String, String>> currencies;
  final Map<String, double> exchangeRates;
  const CurrencyRatesCard({
    required this.currencies,
    required this.exchangeRates,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 3,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Current Exchange Rates',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            SizedBox(height: 4),
            Text(
              'Rates as of today (reference only)',
              style: TextStyle(color: Colors.grey),
            ),
            SizedBox(height: 12),
            Table(
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              columnWidths: {0: FixedColumnWidth(50)},
              children: [
                TableRow(
                  children: [
                    _tableHeader('Code'),
                    _tableHeader('1 VUV = ?'),
                    _tableHeader('1 = ? VUV'),
                  ],
                ),
                ...currencies.map((c) {
                  String code = c['code']!;
                  double rate = exchangeRates[code]!;
                  return TableRow(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(8),
                        child: Text(
                          code,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8),
                        child: Text(rate.toString()),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8),
                        child: Text(
                          rate != 0 ? (1 / rate).toStringAsFixed(2) : '-',
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _tableHeader(String label) => Padding(
    padding: EdgeInsets.all(8),
    child: Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
  );
}

class CurrencyConverterCard extends StatelessWidget {
  final List<Map<String, String>> currencies;
  final String fromCurr;
  final String toCurr;
  final String amount;
  final String converted;
  final Function(String) onAmountChanged;
  final Function(String?) onFromChanged;
  final Function(String?) onToChanged;
  const CurrencyConverterCard({
    required this.currencies,
    required this.fromCurr,
    required this.toCurr,
    required this.amount,
    required this.converted,
    required this.onAmountChanged,
    required this.onFromChanged,
    required this.onToChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 3,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Currency Converter',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: 'Amount',
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                    keyboardType: TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    onChanged: onAmountChanged,
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  flex: 2,
                  child: DropdownButtonFormField<String>(
                    value: fromCurr,
                    items:
                        currencies
                            .map(
                              (c) => DropdownMenuItem(
                                child: Text(c['code']!),
                                value: c['code'],
                              ),
                            )
                            .toList(),
                    onChanged: onFromChanged,
                    decoration: InputDecoration(
                      labelText: 'From',
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Text('='),
                SizedBox(width: 8),
                Expanded(
                  flex: 2,
                  child: Text(
                    converted,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color:
                          converted == 'Enter a valid number'
                              ? Colors.red
                              : Colors.black,
                    ),
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  flex: 2,
                  child: DropdownButtonFormField<String>(
                    value: toCurr,
                    items:
                        currencies
                            .map(
                              (c) => DropdownMenuItem(
                                child: Text(c['code']!),
                                value: c['code'],
                              ),
                            )
                            .toList(),
                    onChanged: onToChanged,
                    decoration: InputDecoration(
                      labelText: 'To',
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ExchangeLocationCard extends StatelessWidget {
  final MoneyExchangeLocation loc;
  const ExchangeLocationCard({required this.loc});
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      child: ListTile(
        leading: Icon(Icons.location_on_outlined, color: Colors.blue),
        title: Text(
          loc.name,
          style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
        ),
        subtitle: Text(
          '${loc.address}\n${loc.note}',
          style: GoogleFonts.poppins(fontSize: 13),
        ),
        isThreeLine: true,
      ),
    );
  }
}

class SamplePricesCard extends StatelessWidget {
  final List<Map<String, dynamic>> samplePrices;
  final Map<String, double> exchangeRates;
  const SamplePricesCard({
    required this.samplePrices,
    required this.exchangeRates,
  });
  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat('#,##0.00');
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children:
              samplePrices
                  .map(
                    (item) => Padding(
                      padding: EdgeInsets.symmetric(vertical: 3),
                      child: Row(
                        children: [
                          Icon(Icons.label_important_outline, size: 16),
                          SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              '${item['item']}: ${item['price']} VUV'
                              ' (≈${formatter.format(item['price'] * exchangeRates['USD']!)} USD)',
                              style: GoogleFonts.poppins(fontSize: 13),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                  .toList(),
        ),
      ),
    );
  }
}

class TipsCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final tips = [
      'Vanuatu Vatu (VUV) is the official currency.',
      'AUD is widely accepted in tourist areas.',
      'ATMs are reliable in Port Vila and accept major cards.',
      'Avoid exchanging money outside official outlets.',
      'Check for hidden fees or poor rates.',
    ];
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      color: Colors.yellow[50],
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children:
              tips
                  .map(
                    (tip) => Padding(
                      padding: EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        children: [
                          Icon(
                            Icons.check_circle_outline,
                            size: 16,
                            color: Colors.orange,
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              tip,
                              style: GoogleFonts.poppins(fontSize: 13),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                  .toList(),
        ),
      ),
    );
  }
}
