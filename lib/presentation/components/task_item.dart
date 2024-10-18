import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tasks_app/cubit/task_cubit.dart';
import 'package:flutter_tasks_app/data/models/task_model.dart';
import 'package:intl/intl.dart';

class TaskItem extends StatelessWidget {
  final Task task;
  final int index;

  const TaskItem({
    Key? key,
    required this.task,
    required this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Access current theme colors
    final theme = Theme.of(context);
    final cardColor = theme.colorScheme.surface; // Surface color from the theme
    final textColor =
        theme.colorScheme.onSurface; // Text color based on surface
    final chipColor = theme.colorScheme.secondary; // Secondary color for chips

    // Formatting the deadline
    final DateFormat formatter = DateFormat('dd/MM/yyyy      hh:mm a');
    String formattedDeadline = 'No Deadline'; // Default value if no deadline
    formattedDeadline = formatter.format(task.deadline); // Format DateTime

    return Card(
      elevation: 4, // Adds shadow for depth
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15), // Rounded corners
      ),
      color: cardColor, // Apply card background color from theme
      child: Padding(
        padding: const EdgeInsets.all(10.0), // Adds padding inside the card
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Task Title
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconButton(
                  onPressed: () {
                    // Toggle task status between "To Do", "Completed", and "Overdue"
                    if (task.status == "To Do") {
                      context
                          .read<TaskCubit>()
                          .updateTaskStatus(index, "Completed");
                    } else if (task.status == "Completed") {
                      context
                          .read<TaskCubit>()
                          .updateTaskStatus(index, "To Do");
                    } else if (task.status == "Overdue") {
                      context
                          .read<TaskCubit>()
                          .updateTaskStatus(index, "Completed");
                    } else if (task.status == "In Progress") {
                      context
                          .read<TaskCubit>()
                          .updateTaskStatus(index, "Completed");
                    }
                  },
                  icon: Icon(
                    task.status == "Completed"
                        ? Icons.check_box
                        : Icons.check_box_outline_blank,
                    color:
                        task.status == "Completed" ? Colors.green : Colors.grey,
                  ),
                ),
                Expanded(
                  child: Text(
                    task.title,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: textColor, // Set text color based on theme
                    ),
                  ),
                ),
                Chip(
                  label: Text(
                    task.priority,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  backgroundColor: _getPriorityColor(task.priority),
                ),
              ],
            ),
            const SizedBox(height: 5), // Space between title and details

            Padding(
              padding: const EdgeInsets.only(left: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    formattedDeadline, // Display the formatted deadline
                    style: TextStyle(
                      fontSize: 16,
                      color: textColor, // Set text color based on theme
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        // Call the cubit to delete the task
                        context.read<TaskCubit>().deleteTask(index);
                      },
                    ),
                  ),
                ],
              ),
            ),
            // Display overdue text if the task is overdue
            if (task.status == "Overdue")
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  'Overdue!',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // Function to get color based on priority
  Color _getPriorityColor(String priority) {
    switch (priority) {
      case 'High':
        return Colors.redAccent.shade700;
      case 'Normal':
        return Colors.orangeAccent.shade400;
      case 'Low':
        return Colors.greenAccent.shade700;
      default:
        return Colors.blueAccent;
    }
  }
}
