import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gacortask/constants.dart';
import 'package:gacortask/screens/menubarpage/provider/theme_provider.dart';
import 'package:gacortask/sizes.dart';
import 'package:get/get.dart';
import 'package:gacortask/screens/loginAuth/login.dart';
import 'package:gacortask/usage/wrapper.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<Signup> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController name = TextEditingController();
  bool isChecked = false;
  bool _obscurePassword = true;

  signup() async {
    if (isChecked) {
      try {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email.text,
          password: password.text,
        );

        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('name', name.text);

        Get.offAll(const Wrapper());
      } catch (e) {
        Get.snackbar('Signup Error', e.toString());
      }
    } else {
      Get.snackbar('Signup Error', 'Please agree to the Terms & Privacy.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final primaryColor = themeProvider.primaryColor;
    final secondaryColor = themeProvider.secondaryColor;

    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: getScreenWidth(20.0)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: getScreenHeight(80.0)),
            Text(
              Constants.textHello,
              style: TextStyle(
                fontSize: getScreenWidth(24.0),
                fontFamily: Constants.fontOpenSansRegular,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: getScreenHeight(4.0)),
            Text(
              Constants.textCred,
              style: TextStyle(
                fontSize: getScreenWidth(14.0),
                fontFamily: Constants.fontOpenSansRegular,
                color: Constants.colorGrey10,
              ),
            ),
            SizedBox(height: getScreenHeight(16.0)),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {},
                    icon: Image.asset(
                      Constants.googleRoot,
                      height: getScreenHeight(29.0),
                    ),
                    label: const Text(Constants.textJustGoogle),
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: getScreenHeight(8.0)),
                      side: const BorderSide(color: Constants.colorGrey9),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(Constants.border6),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: getScreenWidth(8.0)),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {},
                    icon:
                        const Icon(Icons.apple, color: Constants.colorBlack, size: 30),
                    label: const Text(Constants.textJustApple),
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: getScreenHeight(8.0)),
                      side: const BorderSide(color: Constants.colorGrey9),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(Constants.border6),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: getScreenHeight(16.0)),
            Row(
              children: [
                const Expanded(child: Divider(color: Constants.colorGrey9)),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: getScreenWidth(6.0)),
                  child: Text(
                    Constants.textOr,
                    style: TextStyle(fontSize: getScreenWidth(14.0), fontFamily: Constants.fontOpenSansRegular,color: Constants.colorGrey9),
                  ),
                ),
                const Expanded(child: Divider(color: Constants.colorGrey9)),
              ],
            ),
            SizedBox(height: getScreenHeight(16.0)),
            Text(
              Constants.titleName,
              style: TextStyle(
                fontSize: getScreenWidth(18.0),
                fontFamily: Constants.fontOpenSansRegular,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: getScreenHeight(4.0)),
            TextField(
              controller: name,
              decoration: InputDecoration(
                contentPadding:
                    EdgeInsets.symmetric(vertical: getScreenHeight(8.0), horizontal: getScreenWidth(10.0)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(Constants.border),
                ),
              ),
            ),
            SizedBox(height: getScreenHeight(12.0)),
            Text(
              Constants.labelEmailAdd,
              style: TextStyle(
                fontSize: getScreenWidth(18.0),
                fontFamily: Constants.fontOpenSansRegular,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: getScreenHeight(4.0)),
            TextField(
              controller: email,
              decoration: InputDecoration(
                contentPadding:
                    EdgeInsets.symmetric(vertical: getScreenHeight(8.0), horizontal: getScreenWidth(10.0)),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(Constants.border)),
              ),
            ),
            SizedBox(height: getScreenHeight(12.0)),
            Text(
              Constants.labelPassword,
              style: TextStyle(
                fontSize: getScreenWidth(18.0),
                fontFamily: Constants.fontOpenSansRegular,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: getScreenHeight(4.0)),
            TextField(
              controller: password,
              obscureText: _obscurePassword,
              decoration: InputDecoration(
                contentPadding:
                    EdgeInsets.symmetric(vertical: getScreenHeight(8.0), horizontal: getScreenWidth(10.0)),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(Constants.border)),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword ? Icons.visibility_off : Icons.visibility,
                    size: 18,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                ),
              ),
            ),
            SizedBox(height: getScreenHeight(12.0)),
            Row(
              children: [
                Theme(
                  data: ThemeData(
                    checkboxTheme: CheckboxThemeData(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(Constants.border12),
                      ),
                    ),
                  ),
                  child: Checkbox(
                    value: isChecked,
                    onChanged: (bool? value) {
                      setState(() {
                        isChecked = value ?? false;
                      });
                    },
                  ),
                ),
                const Text(Constants.textIAgree),
                GestureDetector(
                  onTap: () {},
                  child: const Text(
                    Constants.textTP,
                    style: TextStyle(
                      color: Constants.colorBlueHer,
                      fontFamily: Constants.fontOpenSansRegular,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: getScreenHeight(16.0)),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: signup,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: secondaryColor,
                  padding: EdgeInsets.symmetric(vertical: getScreenHeight(12.0)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(Constants.border6),
                  ),
                ),
                child: Text(
                  Constants.textSignUp,
                  style: TextStyle(fontSize: getScreenWidth(16.0), fontFamily: Constants.fontOpenSansRegular),
                ),
              ),
            ),
            SizedBox(height: getScreenHeight(12.0)),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(Constants.textAlreadAcc,
                    style: TextStyle(fontSize: getScreenWidth(14.0))),
                TextButton(
                  onPressed: () => Get.to(() => const LoginScreen()),
                  child: Text(
                    Constants.textLogIn,
                    style: TextStyle(
                      fontSize: getScreenWidth(14.0),
                      fontFamily: Constants.fontOpenSansRegular,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: getScreenHeight(20.0)),
            Center(
              child: Text(
                Constants.textCopyRight,
                style: TextStyle(
                  color: Constants.colorGrey10,
                  fontFamily: Constants.fontOpenSansRegular,
                  fontSize: getScreenWidth(10.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
