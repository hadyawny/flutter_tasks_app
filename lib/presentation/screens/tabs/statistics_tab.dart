import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tasks_app/cubit/task_cubit.dart';
import 'package:flutter_tasks_app/cubit/task_state.dart';
import 'package:flutter_tasks_app/presentation/components/task_statistics.dart';
import 'package:google_fonts/google_fonts.dart';

class StatisticsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Statistics',
          style: GoogleFonts.dmSerifText(),
        ),
      ),
      body: BlocBuilder<TaskCubit, TaskState>(
        builder: (context, state) {
          if (state is TaskLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is TaskLoaded) {
            return TaskStatistics(tasks: state.tasks); // Pass the tasks here
          } else {
            return Center(
                child: Text(
              'Failed to load tasks',
              style: GoogleFonts.dmSerifText(),
            ));
          }
        },
      ),
    );
  }
}
