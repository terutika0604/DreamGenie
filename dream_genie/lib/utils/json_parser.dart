import 'package:flutter/material.dart';
import 'package:flutter_gantt/flutter_gantt.dart';
import 'package:intl/intl.dart';

import '../models/response_data.dart';

class JsonParser {
  static final _dateFormat = DateFormat('yyyy/MM/dd');

  static ResponseData parseResponseData(Map<String, dynamic> json) {
    final List<GanttActivity> activities = _parseGanttActivities(json['tasks']);
    return ResponseData(
      projectId: json['project_id'],
      aiComment: json['ai_comment'],
      tasks: activities,
    );
  }

  static List<GanttActivity> _parseGanttActivities(List<dynamic> jsonList) {
    return jsonList.map((e) => _parseActivity(e)).toList();
  }

  static GanttActivity _parseActivity(Map<String, dynamic> json) {
    return GanttActivity(
      key: json['key'] ?? '',
      title: json['title'] ?? '',
      tooltip: json['tooltip'] ?? '',
      start: _dateFormat.parse(json['start']),
      end: _dateFormat.parse(json['end']),
      color: _parseColor(json['color']),
      children: (json['children'] as List<dynamic>? ?? [])
          .map((c) => _parseActivity(c))
          .toList(),
    );
  }

  static Color _parseColor(String? hex) {
    if (hex == null) return Colors.grey;
    return Color(int.parse(hex.replaceFirst('#', '0xFF')));
  }
}
