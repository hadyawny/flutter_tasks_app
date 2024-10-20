import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tasks_app/cubit/theme_cubit.dart';
import 'package:google_fonts/google_fonts.dart';

class SettingsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Preferences',
          style: GoogleFonts.dmSerifText(),
        ),
      ),
      body: SwitchListTile(
        title: Text(
          'Dark Mode',
          style: GoogleFonts.dmSerifText(),
        ),
        value: context.watch<ThemeCubit>().isDarkMode,
        onChanged: (value) {
          context.read<ThemeCubit>().toggleTheme();
        },
      ),
    );
  }
}
