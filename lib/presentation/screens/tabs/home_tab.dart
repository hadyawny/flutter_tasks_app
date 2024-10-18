import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tasks_app/cubit/task_cubit.dart';
import 'package:flutter_tasks_app/cubit/task_state.dart';
import 'package:flutter_tasks_app/presentation/components/task_item.dart';

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Tasks'),
      ),
      body: BlocBuilder<TaskCubit, TaskState>(
        builder: (context, state) {
          if (state is TaskLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is TaskLoaded) {
            return ListView.builder(
              itemCount: state.tasks.length,
              itemBuilder: (context, index) {
                if (state.tasks.length == 0) {
                  return const Center(child: Text('No tasks found.'));
                }
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, 'addTask');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
