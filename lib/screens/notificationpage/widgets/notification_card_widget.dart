import 'package:flutter/material.dart';
import 'package:gacortask/constants.dart';

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
    return Card(
      color: color,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(date),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.bold, fontFamily: Constants.fontOpenSansRegular),
              ),
            ),
            Text(timeRemaining),
          ],
        ),
      ),
    );
  }
}