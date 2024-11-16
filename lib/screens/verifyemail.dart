import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:gacortask/screens/wrapper.dart';

class Verify extends StatefulWidget {
  const Verify({super.key});

  @override
  State<Verify> createState() => _VerifyState();
}

class _VerifyState extends State<Verify> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  // State to manage which icon to show
  bool _showCheckIcon = false;

  @override
  void initState() {
    super.initState();

    // Initialize animation controller
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);

    // Start the animation
    _controller.forward();

    // Delay to change the icon after 4 seconds
    Future.delayed(const Duration(seconds: 4), () {
      setState(() {
        _showCheckIcon = true; // Change icon to check mark
      });
    });

    // Send verification link
    sendVerifyLink();
  }

  @override
  void dispose() {
    _controller.dispose(); // Dispose the animation controller
    super.dispose();
  }

  // Send verification email link
  sendVerifyLink() async {
    final user = FirebaseAuth.instance.currentUser!;
    await user.sendEmailVerification().then(
      (value) => {
        Get.snackbar(
          'Link sent!',
          'Check your email',
          margin: const EdgeInsets.all(30),
          snackPosition: SnackPosition.BOTTOM,
        )
      },
    );
  }

  // Reload verification state
  reload() async {
    await FirebaseAuth.instance.currentUser!
        .reload()
        .then((value) => {Get.offAll(const Wrapper())});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Header text with fade-in animation
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

              // Animated email or check icon
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

              // Reload instruction
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
