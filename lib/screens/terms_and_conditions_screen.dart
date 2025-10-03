import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TermsAndConditionsScreen extends StatelessWidget {
  const TermsAndConditionsScreen({super.key});

  // Helper for bullet points
  Widget bullet(String text) => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text("• ", style: TextStyle(fontSize: 18, height: 1.45)),
      Expanded(child: Text(text, style: GoogleFonts.poppins())),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Terms & Conditions',
          style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Terms & Conditions (VilaCruise App)",
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  fontSize: 22,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Effective Date: 21-09-2025",
                style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 20),
              Text(
                "Welcome to VilaCruise. By using the VilaCruise mobile app, you agree to the following terms and conditions. Please read them carefully.",
                style: GoogleFonts.poppins(),
              ),
              const SizedBox(height: 16),

              Text(
                "Use of the App",
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w500,
                  fontSize: 18,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  bullet(
                    "VilaCruise provides travel guidance, cruise schedules, attractions, and related services for cruise visitors in Port Vila.",
                  ),
                  bullet("You agree to use the app for lawful purposes only."),
                  bullet(
                    "You must not misuse the app or attempt unauthorized access to our servers.",
                  ),
                ],
              ),
              const SizedBox(height: 16),

              Text(
                "Accounts",
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w500,
                  fontSize: 18,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  bullet(
                    "You may be required to create an account using email, phone, or social login.",
                  ),
                  bullet(
                    "You are responsible for keeping your login credentials secure.",
                  ),
                ],
              ),
              const SizedBox(height: 16),

              Text(
                "Payments",
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w500,
                  fontSize: 18,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  bullet(
                    "If you purchase paid services (e.g., eSIM cards, tickets, or guided tours), payments are processed securely via third-party providers (Stripe, PayPal).",
                  ),
                  bullet("VilaCruise does not store payment card details."),
                ],
              ),
              const SizedBox(height: 16),

              Text(
                "Location Services",
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w500,
                  fontSize: 18,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  bullet(
                    "By enabling location permissions, you allow VilaCruise to provide maps and nearby attraction recommendations.",
                  ),
                  bullet(
                    "You may disable location settings, but some features may not function correctly.",
                  ),
                ],
              ),
              const SizedBox(height: 16),

              Text(
                "Content and Intellectual Property",
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w500,
                  fontSize: 18,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  bullet(
                    "All content provided in the app (texts, maps, graphics, layouts) is owned by VilaCruise or its partners.",
                  ),
                  bullet(
                    "You may not copy, redistribute, or modify materials without prior written consent.",
                  ),
                ],
              ),
              const SizedBox(height: 16),

              Text(
                "Limitation of Liability",
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w500,
                  fontSize: 18,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  bullet(
                    "VilaCruise strives to provide accurate information, but we do not guarantee completeness or accuracy (e.g., cruise schedules, attraction opening hours).",
                  ),
                  bullet(
                    "VilaCruise is not liable for travel delays, cancellations, damages, or losses arising from use of the app.",
                  ),
                ],
              ),
              const SizedBox(height: 16),

              Text(
                "Termination",
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w500,
                  fontSize: 18,
                ),
              ),
              bullet(
                "We reserve the right to suspend or terminate your account if you violate these terms.",
              ),
              const SizedBox(height: 16),

              Text(
                "Changes to Terms",
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w500,
                  fontSize: 18,
                ),
              ),
              bullet(
                "We may update these Terms & Conditions at any time. Continued use of the app means you agree to the updated terms.",
              ),
              const SizedBox(height: 16),

              Text(
                "Governing Law",
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w500,
                  fontSize: 18,
                ),
              ),
              Text(
                "These terms are governed by the laws of Vanuatu.",
                style: GoogleFonts.poppins(),
              ),
              const SizedBox(height: 16),

              Text(
                "Contact Us",
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w500,
                  fontSize: 18,
                ),
              ),
              Text(
                "For questions regarding these Terms & Conditions, contact us at:\nsupport@vilacruise.com",
                style: GoogleFonts.poppins(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
