import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
 
class Task {
  final String title;
  DateTime deadline;
  String category;
  int priorityLevel;
  bool isCompleted;
 
  Task({
    required this.title,
    required this.deadline,
    required this.category,
    this.priorityLevel = 0,
    this.isCompleted = false,
  });
 
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'deadline': deadline.toIso8601String(),
      'category': category,
      'priorityLevel': priorityLevel,
      'isCompleted': isCompleted,
    };
  }
 
  // void clearData() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   await prefs.clear();
  // }
 
  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      title: map['title'] ?? '',
      deadline: map['deadline'] != null
          ? DateTime.parse(map['deadline'])
          : DateTime.now(),
      category: map['category'] ?? '',
      priorityLevel: map['priorityLevel'] ?? 0,
      isCompleted: map['isCompleted'] ?? false,
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
 
  void addTask({
    required String title,
    required DateTime deadline,
    required String category,
    String? description,
    int priorityLevel = 0,
  }) {
    final newTask = Task(
      title: title,
      category: category,
      priorityLevel: priorityLevel,
      deadline: deadline,
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
    _tasks[index].deadline = pickedDate;
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