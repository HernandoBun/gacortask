import 'package:flutter/material.dart';


class Task {
  String title;
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

  int get priority => priorityLevel;
 
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'deadline': deadline.toIso8601String(),
      'category': category,
      'priorityLevel': priorityLevel,
      'isCompleted': isCompleted,
    };
  }
 
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