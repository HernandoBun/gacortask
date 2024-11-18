import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gacortask/models/task_models.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TaskProvider with ChangeNotifier {
  List<Task> _tasks = [];
  List<String> _categories = [];
  String _selectedCategory = "All";

  // Getter untuk mendapatkan daftar tugas sesuai kategori
  List<Task> get tasks {
    if (_selectedCategory == "All" || _selectedCategory.isEmpty) {
      return _tasks;
    }
    return _tasks.where((task) => task.category == _selectedCategory).toList();
  }

  List<Task> getTasksByStatus(bool isCompleted) {
    return _tasks.where((task) => task.isCompleted == isCompleted).toList();
  }

  // Getter untuk daftar kategori (termasuk "All")
  List<String> get categories => ["All", ..._categories];
  String get selectedCategory => _selectedCategory;

  // Constructor untuk memuat data awal
  TaskProvider() {
    loadTasks();
    loadCategories();
  }

  // Mengatur kategori yang dipilih
  void setSelectedCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  // Memuat daftar tugas dari SharedPreferences
// Memuat daftar tugas dari SharedPreferences
Future<void> loadTasks() async {
  final prefs = await SharedPreferences.getInstance();
  final tasksJson = prefs.getString('tasks');
  if (tasksJson != null) {
    final List<dynamic> taskList = jsonDecode(tasksJson);
    _tasks = taskList.map((task) => Task.fromMap(task)).toList();
  } else {
    _tasks = []; // Jika tidak ada tugas di SharedPreferences
  }
  notifyListeners();
}


  // Menyimpan daftar tugas ke SharedPreferences
  Future<void> saveTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final tasksJson = jsonEncode(_tasks.map((task) => task.toMap()).toList());
    await prefs.setString('tasks', tasksJson);
  }

  // Menambahkan tugas baru
  void addTask(String title, String time, String category,
      [int priorityLevel = 0]) {
    final newTask = Task(
      title: title,
      time: time,
      category: category,
      isCompleted: false,
      priorityLevel: priorityLevel,
    );
    _tasks.add(newTask);
    _tasks.sort((a, b) => b.priorityLevel.compareTo(a.priorityLevel)); // Urutkan berdasarkan prioritas
    saveTasks();
    notifyListeners();
  }

  // Menghapus tugas berdasarkan indeks
  void deleteTask(int index) {
    _tasks.removeAt(index);
    saveTasks();
    notifyListeners();
  }

  // Memperbarui tanggal tugas
  void updateTaskDate(int index, DateTime newDate) {
    _tasks[index].time = DateFormat('yyyy-MM-dd').format(newDate);
    saveTasks();
    notifyListeners();
  }

  // Mengatur prioritas tugas
  void setTaskPriority(int index, int priorityLevel) {
    _tasks[index].priorityLevel = priorityLevel;
    _tasks.sort((a, b) => b.priorityLevel.compareTo(a.priorityLevel)); // Urutkan ulang berdasarkan prioritas
    saveTasks();
    notifyListeners();
  }

  // Menambahkan kategori baru
  void addCategory(String category) {
    if (!_categories.contains(category)) {
      _categories.add(category);
      saveCategories();
      notifyListeners();
    }
  }

  // Memuat kategori dari SharedPreferences
  Future<void> loadCategories() async {
    final prefs = await SharedPreferences.getInstance();
    final categoriesJson = prefs.getString('categories');
    if (categoriesJson != null) {
      final List<dynamic> categoryList = jsonDecode(categoriesJson);
      _categories = categoryList.cast<String>();
      notifyListeners();
    }
  }

  // Menyimpan kategori ke SharedPreferences
  Future<void> saveCategories() async {
    final prefs = await SharedPreferences.getInstance();
    final categoriesJson = jsonEncode(_categories);
    await prefs.setString('categories', categoriesJson);
  }

  // Menghapus kategori dan semua tugas yang terkait
  void deleteCategory(String category) {
    if (_categories.contains(category)) {
      _categories.remove(category); // Hapus kategori
      _tasks.removeWhere((task) => task.category == category); // Hapus tugas terkait
      saveCategories();
      saveTasks();
      notifyListeners();
    }
  }

  // Menandai tugas selesai atau tidak selesai
  void toggleTaskCompletion(int index) {
    _tasks[index].toggleCompleted();
    saveTasks();
    notifyListeners();
  }
}
