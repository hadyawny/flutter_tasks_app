import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tasks_app/data/local/task_repository.dart';
import '../data/models/task_model.dart';
import 'task_state.dart';

class TaskCubit extends Cubit<TaskState> {
  final TaskRepository taskRepository;
  String? currentFilterStatus;
  String? currentSortStatus;

  TaskCubit(this.taskRepository) : super(TaskInitial());

  // Load all tasks from Hive
  void loadTasks() {
    try {
      //emit loading state
      emit(TaskLoading());
      List<Task> tasks = taskRepository.getAllTasks();

      // mark overdue tasks
      for (var task in tasks) {
        if (task.deadline.isBefore(DateTime.now()) &&
            task.status != "Completed") {
          task.status = "Overdue"; // Update the task status to "Overdue"
          taskRepository.updateTask(
              tasks.indexOf(task), task); // Save changes to the repository
        }
      }

      //  mark To Do tasks
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
      //emit loading state

      emit(TaskLoading());
      List<Task> tasks = taskRepository.getAllTasks();

      //  mark overdue tasks
      for (var task in tasks) {
        if (task.deadline.isBefore(DateTime.now()) &&
            task.status != "Completed") {
          task.status = "Overdue"; // Update the task status to "Overdue"
          taskRepository.updateTask(
              tasks.indexOf(task), task); // Save changes to the repository
        }
      }

      //  mark To Do tasks
      for (var task in tasks) {
        if (task.status == "Overdue" && task.deadline.isAfter(DateTime.now())) {
          task.status = "To Do"; // Update the task status to "To Do"
          taskRepository.updateTask(
              tasks.indexOf(task), task); // Save changes to the repository
        }
      }

      // Apply the current filter if it exists
      if (currentFilterStatus != null) {
        tasks =
            tasks.where((task) => task.status == currentFilterStatus).toList();
      }

      // Apply the current sorts if it exists

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
      // emit loaded state with tasks
      emit(TaskLoaded(tasks));
    } catch (e) {
      emit(TaskError('Failed to load tasks'));
    }
  }

  // Add a new task
  void addTask(Task task) {
    taskRepository.addTask(task);

    // getting task index
    int taskIndex = taskRepository.getAllTasks().length - 1;

    // scheduling notification before the deadline by 1 hour

    scheduleNotificationForTask(task, taskIndex);

    // Reload filtered tasks after adding
    loadSameTasks();
  }

  // Update a task at a specific index
  void updateTask(int index, Task task) {
    // Cancel the previous notification for this task
    AwesomeNotifications().cancel(index);

    // Update the task in the repository
    taskRepository.updateTask(index, task);

    // Schedule a new notification with the updated task details
    scheduleNotificationForTask(task, index);

    // Reload filtered tasks after updating
    loadSameTasks();
  }

  // Delete a task by index
  void deleteTask(int index) {
    taskRepository.deleteTask(index);
    // Reload filtered tasks after deletion
    loadSameTasks();
  }

  // Filter tasks by status
  void filterTasks({String? status}) {
    // Store the current filter
    currentFilterStatus = status;
    // Reload filtered tasks
    loadSameTasks();
  }

  // Update task status
  void updateTaskStatus(int taskIndex, String newStatus) {
    final task = taskRepository.getTaskAtIndex(taskIndex);

    // Check current status before updating

    final updatedTask = Task(
      title: task.title,
      description: task.description,
      status: newStatus,
      deadline: task.deadline,
      priority: task.priority,
    );

    taskRepository.updateTask(taskIndex, updatedTask);
    // Reload filtered tasks after updating status
    loadSameTasks();
  }

  // Load and sort tasks based on criteria
  void sortTasks(String sortBy) {
    // Store the current filter
    currentSortStatus = sortBy;
    // Reload filtered tasks
    loadSameTasks();
  }

// Function to schedule notification
  void scheduleNotificationForTask(task, index) {
    DateTime now = DateTime.now();
    DateTime notificationTime =
        task.deadline.subtract(const Duration(hours: 1)); // Deadline - 1 hour

    // If the task deadline is more than 1 hour away, schedule the notification
    if (notificationTime.isAfter(now)) {
      AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: index, // Unique index for the notification
          channelKey: 'channelKey',
          title: 'Upcoming Task Reminder',
          body: 'Your task "${task.title}" is due in an hour!',
          notificationLayout: NotificationLayout.Default,
        ),
        schedule: NotificationCalendar(
          year: notificationTime.year,
          month: notificationTime.month,
          day: notificationTime.day,
          hour: notificationTime.hour,
          minute: notificationTime.minute,
          second: 0,
          millisecond: 0,
          preciseAlarm: true,
        ),
      );
    }
  }
}
