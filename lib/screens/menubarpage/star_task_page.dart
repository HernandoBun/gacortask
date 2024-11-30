import 'package:flutter/material.dart';
import 'package:gacortask/constants.dart';
import 'package:gacortask/screens/menubarpage/provider/theme_provider.dart';
import 'package:gacortask/screens/taskspage/providers/task_provider.dart';
import 'package:gacortask/sizes.dart';
import 'package:gacortask/screens/taskspage/widgets/task_card.dart';
import 'package:provider/provider.dart';
 
class StarTaskPage extends StatefulWidget {
  const StarTaskPage({super.key});
 
  @override
  State<StarTaskPage> createState() => _StarTaskPageState();
}
 
class _StarTaskPageState extends State<StarTaskPage> {
  int? selectedPriority = 1;
 
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final primaryColor = themeProvider.primaryColor;
    final secondaryColor = themeProvider.secondaryColor;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Star Task",
          style: TextStyle(fontFamily: Constants.fontOpenSansRegular),
        ),
        backgroundColor: primaryColor,
        foregroundColor: secondaryColor,
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: getScreenHeight(8.0)),
            child: Consumer<TaskProvider>(
              builder: (context, taskProvider, child) {
                return SizedBox(
                  height: getScreenHeight(60.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: 5,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 4.0),
                              child: ChoiceChip(
                                label: Text('${index + 1}'),
                                selected: selectedPriority == index + 1,
                                onSelected: (bool selected) {
                                  setState(() {
                                    selectedPriority =
                                        selected ? index + 1 : null;
                                  });
                                },
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: Consumer<TaskProvider>(
              builder: (context, taskProvider, child) {
                final filteredTasks = taskProvider.tasks
                    .where((task) => task.priorityLevel == selectedPriority)
                    .toList();
 
                return ListView(
                  children: [
                    if (filteredTasks.isNotEmpty) ...[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          Constants.textNotDone,
                          style: TextStyle(
                            fontSize: getScreenWidth(18.0),
                            fontWeight: FontWeight.bold,
                            fontFamily: Constants.fontOpenSansRegular,
                          ),
                        ),
                      ),
                      ...filteredTasks.map((task) {
                        final index = taskProvider.tasks.indexOf(task);
                        return TaskCard(task: task, index: index);
                      }),
                    ],
                    if (filteredTasks.isEmpty)
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          Constants.textStp,
                          style: TextStyle(
                            fontSize: getScreenWidth(16.0),
                            fontWeight: FontWeight.normal,
                            fontFamily: Constants.fontOpenSansRegular,
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}