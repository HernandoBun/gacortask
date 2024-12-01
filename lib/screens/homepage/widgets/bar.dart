import 'package:flutter/material.dart';
import 'package:gacortask/screens/homepage/widgets/bar%20graph/bar_graph.dart';
import 'package:gacortask/screens/taskspage/providers/task_provider.dart';
import 'package:gacortask/sizes.dart';
import 'package:provider/provider.dart';


class BarGraph extends StatefulWidget {
  const BarGraph({super.key});

  @override
  State<BarGraph> createState() => _BarGraphState();
}

class _BarGraphState extends State<BarGraph> {
  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);
    final userAktif = taskProvider.tasksPerDay;

    return SizedBox(
      height: getScreenHeight(200),
      child: MyBarGraph(userAktif: userAktif),
    );
  }
}