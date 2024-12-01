import 'package:flutter/material.dart';
import 'package:gacortask/constants.dart';
import 'package:gacortask/screens/menubarpage/provider/theme_provider.dart';
import 'package:gacortask/sizes.dart';
import 'package:provider/provider.dart';

  Widget teamMember(String name, String role, String imageAsset) {
    return Consumer<ThemeProvider>(builder: (context, themeProvider, child) {
      final primaryColor = themeProvider.primaryColor;
      return Row(
        children: [
          CircleAvatar(
            radius: 30.0,
            backgroundImage: AssetImage(imageAsset),
          ),
          SizedBox(width: getScreenWidth(20.0)),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: TextStyle(
                  fontSize: getScreenWidth(18.0),
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),
              Text(
                role,
                style: TextStyle(
                  fontSize: getScreenWidth(16.0),
                  color: Constants.colorBlack,
                ),
              ),
            ],
          ),
        ],
      );
    });
  }