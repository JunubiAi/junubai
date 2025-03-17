import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nilean/ui/widgets/app_buttons.dart';
import 'package:nilean/utils/colors.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  String? _profilePictureUrl;
  XFile? _pickedImage;

  @override
  void initState() {
    super.initState();
    _nameController.text = FirebaseAuth.instance.currentUser?.displayName ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppButtons.backButton(onPressed: () {
                Navigator.pop(context);
              }),
              const SizedBox(height: 20),
              if (FirebaseAuth.instance.currentUser != null) ...[
                Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: _profilePictureUrl != null
                                ? NetworkImage(_profilePictureUrl ?? '')
                                : AssetImage('assets/images/avatar.png'),
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.circular(60),
                          border: Border.all(
                            width: 2,
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          AppButtons.ellipsisButton(
                            onPressed: _pickProfilePicture,
                            text: 'Update Profile Picture',
                            icon: Icons.arrow_outward,
                            color: AppColors.primaryOrange,
                            context: context,
                          )
                        ],
                      ),
                      SizedBox(height: 20),

                      // Name
                      TextFormField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          labelText: 'Name',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your name';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 10),

                      // Password
                      TextFormField(
                        controller: _passwordController,
                        obscureText: true,
                        style: GoogleFonts.lato(fontSize: 15),
                        decoration: InputDecoration(
                          labelText: 'New Password',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.length < 8) {
                            return 'Password must be at least 8 characters';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 10),

                      // Confirm Password
                      TextFormField(
                        controller: _confirmPasswordController,
                        obscureText: true,
                        style: GoogleFonts.lato(fontSize: 15),
                        decoration: InputDecoration(
                          labelText: 'Confirm Password',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value != _passwordController.text) {
                            return 'Passwords do not match';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20),

                      // Update Button
                      AppButtons.defButton(
                        color: Colors.green,
                        onPressed: _updateAccount,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Update Account',
                              style: GoogleFonts.lato(fontSize: 15),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 5),

                      AppButtons.defButton(
                        color: Colors.red,
                        onPressed: _deleteAccount,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Delete Account',
                              style: GoogleFonts.lato(fontSize: 15),
                            ),
                            const SizedBox(width: 5),
                            Icon(Icons.delete_forever_rounded)
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ] else ...[
                AppButtons.defButton(
                  color: Colors.blueAccent,
                  onPressed: () {
                    Navigator.pushNamed(context, '/signin');
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Login',
                        style: GoogleFonts.lato(fontSize: 15),
                      ),
                      const SizedBox(width: 5),
                      Icon(Icons.delete_forever_rounded)
                    ],
                  ),
                ),
              ]
            ],
          ),
        ),
      ),
    );
  }

  void _pickProfilePicture() async {
    final ImagePicker picker = ImagePicker();
    final XFile? photo = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (photo != null) {
        _pickedImage = photo;
      } else {
        _pickedImage = null;
      }
    });
    await _uploadProfilePicture();
  }

  Future<void> _uploadProfilePicture() async {
    try {
      if (_pickedImage != null) {
        final ref = FirebaseStorage.instance.ref().child(
            'profile_pictures/${FirebaseAuth.instance.currentUser?.uid}');
        await ref.putFile(File(_pickedImage!.path));
        final url = await ref.getDownloadURL();
        setState(() {
          _profilePictureUrl = url;
        });
        await FirebaseAuth.instance.currentUser?.updatePhotoURL(url);
        snackBar('Updated successfully');
      }
    } catch (e) {
      snackBar('Error ${e.toString()}');
    }
  }

  void _updateAccount() async {
    if (_formKey.currentState!.validate()) {
      try {
        await FirebaseAuth.instance.currentUser
            ?.updateDisplayName(_nameController.text);
        if (_passwordController.text.isNotEmpty) {
          await FirebaseAuth.instance.currentUser
              ?.updatePassword(_passwordController.text);
        }
        if (_pickedImage != null) {
          await _uploadProfilePicture();
        }
        snackBar('Account updated successfully');
      } catch (e) {
        snackBar('Error updating account: $e');
      }
    }
  }

  void _deleteAccount() async {
    try {
      await FirebaseAuth.instance.currentUser?.delete();
      snackBar('Account deleted successfully');
    } catch (e) {
      snackBar('Error deleting account: $e');
    }
  }

  snackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}
