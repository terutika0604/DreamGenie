import 'package:flutter_gantt/flutter_gantt.dart';

class ResponseData {
  final String projectId;
  final String aiComent;
  final List<GanttActivity> tasks;
  ResponseData(
      {required this.projectId, required this.aiComent, required this.tasks});
}
