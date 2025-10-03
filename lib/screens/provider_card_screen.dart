import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class ProviderCard extends StatelessWidget {
  final Map<String, dynamic> provider;
  const ProviderCard({Key? key, required this.provider}) : super(key: key);

  void _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  @override
  Widget build(BuildContext context) {
    final price = provider['price'] ?? '';
    final websiteUrl = provider['websiteUrl'] ?? '';

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    provider['title'] ?? '',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                if (provider['imageUrl'] != null &&
                    provider['imageUrl'].toString().isNotEmpty)
                  Container(
                    width: 48,
                    height: 48,
                    margin: const EdgeInsets.only(left: 12),
                    child:
                        provider['imageUrl'].startsWith('http')
                            ? Image.network(
                              provider['imageUrl'],
                              fit: BoxFit.contain,
                            )
                            : Image.asset(
                              provider['imageUrl'],
                              fit: BoxFit.contain,
                            ),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            if (provider['services'] != null)
              Text(
                (provider['services'] as List<dynamic>).join(', '),
                style: GoogleFonts.poppins(fontSize: 14),
              ),
            if (provider['locations'] != null)
              Text(
                'Locations: ${provider['locations']}',
                style: GoogleFonts.poppins(fontSize: 12),
              ),
            if (provider['specialOffers'] != null &&
                provider['specialOffers'].toString().isNotEmpty)
              Text(
                'Special Offer: ${provider['specialOffers']}',
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: Colors.green[700],
                ),
              ),
            if (provider['network'] != null)
              Text(
                'Network: ${provider['network']}',
                style: GoogleFonts.poppins(fontSize: 12),
              ),
            if (provider['contact'] != null)
              Text(
                'Contact: ${provider['contact']}',
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: Colors.blueGrey,
                ),
              ),
            const SizedBox(height: 20),
            Row(
              children: [
                Text(
                  price.isNotEmpty ? "From: $price" : "Price: N/A",
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed:
                      websiteUrl.isNotEmpty
                          ? () => _launchUrl(websiteUrl)
                          : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                  ),
                  child: Text(
                    'Book Now',
                    style: GoogleFonts.poppins(color: Colors.white),
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

class ProviderCardScreen extends StatelessWidget {
  const ProviderCardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Recommended Providers',
          style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: StreamBuilder<QuerySnapshot>(
          stream:
              FirebaseFirestore.instance
                  .collection('providers')
                  .orderBy('title')
                  .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Center(
                child: Text(
                  'No provider data available.',
                  style: GoogleFonts.poppins(),
                ),
              );
            }
            final providers =
                snapshot.data!.docs
                    .map((doc) => doc.data() as Map<String, dynamic>)
                    .toList();
            return ListView.builder(
              itemCount: providers.length,
              itemBuilder:
                  (context, idx) => ProviderCard(provider: providers[idx]),
            );
          },
        ),
      ),
    );
  }
}
