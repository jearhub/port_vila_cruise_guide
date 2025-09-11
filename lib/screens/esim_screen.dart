import 'package:flutter/material.dart';
import 'package:esim_installer_flutter/esim_installer_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class EsimScreen extends StatefulWidget {
  @override
  _EsimScreenState createState() => _EsimScreenState();
}

class _EsimScreenState extends State<EsimScreen> {
  // Sound null safety: non-nullable types
  bool _isEsimSupported = false;
  String _installationResult = '';
  String _instructions = '';

  @override
  void initState() {
    super.initState();
    _initEsimSupport();
  }

  Future<void> _initEsimSupport() async {
    // Fix: Safely handle nullable bool with fallback
    bool isSupported = await EsimInstallerFlutter().isSupportESim() ?? false;
    String instructions = await EsimInstallerFlutter().instructions() ?? '';
    setState(() {
      _isEsimSupported = isSupported;
      _instructions = instructions;
    });
  }

  Future<void> _installProfile() async {
    // Replace with actual eSIM activation data
    String result =
        await EsimInstallerFlutter().installESimProfile(
          smdpAddress: 'your.smdp.address',
          activationToken: 'your_activation_token',
        ) ??
        'Unknown result';
    setState(() {
      _installationResult = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Get Local eSIM",
          style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'eSIM Supported: ${_isEsimSupported ? "Yes" : "No"}',
              style: GoogleFonts.poppins(),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isEsimSupported ? _installProfile : null,
              child: Text("Install eSIM Profile", style: GoogleFonts.poppins()),
            ),
            SizedBox(height: 20),
            Text('Status: $_installationResult', style: GoogleFonts.poppins()),
            SizedBox(height: 20),
            TextButton(
              onPressed:
                  () => showDialog(
                    context: context,
                    builder:
                        (_) => AlertDialog(
                          title: Text(
                            "Installation Instructions",
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                          content: Text(
                            _instructions.isNotEmpty
                                ? _instructions
                                : "No instructions available.",
                            style: GoogleFonts.poppins(),
                          ),
                        ),
                  ),
              child: Text("How to Setup eSIM", style: GoogleFonts.poppins()),
            ),
            Divider(),
            Text(
              "Recommended Providers: Nomad, aloSIM, Ubigi",
              style: GoogleFonts.poppins(),
            ),
          ],
        ),
      ),
    );
  }
}
