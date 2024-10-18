import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tasks_app/data/local/task_repository.dart';
import 'package:flutter_tasks_app/presentation/screens/home_screen.dart';
import 'package:flutter_tasks_app/presentation/screens/task_creation_screen.dart';
import 'cubit/task_cubit.dart';
import 'data/local/hive/hive_service.dart';
// New Task Creation Page

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  final hiveService = HiveService();
  await hiveService.initHive();

  runApp(MyApp(hiveService: hiveService));
}

class MyApp extends StatelessWidget {
  final HiveService hiveService;

  MyApp({required this.hiveService});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TaskCubit(TaskRepository(hiveService))..loadTasks(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        routes: {
          '/': (context) => HomeScreen(),
          'addTask': (context) => TaskCreationPage(),
        },
      ),
    );
  }
}
