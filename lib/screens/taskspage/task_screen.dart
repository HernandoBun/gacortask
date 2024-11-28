import 'package:flutter/material.dart';
import 'package:gacortask/constants.dart';
import 'package:gacortask/screens/taskspage/providers/task_provider.dart';
import 'package:intl/intl.dart';
import 'package:gacortask/screens/taskspage/widgets/task_card.dart';
import 'package:gacortask/sizes.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Consumer<TaskProvider>(
              builder: (context, taskProvider, child) {
                return SizedBox(
                  height: 80,
                  child: Row(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: taskProvider.categories.length,
                          itemBuilder: (context, index) {
                            if (index == 0) {
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 4.0),
                                child: ChoiceChip(
                                  label: const Text(Constants.textAll),
                                  selected:
                                      taskProvider.selectedCategory == 'All',
                                  onSelected: (bool selected) {
                                    if (selected) {
                                      taskProvider.setSelectedCategory('All');
                                    }
                                  },
                                ),
                              );
                            }
                            String category = taskProvider.categories[index];
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 4.0),
                              child: ChoiceChip(
                                label: Text(category),
                                selected:
                                    taskProvider.selectedCategory == category,
                                onSelected: (bool selected) {
                                  if (selected) {
                                    taskProvider.setSelectedCategory(category);
                                  }
                                },
                              ),
                            );
                          },
                        ),
                      ),
IconButton(
                        icon: Icon(
                          Icons.delete_outline,
                          color: Constants.colorRedto,
                          size: getScreenWidth(30),
                        ),
                        onPressed: () {
                          _showDeleteCategoryDialog(context);
                        },
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.more_vert_rounded,
                          color: Constants.colorGrey,
                          size: getScreenWidth(30),
                        ),
                        onPressed: () {
                          _showDeleteCategoryDialog(context);
                        },
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
                final pendingTasks = taskProvider.tasks
                    .where((task) => !task.isCompleted)
                    .toList();
                final completedTasks = taskProvider.tasks
                    .where((task) => task.isCompleted)
                    .toList();

                return ListView(
                  children: [
                    if (pendingTasks.isNotEmpty) ...[
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          Constants.textNotDone,
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      ...pendingTasks.map((task) {
                        final index = taskProvider.tasks.indexOf(task);
                        return TaskCard(task: task, index: index);
                      }),
                    ],
                    if (completedTasks.isNotEmpty)
                      const Divider(height: 20, thickness: 2),
                    if (completedTasks.isNotEmpty) ...[
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          Constants.textDone,
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      ...completedTasks.map((task) {
                        final index = taskProvider.tasks.indexOf(task);
                        return TaskCard(task: task, index: index);
                      }),
                    ],
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
                        DropdownButtonFormField<String>(
                          value: selectedCategory,
                          hint: const Text(Constants.textChooseTask),
                          items: taskProvider.categories
                              .where((category) => category != 'All')
                              .map((category) {
                            return DropdownMenuItem(
                              value: category,
                              child: Text(category),
                            );
                          }).toList()
                            ..add(
                              const DropdownMenuItem<String>(
                                value: 'addNewCategory',
                                child: Text(Constants.textNewCategory),
                              ),
                            ),
                          onChanged: (value) {
                            if (value == 'addNewCategory') {
                              _showAddCategoryDialog(context);
                            } else {
                              setState(() {
                                selectedCategory = value;
                              });
                            }
                          },
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
                      child: const Text(Constants.textBatal),
                    ),
                    TextButton(
                      onPressed: () {
                        if (titleController.text.isNotEmpty &&
                            selectedCategory != null &&
                            selectedDate != null &&
                            selectedTime != null &&
                            selectedPriority != null &&
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
                      child: const Text(Constants.textSimpan),
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

  void _showAddCategoryDialog(BuildContext context) {
    final categoryController = TextEditingController();
    String? errorMessage;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text(Constants.textNewCategory),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: categoryController,
                    decoration: InputDecoration(
                      labelText: Constants.labelNameCategory,
                      errorText: errorMessage,
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text(Constants.textBatal),
                ),
                TextButton(
                  onPressed: () {
                    final newCategory = categoryController.text.trim();
                    if (newCategory.isNotEmpty) {
                      final taskProvider = context.read<TaskProvider>();
                      if (taskProvider.categories.contains(newCategory)) {
                        setState(() {
                          errorMessage = 'Kategori sudah ada!';
                        });
                      } else {
                        taskProvider.addCategory(newCategory);
                        Navigator.of(context).pop();
                      }
                    } else {
                      setState(() {
                        errorMessage = 'Nama kategori tidak boleh kosong!';
                      });
                    }
                  },
                  child: const Text(Constants.textSimpan),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showDeleteCategoryDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return Consumer<TaskProvider>(
          builder: (context, taskProvider, child) {
            return AlertDialog(
              title: const Text(Constants.textCleanCategory),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButton<String>(
                    hint: const Text(Constants.textChooseCategoryClean),
                    items: taskProvider.categories
                        .where((category) => category != "All")
                        .map((category) {
                      return DropdownMenuItem<String>(
                        value: category,
                        child: Text(category),
                      );
                    }).toList(),
                    onChanged: (category) {
                      if (category != null) {
                        taskProvider.deleteCategory(category);
                        Navigator.of(context).pop();
                      }
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
