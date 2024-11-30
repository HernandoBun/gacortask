import 'package:flutter/material.dart';
import 'package:gacortask/constants.dart';
import 'package:gacortask/screens/menubarpage/provider/theme_provider.dart';
import 'package:gacortask/sizes.dart';
import 'package:provider/provider.dart';

class ThemePage extends StatelessWidget {
  const ThemePage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final primaryColor = themeProvider.primaryColor;
    final secondaryColor = themeProvider.secondaryColor;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Change Theme',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: primaryColor,
        foregroundColor: secondaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Wrap(
          spacing: 10,
          runSpacing: 10,
          alignment: WrapAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                Provider.of<ThemeProvider>(context, listen: false)
                    .changeTheme(1);
              },
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 5),
                width: getScreenWidth(80),
                height: getScreenHeight(80),
                decoration: BoxDecoration(
                  color: Constants.colorThemes3A,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      spreadRadius: 2,
                      blurRadius: 5,
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    if (themeProvider.selectedTheme == 1)
                      const Positioned(
                        top: 0,
                        right: 0,
                        child: Icon(
                          Icons.check_circle,
                          color: Constants.colorWhite,
                          size: 24,
                        ),
                      ),
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                Provider.of<ThemeProvider>(context, listen: false)
                    .changeTheme(2);
              },
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 5),
                width: getScreenWidth(80),
                height: getScreenHeight(80),
                decoration: BoxDecoration(
                  color: Constants.colorThemes1A,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      spreadRadius: 2,
                      blurRadius: 5,
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    if (themeProvider.selectedTheme == 2)
                      const Positioned(
                        top: 0,
                        right: 0,
                        child: Icon(
                          Icons.check_circle,
                          color: Constants.colorWhite,
                          size: 24,
                        ),
                      ),
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                Provider.of<ThemeProvider>(context, listen: false)
                    .changeTheme(3);
              },
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 5),
                width: getScreenWidth(80),
                height: getScreenHeight(80),
                decoration: BoxDecoration(
                  color: Constants.colorThemes2A,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      spreadRadius: 2,
                      blurRadius: 5,
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    if (themeProvider.selectedTheme == 3)
                      const Positioned(
                        top: 0,
                        right: 0,
                        child: Icon(
                          Icons.check_circle,
                          color: Constants.colorWhite,
                          size: 24,
                        ),
                      ),
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                Provider.of<ThemeProvider>(context, listen: false)
                    .changeTheme(4);
              },
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 5),
                width: getScreenWidth(80),
                height: getScreenHeight(80),
                decoration: BoxDecoration(
                  color: Constants.colorBlueHer,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      spreadRadius: 2,
                      blurRadius: 5,
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    if (themeProvider.selectedTheme == 4)
                      const Positioned(
                        top: 0,
                        right: 0,
                        child: Icon(
                          Icons.check_circle,
                          color: Constants.colorWhite,
                          size: 24,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
