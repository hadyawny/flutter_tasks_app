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

  // Filter tasks based on priority or status
  void filterTasks({String? priority, String? status}) {
    final currentState = state;
    if (currentState is TaskLoaded) {
      List<Task> filteredTasks = currentState.tasks;

      if (priority != null) {
        filteredTasks = filteredTasks.where((task) => task.priority == priority).toList();
      }

      if (status != null) {
        filteredTasks = filteredTasks.where((task) => task.status == status).toList();
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




  // // Refresh tasks manually
  // void refreshTasks() {
  //   loadTasks();
  // }
}
