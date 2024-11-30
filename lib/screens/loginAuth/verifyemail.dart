import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gacortask/constants.dart';
import 'package:gacortask/screens/loginAuth/signup.dart';
import 'package:get/get.dart';
import 'package:gacortask/usage/wrapper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Verify extends StatefulWidget {
  const Verify({super.key});

  @override
  State<Verify> createState() => _VerifyState();
}

class _VerifyState extends State<Verify> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  bool _showCheckIcon = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);

    _controller.forward();

    Future.delayed(const Duration(seconds: 4), () {
      setState(() {
        _showCheckIcon = true;
      });
    });

    sendVerifyLink();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

sendVerifyLink() async {
    final user = FirebaseAuth.instance.currentUser!;

    final prefs = await SharedPreferences.getInstance();
    final lastSentTime = prefs.getInt('lastVerificationTime') ?? 0;
    final currentTime = DateTime.now().millisecondsSinceEpoch;

    if (currentTime - lastSentTime > 60000) { 
      await user.sendEmailVerification().then(
        (value) async {
          await prefs.setInt('lastVerificationTime', currentTime);  
          Get.snackbar(
            'Link sent!',
            'Check your email',
            margin: const EdgeInsets.all(30),
            snackPosition: SnackPosition.BOTTOM,
          );
        },
      );
    } else {
      Get.snackbar(
        'Too many requests!',
        'Please wait a minute before trying again.',
        margin: const EdgeInsets.all(30),
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  reload() async {
    await FirebaseAuth.instance.currentUser!
        .reload()
        .then((value) => {Get.offAll(const Wrapper())});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Constants.colorWhite,
        foregroundColor: Constants.colorBlack,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const Signup()),
            );
          },
        ),
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Verification Email Sent!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              const Text(
                'Please check your email and click the verification link to continue.',
                style: TextStyle(fontSize: 16, color: Colors.black54),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              AnimatedSwitcher(
                duration: const Duration(seconds: 1),
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return ScaleTransition(scale: animation, child: child);
                },
                child: _showCheckIcon
                    ? const Icon(
                        Icons.check_circle_outline,
                        key: ValueKey('checkIcon'),
                        size: 100,
                        color: Colors.green,
                      )
                    : const Icon(
                        Icons.email_outlined,
                        key: ValueKey('emailIcon'),
                        size: 100,
                        color: Colors.blue,
                      ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Once verified, press the button below to reload.',
                style: TextStyle(fontSize: 16, color: Colors.black54),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: reload,
        child: const Icon(
          Icons.restart_alt_rounded,
        ),
      ),
    );
  }
}