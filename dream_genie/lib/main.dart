import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import 'constant.dart';
import 'repositories/ai_repository.dart';
import 'theme.dart';
import 'views/gantt_screen.dart';

void main() {
  final repository = isMock ? MockAIRepository() : AIRepository(http.Client());

  runApp(
    Provider<IAIRepository>.value(
      value: repository,
      child: const DreamGinieApp(),
    ),
  );
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
