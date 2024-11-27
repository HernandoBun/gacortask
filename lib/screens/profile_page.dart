import 'package:flutter/material.dart';
import 'package:gacortask/constants.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  File? _profileImage;
  String _name = 'Boediono';
  String _phone = '+62 812-113-4948';
  String _email = 'boediono@yahoo.com';
  String _address = 'Jl. Merdeka No. 45, Jakarta';

  // Fungsi untuk memilih gambar dari galeri
  Future<void> _pickImage() async {
    try {
      final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
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
  void _editInfo(String title, String currentValue, Function(String) onSave) {
    TextEditingController controller = TextEditingController(text: currentValue);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit $title'),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: 'Masukkan $title baru',
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
      body: Stack(
        children: [
          Container(
            height: 270,
            decoration: const BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(110),
                bottomRight: Radius.circular(110),
              ),
            ),
          ),
          
          // Posisi Ikon Profil
          Positioned(
            top: 170, // Sesuaikan posisi vertikal jika diperlukan
            left: 0,
            right: 0,
            child: Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 70, // Perbesar ukuran profil, misal 70
                    backgroundImage: _profileImage != null
                        ? FileImage(_profileImage!)
                        : const AssetImage('assets/profile_pic.png') as ImageProvider,
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
          
          // Bagian isi konten
          Column(
            children: [
              const SizedBox(height: 350), // Tambah jarak untuk menurunkan konten
              // Nama
              ProfileItem(
                icon: Icons.person,
                title: Constants.titleName,
                content: _name,
                onTap: () {
                  _editInfo('Nama', _name, (newName) {
                    setState(() {
                      _name = newName;
                    });
                  });
                },
              ),
              // Telepon
              ProfileItem(
                icon: Icons.phone,
                title: Constants.titleTelp,
                content: _phone,
                onTap: () {
                  _editInfo('Telepon', _phone, (newPhone) {
                    setState(() {
                      _phone = newPhone;
                    });
                  });
                },
              ),
              // Email
              ProfileItem(
                icon: Icons.email,
                title: Constants.titleEmail,
                content: _email,
                onTap: () {
                  _editInfo('Email', _email, (newEmail) {
                    setState(() {
                      _email = newEmail;
                    });
                  });
                },
              ),
              // Alamat
              ProfileItem(
                icon: Icons.home,
                title: Constants.titleAlamat,
                content: _address,
                onTap: () {
                  _editInfo('Alamat', _address, (newAddress) {
                    setState(() {
                      _address = newAddress;
                    });
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ProfileItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String content;
  final VoidCallback onTap;

  const ProfileItem({
    super.key,
    required this.icon,
    required this.title,
    required this.content,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Container(
          decoration: BoxDecoration(
            color: Constants.colorWhite,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              Icon(icon, color: Constants.colorBlack),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(color: Colors.black54),
                  ),
                  Text(
                    content,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              const Icon(Icons.edit, color: Constants.colorBlack),
            ],
          ),
        ),
      ),
    );
  }
}
