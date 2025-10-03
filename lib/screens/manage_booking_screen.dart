import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'payment_selection_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';

class ManageBookingScreen extends StatelessWidget {
  final String bookingId;
  final Map bookingData;

  const ManageBookingScreen({
    Key? key,
    required this.bookingId,
    required this.bookingData,
  }) : super(key: key);

  String getFormattedStatus(String status) {
    if (status.isEmpty) return '';
    return status
        .replaceAll('_', ' ')
        .split(' ')
        .map((w) => w.isNotEmpty ? w[0].toUpperCase() + w.substring(1) : '')
        .join(' ');
  }

  void _showEditBookingDialog(BuildContext context) {
    DateTime curDate =
        bookingData['date'] is Timestamp
            ? (bookingData['date'] as Timestamp).toDate()
            : DateTime.now();
    int curTickets = int.tryParse(bookingData['tickets'].toString()) ?? 1;
    String curPackage = bookingData['package_name'] ?? '';
    final pkgController = TextEditingController(text: curPackage);

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder:
              (context, setState) => AlertDialog(
                title: Text(
                  'Modify Booking',
                  style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                ),
                content: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                        leading: Icon(Icons.date_range),
                        title: Text(
                          'Date: ${DateFormat('dd-MM-yyyy').format(curDate)}',
                        ),
                        onTap: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: curDate,
                            firstDate: DateTime.now(),
                            lastDate: DateTime.now().add(Duration(days: 365)),
                          );
                          if (picked != null) setState(() => curDate = picked);
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.confirmation_number),
                        title: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.remove),
                              onPressed:
                                  curTickets > 1
                                      ? () => setState(() => curTickets--)
                                      : null,
                            ),
                            Text('$curTickets'),
                            IconButton(
                              icon: Icon(Icons.add),
                              onPressed: () => setState(() => curTickets++),
                            ),
                          ],
                        ),
                      ),
                      TextField(
                        decoration: InputDecoration(labelText: 'Package Name'),
                        controller: pkgController,
                      ),
                    ],
                  ),
                ),
                actions: [
                  TextButton(
                    child: Text('Cancel', style: GoogleFonts.poppins()),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                    ),
                    child: Text(
                      'Save',
                      style: GoogleFonts.poppins(color: Colors.white),
                    ),
                    onPressed: () async {
                      await FirebaseFirestore.instance
                          .collection('bookings')
                          .doc(bookingId)
                          .update({
                            'date': Timestamp.fromDate(curDate),
                            'tickets': curTickets,
                            'package_name': pkgController.text,
                          });
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Booking updated!',
                            style: GoogleFonts.poppins(),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
        );
      },
    );
  }

  void _cancelBooking(BuildContext context) async {
    await FirebaseFirestore.instance
        .collection('bookings')
        .doc(bookingId)
        .update({'status': 'canceled'});
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Booking canceled!', style: GoogleFonts.poppins()),
      ),
    );
    Navigator.of(context).pop();
  }

  void _deleteBooking(BuildContext context) async {
    await FirebaseFirestore.instance
        .collection('bookings')
        .doc(bookingId)
        .delete();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Booking deleted!', style: GoogleFonts.poppins())),
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    String status = bookingData['status'] ?? '';
    String title =
        bookingData['item_name'] ?? bookingData['attraction_name'] ?? '';
    String packageName = bookingData['package_name'] ?? '';
    String tickets = bookingData['tickets']?.toString() ?? 'N/A';
    String displayImageUrl =
        (bookingData['image_url'] != null &&
                bookingData['image_url'].toString().isNotEmpty &&
                bookingData['image_url'].toString().startsWith('http'))
            ? bookingData['image_url']
            : '';
    double totalPaid =
        (bookingData['total_paid'] is int)
            ? (bookingData['total_paid'] as int).toDouble()
            : (bookingData['total_paid'] is double)
            ? (bookingData['total_paid'] as double)
            : 0.0;
    DateTime? date =
        bookingData['date'] is Timestamp
            ? (bookingData['date'] as Timestamp).toDate()
            : null;
    double priceToPay =
        totalPaid > 0
            ? totalPaid
            : (bookingData['price'] is int)
            ? (bookingData['price'] as int).toDouble()
            : (bookingData['price'] is double)
            ? (bookingData['price'] as double)
            : 0.0;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Manage Booking",
          style: GoogleFonts.poppins(fontWeight: FontWeight.w500, fontSize: 16),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child:
                  displayImageUrl.isNotEmpty
                      ? CachedNetworkImage(
                        imageUrl: displayImageUrl,
                        width: 200,
                        height: 200,
                        fit: BoxFit.cover,
                        placeholder:
                            (context, url) => Container(
                              width: 200,
                              height: 200,
                              color: Colors.grey[300],
                              child: Icon(
                                Icons.image,
                                color: Colors.white70,
                                size: 26,
                              ),
                            ),
                        errorWidget:
                            (context, url, error) => Image.asset(
                              'assets/images/placeholder_bg.png',
                              width: 200,
                              height: 200,
                              fit: BoxFit.cover,
                            ),
                      )
                      : Image.asset(
                        (bookingData['image_url'] != null &&
                                bookingData['image_url'].toString().isNotEmpty)
                            ? bookingData['image_url']
                            : 'assets/images/placeholder_bg.png',
                        width: 200,
                        height: 200,
                        fit: BoxFit.cover,
                      ),
            ),
          ),
          SizedBox(height: 15),
          Text(
            title,
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          SizedBox(height: 5),
          Text(
            'Status: ${getFormattedStatus(status)}',
            style: GoogleFonts.poppins(),
          ),
          if (packageName.isNotEmpty)
            Text('Package: $packageName', style: GoogleFonts.poppins()),
          Text('Tickets: $tickets', style: GoogleFonts.poppins()),
          Text(
            'Total Paid: VT ${totalPaid.round()}',
            style: GoogleFonts.poppins(),
          ),
          Text(
            'Date: ${date != null ? date.toLocal().toString().split(' ')[0] : ''}',
            style: GoogleFonts.poppins(),
          ),
          SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: Icon(Icons.edit, color: Colors.blue),
                tooltip: 'Modify booking',
                onPressed: () => _showEditBookingDialog(context),
              ),
              if (status.toLowerCase() != 'canceled')
                IconButton(
                  icon: Icon(Icons.cancel, color: Colors.orange),
                  tooltip: 'Cancel booking',
                  onPressed: () => _cancelBooking(context),
                ),
              IconButton(
                icon: Icon(Icons.delete, color: Colors.red),
                tooltip: 'Delete booking',
                onPressed: () => _deleteBooking(context),
              ),
              if ((status ?? '').trim().toLowerCase().replaceAll(' ', '_') ==
                  'pending_payment')
                IconButton(
                  icon: Icon(Icons.payment, color: Colors.teal),
                  tooltip: 'Pay Now',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => PaymentSelectionScreen(
                              bookingId: bookingId,
                              totalAmount: priceToPay,
                              attractionName: title,
                              imageUrl: displayImageUrl,
                              date: date ?? DateTime.now(),
                              ticketCount: int.tryParse(tickets) ?? 1,
                              packageName: packageName,
                            ),
                      ),
                    );
                  },
                ),
            ],
          ),
        ],
      ),
    );
  }
}
