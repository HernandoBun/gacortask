import 'package:flutter/material.dart';
import 'package:gacortask/constants.dart';
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
                  Text(
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
        icon: const Icon(
          Icons.arrow_drop_down_circle,
          color: Constants.colorBlue5,
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
