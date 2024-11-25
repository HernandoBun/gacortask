import 'package:flutter/material.dart';
import 'package:gacortask/screens/loginAuth/forgot.dart';
import 'package:gacortask/screens/loginAuth/login.dart';
import 'package:gacortask/screens/loginAuth/signup.dart';
import 'package:gacortask/screens/loginAuth/verifyemail.dart';

final Map<String, WidgetBuilder> routes = {
  LoginScreen.routeName: (context) => const LoginScreen(),
  ForgotPassword.routeName: (context) => const ForgotPassword(),
  Signup.routeName: (context) => const Signup(),
  Verify.routeName: (context) => const Verify(),
};
