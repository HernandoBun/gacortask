import 'package:flutter/material.dart';
import 'package:gacortask/constants.dart';
import 'package:gacortask/screens/menubarpage/provider/about_widget.dart';
import 'package:gacortask/screens/menubarpage/provider/theme_provider.dart';
import 'package:gacortask/sizes.dart';
import 'package:provider/provider.dart';

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final primaryColor = themeProvider.primaryColor;
    final secondaryColor = themeProvider.secondaryColor;
    return Scaffold(
      appBar: AppBar(
        title: const Text(Constants.titleAbout),
        backgroundColor: primaryColor,
        foregroundColor: secondaryColor,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(Constants.border20),
                child: Container(
                  width: double.infinity,
                  height: getScreenHeight(200.0),
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(Constants.aboutUs1),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              SizedBox(height: getScreenHeight(20.0)),
              Text(
                Constants.textIntro,
                style: TextStyle(
                  fontSize: getScreenWidth(26.0),
                  fontWeight: FontWeight.bold,
                  fontFamily: Constants.fontOpenSansRegular,
                  color: primaryColor,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: getScreenHeight(10.0)),
              const Text(
                Constants.textIntro1,
                style: TextStyle(
                  fontSize: 16.0,
                  fontFamily: Constants.fontOpenSansRegular,
                  color: Constants.colorBlack,
                  fontWeight: FontWeight.w400,
                ),
                textAlign: TextAlign.justify,
              ),
              SizedBox(height: getScreenHeight(20.0)),
              Text(
                Constants.textTeam,
                style: TextStyle(
                  fontSize: getScreenWidth(22.0),
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),
              SizedBox(height: getScreenHeight(20.0)),
              teamMember(
                  'Hans Malvin Djojo', '535230083/hansmalvin', Constants.hans),
              SizedBox(height: getScreenHeight(20.0)),
              teamMember(
                  'Mario Samuel', '535230091/marioboedi', Constants.mario),
              SizedBox(height: getScreenHeight(20.0)),
              teamMember(
                  'Hernando Bun', '535230133/HernandoBun', Constants.her),
              SizedBox(height: getScreenHeight(20.0)),
              teamMember(
                  'Muhammad Galang', '535230193/EgaaTheFarmer', Constants.ega),
              SizedBox(height: getScreenHeight(20.0)),
              teamMember(
                  'Darren Kurniawan', '535230165/Darren0403', Constants.darren),
              SizedBox(height: getScreenHeight(20.0)),
              teamMember(
                  'Louis Chuannata', '535230130/zieksthi', Constants.louis),
              SizedBox(height: getScreenHeight(20.0)),
              Text(
                Constants.textCU,
                style: TextStyle(
                  fontSize: getScreenWidth(22.0),
                  fontFamily: Constants.fontOpenSansRegular,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),
              SizedBox(height: getScreenHeight(10.0)),
              Text(
                Constants.textAdminGmail,
                style: TextStyle(
                    fontSize: getScreenWidth(16.0),
                    color: Constants.colorBlack),
              ),
              Text(
                Constants.textPhone,
                style: TextStyle(
                    fontSize: getScreenWidth(16.0),
                    color: Constants.colorBlack),
              ),
              SizedBox(height: getScreenHeight(30.0)),
              Text(
                Constants.textThanks,
                style: TextStyle(
                  fontSize: getScreenWidth(14.0),
                  fontFamily: Constants.fontOpenSansRegular,
                  color: Constants.colorBlack,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
