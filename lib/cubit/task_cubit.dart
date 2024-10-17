import 'package:flutter_bloc/flutter_bloc.dart';
import 'task_state.dart';
import '../data/local/task_repository.dart';
import '../data/models/task_model.dart';

class TaskCubit extends Cubit<TaskState> {
  final TaskRepository taskRepository;

  TaskCubit(this.taskRepository) : super(TaskInitial());

  void loadTasks() {
    try {
      emit(TaskLoading());
      final tasks = taskRepository.getAllTasks();
      emit(TaskLoaded(tasks));
    } catch (e) {
      emit(TaskError('Failed to load tasks'));
    }
  }

  void addTask(Task task) {
    try {
      taskRepository.addTask(task);
      loadTasks();  // Reload tasks after adding
    } catch (e) {
      emit(TaskError('Failed to add task'));
    }
  }

  void updateTask(int index, Task task) {
    try {
      taskRepository.updateTask(index, task);
      loadTasks();  // Reload tasks after updating
    } catch (e) {
      emit(TaskError('Failed to update task'));
    }
  }

  void deleteTask(int index) {
    try {
      taskRepository.deleteTask(index);
      loadTasks();  // Reload tasks after deleting
    } catch (e) {
      emit(TaskError('Failed to delete task'));
    }
  }
}
