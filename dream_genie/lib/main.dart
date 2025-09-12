import 'package:flutter/material.dart';

import 'theme.dart';
import 'views/gantt_screen.dart';

void main() {
  runApp(const DreamGinieApp());
}

class DreamGinieApp extends StatelessWidget {
  const DreamGinieApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dream Ginie',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      // TODO: LoginPage, ProjectListPage
      home: const GanttScreen(),
    );
  }
}
