import 'package:flutter_gantt/flutter_gantt.dart';

class AiResponse {
  final String aiComent;
  final List<GanttActivity> tasks;
  AiResponse({required this.aiComent, required this.tasks});
}
