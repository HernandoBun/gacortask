import 'package:flutter/material.dart';
import 'package:gacortask/constants.dart';
import 'package:gacortask/usage/bottom_navbar.dart';
import 'package:get/get.dart';
import 'package:gacortask/screens/wrapper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:gacortask/providers/task_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => TaskProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: Constants.title,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const NavbarWrapper(),
    );
  }
}

class NavbarWrapper extends StatelessWidget {
  const NavbarWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    bool logged = FirebaseAuth.instance.currentUser != null;

    return logged ? const BottomNavBar() : const Wrapper();
  }
}
