import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'booking_confirmation_screen.dart';

class PaymentSelectionScreen extends StatefulWidget {
  final String bookingId;
  final double totalAmount;
  final String attractionName;
  final String imageUrl;
  final DateTime date;
  final int ticketCount;
  final String? packageName;

  const PaymentSelectionScreen({
    Key? key,
    required this.bookingId,
    required this.totalAmount,
    required this.attractionName,
    required this.imageUrl,
    required this.date,
    required this.ticketCount,
    this.packageName,
  }) : super(key: key);

  @override
  State<PaymentSelectionScreen> createState() => _PaymentSelectionScreenState();
}

class _PaymentSelectionScreenState extends State<PaymentSelectionScreen> {
  bool _loading = false;

  Future _payWithStripe() async {
    setState(() => _loading = true);
    try {
      await FirebaseFirestore.instance
          .collection('bookings')
          .doc(widget.bookingId)
          .update({'status': 'confirmed', 'total_paid': widget.totalAmount});
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder:
              (context) => BookingConfirmationScreen(
                bookingId: widget.bookingId,
                attractionName: widget.attractionName,
                imageUrl: widget.imageUrl,
                date: widget.date,
                ticketCount: widget.ticketCount,
                totalPaid: widget.totalAmount,
                packageName: widget.packageName,
              ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Payment failed: $e')));
    } finally {
      setState(() => _loading = false);
    }
  }

  Future _payLater() async {
    setState(() => _loading = true);
    try {
      await FirebaseFirestore.instance
          .collection('bookings')
          .doc(widget.bookingId)
          .update({'status': 'pending_payment', 'total_paid': 0});
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder:
              (context) => BookingConfirmationScreen(
                bookingId: widget.bookingId,
                attractionName: widget.attractionName,
                imageUrl: widget.imageUrl,
                date: widget.date,
                ticketCount: widget.ticketCount,
                totalPaid: 0,
                packageName: widget.packageName,
              ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Could not update booking: $e')));
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Choose Payment',
          style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500),
        ),
      ),
      body:
          _loading
              ? Center(child: CircularProgressIndicator())
              : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ListTile(
                    leading: Icon(Icons.credit_card, color: Colors.teal),
                    title: Text(
                      'Pay Now (Stripe)',
                      style: GoogleFonts.poppins(),
                    ),
                    subtitle: Text(
                      'Amount: VT ${widget.totalAmount}',
                      style: GoogleFonts.poppins(),
                    ),
                    onTap: _payWithStripe,
                  ),
                  ListTile(
                    leading: Icon(Icons.schedule, color: Colors.orange),
                    title: Text('Pay Later', style: GoogleFonts.poppins()),
                    subtitle: Text(
                      'Reserve booking, pay later.',
                      style: GoogleFonts.poppins(),
                    ),
                    onTap: _payLater,
                  ),
                ],
              ),
    );
  }
}
