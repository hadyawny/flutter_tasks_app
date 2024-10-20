import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart'; // For formatting date and time
import 'package:flutter_tasks_app/cubit/task_cubit.dart';
import 'package:flutter_tasks_app/data/models/task_model.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final formKey = GlobalKey<FormState>();

  // Task details
  String title = '';
  String description = '';
  String status = 'To Do';
  String priority = 'Normal';
  DateTime deadline = DateTime.now().add(const Duration(days: 1));

  // Helper function to show date picker
  Future<void> selectDeadline(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: deadline,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null && picked != deadline) {
      setState(() {
        deadline = DateTime(
          picked.year,
          picked.month,
          picked.day,
          deadline.hour,
          deadline.minute,
        );
      });
    }
  }

  // Helper function to show time picker
  Future<void> selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(deadline),
    );
    if (picked != null) {
      setState(() {
        deadline = DateTime(
          deadline.year,
          deadline.month,
          deadline.day,
          picked.hour,
          picked.minute,
        );
      });
    }
  }

  // Format the deadline for display
  String getFormattedDeadline() {
    return DateFormat('dd/MM/yyyy hh:mm a').format(deadline);
  }

  // Helper function to hide keyboard
  void hideKeyboard(BuildContext context) {
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // Get the current theme

    return GestureDetector(
      onTap: () => hideKeyboard(context), // Dismiss keyboard on tap outside
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Create New Task',
            style: GoogleFonts.dmSerifText(),
          ),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: formKey,
            child: ListView(
              children: <Widget>[
                // Task Title
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Title',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a title';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    title = value!;
                  },
                ),
                const SizedBox(height: 16),

                // Task Description
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Description',
                  ),
                  maxLines: 3,
                  onSaved: (value) {
                    description = value!;
                  },
                ),
                const SizedBox(height: 16),

                // Status Dropdown
                DropdownButtonFormField<String>(
                  value: status,
                  decoration: const InputDecoration(
                    labelText: 'Status',
                  ),
                  items: ['To Do', 'In Progress', 'Completed']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      status = newValue!;
                    });
                  },
                ),
                const SizedBox(height: 16),

                // Priority Dropdown
                DropdownButtonFormField<String>(
                  value: priority,
                  decoration: const InputDecoration(
                    labelText: 'Priority',
                  ),
                  items: ['Low', 'Normal', 'High']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      priority = newValue!;
                    });
                  },
                ),
                const SizedBox(height: 16),

                // Date Picker for Deadline
                ListTile(
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 0, horizontal: 8),
                  title: Text(
                    'Deadline: ${getFormattedDeadline()}',
                    style: GoogleFonts.dmSerifText(fontSize: 16),
                  ),
                  trailing: const Icon(Icons.calendar_today),
                  onTap: () async {
                    await selectDeadline(context);
                    await selectTime(context);
                  },
                ),
                const SizedBox(height: 10),

                // Submit Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme
                          .colorScheme.secondary, 
                      foregroundColor:
                          theme.colorScheme.onSecondary, 
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        formKey.currentState!.save();

                        // Create a new Task object
                        Task newTask = Task(
                          title: title,
                          description: description,
                          status: status,
                          deadline: deadline,
                          priority: priority,
                        );

                        // Use TaskCubit to add the task
                        context.read<TaskCubit>().addTask(newTask);

                        // Navigate back to the home screen
                        Navigator.pop(context);
                      }
                    },
                    child: Text(
                      'Create Task',
                      style: GoogleFonts.dmSerifText(fontSize: 18),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
