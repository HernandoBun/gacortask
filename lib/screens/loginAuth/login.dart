import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gacortask/constants.dart';
import 'package:gacortask/screens/menubarpage/provider/theme_provider.dart';
import 'package:gacortask/sizes.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:gacortask/usage/wrapper.dart';
import 'package:gacortask/screens/loginAuth/forgot.dart';
import 'package:gacortask/screens/loginAuth/signup.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  bool isLoading = false;
  bool _isPasswordVisible = false;

  Future<void> signIn() async {
    setState(() {
      isLoading = true;
    });
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email.text,
        password: password.text,
      );
      Get.offAll(() => const Wrapper());
    } on FirebaseAuthException catch (e) {
      Get.snackbar('Error', e.message ?? 'Unknown error');
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final primaryColor = themeProvider.primaryColor;
    final secondaryColor = themeProvider.secondaryColor;
    return Scaffold(
      body: isLoading
          ? Center(child: Lottie.asset(Constants.loadingAnimation))
          : SingleChildScrollView(
              child: Column(
                children: [
                  Stack(
                    children: [
                      Container(
                        height: getScreenHeight(250.0),
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(Constants.headerRoot),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: getScreenWidth(20.0),
                      vertical: getScreenHeight(10.0),
                    ),
                    child: Text(
                      Constants.textGetStarted,
                      style: TextStyle(
                        fontSize: getScreenWidth(24.0),
                        fontWeight: FontWeight.bold,
                        fontFamily: Constants.fontOpenSansBold,
                        color: Constants.colorBlack,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: getScreenHeight(20.0)),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: getScreenWidth(24.0),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextField(
                          controller: email,
                          decoration: InputDecoration(
                            labelText: Constants.labelEmailAdd,
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(Constants.border),
                            ),
                          ),
                        ),
                        SizedBox(height: getScreenHeight(20.0)),
                        TextField(
                          controller: password,
                          obscureText: !_isPasswordVisible,
                          decoration: InputDecoration(
                            labelText: Constants.labelPassword,
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(Constants.border),
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _isPasswordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                              onPressed: () {
                                setState(() {
                                  _isPasswordVisible = !_isPasswordVisible;
                                });
                              },
                            ),
                          ),
                        ),
                        SizedBox(height: getScreenHeight(10.0)),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () =>
                                Get.to(() => const ForgotPassword()),
                            child: const Text(Constants.textForgotPw),
                          ),
                        ),
                        SizedBox(height: getScreenHeight(20.0)),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: signIn,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryColor,
                              foregroundColor: secondaryColor,
                              padding: EdgeInsets.symmetric(
                                  vertical: getScreenHeight(15.0)),
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(Constants.border30),
                              ),
                            ),
                            child: Text(
                              Constants.textLogin,
                              style: TextStyle(
                                fontSize: getScreenWidth(18.0),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: getScreenHeight(20.0)),
                        Row(
                          children: [
                            const Expanded(child: Divider()),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: getScreenWidth(8.0)),
                              child: const Text(Constants.textOr),
                            ),
                            const Expanded(child: Divider()),
                          ],
                        ),
                        SizedBox(height: getScreenHeight(20.0)),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              Get.snackbar('No Apple Sign in','Please use the google account');
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Constants.colorBlack,
                              foregroundColor: Constants.colorWhite,
                              padding: EdgeInsets.symmetric(
                                  vertical: getScreenHeight(15.0)),
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(Constants.border20),
                                side: const BorderSide(
                                    color: Constants.colorGrey9),
                              ),
                            ),
                            icon: const Icon(Icons.apple),
                            label: const Text(Constants.textApple),
                          ),
                        ),
                        SizedBox(height: getScreenHeight(10.0)),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              Get.snackbar('No Google Sign in','due to gradle error');
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Constants.colorWhite,
                              foregroundColor: Constants.colorBlack,
                              padding: EdgeInsets.symmetric(
                                  vertical: getScreenHeight(15.0)),
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(Constants.border20),
                                side: const BorderSide(
                                    color: Constants.colorGrey9),
                              ),
                            ),
                            icon: Image.asset(
                              Constants.googleRoot,
                              height: getScreenHeight(20.0),
                            ),
                            label: const Text(Constants.textGoogle),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: getScreenHeight(20.0)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(Constants.textDontAcc),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const Signup(),
                            ),
                          );
                        },
                        child: const Text(Constants.textSignUp),
                      ),
                    ],
                  ),
                  SizedBox(height: getScreenHeight(10.0)),
                ],
              ),
            ),
    );
  }
}
