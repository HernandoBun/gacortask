import 'package:flutter/material.dart';
import 'package:gacortask/constants.dart';
import 'package:gacortask/screens/menubarpage/provider/theme_provider.dart';
import 'package:gacortask/screens/taskspage/models/task_models.dart' as models;
import 'package:gacortask/screens/taskspage/providers/task_provider.dart';
import 'package:gacortask/sizes.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class TaskCard extends StatelessWidget {
  final models.Task task;
  final int index;

  const TaskCard({super.key, required this.task, required this.index});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTap: () {
        context.read<TaskProvider>().toggleTaskCompletion(index);
      },
      onLongPress: () {
        _showUpdateTaskDialog(context);
      },
      child: Card(
        margin: EdgeInsets.symmetric(
            vertical: getScreenHeight(8.0), horizontal: getScreenHeight(16.0)),
        elevation: 4.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Container(
          color:
              task.isCompleted ? Constants.colorGreen1 : Constants.colorWhite,
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Text(
                        task.title,
                        style: TextStyle(
                          fontSize: getScreenWidth(18.0),
                          fontWeight: FontWeight.bold,
                          decoration: task.isCompleted
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                          fontFamily: Constants.fontOpenSansRegular,
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      _showDeleteTaskDialog(context, index);
                    },
                    child: const Icon(
                      Icons.delete_outline,
                      color: Constants.colorRedto,
                      size: 35,
                    ),
                  ),
                ],
              ),
              Text(
                'Waktu: ${DateFormat('yyyy-MM-dd HH:mm').format(task.deadline)}',
                style: TextStyle(
                  color: Constants.colorBlack,
                  fontSize: getScreenWidth(14.0),
                  fontFamily: Constants.fontOpenSansRegular,
                ),
              ),
              const SizedBox(height: 4.0),
              Text(
                'Kategori: ${task.category}',
                style: TextStyle(
                  color: Constants.colorGrey9,
                  fontSize: getScreenWidth(14.0),
                  fontFamily: Constants.fontOpenSansRegular,
                ),
              ),
              SizedBox(
                height: getScreenHeight(8.0),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Prioritas: ${task.priorityLevel}',
                    style: TextStyle(
                      fontSize: getScreenWidth(16.0),
                      fontFamily: Constants.fontOpenSansRegular,
                    ),
                  ),
                  _buildPriorityDropdown(context),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPriorityDropdown(BuildContext context) {
    return Consumer<ThemeProvider>(builder: (context, themeProvider, child) {
      return SizedBox(
        width: getScreenWidth(80.0),
        child: DropdownButtonFormField<int>(
          value: task.priorityLevel,
          decoration: InputDecoration(
            labelText: Constants.labelPrioritas,
            labelStyle:
                const TextStyle(fontFamily: Constants.fontOpenSansRegular),
            filled: true,
            fillColor: Constants.colorGrey6,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(Constants.border12),
            ),
          ),
          items: List.generate(5, (index) {
            return DropdownMenuItem<int>(
              value: index + 1,
              child: Text(
                '${index + 1}',
                style: const TextStyle(
                  fontFamily: Constants.fontOpenSansRegular,
                ),
              ),
            );
          }).toList(),
          onChanged: (newPriority) {
            if (newPriority != null) {
              context.read<TaskProvider>().setTaskPriority(index, newPriority);
            }
          },
          icon: Icon(
            Icons.arrow_drop_down_circle,
            color: themeProvider.primaryColor,
            size: 30,
          ),
          iconSize: 24,
          style: const TextStyle(
            color: Constants.colorBlack,
            fontFamily: Constants.fontOpenSansRegular,
          ),
          dropdownColor: Constants.colorWhite,
          elevation: 16,
        ),
      );
    });
  }

  void _showUpdateTaskDialog(BuildContext context) {
    final taskProvider = context.read<TaskProvider>();
    final TextEditingController titleController =
        TextEditingController(text: task.title);
    DateTime selectedDate = task.deadline;
    TimeOfDay? selectedTime = TimeOfDay.fromDateTime(task.deadline);
    String? selectedCategory = task.category;
    int selectedPriority = task.priorityLevel;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Update Task'),
              content: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: titleController,
                      decoration:
                          const InputDecoration(labelText: 'Task Title'),
                    ),
                    DropdownButtonFormField<String>(
                      value: selectedCategory,
                      hint: const Text('Select Category'),
                      items: taskProvider.categories
                          .where((category) => category != 'All')
                          .map((category) {
                        return DropdownMenuItem(
                          value: category,
                          child: Text(category),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedCategory = value;
                        });
                      },
                    ),
                    DropdownButtonFormField<int>(
                      value: selectedPriority,
                      hint: const Text('Select Priority'),
                      items: List.generate(5, (index) {
                        return DropdownMenuItem<int>(
                          value: index + 1,
                          child: Text('${index + 1}'),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedPriority = value!;
                        });
                      },
                    ),
                    Row(
                      children: [
                        Text(
                          DateFormat('yyyy-MM-dd').format(selectedDate),
                        ),
                        const Spacer(),
                        IconButton(
                          icon: const Icon(Icons.calendar_today),
                          onPressed: () async {
                            final pickedDate = await showDatePicker(
                              context: context,
                              initialDate: selectedDate,
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2101),
                            );
                            if (pickedDate != null) {
                              setState(() {
                                selectedDate = pickedDate;
                              });

                              final pickedTime = await showTimePicker(
                                context: context,
                                initialTime: selectedTime ?? TimeOfDay.now(),
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
                    if (selectedTime != null)
                      Text('${selectedTime?.format(context)}'),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    if (titleController.text.isNotEmpty &&
                        selectedCategory != null &&
                        selectedTime != null) {
                      final deadline = DateTime(
                        selectedDate.year,
                        selectedDate.month,
                        selectedDate.day,
                        selectedTime!.hour,
                        selectedTime!.minute,
                      );

                      taskProvider.updateTaskDate(index, deadline);
                      taskProvider.setTaskPriority(index, selectedPriority);

                      task.title = titleController.text;
                      task.category = selectedCategory!;

                      taskProvider.saveTasks();
                      Navigator.of(context).pop();
                    }
                  },
                  child: const Text('Update'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showDeleteTaskDialog(BuildContext context, int taskIndex) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            Constants.textConfirmBatal,
            style: TextStyle(
              fontFamily: Constants.fontOpenSansRegular,
            ),
          ),
          content: Text(
            'Apakah Anda yakin ingin menghapus tugas "${task.title}"?',
            style: const TextStyle(
              fontFamily: Constants.fontOpenSansRegular,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                Constants.textBatal,
                style: TextStyle(
                  fontFamily: Constants.fontOpenSansRegular,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                context.read<TaskProvider>().deleteTask(taskIndex);
                Navigator.of(context).pop();
              },
              child: const Text(
                Constants.textHapus,
                style: TextStyle(
                  fontFamily: Constants.fontOpenSansRegular,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
