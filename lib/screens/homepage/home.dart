import 'package:flutter/material.dart';
import 'package:gacortask/screens/homepage/widgets/bar.dart';
import 'package:gacortask/screens/homepage/widgets/navigation_drawer_widget.dart';
import 'package:gacortask/screens/menubarpage/provider/theme_provider.dart';
import 'package:gacortask/screens/taskspage/providers/task_provider.dart';
import 'package:gacortask/screens/homepage/widgets/home_carousel.dart';
import 'package:gacortask/constants.dart';
import 'package:gacortask/sizes.dart';
import 'package:provider/provider.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isTasksMinimized = false;

  @override
  Widget build(BuildContext context) {
    Sizes.init(context);
    final taskProvider = Provider.of<TaskProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final completedTasks = taskProvider.getTasksByStatus(true);
    final pendingTasks = taskProvider.getTasksByStatus(false);
    final tasksForNext7Days = taskProvider.tasksForNext7Days;
    final primaryColor = themeProvider.primaryColor;
    final secondaryColor = themeProvider.secondaryColor;
    final welcomeImage = themeProvider.welcomeImage;

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
              icon: Icon(
                Icons.menu,
                color: secondaryColor,
                size: 30,
              ),
            ),
            backgroundColor: primaryColor,
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
                child: Image(
                  image: AssetImage(welcomeImage),
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
                              color: primaryColor,
                              borderRadius:
                                  BorderRadius.circular(Constants.border),
                            ),
                            child: Column(
                              children: [
                                Text(
                                  "${completedTasks.length}",
                                  style: TextStyle(
                                    color: secondaryColor,
                                    fontSize: getScreenWidth(24),
                                    fontFamily: Constants.fontOpenSansRegular,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  Constants.taskText1,
                                  style: TextStyle(
                                    color: secondaryColor,
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
                              color: primaryColor,
                              borderRadius:
                                  BorderRadius.circular(Constants.border),
                            ),
                            child: Column(
                              children: [
                                Text(
                                  "${pendingTasks.length}",
                                  style: TextStyle(
                                    color: secondaryColor,
                                    fontSize: getScreenWidth(24),
                                    fontFamily: Constants.fontOpenSansRegular,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  Constants.taskText2,
                                  style: TextStyle(
                                    color: secondaryColor,
                                    fontFamily: Constants.fontOpenSansRegular,
                                    fontSize: getScreenWidth(13),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Container(
                        margin:
                            const EdgeInsets.only(left: 10, right: 10, top: 10),
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: primaryColor,
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
                          color: primaryColor,
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
                                    color: secondaryColor,
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(
                                    _isTasksMinimized
                                        ? Icons.expand_more
                                        : Icons.expand_less,
                                    color: secondaryColor,
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
                                    leading: Icon(
                                      Icons.calendar_today,
                                      color: secondaryColor,
                                    ),
                                    title: Text(
                                      task.title,
                                      style: TextStyle(
                                        fontFamily:
                                            Constants.fontOpenSansRegular,
                                        fontWeight: FontWeight.bold,
                                        color: secondaryColor,
                                      ),
                                    ),
                                    subtitle: Text(
                                      formattedDate,
                                      style: TextStyle(
                                        color: secondaryColor,
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