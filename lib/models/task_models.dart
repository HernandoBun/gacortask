import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Task {
  final String title;
  String time;
  String category;
  int priorityLevel;
  bool isCompleted;
  DateTime? dueDate;

  Task({
    required this.title,
    required this.time,
    required this.category,
    this.priorityLevel = 0,
    this.isCompleted = false,
    this.dueDate,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'time': time,
      'category': category,
      'priorityLevel': priorityLevel,
      'isCompleted': isCompleted,
      'dueDate': dueDate?.toIso8601String(),
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      title: map['title'],
      time: map['time'],
      category: map['category'] ?? '',
      priorityLevel: map['priorityLevel'] ?? 0,
      isCompleted: map['isCompleted'],
      dueDate: map['dueDate'] != null ? DateTime.parse(map['dueDate']) : null,
    );
  }

  void toggleCompleted() {
    isCompleted = !isCompleted;
  }
}

class TaskProvider with ChangeNotifier {
  List<Task> _tasks = [];

  List<Task> get tasks => List.unmodifiable(_tasks);

  TaskProvider() {
    loadTasks();
  }

  void addTask(String text, String s, {
    required String title,
    required String time,
    required String category,
    String? description,
    int priorityLevel = 0,
    DateTime? dueDate,
  }) {
    final newTask = Task(
      title: title,
      time: time,
      category: category,
      priorityLevel: priorityLevel,
      dueDate: dueDate,
    );
    _tasks.add(newTask);
    saveTasks();
    notifyListeners();
  }

  void saveTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final String tasksJson =
        jsonEncode(_tasks.map((task) => task.toMap()).toList());
    await prefs.setString('tasks', tasksJson);
  }

  void loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final String? tasksJson = prefs.getString('tasks');
    if (tasksJson != null) {
      final List<dynamic> taskList = jsonDecode(tasksJson);
      _tasks = taskList.map((task) => Task.fromMap(task)).toList().cast<Task>();
      notifyListeners();
    }
  }

  void toggleTaskStatus(int index) {
    _tasks[index].toggleCompleted();
    saveTasks();
    notifyListeners();
  }

  void deleteTask(int index) {
    _tasks.removeAt(index);
    saveTasks();
    notifyListeners();
  }

  void deleteAllTasks() {
    _tasks.clear();
    saveTasks();
    notifyListeners();
  }

  void setTaskPriority(int index, int priorityLevel) {
    _tasks[index].priorityLevel = priorityLevel;
    saveTasks();
    notifyListeners();
  }

  void updateTaskDate(int index, DateTime pickedDate) {
    _tasks[index].dueDate = pickedDate;
    saveTasks();
    notifyListeners();
  }

  List<Task> filterTasksByCategory(String category) {
    return _tasks.where((task) => task.category == category).toList();
  }

  List<Task> get tasksSortedByPriority {
    List<Task> sortedTasks = List.from(_tasks);
    sortedTasks.sort((a, b) => b.priorityLevel.compareTo(a.priorityLevel));
    return sortedTasks;
  }

  get selectedCategory => null;

  get categories => null;

  void setSelectedCategory(String s) {}
}
