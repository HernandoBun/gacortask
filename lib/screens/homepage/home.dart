import 'package:flutter/material.dart';
import 'package:gacortask/screens/menubarpage/faq_page.dart';
import 'package:gacortask/screens/taskspage/providers/task_provider.dart';
import 'package:gacortask/screens/homepage/provider/navigation_provider.dart';
import 'package:gacortask/screens/homepage/widgets/drawer_item.dart';
import 'package:gacortask/screens/homepage/widgets/drawer_items.dart';
import 'package:gacortask/screens/homepage/widgets/bar%20graph/bar_graph.dart';
import 'package:gacortask/screens/homepage/widgets/home_carousel.dart';
import 'package:gacortask/screens/menubarpage/star_task_page.dart';
import 'package:gacortask/constants.dart';
import 'package:gacortask/screens/menubarpage/contact_us_page.dart';
import 'package:gacortask/screens/notification_screen.dart';
import 'package:gacortask/sizes.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final user = FirebaseAuth.instance.currentUser;
  bool _isTasksMinimized = false;

  signout() async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    Sizes.init(context);
    final taskProvider = Provider.of<TaskProvider>(context);
    final completedTasks = taskProvider.getTasksByStatus(true);
    final pendingTasks = taskProvider.getTasksByStatus(false);
    final tasksForNext7Days = taskProvider.tasksForNext7Days;

    return Scaffold(
      key: _scaffoldKey,
      drawer: const NavigationDrawerWidget(),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            leading: IconButton(
              onPressed: () {
                _scaffoldKey.currentState!.openDrawer();
              },
              icon: const Icon(
                Icons.menu,
                color: Constants.colorWhite,
                size: 30,
              ),
            ),
            backgroundColor: Constants.colorBlueHer,
            elevation: 0,
            pinned: true,
            expandedHeight: 280.0,
            stretch: true,
            flexibleSpace: FlexibleSpaceBar(
              stretchModes: const [
                StretchMode.zoomBackground,
              ],
              background: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                child: const Image(
                  image: AssetImage(Constants.welcomeRoot),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                SafeArea(
                  child: Column(
                    children: [
                      const CarouselHome(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(left: 22),
                            child: Text(
                              Constants.textTaskOw,
                              style: TextStyle(
                                fontSize: getScreenWidth(20.0),
                                fontFamily: Constants.fontOpenSansRegular,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(left: 10),
                            padding: const EdgeInsets.symmetric(
                              vertical: 34.5,
                              horizontal: 42,
                            ),
                            decoration: BoxDecoration(
                              color: Constants.colorGrey7,
                              borderRadius:
                                  BorderRadius.circular(Constants.border),
                            ),
                            child: Column(
                              children: [
                                Text(
                                  "${completedTasks.length}",
                                  style: TextStyle(
                                    color: Constants.colorBlack,
                                    fontSize: getScreenWidth(24),
                                    fontFamily: Constants.fontOpenSansRegular,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  Constants.taskText1,
                                  style: TextStyle(
                                    color: Constants.colorBlack,
                                    fontFamily: Constants.fontOpenSansRegular,
                                    fontSize: getScreenWidth(14.5),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(right: 10),
                            padding: const EdgeInsets.symmetric(
                              vertical: 36,
                              horizontal: 38,
                            ),
                            decoration: BoxDecoration(
                              color: Constants.colorGrey7,
                              borderRadius:
                                  BorderRadius.circular(Constants.border),
                            ),
                            child: Column(
                              children: [
                                Text(
                                  "${pendingTasks.length}",
                                  style: TextStyle(
                                    color: Constants.colorBlack,
                                    fontSize: getScreenWidth(24),
                                    fontFamily: Constants.fontOpenSansRegular,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  Constants.taskText2,
                                  style: TextStyle(
                                    color: Constants.colorBlack,
                                    fontFamily: Constants.fontOpenSansRegular,
                                    fontSize: getScreenWidth(13),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      // Bar Graph
                      Container(
                        margin:
                            const EdgeInsets.only(left: 10, right: 10, top: 10),
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: Constants.colorBlue3,
                          borderRadius: BorderRadius.circular(Constants.border),
                        ),
                        child: const BarGraph(),
                      ),

                      Container(
                        margin: const EdgeInsets.only(
                          top: 10,
                          left: 11,
                          right: 11,
                          bottom: 30,
                        ),
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: Constants.colorGrey7,
                          borderRadius: BorderRadius.circular(Constants.border),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  Constants.textTask7,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontFamily: Constants.fontOpenSansRegular,
                                    fontSize: getScreenWidth(18.0),
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(
                                    _isTasksMinimized
                                        ? Icons.expand_more
                                        : Icons.expand_less,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _isTasksMinimized = !_isTasksMinimized;
                                    });
                                  },
                                ),
                              ],
                            ),
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              height: _isTasksMinimized ? 0 : null,
                              child: ListView(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                children: tasksForNext7Days.map((task) {
                                  String formattedDate =
                                      "${task.deadline.day}-${task.deadline.month}";
                                  return ListTile(
                                    leading: const Icon(Icons.calendar_today,
                                        color: Constants.colorBlue),
                                    title: Text(
                                      task.title,
                                      style: const TextStyle(
                                        fontFamily:
                                            Constants.fontOpenSansRegular,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    subtitle: Text(
                                      formattedDate,
                                      style: const TextStyle(
                                        color: Constants.colorGrey,
                                        fontFamily:
                                            Constants.fontOpenSansRegular,
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class BarGraph extends StatefulWidget {
  const BarGraph({super.key});

  @override
  State<BarGraph> createState() => _BarGraphState();
}

class _BarGraphState extends State<BarGraph> {
  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);
    final userAktif = taskProvider.tasksPerDay;

    return SizedBox(
      height: getScreenHeight(200),
      child: MyBarGraph(userAktif: userAktif),
    );
  }
}

class NavigationDrawerWidget extends StatelessWidget {
  const NavigationDrawerWidget({super.key});
  final EdgeInsets padding = const EdgeInsets.symmetric(horizontal: 20);

  @override
  Widget build(BuildContext context) {
    final EdgeInsets spaceArea =
        EdgeInsets.only(top: MediaQuery.of(context).viewPadding.top);

    final provider = Provider.of<NavigationProvider>(context);
    final isExpanded = provider.isExpanded;

    return SizedBox(
      width: isExpanded ? MediaQuery.of(context).size.width * 0.2 : null,
      child: Drawer(
        elevation: 10,
        child: Container(
          color: Constants.colorBlue6,
          child: Column(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 24).add(spaceArea),
                width: double.infinity,
                color: Constants.colorWhite12,
                child: buildHeader(isExpanded),
              ),
              SizedBox(height: getScreenHeight(24.0)),
              buildList(
                items: itemsFirst,
                isExpanded: isExpanded,
              ),
              SizedBox(height: getScreenHeight(12)),
              const Divider(color: Constants.colorWhite70),
              SizedBox(height: getScreenHeight(12)),
              buildList(
                indexOffset: itemsFirst.length,
                items: itemsSecond,
                isExpanded: isExpanded,
              ),
              SizedBox(height: getScreenHeight(12)),
              const Divider(color: Constants.colorWhite70),
              SizedBox(height: getScreenHeight(12)),
              buildList(
                indexOffset: 6,
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

  void selectItem(BuildContext context, int index) {
    navigateTo(page) => Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => page),
        );

    Navigator.of(context).pop();

    switch (index) {
      case 0:
        navigateTo(const NotificationScreen());
        break;
      case 1:
        navigateTo(const StarTaskPage());
        break;
      case 2:
        navigateTo(const NotificationScreen());
        break;
      case 3:
        navigateTo(const NotificationScreen());
        break;
      case 4:
        navigateTo(const FaqPage());
        break;
      case 5:
        navigateTo(const ContactUsPage());
        break;
      case 6:
        final myHomePageState =
            context.findAncestorStateOfType<_MyHomePageState>();
        if (myHomePageState != null) {
          myHomePageState.signout();
        }
        break;
    }
  }

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

  Widget buildHeader(bool isExpanded) => isExpanded
      ? Image.asset(
          Constants.logoRoot,
          height: getScreenHeight(48),
        )
      : Row(
          children: [
            SizedBox(
              width: getScreenWidth(20),
            ),
            Image.asset(
              Constants.logoRoot,
              height: getScreenHeight(48),
            ),
            SizedBox(
              width: getScreenWidth(12),
            ),
            Text(
              Constants.title,
              style: TextStyle(
                fontSize: getScreenWidth(24),
                color: Constants.colorWhite,
                fontFamily: Constants.fontOpenSansRegular,
              ),
            ),
          ],
        );
}
