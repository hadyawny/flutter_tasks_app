import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tasks_app/data/local/task_repository.dart';
import '../data/models/task_model.dart';
import 'task_state.dart';

class TaskCubit extends Cubit<TaskState> {
  final TaskRepository taskRepository;
  String? currentFilterStatus; // Store the current filter status

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

  // Load tasks based on the current filter (if any)
void loadSameTasks() {
  try {
    emit(TaskLoading());
    List<Task> tasks = taskRepository.getAllTasks();

    // Automatically mark overdue tasks
    for (var task in tasks) {
      if (task.deadline.isBefore(DateTime.now()) &&
          task.status != "Completed") {
        task.status = "Overdue"; // Update the task status to "Overdue"
        taskRepository.updateTask(tasks.indexOf(task), task); // Save changes to the repository
      }
    }

    // Apply the current filter if it exists
    if (currentFilterStatus != null) {
      tasks = tasks.where((task) => task.status == currentFilterStatus).toList();
    }

    emit(TaskLoaded(tasks));
  } catch (e) {
    emit(TaskError('Failed to load tasks'));
  }
}

  // Add a new task
  void addTask(Task task) {
    taskRepository.addTask(task);
    loadSameTasks(); // Reload filtered tasks after adding
  }

  // Update a task at a specific index
  void updateTask(int index, Task task) {
    taskRepository.updateTask(index, task);
    loadSameTasks(); // Reload filtered tasks after updating
  }

  // Delete a task by index
  void deleteTask(int index) {
    taskRepository.deleteTask(index);
    loadSameTasks(); // Reload filtered tasks after deletion
  }

  // Filter tasks by status
  void filterTasks({String? status}) {
    currentFilterStatus = status; // Store the current filter
    loadSameTasks(); // Reload filtered tasks
  }

  // Update task status
void updateTaskStatus(int taskIndex, String newStatus) {
  final task = taskRepository.getTaskAtIndex(taskIndex);
  
  // Check current status before updating
  print("Current Status: ${task.status}");

  final updatedTask = Task(
    title: task.title,
    description: task.description,
    status: newStatus,
    deadline: task.deadline,
    priority: task.priority,
  );

  taskRepository.updateTask(taskIndex, updatedTask);
  loadSameTasks(); // Reload filtered tasks after updating status
}

}
