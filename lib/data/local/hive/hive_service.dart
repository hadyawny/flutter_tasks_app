import 'package:flutter_tasks_app/data/models/task_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HiveService {

  // Initialize Hive and open the 'tasks' box

  Future<void> initHive() async {
    await Hive.initFlutter();
    Hive.registerAdapter(TaskAdapter());
    await Hive.openBox<Task>('tasks');
  }

  // Get the instance of the 'tasks' box

  Box<Task> getTasksBox() {
    return Hive.box<Task>('tasks');
  }
}
