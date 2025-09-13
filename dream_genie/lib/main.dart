import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import 'constant.dart';
import 'repositories/ai_repository.dart';
import 'theme.dart';
import 'viewmodels/gantt_view_model.dart';
import 'views/create_screen.dart';
import 'views/gantt_screen.dart';

void main() {
  final repository = isMock ? MockAIRepository() : AIRepository(http.Client());

  runApp(
    MultiProvider(
      providers: [
        Provider<IAIRepository>.value(value: repository),
        ChangeNotifierProvider(
          create: (context) => GanttViewModel(repository),
        ),
      ],
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
        routes: {
          // '/': (context) => ProjectListPage(),
          '/': (context) => const CreateScreen(),
          '/gantt': (context) => const GanttScreen(),
        });
  }
}
