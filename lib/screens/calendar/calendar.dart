import 'package:flutter/material.dart';
import 'package:gacortask/constants.dart';
import 'package:gacortask/screens/menubarpage/provider/theme_provider.dart';
import 'package:gacortask/sizes.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:gacortask/screens/taskspage/providers/task_provider.dart';
import 'package:table_calendar/table_calendar.dart';

// calendar screen yang menampilkan tugas pada hari yang ditentukan sesuai deadline
class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final primaryColor = themeProvider.primaryColor;
    final secondaryColor = themeProvider.secondaryColor;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          Constants.titleCalendar,
          style: TextStyle(color: secondaryColor),
        ),
        backgroundColor: primaryColor,
      ),
      body: Column(
        children: [
          TableCalendar(
            focusedDay: _focusedDay,
            firstDay: DateTime.utc(2000, 1, 1),
            lastDay: DateTime.utc(2100, 12, 31),
            calendarFormat: _calendarFormat,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            onFormatChanged: (format) {
              setState(() {
                _calendarFormat = format;
              });
            },
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
            eventLoader: (day) {
              return _getEventsForDay(day, context);
            },
          ),
          Divider(
            height: getScreenHeight(10.0),
          ),
          SizedBox(height: getScreenHeight(10.0)),
          ..._getEventsForDay(_selectedDay ?? _focusedDay, context).map(
            (event) => ListTile(
              title: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: primaryColor,
                    width: getScreenWidth(3.0),
                  ),
                  borderRadius: BorderRadius.circular(Constants.border),
                ),
                padding: EdgeInsets.symmetric(
                    vertical: getScreenHeight(8.0),
                    horizontal: getScreenWidth(12.0)),
                child: Text(
                  event,
                  style: TextStyle(
                    fontSize: getScreenWidth(16.0),
                    fontWeight: FontWeight.bold,
                    fontFamily: Constants.fontOpenSansRegular,
                    color: primaryColor,
                  ),
                ),
              ),
              leading: Icon(
                Icons.calendar_month_rounded,
                color: primaryColor,
              ),
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
}

List<String> _getEventsForDay(DateTime day, BuildContext context) {
  final tasks = context.watch<TaskProvider>().tasks;
  List<String> eventsForDay = [];

  for (var task in tasks) {
    if (isSameDay(task.deadline, day) && !task.isCompleted) {
      eventsForDay.add(task.title);
    }
  }

  return eventsForDay;
}
