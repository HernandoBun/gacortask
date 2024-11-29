import 'package:flutter/material.dart';
import 'package:gacortask/constants.dart';

class ThemeProvider extends ChangeNotifier {
  Color primaryColor = Constants.colorBlueHer;
  Color secondaryColor = Constants.colorWhite;

  // Method to change theme
  void changeTheme(int themeIndex) {
    if (themeIndex == 1) {
      primaryColor = Constants.colorThemes3A;
      secondaryColor = Constants.colorThemes3B;
    } else if (themeIndex == 2) {
      primaryColor = Constants.colorThemes1A;
      secondaryColor = Constants.colorThemes1B;
    } else if (themeIndex == 3) {
      primaryColor = Constants.colorThemes2A;
      secondaryColor = Constants.colorThemes2B;
    } else {
      primaryColor = Constants.colorBlueHer;
      secondaryColor = Constants.colorWhite;
    }

    notifyListeners();
  }
}
