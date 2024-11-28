import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gacortask/screens/taskspage/models/task_models.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TaskProvider with ChangeNotifier {
  List<Task> _tasks = [];
  List<String> _categories = [];
  String _selectedCategory = "All";

  List<Task> get tasks {
    if (_selectedCategory == "All" || _selectedCategory.isEmpty) {
      return _tasks;
    }
    return _tasks.where((task) => task.category == _selectedCategory).toList();
  }

  List<Task> getTasksByStatus(bool isCompleted) {
    return _tasks.where((task) => task.isCompleted == isCompleted).toList();
  }

  List<int> _tasksPerDay = List.generate(7, (index) => 0);

  List<int> get tasksPerDay => _tasksPerDay;

  List<String> get categories => ["All", ..._categories];

  List<Task> get tasksForNext7Days {
    DateTime currentDate = DateTime.now();
    DateTime endDate = currentDate.add(const Duration(days: 7));

    return _tasks.where((task) {
      return task.deadline.isAfter(currentDate) &&
          task.deadline.isBefore(endDate) &&
          !task.isCompleted;
    }).toList();
  }

  String get selectedCategory => _selectedCategory;

  TaskProvider() {
    loadTasks();
    loadCategories();
    loadTaskActivity();
  }

  void setSelectedCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  Future<void> loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final tasksJson = prefs.getString('tasks');
    if (tasksJson != null) {
      final List<dynamic> taskList = jsonDecode(tasksJson);
      _tasks = taskList.map((task) => Task.fromMap(task)).toList();
    } else {
      _tasks = [];
    }
    notifyListeners();
  }

  Future<void> saveTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final tasksJson = jsonEncode(_tasks.map((task) => task.toMap()).toList());
    await prefs.setString('tasks', tasksJson);
  }

  void addTask(String title, DateTime deadline, String category,
      [int priorityLevel = 0]) {
    final newTask = Task(
      title: title,
      deadline: deadline,
      category: category,
      priorityLevel: priorityLevel,
    );
    _tasks.add(newTask);
    _tasks.sort((a, b) => b.priorityLevel.compareTo(a.priorityLevel));
    saveTasks();
    _updateTaskActivity(deadline);
    saveTaskActivity();
    notifyListeners();
  }

  void _updateTaskActivity(DateTime deadline) {
    final dayOfWeek = deadline.weekday;
    _tasksPerDay[dayOfWeek] += 1;
  }

  Future<void> saveTaskActivity() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('tasks_per_day', jsonEncode(_tasksPerDay));
  }

  Future<void> loadTaskActivity() async {
    final prefs = await SharedPreferences.getInstance();
    final tasksPerDayJson = prefs.getString('tasks_per_day');
    if (tasksPerDayJson != null) {
      final List<dynamic> taskActivityList = jsonDecode(tasksPerDayJson);
      _tasksPerDay = taskActivityList.cast<int>();
    }
    notifyListeners();
  }

  void deleteTask(int index) {
    _tasks.removeAt(index);
    saveTasks();
    notifyListeners();
  }

  void updateTaskDate(int index, DateTime newDate) {
    _tasks[index].deadline = newDate;
    saveTasks();
    notifyListeners();
  }

  void setTaskPriority(int index, int priorityLevel) {
    _tasks[index].priorityLevel = priorityLevel;
    _tasks.sort((a, b) => b.priorityLevel.compareTo(a.priorityLevel));
    saveTasks();
    notifyListeners();
  }

  void addCategory(String category) {
    if (!_categories.contains(category)) {
      _categories.add(category);
      saveCategories();
      notifyListeners();
    }
  }

  Future<void> loadCategories() async {
    final prefs = await SharedPreferences.getInstance();
    final categoriesJson = prefs.getString('categories');
    if (categoriesJson != null) {
      final List<dynamic> categoryList = jsonDecode(categoriesJson);
      _categories = categoryList.cast<String>();
      notifyListeners();
    }
  }

  Future<void> saveCategories() async {
    final prefs = await SharedPreferences.getInstance();
    final categoriesJson = jsonEncode(_categories);
    await prefs.setString('categories', categoriesJson);
  }

  void deleteCategory(String category) {
    if (_categories.contains(category)) {
      _categories.remove(category);
      _tasks.removeWhere((task) => task.category == category);
      saveCategories();
      saveTasks();
      notifyListeners();
    }
  }

  void toggleTaskCompletion(int index) {
    _tasks[index].toggleCompleted();
    saveTasks();
    notifyListeners();
  }
}