import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MoneyExchangeLocation {
  final String name;
  final String address;
  final double latitude;
  final double longitude;
  final String? type;
  final String? note;

  MoneyExchangeLocation({
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
    this.type,
    this.note,
  });

  factory MoneyExchangeLocation.fromFirestore(Map<String, dynamic> data) {
    return MoneyExchangeLocation(
      name: data['name'] ?? '',
      address: data['address'] ?? '',
      latitude: (data['latitude'] as num).toDouble(),
      longitude: (data['longitude'] as num).toDouble(),
      type: data['type'],
      note: data['note'],
    );
  }
}

Future<List<MoneyExchangeLocation>> fetchExchangeLocations() async {
  final snapshot =
      await FirebaseFirestore.instance
          .collection('money_exchange_location')
          .get();
  return snapshot.docs
      .map((doc) => MoneyExchangeLocation.fromFirestore(doc.data()))
      .toList();
}

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

  Map<String, double> exchangeRates = {};
  String fromCurr = 'VUV';
  String toCurr = 'AUD';
  String amount = '';
  String converted = '';
  final _formatter = NumberFormat('#,##0.00');

  @override
  void initState() {
    super.initState();
    fetchExchangeRates();
  }

  void convert() {
    double? amt = double.tryParse(amount);
    if (amt == null) {
      setState(
        () => converted = amount.isNotEmpty ? 'Enter a valid number' : '',
      );
      return;
    }
    if (exchangeRates.isEmpty ||
        !exchangeRates.containsKey(fromCurr) ||
        !exchangeRates.containsKey(toCurr)) {
      setState(() => converted = "Rates unavailable");
      return;
    }
    double vuvAmount =
        fromCurr == 'VUV' ? amt : amt / (exchangeRates[fromCurr] ?? 0.0);
    double result =
        toCurr == 'VUV'
            ? vuvAmount
            : vuvAmount * (exchangeRates[toCurr] ?? 1.0);
    setState(() => converted = _formatter.format(result));
  }

  Future<void> fetchExchangeRates() async {
    final doc =
        await FirebaseFirestore.instance
            .collection('exchange_rates')
            .doc('daily')
            .get();
    if (doc.exists) {
      final data = doc.data();
      if (data != null) {
        Map<String, double> fetchedRates = {};
        for (final entry in data.entries) {
          if (entry.key != 'last_updated') {
            fetchedRates[entry.key] =
                (entry.value is int)
                    ? entry.value.toDouble()
                    : (entry.value is double)
                    ? entry.value
                    : double.tryParse(entry.value.toString()) ?? 0.0;
          }
        }
        if (!exchangeRates.containsKey('VUV')) {
          exchangeRates['VUV'] = 1.0;
        }
        setState(() {
          exchangeRates = fetchedRates;
          convert();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> samplePrices = [
      {'item': 'Coffee', 'price': 400},
      {'item': 'Taxi (city center)', 'price': 1000},
      {'item': 'Souvenir', 'price': 1500},
      {'item': 'Meal (budget)', 'price': 2000},
      {'item': 'Water (1.5L)', 'price': 150},
    ];
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
              'Foreign Currency Exchange',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child:
            exchangeRates.isEmpty
                ? Center(child: CircularProgressIndicator())
                : ListView(
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
                        toCurr = val ?? 'AUD';
                        convert();
                      },
                    ),
                    SizedBox(height: 24),
                    Text(
                      'Sample Prices (Estimated)',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontFamily: GoogleFonts.poppins().fontFamily,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 12),
                    SamplePricesCard(
                      samplePrices: samplePrices,
                      exchangeRates: exchangeRates,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Useful Tips',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontFamily: GoogleFonts.poppins().fontFamily,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 12),
                    TipsCard(),
                    SizedBox(height: 16),
                    Text(
                      'Where to Exchange Money',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontFamily: GoogleFonts.poppins().fontFamily,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 12),
                    FutureBuilder<List<MoneyExchangeLocation>>(
                      future: fetchExchangeLocations(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Center(child: CircularProgressIndicator());
                        }
                        final locations = snapshot.data!;
                        return Column(
                          children: [
                            ExchangeMapCard(locations: locations),
                            ...locations
                                .map((loc) => ExchangeLocationCard(loc: loc))
                                .toList(),
                          ],
                        );
                      },
                    ),
                  ],
                ),
      ),
    );
  }
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
      elevation: 1,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Current Exchange Rates',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontFamily: GoogleFonts.poppins().fontFamily,
                fontSize: 16,
              ),
            ),
            SizedBox(height: 4),
            Text(
              'Rates as of today (reference only)',
              style: TextStyle(
                color: Colors.grey,
                fontFamily: GoogleFonts.poppins().fontFamily,
              ),
            ),
            SizedBox(height: 12),
            Table(
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              columnWidths: {0: FixedColumnWidth(50)},
              children: [
                TableRow(
                  children: [
                    Text(
                      'Code',
                      style: TextStyle(
                        fontFamily:
                            GoogleFonts.poppins(
                              fontWeight: FontWeight.bold,
                            ).fontFamily,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '1 VUV = ?',
                      style: TextStyle(
                        fontFamily:
                            GoogleFonts.poppins(
                              fontWeight: FontWeight.bold,
                            ).fontFamily,
                      ),
                    ),
                    Text(
                      '1 = ? VUV',
                      style: TextStyle(
                        fontFamily:
                            GoogleFonts.poppins(
                              fontWeight: FontWeight.bold,
                            ).fontFamily,
                      ),
                    ),
                  ],
                ),
                ...currencies.map((c) {
                  String code = c['code']!;
                  double rate = exchangeRates[code] ?? 1.0;
                  return TableRow(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(8),
                        child: Text(
                          code,
                          style: TextStyle(
                            fontFamily: GoogleFonts.poppins().fontFamily,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8),
                        child: Text(
                          rate.toString(),
                          style: TextStyle(
                            fontFamily: GoogleFonts.poppins().fontFamily,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8),
                        child: Text(
                          rate != 0 ? (1 / rate).toStringAsFixed(2) : '-',
                          style: TextStyle(
                            fontFamily: GoogleFonts.poppins().fontFamily,
                          ),
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
}

class CurrencyConverterCard extends StatelessWidget {
  final List<Map<String, String>> currencies;
  final String fromCurr;
  final String toCurr;
  final String amount;
  final String converted;
  final Function(String) onAmountChanged;
  final Function(String?)? onFromChanged;
  final Function(String?)? onToChanged;

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
      elevation: 1,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Currency Converter',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontFamily: GoogleFonts.poppins().fontFamily,
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
                      labelStyle: GoogleFonts.poppins(),
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
                              (c) => DropdownMenuItem<String>(
                                value: c['code'],
                                child: Text(
                                  c['code']!,
                                  style: TextStyle(
                                    fontFamily:
                                        GoogleFonts.poppins().fontFamily,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                    onChanged: onFromChanged,
                    decoration: InputDecoration(
                      labelText: 'From',
                      labelStyle: GoogleFonts.poppins(),
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
                      fontFamily: GoogleFonts.poppins().fontFamily,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color:
                          converted == "Enter a valid number"
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
                              (c) => DropdownMenuItem<String>(
                                value: c['code'],
                                child: Text(
                                  c['code']!,
                                  style: TextStyle(
                                    fontFamily:
                                        GoogleFonts.poppins().fontFamily,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                    onChanged: onToChanged,
                    decoration: InputDecoration(
                      labelText: 'To',
                      labelStyle: GoogleFonts.poppins(),
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
      elevation: 1,
      color: Colors.teal.shade50,
      child: Padding(
        padding: EdgeInsets.all(14),
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
                              ' (≈${formatter.format(item['price'] * exchangeRates['AUD']!)} AUD)',
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
      'AUD are sometimes accepted at tourist shops, but change is in Vatu.',
      'ATMs are reliable in Port Vila and accept major cards. ATMs dispense VUV only, but many larger shops, hotels and restaurants accept cards directly.',
      'Smaller vendors and rural areas may only accept cash.',
      'Exchange at banks, hotels, or licensed bureaux de changes.',
      'Check for hidden fees or poor rates.',
    ];
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 1,
      color: Colors.yellow[50],
      child: Padding(
        padding: EdgeInsets.all(14),
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
                              style: GoogleFonts.poppins(
                                fontSize: 13,
                                color: Colors.black87,
                              ),
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
                position: LatLng(loc.latitude, loc.longitude),
                infoWindow: InfoWindow(title: loc.name, snippet: loc.address),
              ),
            )
            .toSet();

    final CameraPosition initialCameraPosition = CameraPosition(
      target:
          locations.isNotEmpty
              ? LatLng(locations[0].latitude, locations[0].longitude)
              : LatLng(-17.7333, 168.3273),
      zoom: 13,
    );
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white, // wide white background
        border: Border.all(
          color: Colors.teal.shade100, // subtle border color
          width: 1.5,
        ),
        borderRadius: BorderRadius.circular(16), // rounded corners
        boxShadow: [
          BoxShadow(
            color: Colors.teal.shade50,
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: SizedBox(
        height: 250,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Opacity(
            opacity: 0.7,
            child: GoogleMap(
              initialCameraPosition: initialCameraPosition,
              markers: markers,
              mapType: MapType.normal,
              myLocationButtonEnabled: false,
              zoomControlsEnabled: true,
              onTap: (_) {
                // Add optional fullscreen map
              },
            ),
          ),
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
      elevation: 1,
      child: ListTile(
        leading: Icon(Icons.location_on_outlined, color: Colors.teal),
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
