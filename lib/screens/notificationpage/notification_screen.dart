import 'dart:async';
import 'package:flutter/material.dart';
import 'package:gacortask/constants.dart';
import 'package:gacortask/screens/menubarpage/provider/theme_provider.dart';
import 'package:gacortask/screens/taskspage/providers/task_provider.dart';
import 'package:gacortask/sizes.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:gacortask/main.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  Timer? countdownTimer;
  List<Map<String, dynamic>> notifications = [];

  @override
  void initState() {
    super.initState();

    countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        final taskProvider = Provider.of<TaskProvider>(context, listen: false);

        for (final task in taskProvider.tasks) {
          final remainingTime = task.deadline.difference(DateTime.now());

          if (remainingTime.inDays == 1 && remainingTime.inHours == 0) {
            showNotification(
              Constants.notifText,
              'Deadline untuk "${task.title}" tinggal 1 hari lagi!',
            );
          }

          if (remainingTime.inMinutes <= 1 &&
              remainingTime.inMinutes > 0 &&
              !task.isCompleted) {
            showNotification(
              Constants.notifText,
              'Deadline untuk "${task.title}" tinggal 1 menit lagi!',
            );
          }

          if (remainingTime.inHours == 1 && !task.isCompleted) {
            showNotification(
              Constants.notifText,
              'Deadline untuk "${task.title}" tinggal 1 jam lagi!',
            );
          }

          if (remainingTime.isNegative && !task.isCompleted) {
            taskProvider.toggleTaskCompletion(taskProvider.tasks.indexOf(task));
            showNotification(
              Constants.notifTaskDone,
              'Tugas "${task.title}" sudah selesai!',
            );
          }
        }
      });
    });
  }

  @override
  void dispose() {
    countdownTimer?.cancel();
    super.dispose();
  }

  String _getCountdown(DateTime deadline) {
    final now = DateTime.now();
    final difference = deadline.difference(now);

    if (difference.isNegative) {
      return Constants.textSelesai;
    }

    final days = difference.inDays;
    final hours = difference.inHours % 24;
    final minutes = difference.inMinutes % 60;
    final seconds = difference.inSeconds % 60;

    if (days > 0) {
      return '$days hari, $hours jam, $minutes menit';
    } else if (hours > 0) {
      return '$hours jam, $minutes menit';
    } else if (minutes > 0) {
      return '$minutes menit, $seconds detik';
    } else {
      return '$seconds detik';
    }
  }

  @override
  Widget build(BuildContext context) {
    Sizes.init(context);
    final taskProvider = Provider.of<TaskProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final completedTasks = taskProvider.getTasksByStatus(true);
    final pendingTasks = taskProvider.getTasksByStatus(false);
    final primaryColor = themeProvider.primaryColor;
    final secondaryColor = themeProvider.secondaryColor;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          Constants.textNotification,
          style: TextStyle(
            color: secondaryColor,
            fontFamily: Constants.fontOpenSansBold,
            fontWeight: FontWeight.w700,
          ),
        ),
        backgroundColor: primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Completed: ${completedTasks.length} | Pending: ${pendingTasks.length}",
              style: TextStyle(
                fontSize: getScreenWidth(16),
                fontFamily: Constants.fontOpenSansBold,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: getScreenHeight(16)),
            Expanded(
              child: ListView(
                children: [
                  ...pendingTasks.map(
                    (task) => NotificationCard(
                      date: DateFormat('yyyy-MM-dd').format(task.deadline),
                      title: task.title,
                      timeRemaining: _getCountdown(task.deadline),
                      color: Constants.colorOrange,
                    ),
                  ),
                  Divider(
                    thickness: 2,
                    height: getScreenHeight(20),
                  ),
                  ...completedTasks.map(
                    (task) => NotificationCard(
                      date: DateFormat('yyyy-MM-dd').format(task.deadline),
                      title: task.title,
                      timeRemaining: Constants.textSelesai,
                      color: Constants.colorGreen,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NotificationCard extends StatelessWidget {
  final String date;
  final String title;
  final String timeRemaining;
  final Color color;

  const NotificationCard({
    super.key,
    required this.date,
    required this.title,
    required this.timeRemaining,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Constants.colorGrey8,
        borderRadius: BorderRadius.circular(Constants.border20),
        border: Border.all(
          color: color,
          width: getScreenWidth(1.5),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                date,
                style: TextStyle(
                  fontSize: getScreenWidth(14),
                  fontFamily: Constants.fontOpenSansRegular,
                  color: Constants.colorBlack1,
                ),
              ),
              SizedBox(
                height: getScreenHeight(4),
              ),
              Text(
                title,
                style: TextStyle(
                  fontSize: getScreenWidth(16),
                  fontFamily: Constants.fontOpenSansBold,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                timeRemaining,
                style: TextStyle(
                  fontSize: getScreenWidth(14),
                  color: color,
                  fontFamily: Constants.fontOpenSansRegular,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
