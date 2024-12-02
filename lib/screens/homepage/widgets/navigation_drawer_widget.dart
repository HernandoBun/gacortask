import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gacortask/constants.dart';
import 'package:gacortask/screens/homepage/provider/navigation_provider.dart';
import 'package:gacortask/screens/homepage/widgets/drawer_item.dart';
import 'package:gacortask/screens/homepage/widgets/drawer_items.dart';
import 'package:gacortask/screens/menubarpage/about_us_page.dart';
import 'package:gacortask/screens/menubarpage/contact_us_page.dart';
import 'package:gacortask/screens/menubarpage/faq_page.dart';
import 'package:gacortask/screens/menubarpage/provider/theme_provider.dart';
import 'package:gacortask/screens/menubarpage/star_task_page.dart';
import 'package:gacortask/screens/menubarpage/theme_page.dart';
import 'package:gacortask/sizes.dart';
import 'package:provider/provider.dart';

class NavigationDrawerWidget extends StatefulWidget {
  const NavigationDrawerWidget({super.key});

  @override
  State<NavigationDrawerWidget> createState() => _NavigationDrawerWidgetState();
}

class _NavigationDrawerWidgetState extends State<NavigationDrawerWidget> {
  final EdgeInsets padding = const EdgeInsets.symmetric(horizontal: 20);

  // sign out function
  signout() async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final primaryColor = themeProvider.primaryColor;
    final EdgeInsets spaceArea = EdgeInsets.only(top: MediaQuery.of(context).viewPadding.top);

    final provider = Provider.of<NavigationProvider>(context);
    final isExpanded = provider.isExpanded;

    return SizedBox(
      width: isExpanded ? MediaQuery.of(context).size.width * 0.2 : null,
      child: Drawer(
        elevation: 10,
        child: Container(
          color: primaryColor,
          child: Column(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 24).add(spaceArea),
                width: double.infinity,
                color: Constants.colorWhite12,
                child: buildHeader(
                  isExpanded,
                ),
              ),
              SizedBox(height: getScreenHeight(28.0)),
              buildList(
                items: itemsFirst,
                isExpanded: isExpanded,
              ),
              SizedBox(height: getScreenHeight(20)),
              const Divider(color: Constants.colorWhite70),
              SizedBox(height: getScreenHeight(20)),
              buildList(
                indexOffset: itemsFirst.length,
                items: itemsSecond,
                isExpanded: isExpanded,
              ),
              SizedBox(height: getScreenHeight(20)),
              const Divider(color: Constants.colorWhite70),
              SizedBox(height: getScreenHeight(20)),
              buildList(
                indexOffset: 5,
                items: itemsThird,
                isExpanded: isExpanded,
              ),
              const Spacer(),
              buildCollapseIcon(context, isExpanded),
              SizedBox(height: getScreenHeight(12)),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildList(
          {required bool isExpanded,
          required List<DrawerItem> items,
          int indexOffset = 0}) =>
      ListView.separated(
        padding: isExpanded ? EdgeInsets.zero : padding,
        shrinkWrap: true,
        primary: true,
        itemCount: items.length,
        separatorBuilder: (context, index) =>
            SizedBox(height: getScreenHeight(16)),
        itemBuilder: (context, index) {
          final item = items[index];

          return buildMenuItem(
            isExpanded: isExpanded,
            text: item.title,
            icon: item.icon,
            onClicked: () => selectItem(context, indexOffset + index),
          );
        },
      );

  // untuk select item dan navigation ke page berdasarkan icon dan text yang ditekan
  void selectItem(BuildContext context, int index) {
    navigateTo(page) => Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => page),
        );

    Navigator.of(context).pop();

    switch (index) {
      case 0:
        navigateTo(const AboutUsPage());
        break;
      case 1:
        navigateTo(const StarTaskPage());
        break;
      case 2:
        navigateTo(const ThemePage());
        break;
      case 3:
        navigateTo(const FaqPage());
        break;
      case 4:
        navigateTo(const ContactUsPage());
        break;
      case 5:
        final myHomePageState =
            context.findAncestorStateOfType<_NavigationDrawerWidgetState>();
        if (myHomePageState != null) {
          myHomePageState.signout();
        }
        break;
    }
  }

  // untuk build dari menu item pada saat expanded dan pada saat collapse
  Widget buildMenuItem({
    required bool isExpanded,
    required String text,
    required IconData icon,
    VoidCallback? onClicked,
  }) {
    const color = Constants.colorWhite;
    final leading = Icon(icon, color: color);

    return Material(
      color: Constants.colorTransparent1,
      child: isExpanded
          ? ListTile(
              title: leading,
              onTap: onClicked,
            )
          : ListTile(
              leading: leading,
              title: Text(
                text,
                style: TextStyle(color: color, fontSize: getScreenWidth(16)),
              ),
              onTap: onClicked,
            ),
    );
  }

  // widget untuk collapse drawer
  Widget buildCollapseIcon(BuildContext context, bool isExpanded) {
    const double size = 52;
    final icon = isExpanded ? Icons.dashboard : Icons.dashboard_outlined;
    final alignment = isExpanded ? Alignment.center : Alignment.centerRight;
    final margin = isExpanded ? null : const EdgeInsets.only(right: 16);
    final width = isExpanded ? double.infinity : size;

    return Container(
      alignment: alignment,
      margin: margin,
      child: Material(
        color: Constants.colorTransparent1,
        child: InkWell(
          child: SizedBox(
            width: width,
            height: size,
            child: Icon(
              icon,
              color: Constants.colorWhite,
            ),
          ),
          onTap: () {
            final provider =
                Provider.of<NavigationProvider>(context, listen: false);

            provider.toggleExpanded();
          },
        ),
      ),
    );
  }

  // widget build header untuk header dari menubar
  Widget buildHeader(bool isExpanded) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return isExpanded
            ? Image.asset(
                themeProvider.logoImage,
                height: getScreenHeight(48),
              )
            : Row(
                children: [
                  SizedBox(
                    width: getScreenWidth(20),
                  ),
                  Image.asset(
                    themeProvider.logoImage,
                    height: getScreenHeight(48),
                  ),
                  SizedBox(
                    width: getScreenWidth(12),
                  ),
                  Text(
                    Constants.title,
                    style: TextStyle(
                      fontSize: getScreenWidth(24),
                      color: themeProvider.secondaryColor,
                      fontFamily: Constants.fontOpenSansRegular,
                    ),
                  ),
                ],
              );
      },
    );
  }
}