import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';

class UserBookingsScreen extends StatelessWidget {
  final String userId;

  const UserBookingsScreen({Key? key, required this.userId}) : super(key: key);

  Color statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'confirmed':
        return Colors.green.shade600;
      case 'canceled':
        return Colors.red.shade400;
      default:
        return Colors.grey.shade600;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "My Bookings",
          style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream:
            FirebaseFirestore.instance
                .collection('bookings')
                .where('user_id', isEqualTo: userId)
                .orderBy('date', descending: true)
                .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text('No bookings found.', style: GoogleFonts.poppins()),
            );
          }

          return ListView(
            padding: const EdgeInsets.all(12.0),
            children:
                snapshot.data!.docs.map((doc) {
                  var data = Map<String, dynamic>.from(doc.data() as Map);

                  String status = data['status'] ?? 'Booked';
                  String title = data['attraction_name'] ?? '';
                  DateTime? date =
                      data['date'] is Timestamp
                          ? (data['date'] as Timestamp).toDate()
                          : null;
                  String formattedDate =
                      date != null ? DateFormat('EEE, MMM d').format(date) : '';
                  String subtitle =
                      status.toLowerCase() == 'booked'
                          ? 'Check in on $formattedDate'
                          : 'Activity on $formattedDate';

                  String packageName = data['package_name'] ?? '';
                  String tickets = data['tickets']?.toString() ?? 'N/A';
                  String itinerary = doc.id;
                  String totalPaid =
                      data['total_paid']?.round().toString() ?? '';

                  // Either show image from Firestore or asset fallback
                  return FutureBuilder<QuerySnapshot>(
                    future:
                        FirebaseFirestore.instance
                            .collection('attractions')
                            .where('name', isEqualTo: title)
                            .limit(1)
                            .get(),
                    builder: (context, snap) {
                      String displayImageUrl = '';
                      if (snap.hasData && snap.data!.docs.isNotEmpty) {
                        var attractionData =
                            snap.data!.docs.first.data()
                                as Map<String, dynamic>;
                        displayImageUrl = attractionData['image_url'] ?? '';
                      }
                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                        elevation: 2,
                        margin: const EdgeInsets.only(bottom: 14),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child:
                                    (data['image_url']?.startsWith('http') ??
                                            false)
                                        ? CachedNetworkImage(
                                          imageUrl: data['image_url'],
                                          width: 54,
                                          height: 54,
                                          fit: BoxFit.cover,
                                          placeholder:
                                              (context, url) => Container(
                                                width: 54,
                                                height: 54,
                                                color: Colors.grey[300],
                                                child: Icon(
                                                  Icons.image,
                                                  color: Colors.white70,
                                                  size: 26,
                                                ),
                                              ),
                                          errorWidget:
                                              (
                                                context,
                                                url,
                                                error,
                                              ) => Image.asset(
                                                'assets/images/placeholder_bg.png',
                                                width: 54,
                                                height: 54,
                                                fit: BoxFit.cover,
                                              ),
                                        )
                                        : Image.asset(
                                          data['image_url']?.isNotEmpty == true
                                              ? data['image_url']
                                              : 'assets/images/placeholder_bg.png',
                                          width: 54,
                                          height: 54,
                                          fit: BoxFit.cover,
                                        ),
                              ),

                              SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 2,
                                          ),
                                          decoration: BoxDecoration(
                                            color: statusColor(
                                              status,
                                            ).withOpacity(0.15),
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                          child: Text(
                                            status,
                                            style: GoogleFonts.poppins(
                                              color: statusColor(status),
                                              fontWeight: FontWeight.w500,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      title,
                                      style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Text(
                                      subtitle,
                                      style: GoogleFonts.poppins(
                                        fontSize: 13,
                                        color: Colors.grey.shade700,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    if (packageName.isNotEmpty)
                                      Text(
                                        'Package: $packageName',
                                        style: GoogleFonts.poppins(
                                          fontSize: 13,
                                          color: Colors.grey.shade600,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    Text(
                                      'Tickets: $tickets',
                                      style: GoogleFonts.poppins(
                                        fontSize: 12,
                                        color: Colors.grey.shade600,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Text(
                                      'Total Paid: VT $totalPaid',
                                      style: GoogleFonts.poppins(
                                        fontSize: 12,
                                        color: Colors.grey.shade600,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Text(
                                      'Itinerary: $itinerary',
                                      style: GoogleFonts.poppins(
                                        fontSize: 11,
                                        color: Colors.grey.shade500,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                  left: 8.0,
                                  top: 2.0,
                                ),
                                child: Icon(
                                  Icons.more_vert,
                                  size: 18,
                                  color: Colors.grey.shade500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }).toList(),
          );
        },
      ),
    );
  }
}
