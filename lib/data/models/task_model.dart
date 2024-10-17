import 'package:hive/hive.dart';

part 'task_model.g.dart';

@HiveType(typeId: 0)
class Task extends HiveObject {
  @HiveField(0)
  String title;

  @HiveField(1)
  String description;

  @HiveField(2)
  String status; // "toDo", "inProgress", "completed"

  @HiveField(3)
  DateTime deadline;

  @HiveField(4)
  String priority; // "low", "normal", "high"

  Task({required this.title, required this.description, required this.status, required this.deadline, required this.priority});
}
