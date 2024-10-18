import 'package:flutter_tasks_app/data/local/hive/hive_service.dart';
import '../models/task_model.dart';

class TaskRepository {
  final HiveService hiveService;

  TaskRepository(this.hiveService);

  List<Task> getAllTasks() {
    return hiveService.getTasksBox().values.toList();
  }

    Task getTaskAtIndex(int index) {
    return hiveService.getTasksBox().getAt(index)!; 
  }

  void addTask(Task task) {
    hiveService.getTasksBox().add(task);
  }

  void updateTask(int index, Task task) {
    hiveService.getTasksBox().putAt(index, task);
  }

  void deleteTask(int index) {
    hiveService.getTasksBox().deleteAt(index);
  }
}
