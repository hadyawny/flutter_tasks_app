import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tasks_app/cubit/task_cubit.dart';
import 'package:flutter_tasks_app/presentation/components/nav_bar.dart';
import 'package:flutter_tasks_app/presentation/screens/tabs/home_tab.dart';
import 'package:flutter_tasks_app/presentation/screens/tabs/settings_tab.dart';
import 'package:flutter_tasks_app/presentation/screens/tabs/statistics_tab.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedIndex = 0;

  // List of pages that correspond to each tab
  final List<Widget> screens = [
    const HomeTab(),
    StatisticsTab(),
    SettingsTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: screens[selectedIndex],
        bottomNavigationBar:
            NavBar(selectedIndex: selectedIndex, onTabChange: navFunction));
  }

  navFunction(index) {
    BlocProvider.of<TaskCubit>(context).loadTasks();
    setState(() {
      selectedIndex = index;
    });
  }
}
