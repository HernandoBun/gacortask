import 'package:flutter/material.dart';
import 'package:gacortask/constants.dart';
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
        title: const Text('About Us'),
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
                borderRadius: BorderRadius.circular(20.0),
                child: Container(
                  width: double.infinity,
                  height: 200.0,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/AboutUs.jpeg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              SizedBox(height: getScreenHeight(20.0)),
              Text(
                'Introducing Our Team!',
                style: TextStyle(
                  fontSize: getScreenWidth(26.0),
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: getScreenHeight(10.0)),
              const Text(
                'We are a team of passionate developers and designers dedicated to building high-quality applications that make your life easier. Our goal is to provide innovative solutions that are user-friendly and efficient.',
                style: TextStyle(
                    fontSize: 16.0,
                    color: Constants.colorBlack,
                    fontWeight: FontWeight.w400),
                textAlign: TextAlign.justify,
              ),
              SizedBox(height: getScreenHeight(20.0)),
              Text(
                'Our Team:',
                style: TextStyle(
                  fontSize: getScreenWidth(22.0),
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),
              SizedBox(height: getScreenHeight(20.0)),
              teamMember('John Doe', 'CEO & Lead Developer',
                  'assets/images/john_doe.jpg'),
              SizedBox(height: getScreenHeight(20.0)),
              teamMember('Jane Smith', 'Product Manager',
                  'assets/images/jane_smith.jpg'),
              SizedBox(height: getScreenHeight(20.0)),
              teamMember('Michael Brown', 'UX/UI Designer',
                  'assets/images/michael_brown.jpg'),
              SizedBox(height: getScreenHeight(20.0)),
              teamMember('Alice White', 'Backend Developer',
                  'assets/images/alice_white.jpg'),
              SizedBox(height: getScreenHeight(20.0)),
              teamMember('David Black', 'Marketing Specialist',
                  'assets/images/david_black.jpg'),
              SizedBox(height: getScreenHeight(20.0)),
              teamMember('Sophia Green', 'Quality Assurance',
                  'assets/images/sophia_green.jpg'),
              SizedBox(height: getScreenHeight(20.0)),
              Text(
                'Contact Us:',
                style: TextStyle(
                  fontSize: getScreenWidth(22.0),
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),
              SizedBox(height: getScreenHeight(10.0)),
              Text(
                'Email: darrenamadeus1@gmail.com',
                style: TextStyle(
                    fontSize: getScreenWidth(16.0),
                    color: Constants.colorBlack),
              ),
              Text(
                'Phone: +123 456 7890',
                style: TextStyle(
                    fontSize: getScreenWidth(16.0),
                    color: Constants.colorBlack),
              ),
              const SizedBox(height: 30.0),
              Text(
                'Thank you for using our application! We are constantly working to improve and provide better services to our users.',
                style: TextStyle(
                  fontSize: getScreenWidth(14.0),
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
 
  Widget teamMember(String name, String role, String imageAsset) {
    return Consumer<ThemeProvider>(builder: (context, themeProvider, child) {
      final primaryColor = themeProvider.primaryColor; // Mengakses primaryColor
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
}