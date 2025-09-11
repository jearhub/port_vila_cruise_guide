import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final user = FirebaseAuth.instance.currentUser;
  final _nameController = TextEditingController();
  File? _imageFile;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _nameController.text = user?.displayName ?? '';
  }

  Future<void> _pickImage() async {
    final picked = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 75,
    );
    if (picked != null) setState(() => _imageFile = File(picked.path));
  }

  Future<String?> _uploadPhoto(File file) async {
    final ref = FirebaseStorage.instance.ref('profilePhotos/${user?.uid}.jpg');
    await ref.putFile(file);
    return await ref.getDownloadURL();
  }

  Future<void> _saveProfile() async {
    setState(() => _saving = true);
    String? photoURL = user?.photoURL;
    if (_imageFile != null) {
      photoURL = await _uploadPhoto(_imageFile!);
    }
    await user?.updateDisplayName(_nameController.text.trim());
    if (photoURL != null) {
      await user?.updatePhotoURL(photoURL);
    }
    await user?.reload();
    setState(() => _saving = false);
    Navigator.pop(context, true); // Return to previous screen
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Profile updated', style: GoogleFonts.poppins())),
    );
  }

  @override
  Widget build(BuildContext context) {
    final initialPhoto =
        _imageFile != null
            ? FileImage(_imageFile!)
            : (user?.photoURL != null ? NetworkImage(user!.photoURL!) : null);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Edit Profile',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w500, fontSize: 16),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // Profile photo with edit option
            Stack(
              children: [
                CircleAvatar(
                  radius: 48,
                  backgroundImage: initialPhoto as ImageProvider?,
                  child:
                      initialPhoto == null
                          ? const Icon(Icons.person, size: 48)
                          : null,
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: _pickImage,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.teal,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.edit,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Display Name',
                labelStyle: GoogleFonts.poppins(),
                border: OutlineInputBorder(),
              ),
              textInputAction: TextInputAction.done,
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon:
                    _saving
                        ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                        : const Icon(Icons.save),
                label: Text(_saving ? 'Saving...' : 'Save Profile'),
                onPressed: _saving ? null : _saveProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
