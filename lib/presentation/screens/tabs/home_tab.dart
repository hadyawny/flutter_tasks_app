import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tasks_app/cubit/task_cubit.dart';
import 'package:flutter_tasks_app/cubit/task_state.dart';
import 'package:flutter_tasks_app/presentation/components/task_item.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  String selectedFilter = "All"; // Track the selected filter button

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // Access the current theme

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Tasks'),
      ),
      body: Column(
        children: [
          // Filter Buttons
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _filterButton(context, "All", theme),
                _filterButton(context, "In Progress", theme),
                _filterButton(context, "Completed", theme),
                _filterButton(context, "Overdue", theme),
              ],
            ),
          ),
          Expanded(
            child: BlocBuilder<TaskCubit, TaskState>(
              builder: (context, state) {
                if (state is TaskLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is TaskLoaded) {
                  if (state.tasks.isEmpty) {
                    return const Center(child: Text('No tasks found.'));
                  }
                  return ListView.builder(
                    itemCount: state.tasks.length,
                    itemBuilder: (context, index) {
                      final task = state.tasks[index];
                      return TaskItem(task: task, index: index);
                    },
                  );
                } else if (state is TaskError) {
                  return Center(child: Text(state.message));
                } else {
                  return const Center(child: Text('No tasks found.'));
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, 'addTask');
        },
        backgroundColor: theme.brightness == Brightness.light
            ? Colors.grey.shade600 // Softer color for light mode
            : theme.colorScheme.secondary, // Keep dark mode consistent
        child: Icon(Icons.add,
            color: theme.colorScheme.onSecondary // Selected button text color
            ),
      ),
    );
  }

  // Helper function to create filter buttons with theme-based colors and selection logic
  Widget _filterButton(BuildContext context, String label, ThemeData theme) {
    final bool isSelected = label == selectedFilter;

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
        backgroundColor: isSelected
            ? theme.colorScheme.secondary // Selected button background
            : theme.colorScheme.tertiary, // Unselected button background
        foregroundColor: isSelected
            ? theme.colorScheme.onSecondary // Selected button text color
            : theme.colorScheme.inversePrimary, // Unselected button text color
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0), // Rounded button shape
        ),
      ),
      onPressed: () {
        setState(() {
          selectedFilter = label; // Update the selected filter
        });
        context.read<TaskCubit>().filterTasks(
            status: label == "All"
                ? null
                : label); // Filter tasks based on the label
      },
      child: Text(
        label,
        style: const TextStyle(
            fontWeight: FontWeight.bold), // Bold text for buttons
      ),
    );
  }
}
