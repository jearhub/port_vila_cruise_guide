import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:google_fonts/google_fonts.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool isLogin = true;
  bool isSubmitting = false;
  String? error;
  String? verificationId;
  bool isPhoneOTPStep = false;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  String? selectedPhone;
  final otpController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _phoneFormKey = GlobalKey<FormState>();

  void setLoading(bool loading) {
    setState(() {
      isSubmitting = loading;
    });
  }

  void showError(String err) {
    setState(() {
      error = err;
    });
  }

  Future<void> handleAuth() async {
    setLoading(true);
    try {
      if (isLogin) {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );
      } else {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );
      }
      Navigator.pushReplacementNamed(context, '/main');
    } catch (e) {
      showError(e.toString());
    } finally {
      setLoading(false);
    }
  }

  Future<void> handleGoogleSignIn() async {
    setLoading(true);
    try {
      final googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return;
      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      await FirebaseAuth.instance.signInWithCredential(credential);
      Navigator.pushReplacementNamed(context, '/main');
    } catch (e) {
      showError(e.toString());
    } finally {
      setLoading(false);
    }
  }

  Future<void> handleAppleSignIn() async {
    setLoading(true);
    try {
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );
      final authCredential = OAuthProvider("apple.com").credential(
        idToken: appleCredential.identityToken,
        accessToken: appleCredential.authorizationCode,
      );
      await FirebaseAuth.instance.signInWithCredential(authCredential);
      Navigator.pushReplacementNamed(context, '/main');
    } catch (e) {
      showError(e.toString());
    } finally {
      setLoading(false);
    }
  }

  Future<void> startPhoneAuth() async {
    setLoading(true);
    setState(() {
      error = null;
      isPhoneOTPStep = false;
    });
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: selectedPhone ?? '',
      verificationCompleted: (credential) async {
        await FirebaseAuth.instance.signInWithCredential(credential);
        Navigator.pushReplacementNamed(context, '/main');
      },
      verificationFailed: (e) {
        showError(e.toString());
        setLoading(false);
      },
      codeSent: (verId, forceResend) {
        setState(() {
          verificationId = verId;
          isPhoneOTPStep = true;
          isSubmitting = false;
        });
      },
      codeAutoRetrievalTimeout: (verId) {
        setState(() {
          verificationId = verId;
          isSubmitting = false;
        });
      },
    );
  }

  Future<void> verifyOTP() async {
    setLoading(true);
    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: verificationId!,
        smsCode: otpController.text.trim(),
      );
      await FirebaseAuth.instance.signInWithCredential(credential);
      Navigator.pushReplacementNamed(context, '/main');
    } catch (e) {
      showError(e.toString());
    } finally {
      setLoading(false);
    }
  }

  Future<void> resetPassword() async {
    if (emailController.text.isNotEmpty) {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: emailController.text,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password reset email sent!')),
      );
    }
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Image.asset(
          'assets/images/port_vila_logo_trans.png',
          height: 36,
          width: 36,
        ),
        const SizedBox(width: 8),
        Text(
          'VilaCruise',
          style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        Text(
          isLogin ? 'Sign in to continue' : 'Create a new account',
          style: GoogleFonts.poppins(
            color: Colors.grey,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildEmailPasswordForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: emailController,
            decoration: InputDecoration(
              labelText: 'Email',
              labelStyle: GoogleFonts.poppins(),
              prefixIcon: Icon(Icons.email),
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.emailAddress,
            validator:
                (value) =>
                    value == null || value.isEmpty ? 'Enter your email' : null,
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: passwordController,
            decoration: InputDecoration(
              labelText: 'Password',
              labelStyle: GoogleFonts.poppins(),
              prefixIcon: const Icon(Icons.lock),
              border: const OutlineInputBorder(),
            ),
            obscureText: true,
            validator:
                (value) =>
                    value == null || value.length < 6
                        ? 'Password must be at least 6 characters'
                        : null,
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed:
                isSubmitting
                    ? null
                    : () {
                      if (_formKey.currentState?.validate() ?? false)
                        handleAuth();
                    },
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 50),
              backgroundColor: Colors.teal,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              isLogin ? 'Login' : 'Register',
              style: GoogleFonts.poppins(),
            ),
          ),
          if (isLogin)
            TextButton(
              onPressed: resetPassword,
              child: Text('Forgot password?', style: GoogleFonts.poppins()),
            ),
        ],
      ),
    );
  }

  Widget _buildDivider(String label) {
    return Row(
      children: [
        Expanded(child: Divider(thickness: 1, color: Colors.grey[400])),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(label, style: const TextStyle(color: Colors.grey)),
        ),
        Expanded(child: Divider(thickness: 1, color: Colors.grey[400])),
      ],
    );
  }

  Widget _buildSocialProviders() {
    return Column(
      children: [
        ElevatedButton.icon(
          icon: Image.asset('assets/icons/google_logo.png', height: 24),
          label: Text('Continue with Google', style: GoogleFonts.poppins()),
          onPressed: isSubmitting ? null : handleGoogleSignIn,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black87,
            side: const BorderSide(color: Colors.grey),
            minimumSize: const Size(double.infinity, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        if (Platform.isIOS)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: ElevatedButton.icon(
              icon: const Icon(Icons.apple),
              label: Text('Continue with Apple', style: GoogleFonts.poppins()),
              onPressed: isSubmitting ? null : handleAppleSignIn,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildPhoneAuthSection() {
    return !isPhoneOTPStep
        ? Form(
          key: _phoneFormKey,
          child: Column(
            children: [
              IntlPhoneField(
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                  labelStyle: GoogleFonts.poppins(),
                  border: const OutlineInputBorder(),
                ),
                initialCountryCode: 'VU', // Vanuatu
                onChanged: (phone) {
                  selectedPhone = phone.completeNumber;
                },
                validator:
                    (phone) =>
                        (phone == null || phone.completeNumber.length < 8)
                            ? 'Enter a valid phone number'
                            : null,
              ),
              const SizedBox(height: 10),
              ElevatedButton.icon(
                icon: const Icon(Icons.send, color: Colors.white),
                label: Text(
                  'Send OTP',
                  style: GoogleFonts.poppins(color: Colors.white),
                ),
                onPressed:
                    isSubmitting
                        ? null
                        : () {
                          if (_phoneFormKey.currentState?.validate() ?? false)
                            startPhoneAuth();
                        },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  backgroundColor: Colors.green.shade700,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
        )
        : Column(
          children: [
            TextFormField(
              controller: otpController,
              decoration: InputDecoration(
                labelText: 'Enter OTP',
                labelStyle: GoogleFonts.poppins(),
                prefixIcon: Icon(Icons.key),
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: isSubmitting ? null : verifyOTP,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green.shade700,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text('Verify OTP', style: GoogleFonts.poppins()),
            ),
            TextButton(
              onPressed:
                  () => setState(() {
                    isPhoneOTPStep = false;
                  }),
              child: const Text('Cancel'),
            ),
          ],
        );
  }

  Widget _buildSwitchMode() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          isLogin ? "Don't have an account?" : "Already registered?",
          style: GoogleFonts.poppins(),
        ),
        TextButton(
          onPressed:
              () => setState(() {
                isLogin = !isLogin;
                error = null;
                isPhoneOTPStep = false;
              }),
          child: Text(
            isLogin ? "Register" : "Login",
            style: GoogleFonts.poppins(),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Go to home when user presses system back
        Navigator.of(context).pushReplacementNamed('/main');
        return false; // prevent default navigation
      },
      child: Scaffold(
        //backgroundColor: const Color(0xFFF6F9FF),
        body: Stack(
          children: [
            Center(
              child: SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 34,
                  ),
                  /*decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    gradient: LinearGradient(
                      colors: [Colors.teal.shade50, Colors.white],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 16,
                        spreadRadius: 3,
                      ),
                    ],
                  ),*/
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildHeader(),
                      if (error != null)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 18.0),
                          child: Text(
                            error!,
                            style: const TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      _buildEmailPasswordForm(),
                      const SizedBox(height: 18),
                      _buildDivider("OR"),
                      const SizedBox(height: 14),
                      _buildSocialProviders(),
                      const SizedBox(height: 18),
                      _buildDivider("OR"),
                      const SizedBox(height: 14),
                      _buildPhoneAuthSection(),
                      const SizedBox(height: 16),
                      _buildSwitchMode(),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              top: 32,
              left: 16,
              child: ClipOval(
                child: Material(
                  color: Colors.white, // Button color
                  elevation: 2,
                  child: InkWell(
                    splashColor: Colors.grey.shade100,
                    onTap: () {
                      Navigator.pushReplacementNamed(context, '/main');
                    },
                    child: const SizedBox(
                      width: 38,
                      height: 38,
                      child: Icon(
                        Icons.close_outlined,
                        size: 24,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
