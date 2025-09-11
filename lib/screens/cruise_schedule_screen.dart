import 'package:VilaCruise/screens/ship_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';

class CruiseScheduleScreen extends StatelessWidget {
  const CruiseScheduleScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Port Vila Cruise Schedules',
          style: GoogleFonts.getFont(
            'Poppins',
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
        elevation: 2,
      ),
      body: StreamBuilder(
        stream:
            FirebaseFirestore.instance
                .collection('port_vila_cruise_schedule')
                .orderBy('date')
                .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No cruise schedules available.'));
          }

          final now = DateTime.now();
          final today = DateTime(now.year, now.month, now.day);
          final schedules =
              snapshot.data!.docs.where((doc) {
                final data = doc.data() as Map;
                try {
                  final arrivalDate = DateTime.parse(data['date'] ?? '');
                  return arrivalDate.isAtSameMomentAs(today) ||
                      arrivalDate.isAfter(today);
                } catch (_) {
                  return false;
                }
              }).toList();

          if (schedules.isEmpty) {
            return const Center(child: Text('No upcoming cruise schedules.'));
          }

          return ListView.builder(
            itemCount: schedules.length,
            itemBuilder: (context, index) {
              final data = schedules[index].data() as Map;
              final isNextShip = index == 0;
              String displayDate;
              try {
                final dt = DateTime.parse(data['date'] ?? '');
                displayDate =
                    '${dt.day.toString().padLeft(2, '0')}-${dt.month.toString().padLeft(2, '0')}-${dt.year}';
              } catch (_) {
                displayDate = data['date'] ?? '--';
              }

              final double imageWidth = isNextShip ? 110 : 100;
              final double imageHeight = isNextShip ? 160 : 140;

              return InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ShipDetailScreen(shipData: data),
                    ),
                  );
                },
                child: SizedBox(
                  height: imageHeight,
                  child: Card(
                    margin: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 18,
                    ),
                    elevation: isNextShip ? 9 : 1,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side:
                          isNextShip
                              ? const BorderSide(color: Colors.teal, width: 1)
                              : BorderSide.none,
                    ),
                    color: isNextShip ? Colors.teal[50] : Colors.white,
                    child: Row(
                      children: [
                        Stack(
                          children: [
                            ClipRRect(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(16),
                                bottomLeft: Radius.circular(16),
                              ),
                              child:
                                  (data['imageUrl'] != null &&
                                          (data['imageUrl'] as String)
                                              .isNotEmpty)
                                      ? CachedNetworkImage(
                                        imageUrl: data['imageUrl'],
                                        width: imageWidth,
                                        height: imageHeight,
                                        fit: BoxFit.cover,
                                        placeholder:
                                            (context, url) => Image.asset(
                                              'assets/images/placeholder_bg.png',
                                              width: imageWidth,
                                              height: imageHeight,
                                              fit: BoxFit.cover,
                                            ),
                                        errorWidget:
                                            (
                                              context,
                                              url,
                                              error,
                                            ) => Image.asset(
                                              'assets/images/placeholder_bg.png',
                                              width: imageWidth,
                                              height: imageHeight,
                                              fit: BoxFit.cover,
                                            ),
                                      )
                                      : Image.asset(
                                        'assets/images/placeholder_bg.png',
                                        width: imageWidth,
                                        height: imageHeight,
                                        fit: BoxFit.cover,
                                      ),
                            ),
                            if (isNextShip)
                              Positioned(
                                top: 8,
                                right: 8,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 3,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.orange,
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.15),
                                        blurRadius: 6,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Text(
                                    'Next Arrival',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                      fontFamily:
                                          GoogleFonts.poppins().fontFamily,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: isNextShip ? 18 : 10,
                              horizontal: 4,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Text(
                                  displayDate,
                                  style: TextStyle(
                                    fontSize: 15,
                                    color:
                                        isNextShip
                                            ? Colors.teal
                                            : Colors.teal[700],
                                    fontWeight: FontWeight.bold,
                                    fontFamily:
                                        GoogleFonts.poppins().fontFamily,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  data['shipName'] ?? 'Unknown Ship',
                                  style: TextStyle(
                                    fontSize: isNextShip ? 19 : 17,
                                    fontWeight: FontWeight.bold,
                                    fontFamily:
                                        GoogleFonts.poppins().fontFamily,
                                    color: Colors.black87,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  data['cruiseLine'] ??
                                      'Cruise Line unavailable',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[700],
                                    fontFamily:
                                        GoogleFonts.poppins().fontFamily,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'Arrives: ${data['arrivalTime'] ?? '--'}   Departs: ${data['departureTime'] ?? '--'}',
                                  style: TextStyle(
                                    fontFamily:
                                        GoogleFonts.poppins().fontFamily,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black87,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
