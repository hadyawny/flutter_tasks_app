import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tasks_app/presentation/screens/home_screen.dart';
import 'package:flutter_tasks_app/cubit/theme_cubit.dart';
import 'package:flutter_tasks_app/data/local/task_repository.dart';
import 'package:flutter_tasks_app/presentation/screens/task_creation_screen.dart';
import 'package:flutter_tasks_app/presentation/theme/app_theme.dart';
import 'package:flutter_tasks_app/utils/theme_manager.dart';
import 'cubit/task_cubit.dart';
import 'data/local/hive/hive_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ThemeManager.init();
  final isDarkMode = await ThemeManager.getTheme(); // Load theme preference
  final hiveService = HiveService();
  await hiveService.initHive();
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
          create: (context) => TaskCubit(TaskRepository(hiveService))..loadTasks(),
        ),
        BlocProvider(
          create: (context) => ThemeCubit(initialMode: isDarkMode),
        ),
      ],
      child: BlocBuilder<ThemeCubit, bool>(
        builder: (context, isDarkMode) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: isDarkMode ? darkMode : lightMode,
            initialRoute: '/',
            routes: {
              '/': (context) => HomeScreen(),
              'addTask': (context) => TaskCreationPage(),
            },
          );
        },
      ),
    );
  }
}
