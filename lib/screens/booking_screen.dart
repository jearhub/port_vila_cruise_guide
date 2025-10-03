import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/bookable_item.dart';
import '../models/package.dart';
import 'payment_selection_screen.dart';

class BookingScreen extends StatefulWidget {
  final BookableItem item;
  const BookingScreen({Key? key, required this.item}) : super(key: key);

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  DateTime selectedDate = DateTime.now();
  int ticketCount = 1;
  Package? selectedPackage;

  double get pricePerTicket {
    // Try fetching price first, fallback to entryFee if price is empty
    String priceString = widget.item.entryFee;
    if (priceString.isEmpty && (widget.item as dynamic).entryFee != null) {
      priceString = (widget.item as dynamic).entryFee;
    }
    final cleaned = priceString.replaceAll(RegExp(r'[^\d.]'), '');
    return double.tryParse(cleaned) ?? 0.0;
  }

  double get packagePrice {
    if (selectedPackage == null) return 0.0;
    final cleaned = selectedPackage!.price.replaceAll(RegExp(r'[^\d.]'), '');
    return double.tryParse(cleaned) ?? 0.0;
  }

  int get _totalTickets => selectedPackage?.ticketsIncluded ?? ticketCount;

  double get _totalPrice {
    // Always calculate based on latest selection.
    if (selectedPackage != null && selectedPackage!.price.isNotEmpty) {
      return packagePrice;
    }
    return pricePerTicket * ticketCount;
  }

  final NumberFormat _currencyFormat = NumberFormat.currency(
    locale: 'en_IN',
    symbol: 'VT ',
    decimalDigits: 0,
  );

  Future<void> _pickDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Future<void> _storeBookingAndConfirm() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Please log in to complete booking.',
            style: GoogleFonts.poppins(),
          ),
          action: SnackBarAction(
            label: 'Sign in',
            textColor: Colors.teal,
            onPressed: () => Navigator.pushNamed(context, '/auth'),
          ),
        ),
      );
      return;
    }

    final bookingRef = await FirebaseFirestore.instance
        .collection('bookings')
        .add({
          'user_id': user.uid,
          'item_name': widget.item.name,
          'image_url': widget.item.imageUrl,
          'date': Timestamp.fromDate(selectedDate),
          'tickets': _totalTickets,
          'package_name': selectedPackage?.name ?? '',
          'total_paid': 0,
          'price': _totalPrice,
          'status': 'pending_payment',
          'created_at': FieldValue.serverTimestamp(),
        });

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder:
            (_) => PaymentSelectionScreen(
              bookingId: bookingRef.id,
              totalAmount: _totalPrice, // Always use latest _totalPrice
              attractionName: widget.item.name,
              imageUrl: widget.item.imageUrl,
              date: selectedDate,
              ticketCount: _totalTickets,
              packageName: selectedPackage?.name,
            ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final hasPackages =
        widget.item.packages != null && widget.item.packages!.isNotEmpty;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Book ${widget.item.name}',
          style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Pick a Date',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 10),
              InkWell(
                onTap: () => _pickDate(context),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 14,
                    horizontal: 16,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.teal.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.calendar_today, color: Colors.teal.shade700),
                      const SizedBox(width: 12),
                      Text(
                        DateFormat('yyyy-MM-dd').format(selectedDate),
                        style: GoogleFonts.poppins(color: Colors.black87),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              if (hasPackages)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Select Package',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 10),
                    DropdownButton<Package>(
                      value: selectedPackage,
                      hint: Text('Choose a package'),
                      items:
                          widget.item.packages!
                              .map(
                                (pkg) => DropdownMenuItem<Package>(
                                  value: pkg,
                                  child: Text(
                                    '${pkg.name} - ${pkg.price} (${pkg.ticketsIncluded} tickets)',
                                  ),
                                ),
                              )
                              .toList(),
                      onChanged: (pkg) {
                        setState(() {
                          selectedPackage = pkg;
                          // Always update count according to package!
                          ticketCount = pkg?.ticketsIncluded ?? 1;
                        });
                      },
                    ),
                    if (selectedPackage != null)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Text(
                          selectedPackage!.description,
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: Colors.teal.shade700,
                          ),
                        ),
                      ),
                    const SizedBox(height: 24),
                  ],
                ),
              if (!hasPackages || selectedPackage == null)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Solo Travellers or additional Guests excluded from the package deals',
                      style: GoogleFonts.poppins(fontSize: 13),
                    ),
                    Text(
                      'Number of Tickets',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove_circle),
                          onPressed:
                              ticketCount > 1
                                  ? () => setState(() => ticketCount--)
                                  : null,
                          color: Colors.teal,
                        ),
                        Text(
                          '$ticketCount',
                          style: GoogleFonts.poppins(fontSize: 18),
                        ),
                        IconButton(
                          icon: const Icon(Icons.add_circle),
                          onPressed: () => setState(() => ticketCount++),
                          color: Colors.teal,
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              const Spacer(),
              Text(
                'Total: ${_currencyFormat.format(_totalPrice)}',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 18),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: _storeBookingAndConfirm,
                  child: Text(
                    'Confirm Booking',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
