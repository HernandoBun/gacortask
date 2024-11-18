import 'package:flutter/material.dart';
import 'package:gacortask/providers/task_provider.dart';
import 'package:intl/intl.dart';
import 'package:gacortask/widgets/task_card.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Gacor Task',
          style: TextStyle(color: Colors.blue),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.blue),
          onPressed: () {},
        ),
        actions: const [],
      ),
      body: Column(
        children: [
          // Row scrollable untuk kategori
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: SizedBox(
              height: 50,
              child: Consumer<TaskProvider>(
                builder: (context, taskProvider, child) {
                  return Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: ChoiceChip(
                          label: const Text('All'),
                          selected: taskProvider.selectedCategory == 'All',
                          onSelected: (bool selected) {
                            if (selected) {
                              taskProvider.setSelectedCategory('All');
                            }
                          },
                        ),
                      ),
                      ...taskProvider.categories
                          .where((category) => category != 'All')
                          .map((category) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4.0),
                          child: ChoiceChip(
                            label: Text(category),
                            selected: taskProvider.selectedCategory == category,
                            onSelected: (bool selected) {
                              if (selected) {
                                taskProvider.setSelectedCategory(category);
                              }
                            },
                          ),
                        );
                      }),

                      // Tombol hapus kategori yang dipindahkan ke sini
                      IconButton(
                        icon: const Icon(
                          Icons.delete_outline,
                          color: Colors.red,
                          size: 35,
                        ),
                        onPressed: () {
                          _showDeleteCategoryDialog(context);
                        },
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
          // List tugas berdasarkan kategori yang dipilih
          Expanded(
            child: Consumer<TaskProvider>(
              builder: (context, taskProvider, child) {
                // Filter tugas yang belum selesai
                final pendingTasks = taskProvider.tasks
                    .where((task) => !task.isCompleted)
                    .toList();
                // Filter tugas yang sudah selesai
                final completedTasks = taskProvider.tasks
                    .where((task) => task.isCompleted)
                    .toList();

                return ListView(
                  children: [
                    // Tugas Belum Selesai
                    if (pendingTasks.isNotEmpty) ...[
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'Tugas Belum Selesai',
                          style: TextStyle(
                              fontSize: 18.0, fontWeight: FontWeight.bold),
                        ),
                      ),
                      ...pendingTasks.map((task) {
                        final index = taskProvider.tasks.indexOf(task);
                        return TaskCard(task: task, index: index);
                      }),
                    ],

                    // Separator jika ada tugas selesai
                    if (completedTasks.isNotEmpty)
                      const Divider(height: 20, thickness: 2),

                    // Tugas Sudah Selesai
                    if (completedTasks.isNotEmpty) ...[
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'Tugas Sudah Selesai',
                          style: TextStyle(
                              fontSize: 18.0, fontWeight: FontWeight.bold),
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
                  title: const Text('Tambah Tugas Baru'),
                  content: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextField(
                          controller: titleController,
                          decoration: InputDecoration(
                            labelText: 'Judul Tugas',
                            errorText: _isTitleDuplicate(
                                    taskProvider, titleController.text)
                                ? 'Judul Tugas sudah ada!'
                                : null,
                          ),
                        ),
                        // Dropdown untuk kategori
                        DropdownButtonFormField<String>(
                          value: selectedCategory,
                          hint: const Text("Pilih Kategori"),
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
                                child: Text('Tambah Kategori Baru'),
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
                        // Dropdown untuk memilih prioritas
                        DropdownButtonFormField<int>(
                          value: selectedPriority,
                          hint: const Text("Pilih Prioritas (1-5)"),
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
                      child: const Text('Batal'),
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
                          taskProvider.addTask(
                            titleController.text,
                            '${selectedDate!.toIso8601String()} ${selectedTime!.format(context)}',
                            selectedCategory!,
                            selectedPriority!,
                          );
                          Navigator.of(context).pop();
                        }
                      },
                      child: const Text('Simpan'),
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
              title: const Text('Tambah Kategori Baru'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: categoryController,
                    decoration: InputDecoration(
                      labelText: 'Nama Kategori',
                      errorText: errorMessage,
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Batal'),
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
                  child: const Text('Simpan'),
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
              title: const Text('Hapus Kategori'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButton<String>(
                    hint: const Text('Pilih kategori untuk dihapus'),
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
