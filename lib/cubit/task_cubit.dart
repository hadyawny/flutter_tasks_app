import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tasks_app/data/local/task_repository.dart';
import '../data/models/task_model.dart';
import 'task_state.dart';

class TaskCubit extends Cubit<TaskState> {
  final TaskRepository taskRepository;

  TaskCubit(this.taskRepository) : super(TaskInitial());

  // Load all tasks from Hive
  void loadTasks() {
    try {
      emit(TaskLoading());
      List<Task> tasks = taskRepository.getAllTasks();

      // Automatically mark overdue tasks
      for (var task in tasks) {
        if (task.deadline.isBefore(DateTime.now()) &&
            task.status != "Completed") {
          task.status = "Overdue"; // Update the task status to "Overdue"
          taskRepository.updateTask(
              tasks.indexOf(task), task); // Save changes to the repository
        }
      }

      emit(TaskLoaded(tasks));
    } catch (e) {
      emit(TaskError('Failed to load tasks'));
    }
  }

  // Add a new task
  void addTask(Task task) {
    taskRepository.addTask(task);
    loadTasks();
  }

  // Update a task at a specific index
  void updateTask(int index, Task task) {
    taskRepository.updateTask(index, task);
    loadTasks();
  }

  // Delete a task by index
  void deleteTask(int index) {
    taskRepository.deleteTask(index);
    // Reload tasks to reflect the deletion
    loadTasks();
  }

  void filterTasks({String? status}) {
    loadTasks();
    final currentState = state;
    if (currentState is TaskLoaded) {
      List<Task> filteredTasks = currentState.tasks;

      if (status != null) {
        // Filter based on the status
        filteredTasks =
            filteredTasks.where((task) => task.status == status).toList();
      }

      emit(TaskLoaded(filteredTasks));
    }
  }

  void updateTaskStatus(int taskIndex, String newStatus) {
    final task = taskRepository.getTaskAtIndex(taskIndex);
    final updatedTask = Task(
      title: task.title,
      description: task.description,
      status: newStatus, // Update the status field
      deadline: task.deadline,
      priority: task.priority,
    );

    taskRepository.updateTask(taskIndex, updatedTask);
    loadTasks(); // Refresh the task list
  }
}
