import 'package:flutter_tasks_app/data/models/task_model.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HiveService {
  Future<void> initHive() async {
    await Hive.initFlutter();
    Hive.registerAdapter(TaskAdapter());
    await Hive.openBox<Task>('tasks');
  }

  Box<Task> getTasksBox() {
    return Hive.box<Task>('tasks');
  }
}
