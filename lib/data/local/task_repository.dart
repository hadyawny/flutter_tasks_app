import 'package:flutter_tasks_app/data/local/hive/hive_service.dart';
import '../models/task_model.dart';

class TaskRepository {
  final HiveService hiveService;

  // Constructor to initialize the HiveService

  TaskRepository(this.hiveService);

  // Get all tasks from the Hive box

  List<Task> getAllTasks() {
    return hiveService.getTasksBox().values.toList();
  }

  // Get a specific task by its index

    Task getTaskAtIndex(int index) {
    return hiveService.getTasksBox().getAt(index)!; 
  }

  // Add a new task to the Hive box

  void addTask(Task task) {
    hiveService.getTasksBox().add(task);
  }

  // Update an existing task at a specific index

  void updateTask(int index, Task task) {
    hiveService.getTasksBox().putAt(index, task);
  }

  // Delete a task by its index

  void deleteTask(int index) {
    hiveService.getTasksBox().deleteAt(index);
  }
}
