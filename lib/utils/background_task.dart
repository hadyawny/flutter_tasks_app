// import 'dart:async';

// import 'package:flutter_background_service/flutter_background_service.dart';
// import 'package:flutter_tasks_app/cubit/task_cubit.dart';
// import 'package:flutter_tasks_app/data/local/hive/hive_service.dart';
// import 'package:flutter_tasks_app/data/local/task_repository.dart';

// Future<void> initializeService() async {
//   final service = FlutterBackgroundService();

//   await service.configure(
//     androidConfiguration: AndroidConfiguration(
//       onStart: onStart,
//       isForegroundMode: true,
//     ),
//     iosConfiguration: IosConfiguration(
       
//     )
//   );

//   service.startService();
// }

// void onStart(ServiceInstance service) {
//   if (service is AndroidServiceInstance) {
//     service.setAsForegroundService();
//   }

//   // Periodic task execution every 15 minutes
//   service.on('setAsForeground').listen((event) {
//     // Add your task notification check logic here
//     checkForTaskNotifications();
//   });

//   Timer.periodic(const Duration(minutes: 15), (timer) async {
//     if (service is AndroidServiceInstance) {
//       checkForTaskNotifications();
//     }
//   });
// }

// // The function that runs the task notification check
// void checkForTaskNotifications() {
//     HiveService hiveService = HiveService(); // Get the singleton instance

//   // Assuming taskCubit is accessible, run the function that checks tasks and triggers notifications
//   TaskCubit taskCubit = TaskCubit(TaskRepository(hiveService));  // Make sure the repository is injected
//   taskCubit.checkTasksForNotification();
// }
