import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';

import 'settings_screen.dart';
import 'edit_profile_screen.dart';
import 'change_password_screen.dart';

class ProfileScreen extends StatelessWidget {
  final Function(int)? onTabSwitch;
  const ProfileScreen({Key? key, this.onTabSwitch}) : super(key: key);

  Future _confirmLogout(BuildContext context) async {
    final shouldLogout = await showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(
              'Log Out',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w500,
                fontSize: 16,
              ),
            ),
            content: Text(
              'Are you sure you want to log out from VilaCruise?',
              style: GoogleFonts.poppins(),
            ),
            actions: [
              TextButton(
                child: Text('Cancel', style: GoogleFonts.poppins()),
                onPressed: () => Navigator.of(context).pop(false),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: Text(
                  'Log Out',
                  style: GoogleFonts.poppins(color: Colors.white),
                ),
                onPressed: () => Navigator.of(context).pop(true),
              ),
            ],
          ),
    );
    if (shouldLogout == true) {
      await FirebaseAuth.instance.signOut();
      Navigator.pushNamedAndRemoveUntil(context, '/auth', (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return WillPopScope(
      onWillPop: () async {
        if (onTabSwitch != null) {
          onTabSwitch!(0); // Switch to home tab
          return false;
        }
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              if (onTabSwitch != null) {
                onTabSwitch!(0);
              } else {
                Navigator.of(context).pushReplacementNamed('/main');
              }
            },
          ),
          title: Text(
            'Profile',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w500,
              fontSize: 16,
            ),
          ),
        ),
        body: ListView(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 12),
          children: [
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundImage:
                        user?.photoURL != null
                            ? NetworkImage(user!.photoURL!)
                            : null,
                    child:
                        user?.photoURL == null
                            ? Text(
                              user?.displayName != null &&
                                      user!.displayName!.isNotEmpty
                                  ? user.displayName![0]
                                  : 'U',
                              style: const TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                            : null,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    user?.displayName ?? 'Anonymous User',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      fontFamily: GoogleFonts.poppins().fontFamily,
                    ),
                  ),
                  Text(
                    user?.email ?? '',
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
            const Divider(),
            Container(
              margin: const EdgeInsets.only(bottom: 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    leading: const Icon(Icons.edit),
                    title: Text("Edit Profile", style: GoogleFonts.poppins()),
                    subtitle: Text(
                      "Update your name, email, or system contact details.",
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        color: Colors.grey[700],
                      ),
                    ),
                    onTap: () async {
                      final updated = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const EditProfileScreen(),
                        ),
                      );
                      if (updated == true) {
                        // Optionally refresh UI
                      }
                    },
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    leading: const Icon(Icons.lock),
                    title: Text(
                      "Change Password",
                      style: GoogleFonts.poppins(),
                    ),
                    subtitle: Text(
                      "Set a new password for your VilaCruise account.",
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        color: Colors.grey[700],
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ChangePasswordScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    leading: Icon(Icons.settings),
                    title: Text("Settings", style: GoogleFonts.poppins()),
                    subtitle: Text(
                      "App preferences, notifications, and privacy settings.",
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        color: Colors.grey[700],
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SettingsScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    leading: const Icon(
                      Icons.receipt_long,
                      //color: Colors.teal,
                    ),
                    title: Text(
                      "My Bookings",
                      style: GoogleFonts.poppins(fontSize: 16),
                    ),
                    subtitle: Text(
                      "View and manage bookings and reservations.",
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        color: Colors.grey[700],
                      ),
                    ),
                    onTap: () {
                      if (user != null) {
                        Navigator.pushNamed(
                          context,
                          '/user_bookings',
                          arguments: {'userId': user.uid},
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              "Please log in to access your bookings.",
                              style: GoogleFonts.poppins(),
                            ),
                            action: SnackBarAction(
                              label: 'Sign In',
                              textColor: Colors.teal,
                              onPressed: () {
                                Navigator.pushNamed(context, '/auth');
                              },
                            ),
                            duration: const Duration(seconds: 7),
                          ),
                        );
                      }
                    },
                  ),
                  ListTile(
                    leading: const Icon(
                      Icons.discount,
                      //color: Colors.amber,
                    ),
                    title: Text(
                      "My Saved Deals",
                      style: GoogleFonts.poppins(fontSize: 16),
                    ),
                    subtitle: Text(
                      "View all deals you've grabbed.",
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        color: Colors.grey[700],
                      ),
                    ),
                    onTap: () {
                      if (user != null) {
                        Navigator.pushNamed(context, '/myDeals');
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              "Please log in to access your bookings.",
                              style: GoogleFonts.poppins(),
                            ),
                            action: SnackBarAction(
                              label: 'Sign In',
                              textColor: Colors.teal,
                              onPressed: () {
                                Navigator.pushNamed(context, '/auth');
                              },
                            ),
                            duration: const Duration(seconds: 7),
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: Text(
                'Log Out',
                style: GoogleFonts.poppins(color: Colors.red, fontSize: 14),
              ),
              onTap: () => _confirmLogout(context),
            ),
          ],
        ),
        floatingActionButton:
            user != null
                ? FloatingActionButton.extended(
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  icon: Icon(Icons.receipt_long_rounded, color: Colors.teal),
                  label: Text(
                    "Bookings",
                    style: GoogleFonts.poppins(
                      color: Colors.teal,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      '/user_bookings',
                      arguments: {'userId': user.uid},
                    );
                  },
                )
                : null,
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      ),
    );
  }
}
