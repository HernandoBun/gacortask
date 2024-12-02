import 'package:flutter/material.dart';
import 'package:gacortask/screens/loginAuth/login.dart';
import 'package:gacortask/screens/loginAuth/verifyemail.dart';
import 'package:gacortask/usage/bottom_navbar.dart';
import 'package:firebase_auth/firebase_auth.dart';

/* 
wrapper yang digunakan untuk mengverifikasi apakah user 
sudah pernah masuk menggunakan snapshot dan jika baru signup maka akan verifikasi terlebih dahulu
*/
class Wrapper extends StatefulWidget {
  const Wrapper({super.key});

  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            print(snapshot.data);
            if (snapshot.data!.emailVerified) {
              return const BottomNavBar();
            } else {
              return const Verify();
            }
          } else {
            return const LoginScreen();
          }
        },
      ),
    );
  }
}
