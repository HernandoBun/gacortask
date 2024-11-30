import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:gacortask/constants.dart';
import 'package:gacortask/screens/homepage/home.dart';
import 'package:gacortask/screens/menubarpage/provider/theme_provider.dart';
import 'package:gacortask/screens/profilepage/profile_page.dart';
import 'package:gacortask/screens/taskspage/task_screen.dart';
import 'package:gacortask/screens/notificationpage/notification_screen.dart';
import 'package:provider/provider.dart';
 
class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});
 
  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}
 
class _BottomNavBarState extends State<BottomNavBar> {
  int _page = 0;
  final GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();
 
  final List<Widget> pages = [
    const MyHomePage(),
    const HomeScreen(),
    const NotificationScreen(),
    const Center(child: Text("Call Page")), // ganti disini
    const ProfilePage(),
  ];
 
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final primaryColor = themeProvider.primaryColor;
    final secondaryColor = themeProvider.secondaryColor;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      bottomNavigationBar: CurvedNavigationBar(
        key: _bottomNavigationKey,
        index: _page,
        height: 65.0,
        items: const <Widget>[
          Icon(
            Icons.home,
            size: 33,
            color: Constants.colorWhite,
          ),
          Icon(
            Icons.list_alt_rounded,
            size: 33,
            color: Constants.colorWhite,
          ),
          Icon(
            Icons.edit_notifications_rounded,
            size: 33,
            color: Constants.colorWhite,
          ),
          Icon(
            Icons.calendar_month_outlined,
            size: 33,
            color: Constants.colorWhite,
          ),
          Icon(
            Icons.person_pin,
            size: 33,
            color: Constants.colorWhite,
          ),
        ],
        color: primaryColor,
        buttonBackgroundColor: primaryColor,
        backgroundColor: Constants.colorWhite,
        animationCurve: Curves.easeInOut,
        animationDuration: const Duration(milliseconds: 600),
        onTap: (index) {
          setState(() {
            _page = index;
          });
        },
        letIndexChange: (index) => true,
      ),
      body: pages[_page],
    );
  }
}