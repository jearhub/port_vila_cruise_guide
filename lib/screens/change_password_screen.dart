import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({Key? key}) : super(key: key);

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final currentPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool isSubmitting = false;
  String? error;
  String? success;

  @override
  void dispose() {
    currentPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleChangePassword() async {
    setState(() {
      isSubmitting = true;
      error = null;
      success = null;
    });
    final user = FirebaseAuth.instance.currentUser;
    if (user == null || user.email == null) {
      setState(() {
        error = "No authenticated user.";
        isSubmitting = false;
      });
      return;
    }
    try {
      // Re-authenticate
      final cred = EmailAuthProvider.credential(
        email: user.email!,
        password: currentPasswordController.text.trim(),
      );
      await user.reauthenticateWithCredential(cred);
      // Update password
      await user.updatePassword(newPasswordController.text.trim());
      setState(() {
        success = "Password updated successfully.";
      });
      // Optionally, pop after a delay to show success
      Future.delayed(const Duration(seconds: 1), () {
        Navigator.of(context).pop(true);
      });
    } on FirebaseAuthException catch (e) {
      setState(() {
        error = e.message ?? "Authentication error.";
      });
    } catch (e) {
      setState(() {
        error = "An unexpected error occurred.";
      });
    } finally {
      setState(() {
        isSubmitting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Change Password',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w500, fontSize: 16),
        ),
        // You can set background color or theme as needed
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 18),
        child: Form(
          key: _formKey,
          child: ListView(
            shrinkWrap: true,
            children: [
              if (error != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    error!,
                    style: const TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              if (success != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    success!,
                    style: const TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              TextFormField(
                controller: currentPasswordController,
                decoration: InputDecoration(
                  labelText: 'Current Password',
                  labelStyle: GoogleFonts.poppins(),
                  prefixIcon: Icon(Icons.lock_outline),
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
                validator:
                    (value) =>
                        (value == null || value.isEmpty)
                            ? 'Enter your current password'
                            : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: newPasswordController,
                decoration: InputDecoration(
                  labelText: 'New Password',
                  labelStyle: GoogleFonts.poppins(),
                  prefixIcon: Icon(Icons.lock),
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.length < 6) {
                    return 'Password must be at least 6 characters';
                  }
                  if (value == currentPasswordController.text) {
                    return 'New password must differ from current';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: confirmPasswordController,
                decoration: InputDecoration(
                  labelText: 'Confirm New Password',
                  labelStyle: GoogleFonts.poppins(),
                  prefixIcon: Icon(Icons.lock),
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
                validator:
                    (value) =>
                        value != newPasswordController.text
                            ? 'Passwords do not match'
                            : null,
              ),
              const SizedBox(height: 26),
              ElevatedButton(
                onPressed:
                    isSubmitting
                        ? null
                        : () {
                          if (_formKey.currentState?.validate() ?? false) {
                            _handleChangePassword();
                          }
                        },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  backgroundColor: Colors.teal,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child:
                    isSubmitting
                        ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                        : Text('Update Password', style: GoogleFonts.poppins()),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
