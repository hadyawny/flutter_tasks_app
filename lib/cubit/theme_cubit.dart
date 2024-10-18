import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tasks_app/utils/theme_manager.dart';

class ThemeCubit extends Cubit<bool> {
  ThemeCubit({required bool initialMode}) : super(initialMode);

  bool get isDarkMode => state;

  Future<void> toggleTheme() async {
    final newTheme = !isDarkMode;
    emit(newTheme);
    await ThemeManager.setTheme(newTheme);
  }
}
