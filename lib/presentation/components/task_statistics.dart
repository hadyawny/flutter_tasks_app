import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import 'package:flutter_tasks_app/data/models/task_model.dart';
import 'package:flutter_tasks_app/presentation/components/animated_counter.dart';
import 'package:google_fonts/google_fonts.dart';

class TaskStatistics extends StatelessWidget {
  final List<Task> tasks; // Assume you pass the tasks here

  const TaskStatistics({super.key, required this.tasks});

  @override
  Widget build(BuildContext context) {
    // Calculate task statistics
    int completedTasks =
        tasks.where((task) => task.status == "Completed").length;
    int overdueTasks = tasks.where((task) => task.status == "Overdue").length;
    int toDoTasks = tasks.where((task) => task.status == "To Do").length;
    int inProgressTasks =
        tasks.where((task) => task.status == "In Progress").length; // New line

    return Column(
      children: [
        AspectRatio(
          aspectRatio: 1,
          child: PieChart(
            PieChartData(
              sections: showingSections(
                  completedTasks, overdueTasks, toDoTasks, inProgressTasks),
              borderData: FlBorderData(show: false),
              centerSpaceRadius: 50,
            ),
          ),
        ),
        const SizedBox(height: 10),
        AnimatedCounter(
          completed: completedTasks,
          overdue: overdueTasks,
          toDo: toDoTasks,
          inProgress: inProgressTasks, // Pass inProgress tasks here
        ),
      ],
    );
  }

  List<PieChartSectionData> showingSections(
      int completed, int overdue, int toDo, int inProgress) {
    // Update this method
    return [
      PieChartSectionData(
        color: Colors.green,
        value: completed.toDouble(),
        title: 'Completed',
        radius: 30,
        titlePositionPercentageOffset: 2,
        titleStyle: GoogleFonts.dmSerifText(fontWeight: FontWeight.bold),
      ),
      PieChartSectionData(
        color: Colors.red,
        value: overdue.toDouble(),
        title: 'Overdue',
        radius: 30,
        titlePositionPercentageOffset: 2,
        titleStyle: GoogleFonts.dmSerifText(fontWeight: FontWeight.bold),
      ),
      PieChartSectionData(
        color: Colors.blue,
        value: toDo.toDouble(),
        title: 'To Do',
        radius: 30,
        titlePositionPercentageOffset: 2,
        titleStyle: GoogleFonts.dmSerifText(fontWeight: FontWeight.bold),
      ),
      PieChartSectionData(
        color: Colors.orange,
        value: inProgress.toDouble(), // Add inProgress section
        title: 'In Progress',
        radius: 30,
        titlePositionPercentageOffset: 2,

        titleStyle: GoogleFonts.dmSerifText(fontWeight: FontWeight.bold),
      ),
    ];
  }
}
