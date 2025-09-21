import 'package:flutter_gantt/flutter_gantt.dart';

class ResponseData {
  final String projectId;
  final String aiComment;
  final List<GanttActivity> tasks;
  ResponseData(
      {required this.projectId, required this.aiComment, required this.tasks});
}
