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
    // Formatting the deadline
    final DateFormat formatter = DateFormat('dd/MM/yyyy      hh:mm a');
    String formattedDeadline = 'No Deadline'; // Default value if no deadline
    // Assuming task.deadline is a DateTime
    formattedDeadline = formatter.format(task.deadline); // Format DateTime

    return Card(
      elevation: 4, // Adds shadow for depth
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15), // Rounded corners
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0), // Adds padding inside the card
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Task Title
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconButton(
                  onPressed: () {
                    // Toggle task status between "toDo" and "completed"
                    if (task.status == "toDo") {
                      context
                          .read<TaskCubit>()
                          .updateTaskStatus(index, "completed");
                    } else if (task.status == "completed") {
                      context.read<TaskCubit>().updateTaskStatus(index, "toDo");
                    }
                  },
                  icon: Icon(
                    task.status == "toDo"
                        ? Icons
                            .check_box_outline_blank // Empty checkbox for "toDo"
                        : Icons.check_box, // Filled checkbox for "completed"
                    color: task.status == "toDo" ? Colors.grey : Colors.green,
                  ),
                ),
                Expanded(
                  child: Text(
                    task.title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Chip(
                  label: Text(
                    '${task.priority}',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  backgroundColor: _getPriorityColor(task.priority),
                ),
              ],
            ),
            const SizedBox(height: 8), // Space between title and details

            // Task Details Row (Priority, Status, Deadline)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Priority

                // Status
                Text(
                  formattedDeadline, // Display the formatted deadline
                  style: const TextStyle(
                    fontSize: 16,
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
          ],
        ),
      ),
    );
  }

  //function to get color based on priority
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
