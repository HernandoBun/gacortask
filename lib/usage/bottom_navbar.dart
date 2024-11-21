import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:gacortask/constants.dart';
import 'package:gacortask/screens/home.dart';
import 'package:gacortask/screens/profile_page.dart';
import 'package:gacortask/screens/task_screen.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _page = 0;
  final GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();

  final List<Widget> pages = [
    const MyHomePage(),
    const HomeScreen(),
    const Center(child: Text("Contact Page")),
    const Center(child: Text("Call Page")),
    const ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        key: _bottomNavigationKey,
        index: _page,
        height: 65.0,
        items: const <Widget>[
          Icon(Icons.home, size: 33, color: Constants.colorBlue4),
          Icon(Icons.list, size: 33, color: Constants.colorBlue4),
          Icon(Icons.edit_notifications_rounded, size: 33, color: Constants.colorBlue4),
          Icon(Icons.calendar_month_outlined, size: 33, color: Constants.colorBlue4),
          Icon(Icons.person_pin, size: 33, color: Constants.colorBlue4),
        ],
        color: Constants.colorWhite,
        buttonBackgroundColor: Constants.colorWhite,
        backgroundColor: Constants.colorBlue4,
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
