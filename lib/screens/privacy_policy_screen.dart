import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

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
          'Privacy Policy',
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
                "Privacy Policy \n(VilaCruise App)",
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
                "VilaCruise (\"we,\" \"our,\" or \"us\") values your privacy. This Privacy Policy explains how we collect, use, and protect your information when you use the VilaCruise mobile application.",
                style: GoogleFonts.poppins(),
              ),
              const SizedBox(height: 16),

              Text(
                "Information We Collect",
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w500,
                  fontSize: 18,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  bullet(
                    "Personal Information: When you sign in or create an account, we may collect information such as your name, email, phone number, or Google/Apple login details.",
                  ),
                  bullet(
                    "Location Information: With your permission, we may collect your device’s location to provide maps, nearby attractions, and navigation services.",
                  ),
                  bullet(
                    "Usage Data: We collect anonymous data about how you use the app (e.g., pages visited, buttons clicked) to improve our services.",
                  ),
                  bullet(
                    "Third-Party Data: We may integrate services like Google Maps, Firebase, or Stripe/PayPal for payments. These providers follow their own privacy terms.",
                  ),
                ],
              ),
              const SizedBox(height: 16),

              Text(
                "How We Use Your Information",
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w500,
                  fontSize: 18,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  bullet(
                    "To personalize your app experience and show relevant cruise activities.",
                  ),
                  bullet(
                    "To provide navigation, location-based suggestions, and travel recommendations.",
                  ),
                  bullet(
                    "To process payments and transactions (when applicable).",
                  ),
                  bullet("To improve our app features and fix bugs."),
                  bullet(
                    "To communicate with you about updates, offers, and support.",
                  ),
                ],
              ),
              const SizedBox(height: 16),

              Text(
                "Data Sharing",
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w500,
                  fontSize: 18,
                ),
              ),
              Text(
                "We do not sell your data. We may share information with:",
                style: GoogleFonts.poppins(),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  bullet(
                    "Service Providers: Google Maps, Firebase, Stripe, PayPal, etc., strictly to provide core features.",
                  ),
                  bullet(
                    "Legal Requirements: If required by law, we may disclose your information.",
                  ),
                ],
              ),
              const SizedBox(height: 16),

              Text(
                "Data Security",
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w500,
                  fontSize: 18,
                ),
              ),
              Text(
                "We use industry-standard practices to protect your personal and payment data. However, no system is fully secure, and you use the app at your own risk.",
                style: GoogleFonts.poppins(),
              ),
              const SizedBox(height: 16),

              Text(
                "Your Rights",
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w500,
                  fontSize: 18,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  bullet(
                    "You may request to view, update, or delete your personal information.",
                  ),
                  bullet(
                    "You may disable location services any time in your device settings.",
                  ),
                  bullet("You may unsubscribe from promotional emails."),
                ],
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
                "For questions about this Privacy Policy, contact us at:\nsupport@vilacruise.com",
                style: GoogleFonts.poppins(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
