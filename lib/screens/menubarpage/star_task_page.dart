import 'package:flutter/material.dart';
import 'package:gacortask/constants.dart';
import 'package:gacortask/screens/taskspage/providers/task_provider.dart';
import 'package:gacortask/sizes.dart';
import 'package:intl/intl.dart';
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
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Star Task",
          style: TextStyle(fontFamily: Constants.fontOpenSansRegular),
        ),
        backgroundColor: Constants.colorBlueHer,
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: getScreenHeight(8.0)),
            child: Consumer<TaskProvider>(
              builder: (context, taskProvider, child) {
                return SizedBox(
                  height: getScreenHeight(80.0),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddTaskDialog(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddTaskDialog(BuildContext context) {
    final titleController = TextEditingController();
    DateTime? selectedDate;
    TimeOfDay? selectedTime;
    String? selectedCategory;
    int? selectedPriority;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Consumer<TaskProvider>(
              builder: (context, taskProvider, child) {
                return AlertDialog(
                  title: const Text(Constants.titleNewTask),
                  content: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextField(
                          controller: titleController,
                          decoration: InputDecoration(
                            labelText: Constants.labelTitleTask,
                            errorText: _isTitleDuplicate(
                              taskProvider,
                              titleController.text,
                            )
                                ? Constants.textAlreadyTask
                                : null,
                          ),
                        ),
                        DropdownButtonFormField<int>(
                          value: selectedPriority,
                          hint: const Text(Constants.textChoosePriority),
                          items: List.generate(5, (index) {
                            return DropdownMenuItem<int>(
                              value: index + 1,
                              child: Text('${index + 1}'),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedPriority = value;
                            });
                          },
                        ),
                        Row(
                          children: [
                            Text(
                              selectedDate == null
                                  ? 'Pilih Tanggal'
                                  : DateFormat('yyyy-MM-dd')
                                      .format(selectedDate!),
                            ),
                            const Spacer(),
                            IconButton(
                              icon: const Icon(Icons.calendar_today),
                              onPressed: () async {
                                final pickedDate = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(2000),
                                  lastDate: DateTime(2101),
                                );
                                if (pickedDate != null) {
                                  setState(() {
                                    selectedDate = pickedDate;
                                  });

                                  final pickedTime = await showTimePicker(
                                    context: context,
                                    initialTime: TimeOfDay.now(),
                                  );
                                  if (pickedTime != null) {
                                    setState(() {
                                      selectedTime = pickedTime;
                                    });
                                  }
                                }
                              },
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              selectedTime == null
                                  ? ''
                                  : selectedTime!.format(context),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text(
                        Constants.textBatal,
                        style: TextStyle(
                          fontFamily: Constants.fontOpenSansRegular,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        if (titleController.text.isNotEmpty &&
                            selectedPriority != null &&
                            selectedDate != null &&
                            selectedTime != null &&
                            !_isTitleDuplicate(
                                taskProvider, titleController.text)) {
                          final deadline = DateTime(
                            selectedDate!.year,
                            selectedDate!.month,
                            selectedDate!.day,
                            selectedTime!.hour,
                            selectedTime!.minute,
                          );
                          taskProvider.addTask(
                            titleController.text,
                            deadline,
                            selectedCategory!,
                            selectedPriority!,
                          );

                          Navigator.of(context).pop();
                        }
                      },
                      child: const Text(
                        Constants.textSimpan,
                        style: TextStyle(
                          fontFamily: Constants.fontOpenSansRegular,
                        ),
                      ),
                    ),
                  ],
                );
              },
            );
          },
        );
      },
    );
  }

  bool _isTitleDuplicate(TaskProvider taskProvider, String title) {
    return taskProvider.tasks.any((task) => task.title == title);
  }
}
