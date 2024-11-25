import 'package:flutter/material.dart';

class Sizes {
  static MediaQueryData _mediaQueryData = const MediaQueryData();
  static double _screenWidth = 0.0;
  static double _screenHeight = 0.0;
  static double _default = 0.0;
  static Orientation orientation = Orientation.portrait;

  static void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    _screenWidth = _mediaQueryData.size.width;
    _screenHeight = _mediaQueryData.size.height;
    orientation = _mediaQueryData.orientation;
    _default =
        (_screenWidth < _screenHeight ? _screenWidth : _screenHeight) / 100;
  }
}

double getScreenHeight(double inputHeight) {
  double screenHeight = Sizes._screenHeight;
  return (inputHeight / 812.0) * screenHeight;
}

double getScreenWidth(double inputWidth) {
  double screenWidth = Sizes._screenWidth;
  return (inputWidth / 375.0) * screenWidth;
}