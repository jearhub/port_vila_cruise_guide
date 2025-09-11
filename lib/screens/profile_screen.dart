import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';

import 'settings_screen.dart';
import 'edit_profile_screen.dart';
import 'change_password_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

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

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pushReplacementNamed('/main');
          },
        ),
        title: Text(
          'Profile',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w500, fontSize: 16),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
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
                const SizedBox(height: 24),
              ],
            ),
          ),
          const Divider(),

          // Personalized Options
          ListTile(
            leading: const Icon(Icons.edit, color: Colors.blue),
            title: Text("Edit Profile", style: GoogleFonts.poppins()),
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
          ListTile(
            leading: const Icon(Icons.lock, color: Colors.orange),
            title: Text("Change Password", style: GoogleFonts.poppins()),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ChangePasswordScreen(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings, color: Colors.teal),
            title: Text("Settings", style: GoogleFonts.poppins()),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
          ),

          // --- ADD "My Bookings" Option ---
          ListTile(
            leading: const Icon(Icons.receipt_long, color: Colors.teal),
            title: Text(
              "My Bookings",
              style: GoogleFonts.poppins(fontSize: 16),
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
                    duration: Duration(seconds: 7),
                  ),
                );
              }
            },
          ),
          const Divider(),

          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: Text(
              'Log Out',
              style: GoogleFonts.poppins(color: Colors.red),
            ),
            onTap: () => _confirmLogout(context),
          ),
        ],
      ),

      // --- ADD FLOATING ACTION BUTTON FOR BOOKINGS TOO ---
      floatingActionButton:
          user != null
              ? FloatingActionButton.extended(
                backgroundColor: Colors.teal,
                icon: Icon(Icons.receipt_long, color: Colors.white),
                label: Text(
                  "My Bookings",
                  style: TextStyle(color: Colors.white),
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
    );
  }
}
