import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tasks_app/data/local/task_repository.dart';
import '../data/models/task_model.dart';
import 'task_state.dart';

class TaskCubit extends Cubit<TaskState> {
  final TaskRepository taskRepository;
  String? currentFilterStatus; // Store the current filter status
  String? currentSortStatus; // Store the current filter status

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

      // Automatically mark To Do tasks
      for (var task in tasks) {
        if (task.status == "Overdue" && task.deadline.isAfter(DateTime.now())) {
          task.status = "To Do"; // Update the task status to "Overdue"
          taskRepository.updateTask(
              tasks.indexOf(task), task); // Save changes to the repository
        }
      }

      emit(TaskLoaded(tasks));
    } catch (e) {
      emit(TaskError('Failed to load tasks'));
    }
  }

  // Load tasks based on the current filter or Sort (if any)
  void loadSameTasks() {
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

      // Automatically mark To Do tasks
      for (var task in tasks) {
        if (task.status == "Overdue" && task.deadline.isAfter(DateTime.now())) {
          task.status = "To Do"; // Update the task status to "Overdue"
          taskRepository.updateTask(
              tasks.indexOf(task), task); // Save changes to the repository
        }
      }

      // Apply the current filter if it exists
      if (currentFilterStatus != null) {
        tasks =
            tasks.where((task) => task.status == currentFilterStatus).toList();
      }

      if (currentSortStatus != null) {
        if (currentSortStatus == "Priority Asc") {
          tasks.sort((a, b) => a.priority.compareTo(b.priority));
        } else if (currentSortStatus == "Priority Desc") {
          tasks.sort((a, b) => b.priority.compareTo(a.priority));
        } else if (currentSortStatus == "Deadline Asc") {
          tasks.sort((a, b) => a.deadline.compareTo(b.deadline));
        } else if (currentSortStatus == "Deadline Desc") {
          tasks.sort((a, b) => b.deadline.compareTo(a.deadline));
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

  // Load and sort tasks based on criteria
  void sortTasks(String sortBy) {
    try {
      emit(TaskLoading());
      List<Task> tasks = taskRepository.getAllTasks();
      currentSortStatus = sortBy;
      if (currentFilterStatus != null) {
        tasks =
            tasks.where((task) => task.status == currentFilterStatus).toList();
      }

      // Apply sorting based on the selected option
      if (sortBy == "Priority Asc") {
        tasks.sort((a, b) => a.priority.compareTo(b.priority));
      } else if (sortBy == "Priority Desc") {
        tasks.sort((a, b) => b.priority.compareTo(a.priority));
      } else if (sortBy == "Deadline Asc") {
        tasks.sort((a, b) => a.deadline.compareTo(b.deadline));
      } else if (sortBy == "Deadline Desc") {
        tasks.sort((a, b) => b.deadline.compareTo(a.deadline));
      }

      emit(TaskLoaded(tasks));
    } catch (e) {
      emit(TaskError('Failed to sort tasks'));
    }
  }


  void triggerNotification(task, index) {
    AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: index, // Ensure unique ID for each notification
        channelKey: 'channelKey',
        title: 'Task Reminder',
        body: 'Your task "${task.title}" is due in an hour!',
      ),
    );
  }

// void checkTasksForNotification() {
//   List<Task> tasks = taskRepository.getAllTasks();
//   DateTime now = DateTime.now();

//   for (var task in tasks) {
//     if (task.notificationSent == false) {
//       Duration timeUntilDeadline = task.deadline.difference(now);

//       // Check if the task is due in 1 hour
//       if (timeUntilDeadline.inMinutes <= 60 && timeUntilDeadline.inMinutes > 0) {
//         // Trigger notification
//         triggerNotification(task, tasks.indexOf(task));

//         // Mark the task's notification as sent
//         task.notificationSent = true;
//         taskRepository.updateTask(tasks.indexOf(task), task); // Save changes
//       }
//     }
//   }
// }

}
