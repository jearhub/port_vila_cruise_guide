import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'manage_booking_screen.dart';

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
      body: SafeArea(
        child: StreamBuilder(
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
                    var data = Map.from(doc.data() as Map);
                    String status = data['status'] ?? 'Booked';
                    String title =
                        data['item_name'] ?? data['attraction_name'] ?? '';
                    DateTime? date =
                        data['date'] is Timestamp
                            ? (data['date'] as Timestamp).toDate()
                            : null;
                    String formattedDate =
                        date != null
                            ? DateFormat('EEE, MMM d').format(date)
                            : '';
                    String subtitle =
                        status.toLowerCase() == 'booked'
                            ? 'Check in on $formattedDate'
                            : 'Activity on $formattedDate';
                    String packageName = data['package_name'] ?? '';
                    String tickets = data['tickets']?.toString() ?? 'N/A';
                    String itinerary = doc.id;
                    double totalPaid =
                        (data['total_paid'] is int)
                            ? (data['total_paid'] as int).toDouble()
                            : (data['total_paid'] is double)
                            ? (data['total_paid'] as double)
                            : 0.0;
                    String displayImageUrl =
                        (data['image_url'] != null &&
                                data['image_url'].toString().startsWith('http'))
                            ? data['image_url']
                            : '';

                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                      elevation: 2,
                      margin: const EdgeInsets.only(bottom: 14),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(18),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => ManageBookingScreen(
                                    bookingId: doc.id,
                                    bookingData: data,
                                  ),
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Expanded column for details ON THE LEFT
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Status + Tour Name (at top)
                                    Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 10,
                                            vertical: 3,
                                          ),
                                          decoration: BoxDecoration(
                                            color: statusColor(
                                              status,
                                            ).withOpacity(0.15),
                                            borderRadius: BorderRadius.circular(
                                              20,
                                            ),
                                          ),
                                          child: Text(
                                            status,
                                            style: GoogleFonts.poppins(
                                              color: statusColor(status),
                                              fontWeight: FontWeight.w600,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 6),
                                    Text(
                                      title,
                                      style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    SizedBox(height: 3),
                                    Text(
                                      subtitle,
                                      style: GoogleFonts.poppins(
                                        fontSize: 13,
                                        color: Colors.grey.shade700,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    // Stacked details under status and title
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
                                      'Total Paid: VT ${totalPaid.round()}',
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
                                    SizedBox(height: 7),
                                  ],
                                ),
                              ),
                              SizedBox(width: 10),
                              // IMAGE ON THE RIGHT
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child:
                                    displayImageUrl.isNotEmpty
                                        ? CachedNetworkImage(
                                          imageUrl: displayImageUrl,
                                          width: 100,
                                          height: 100,
                                          fit: BoxFit.cover,
                                          placeholder:
                                              (context, url) => Container(
                                                width: 100,
                                                height: 100,
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
                                                width: 100,
                                                height: 100,
                                                fit: BoxFit.cover,
                                              ),
                                        )
                                        : Image.asset(
                                          (data['image_url'] != null &&
                                                  data['image_url'].isNotEmpty)
                                              ? data['image_url']
                                              : 'assets/images/placeholder_bg.png',
                                          width: 100,
                                          height: 100,
                                          fit: BoxFit.cover,
                                        ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
            );
          },
        ),
      ),
    );
  }
}
