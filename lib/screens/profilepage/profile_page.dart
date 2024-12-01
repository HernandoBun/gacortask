import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gacortask/constants.dart';
import 'package:gacortask/screens/menubarpage/provider/theme_provider.dart';
import 'package:gacortask/screens/profilepage/widgets/profile_item.dart';
import 'package:gacortask/sizes.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
 
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});
 
  @override
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
              child: const Text(
                Constants.textBatal,
                style: TextStyle(
                  fontFamily: Constants.fontOpenSansRegular,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                onSave(controller.text);
                _saveProfileData(key, controller.text);
                Navigator.of(context).pop();
              },
              child: const Text(
                Constants.textSimpan,
                style: TextStyle(
                  fontFamily: Constants.fontOpenSansRegular,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
 
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final primaryColor = themeProvider.primaryColor;
    final secondaryColor = themeProvider.secondaryColor;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              height: getScreenHeight(270.0),
              decoration: BoxDecoration(
                color: primaryColor,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(Constants.borderProf),
                  bottomRight: Radius.circular(Constants.borderProf),
                ),
              ),
            ),
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
                        child: CircleAvatar(
                          radius: 16,
                          backgroundColor: secondaryColor,
                          child: Icon(
                            Icons.camera_alt,
                            color: primaryColor,
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
                SizedBox(height: getScreenHeight(350.0)),
                ProfileItem(
                  icon: Icons.person,
                  title: Constants.titleName,
                  content: _name,
                  label: Constants.labelPP,
                  onTap: () {
                    _editInfo('Nama', _name, (newName) {
                      setState(() {
                        _name = newName;
                      });
                    }, 'name', 'Name');
                  },
                ),
                ProfileItem(
                  icon: Icons.phone,
                  title: Constants.titleTelp,
                  content: _phone,
                  label: Constants.labelPP1,
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
                  label: Constants.labelPP2,
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
                  label: Constants.labelPP3,
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