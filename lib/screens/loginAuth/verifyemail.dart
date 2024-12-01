import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gacortask/constants.dart';
import 'package:gacortask/screens/loginAuth/signup.dart';
import 'package:gacortask/sizes.dart';
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
              Text(
                Constants.textVerifEmail,
                style: TextStyle(
                  fontSize: getScreenWidth(24.0),
                  fontWeight: FontWeight.bold,
                  fontFamily: Constants.fontOpenSansRegular,
                  color: Constants.colorBlack,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: getScreenHeight(20.0)),
              Text(
                Constants.textAnimationVerif,
                style: TextStyle(
                  fontSize: getScreenWidth(16.0),
                  fontFamily: Constants.fontOpenSansRegular,
                  color: Constants.colorBlack1,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: getScreenHeight(40.0)),
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
                        color: Constants.colorGreen,
                      )
                    : const Icon(
                        Icons.email_outlined,
                        key: ValueKey('emailIcon'),
                        size: 100,
                        color: Constants.colorBlueHer,
                      ),
              ),
              SizedBox(height: getScreenHeight(20.0)),
              Text(
                Constants.textVerifRefresh,
                style: TextStyle(
                  fontSize: getScreenWidth(16.0),
                  color: Constants.colorBlack1,
                ),
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
