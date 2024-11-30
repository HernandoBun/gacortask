import 'package:flutter/material.dart';
import 'package:gacortask/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  Color primaryColor = Constants.colorBlueHer;
  Color secondaryColor = Constants.colorWhite;
  String welcomeImage = Constants.welcomeRoot;

  int selectedTheme = 0;

  ThemeProvider() {
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    selectedTheme = prefs.getInt('selectedTheme') ?? 0;
    _applyTheme(selectedTheme);
  }

  Future<void> _saveTheme(int themeIndex) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('selectedTheme', themeIndex);
  }

  void _applyTheme(int themeIndex) {
    if (themeIndex == 1) {
      primaryColor = Constants.colorThemes3A;
      secondaryColor = Constants.colorThemes3B;
      welcomeImage = Constants.welcomeRoot2;
    } else if (themeIndex == 2) {
      primaryColor = Constants.colorThemes1A;
      secondaryColor = Constants.colorThemes1B;
      welcomeImage = Constants.welcomeRoot1;
    } else if (themeIndex == 3) {
      primaryColor = Constants.colorThemes2A;
      secondaryColor = Constants.colorThemes2B;
      welcomeImage = Constants.welcomeRoot3;
    } else {
      primaryColor = Constants.colorBlueHer;
      secondaryColor = Constants.colorWhite;
    }

    notifyListeners();
  }

  void changeTheme(int themeIndex) {
    selectedTheme = themeIndex;
    _applyTheme(themeIndex);
    _saveTheme(themeIndex);
  }
}