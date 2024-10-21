import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tasks_app/cubit/task_cubit.dart';
import 'package:flutter_tasks_app/cubit/task_state.dart';
import 'package:flutter_tasks_app/presentation/components/task_item.dart';
import 'package:flutter_tasks_app/presentation/screens/view_task_screen.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  String selectedFilter = "All"; // Track the selected filter button
  String selectedSort = "None"; // Track the selected sorting option

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // Access the current theme

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Tasks',
          style: GoogleFonts.dmSerifText(),
        ),
      ),
      body: Column(
        children: [
          // Filter Buttons
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal, // Allow horizontal scroll
              child: Row(
                children: [
                  _filterButton(context, "All", theme),
                  SizedBox(width: 10), // Add spacing between buttons
                  _filterButton(context, "In Progress", theme),
                  SizedBox(width: 10),
                  _filterButton(context, "Completed", theme),
                  SizedBox(width: 10),
                  _filterButton(context, "Overdue", theme),
                ],
              ),
            ),
          ),

          // Sorting Button
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                DropdownButton<String>(
                  value: selectedSort,
                  items: [
                    DropdownMenuItem(
                      value: "None",
                      child: Text(
                        "Sort by",
                        style: GoogleFonts.dmSerifText(),
                      ),
                    ),
                    DropdownMenuItem(
                      value: "Priority Asc",
                      child: Text(
                        "Priority (Low to High)",
                        style: GoogleFonts.dmSerifText(),
                      ),
                    ),
                    DropdownMenuItem(
                      value: "Priority Desc",
                      child: Text(
                        "Priority (High to Low)",
                        style: GoogleFonts.dmSerifText(),
                      ),
                    ),
                    DropdownMenuItem(
                      value: "Deadline Asc",
                      child: Text(
                        "Deadline (Earliest to Latest)",
                        style: GoogleFonts.dmSerifText(),
                      ),
                    ),
                    DropdownMenuItem(
                      value: "Deadline Desc",
                      child: Text(
                        "Deadline (Latest to Earliest)",
                        style: GoogleFonts.dmSerifText(),
                      ),
                    ),
                  ],
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedSort = newValue!;
                    });
                    context.read<TaskCubit>().sortTasks(newValue!);
                  },
                ),
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
                    return Center(
                        child: Text(
                      'No tasks found.',
                      style: GoogleFonts.dmSerifText(),
                    ));
                  }
                  return ListView.builder(
                    itemCount: state.tasks.length,
                    itemBuilder: (context, filteredIndex) {
                      final task = state.tasks[filteredIndex];

                      // Find the original index in the repository
                      final originalIndex = context
                          .read<TaskCubit>()
                          .taskRepository
                          .getAllTasks()
                          .indexOf(task);

                      return InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ViewTaskScreen(
                                  task: task,
                                  index: originalIndex,
                                ),
                              ),
                            );
                          },
                          child: TaskItem(task: task, index: originalIndex));
                    },
                  );
                } else if (state is TaskError) {
                  return Center(child: Text(state.message));
                } else {
                  return Center(
                      child: Text(
                    'No tasks found.',
                    style: GoogleFonts.dmSerifText(),
                  ));
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
        shape: const CircleBorder(),
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
        style: GoogleFonts.dmSerifText(
            fontWeight: FontWeight.bold), // Bold text for buttons
      ),
    );
  }
}
