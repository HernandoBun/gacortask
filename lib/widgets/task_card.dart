import 'package:flutter/material.dart';
import 'package:gacortask/models/task_models.dart' as models;
import 'package:gacortask/providers/task_provider.dart';
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
        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        elevation: 4.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Container(
          color: task.isCompleted ? Colors.green[100] : Colors.white,
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
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      decoration: task.isCompleted
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                      fontFamily: 'Roboto',
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      _showDeleteTaskDialog(context, index);
                    },
                    child: const Icon(
                      Icons.delete_outline,
                      color: Colors.red,
                      size: 35,
                    ),
                  ),
                ],
              ),
              Text(
                'Waktu: ${task.time}',
                style: const TextStyle(color: Colors.black, fontSize: 14.0),
              ),
              const SizedBox(height: 4.0),
              Text(
                'Kategori: ${task.category}',
                style: const TextStyle(color: Colors.grey, fontSize: 14.0),
              ),
              const SizedBox(height: 8.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Prioritas: ${task.priorityLevel}',
                    style:
                        const TextStyle(fontSize: 16.0, fontFamily: 'Roboto'),
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
      width: 80.0,
      child: DropdownButtonFormField<int>(
        value: task.priorityLevel,
        decoration: InputDecoration(
          labelText: 'Prioritas',
          labelStyle: const TextStyle(fontFamily: 'Roboto'),
          filled: true,
          fillColor: Colors.grey.shade200,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        items: List.generate(5, (index) {
          return DropdownMenuItem<int>(
            value: index + 1,
            child: Text('${index + 1}'),
          );
        }).toList(),
        onChanged: (newPriority) {
          if (newPriority != null) {
            context.read<TaskProvider>().setTaskPriority(index, newPriority);
          }
        },
        icon: const Icon(
          Icons.arrow_drop_down_circle,
          color: Colors.blueAccent,
          size: 30,
        ),
        iconSize: 24,
        style: const TextStyle(color: Colors.black),
        dropdownColor: Colors.white,
        elevation: 16,
      ),
    );
  }

  void _showDeleteTaskDialog(BuildContext context, int taskIndex) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Konfirmasi Hapus Tugas'),
          content: const Text('Apakah Anda yakin ingin menghapus tugas ini?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                context.read<TaskProvider>().deleteTask(taskIndex);
                Navigator.of(context).pop();
              },
              child: const Text('Hapus'),
            ),
          ],
        );
      },
    );
  }
}
