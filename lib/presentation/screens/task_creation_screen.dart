import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart'; // For formatting date and time
import 'package:flutter_tasks_app/cubit/task_cubit.dart';
import 'package:flutter_tasks_app/data/models/task_model.dart';

class TaskCreationPage extends StatefulWidget {
  @override
  _TaskCreationPageState createState() => _TaskCreationPageState();
}

class _TaskCreationPageState extends State<TaskCreationPage> {
  final formKey = GlobalKey<FormState>();

  // Task details
  String title = '';
  String description = '';
  String status = 'To Do'; // Default status
  String priority = 'Normal'; // Default priority
  DateTime deadline = DateTime.now(); // Default deadline

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create New Task'),
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
                decoration: InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
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
                decoration: InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                maxLines: 5, // Increases the size of the text box

                onSaved: (value) {
                  description = value!;
                },
              ),
              const SizedBox(height: 16),

              // Status Dropdown
              DropdownButtonFormField<String>(
                value: status,
                decoration: InputDecoration(
                  labelText: 'Status',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
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
                decoration: InputDecoration(
                  labelText: 'Priority',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
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
                    EdgeInsets.symmetric(vertical: 0, horizontal: 8),
                title: Text(
                  'Deadline: ${getFormattedDeadline()}',
                  style: TextStyle(fontSize: 16),
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
                    padding: EdgeInsets.symmetric(vertical: 12),
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
                  child: const Text(
                    'Create Task',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
