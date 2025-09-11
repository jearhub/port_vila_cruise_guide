import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../models/tour.dart';
import '../models/package.dart';

class TourBookingScreen extends StatefulWidget {
  final Tour tour;
  const TourBookingScreen({Key? key, required this.tour}) : super(key: key);

  @override
  State<TourBookingScreen> createState() => _TourBookingScreenState();
}

class _TourBookingScreenState extends State<TourBookingScreen> {
  DateTime selectedDate = DateTime.now();
  int ticketCount = 1;
  Package? selectedPackage;

  double get _pricePerTicket {
    // Remove currency symbols (₹, $, etc.)
    final cleaned = widget.tour.entryFee.replaceAll(RegExp(r'[^\d.]'), '');
    return double.tryParse(cleaned) ?? 0.0;
  }

  double get _packagePrice {
    if (selectedPackage == null) return 0.0;
    final cleaned = selectedPackage!.price.replaceAll(RegExp(r'[^\d.]'), '');
    return double.tryParse(cleaned) ?? 0.0;
  }

  int get _totalTickets {
    return selectedPackage?.ticketsIncluded ?? ticketCount;
  }

  double get _totalPrice {
    if (selectedPackage != null) {
      return _packagePrice;
    }
    return _pricePerTicket * ticketCount;
  }

  Future<void> _pickDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
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

  final NumberFormat _currencyFormat = NumberFormat.currency(
    locale: 'en_IN',
    symbol: 'VT ',
    decimalDigits: 0,
  );

  @override
  Widget build(BuildContext context) {
    final hasPackages =
        widget.tour.packages != null && widget.tour.packages!.isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Book ${widget.tour.name}',
          style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // DATE PICKER
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

              // PACKAGE SELECTOR
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
                          widget.tour.packages!.map<
                            DropdownMenuItem<Package>
                          >((pkg) {
                            return DropdownMenuItem<Package>(
                              value: pkg,
                              child: Text(
                                '${pkg.name} - ${pkg.price} (${pkg.ticketsIncluded} tickets)',
                              ),
                            );
                          }).toList(),
                      onChanged: (pkg) {
                        setState(() {
                          selectedPackage = pkg;
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

              // TICKET SELECTOR (if not booking package)
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

              // TOTAL
              Text(
                'Total: ${_currencyFormat.format(_totalPrice)}',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 18),

              // CONFIRM BOOKING
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
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder:
                          (_) => AlertDialog(
                            title: Text(
                              'Booking Confirmed',
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            content: Text(
                              selectedPackage != null
                                  ? 'You booked the ${selectedPackage!.name} package for ${widget.tour.name} on ${DateFormat('yyyy-MM-dd').format(selectedDate)}.\nTotal paid: ${_currencyFormat.format(_totalPrice)}'
                                  : 'You booked $ticketCount tickets for ${widget.tour.name} on ${DateFormat('yyyy-MM-dd').format(selectedDate)}.\nTotal paid: ${_currencyFormat.format(_totalPrice)}',
                              style: GoogleFonts.poppins(),
                            ),
                            actions: [
                              TextButton(
                                onPressed:
                                    () => Navigator.popUntil(
                                      context,
                                      (route) => route.isFirst,
                                    ),
                                child: const Text('OK'),
                              ),
                            ],
                          ),
                    );
                  },
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
