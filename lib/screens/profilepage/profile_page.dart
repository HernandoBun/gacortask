import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gacortask/constants.dart';
import 'package:gacortask/screens/profilepage/widgets/profile_item.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final user = FirebaseAuth.instance.currentUser;
  File? _profileImage;
  String _name = '-';
  String _phone = '+62';
  String _email = '';
  String _address = '';

  @override
  void initState() {
    super.initState();
    _loadProfileData();
    if (user != null) {
      _email = user!.email ?? 'Email tidak tersedia';
    }
  }

  Future<void> _loadProfileData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _name = prefs.getString('name') ?? '';
      _phone = prefs.getString('phone') ?? '+62';
      _address = prefs.getString('address') ?? '';
    });
  }

  Future<void> _saveProfileData(String key, String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value);
  }

  // Fungsi untuk memilih gambar dari galeri
  Future<void> _pickImage() async {
    try {
      final pickedFile =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _profileImage = File(pickedFile.path);
        });
      }
    } catch (e) {
      print("Error picking image: $e");
    }
  }

  // Fungsi untuk mengedit informasi
  void _editInfo(String title, String currentValue, Function(String) onSave,
      String key, String label) {
    TextEditingController controller =
        TextEditingController(text: currentValue);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit $title'),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: 'Masukkan $title baru',
              labelText: label,
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(Constants.textBatal),
            ),
            TextButton(
              onPressed: () {
                onSave(controller.text);
                _saveProfileData(key, controller.text);
                Navigator.of(context).pop();
              },
              child: const Text(Constants.textSimpan),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              height: 270,
              decoration: const BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(50),
                  bottomRight: Radius.circular(50),
                ),
              ),
            ),
            // Posisi Ikon Profil
            Positioned(
              top: 170,
              left: 0,
              right: 0,
              child: Center(
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 70,
                      backgroundImage: _profileImage != null
                          ? FileImage(_profileImage!)
                          : const AssetImage('assets/profile_pic.png')
                              as ImageProvider,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: _pickImage,
                        child: const CircleAvatar(
                          radius: 16,
                          backgroundColor: Constants.colorWhite,
                          child: Icon(
                            Icons.camera_alt,
                            color: Constants.colorBlueHer,
                            size: 18,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Column(
              children: [
                const SizedBox(height: 350),
                // Nama
                ProfileItem(
                  icon: Icons.person,
                  title: Constants.titleName,
                  content: _name,
                  label:
                      'Nama harus diisi dengan nama lengkap Anda', // Menyertakan label
                  onTap: () {
                    _editInfo('Nama', _name, (newName) {
                      setState(() {
                        _name = newName;
                      });
                    }, 'name', 'Masukkan nama lengkap Anda');
                  },
                ),
                ProfileItem(
                  icon: Icons.phone,
                  title: Constants.titleTelp,
                  content: _phone,
                  label:
                      'Nomor telepon harus diisi dengan format yang benar', // Menyertakan label
                  onTap: () {
                    _editInfo('Telepon', _phone, (newPhone) {
                      setState(() {
                        _phone = newPhone;
                      });
                    }, 'phone', 'Masukkan nomor telepon yang valid');
                  },
                ),
                ProfileItem(
                  icon: Icons.email,
                  title: Constants.titleEmail,
                  content: _email,
                  label:
                      'Email harus diisi dengan format email yang benar', // Menyertakan label
                  onTap: () {
                    _editInfo('Email', _email, (newEmail) {
                      setState(() {
                        _email = newEmail;
                      });
                    }, 'email', 'Masukkan alamat email yang valid');
                  },
                ),
                ProfileItem(
                  icon: Icons.home,
                  title: Constants.titleAlamat,
                  content: _address,
                  label:
                      'Alamat harus diisi dengan alamat yang valid', // Menyertakan label
                  onTap: () {
                    _editInfo('Alamat', _address, (newAddress) {
                      setState(() {
                        _address = newAddress;
                      });
                    }, 'address', 'Masukkan alamat lengkap Anda');
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}


