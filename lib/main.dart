import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tasks_app/presentation/screens/home_screen.dart';
import 'package:flutter_tasks_app/cubit/theme_cubit.dart';
import 'package:flutter_tasks_app/data/local/task_repository.dart';
import 'package:flutter_tasks_app/presentation/screens/add_task_screen.dart';
import 'package:flutter_tasks_app/presentation/theme/app_theme.dart';
import 'package:flutter_tasks_app/utils/notification_setup.dart';
import 'package:flutter_tasks_app/utils/theme_manager.dart';
import 'cubit/task_cubit.dart';
import 'data/local/hive/hive_service.dart';

void main() async {
  // Ensure Flutter binding is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize ThemeManager for managing theme preferences
  await ThemeManager.init();

  // Load theme preference
  final isDarkMode = await ThemeManager.getTheme();

  // Create an instance of HiveService and Initialize Hive
  final hiveService = HiveService();
  await hiveService.initHive();

  // Set up notifications
  await initializeNotifications();

  runApp(MyApp(isDarkMode: isDarkMode, hiveService: hiveService));
}

class MyApp extends StatelessWidget {
  final bool isDarkMode;
  final HiveService hiveService;

  const MyApp({super.key, required this.isDarkMode, required this.hiveService});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              TaskCubit(TaskRepository(hiveService))..loadTasks(),
        ),
        BlocProvider(
          create: (context) => ThemeCubit(initialMode: isDarkMode),
        ),
      ],
      child: BlocBuilder<ThemeCubit, bool>(
        builder: (context, isDarkMode) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: isDarkMode
                ? darkMode
                : lightMode, // Set theme based on current mode
            initialRoute: '/',
            routes: {
              '/': (context) => const HomeScreen(),
              'addTask': (context) => const AddTaskScreen(),
            },
          );
        },
      ),
    );
  }
}
