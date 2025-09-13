// AIRepository から JSON を取得
// JSON → GanttActivity に変換
// List<GanttActivity> を公開して View に渡す
// 状態（loading / error / success）を管理
import 'package:flutter/material.dart';
import 'package:flutter_gantt/flutter_gantt.dart';

import '../constant.dart';
import '../repositories/ai_repository.dart';

class GanttViewModel extends ChangeNotifier {
  final IAIRepository repository;

  GanttViewModel(this.repository);

  bool isLoading = false;
  String? errorMessage;
  List<GanttActivity> activities = [];

  List<ChatMessage> messages = [
    ChatMessage(sender: 'ai', text: "aaaaaa"),
    ChatMessage(sender: 'user', text: "aaaaaa"),
  ];

  Future<void> update() async {
    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      final json = await repository.update();
      activities = JsonParser.parseGanttActivities(json);

      isLoading = false;
      notifyListeners();
    } catch (e) {
      isLoading = false;
      errorMessage = e.toString();
      notifyListeners();
    }
  }
}

class ChatMessage {
  final String sender;
  final String text;
  ChatMessage({required this.sender, required this.text});
}

class JsonParser {
  static List<GanttActivity> parseGanttActivities(Map<String, dynamic> json) {
    final List<GanttActivity> activities = [
      // ✅ Main activity with children inside range
      GanttActivity(
        key: 'task1',
        start: now.subtract(const Duration(days: 3)),
        end: now.add(const Duration(days: 6)),
        title: 'Main Taskkkkk',
        tooltip: 'WO-1001 | Top-level task across multiple days',
        color: const Color(0xFF4DB6AC),
        cellBuilder: (cellDate) => Container(
          color: const Color(0xFF00796B),
          child: Center(
            child: Text(
              cellDate.day.toString(),
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ),
        actions: [
          GanttActivityAction(
            icon: Icons.visibility,
            tooltip: 'View',
            onTap: () => debugPrint('Viewing WO-1001'),
          ),
          GanttActivityAction(
            icon: Icons.edit,
            tooltip: 'Edit',
            onTap: () => debugPrint('Editing WO-1001'),
          ),
          GanttActivityAction(
            icon: Icons.delete,
            tooltip: 'Delete',
            onTap: () => debugPrint('Deleting WO-1001'),
          ),
        ],
        children: [
          GanttActivity(
            key: 'task1.sub1',
            start: now.subtract(const Duration(days: 2)),
            end: now.add(const Duration(days: 1)),
            title: 'Subtask 1',
            tooltip: 'WO-1001-1 | Subtask',
            color: const Color(0xFF81C784),
            actions: [
              GanttActivityAction(
                icon: Icons.check,
                tooltip: 'Mark done',
                onTap: () => debugPrint('Marking subtask done'),
              ),
            ],
          ),
          GanttActivity(
            key: 'task1.sub2',
            start: now,
            end: now.add(const Duration(days: 5)),
            title: 'Subtask 2',
            tooltip: 'WO-1001-2 | Subtask with nested children',
            color: const Color(0xFF9575CD),
            actions: [
              GanttActivityAction(
                icon: Icons.add,
                tooltip: 'Add nested task',
                onTap: () => debugPrint('Add nested to WO-1001-2'),
              ),
            ],
            children: [
              GanttActivity(
                key: 'task1.sub2.subA',
                start: now.add(const Duration(days: 1)),
                end: now.add(const Duration(days: 3)),
                title: 'Nested Subtask A',
                tooltip: 'WO-1001-2A | Second-level task',
                color: const Color(0xFFBA68C8),
                actions: [
                  GanttActivityAction(
                    icon: Icons.edit,
                    tooltip: 'Edit',
                    onTap: () => debugPrint('Editing nested A'),
                  ),
                ],
              ),
              GanttActivity(
                key: 'task1.sub2.subB',
                start: now.add(const Duration(days: 2)),
                end: now.add(const Duration(days: 4)),
                title: 'Nested Subtask B',
                tooltip: 'WO-1001-2B | Continued',
                color: const Color(0xFFFF8A65),
                actions: [
                  GanttActivityAction(
                    icon: Icons.delete,
                    tooltip: 'Delete',
                    onTap: () => debugPrint('Deleting nested B'),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),

      // ✅ Standalone task near today
      GanttActivity(
        key: 'task2',
        start: now.add(const Duration(days: 1)),
        end: now.add(const Duration(days: 8)),
        title: 'Independent Task',
        tooltip: 'A separate task',
        color: const Color(0xFF64B5F6),
      ),

      // ✅ Activity from one month ago
      GanttActivity(
        key: 'task3',
        start: monthAgo.subtract(const Duration(days: 3)),
        end: monthAgo.add(const Duration(days: 3)),
        title: 'Archived Task',
        tooltip: 'Task from one month ago',
        color: const Color(0xFF90A4AE), // Blue grey
      ),

      // ✅ Activity a few days ago
      GanttActivity(
        key: 'task4',
        start: now.subtract(const Duration(days: 10)),
        end: now.subtract(const Duration(days: 4)),
        title: 'Older Task',
        tooltip: 'Past task',
        color: const Color(0xFFBCAAA4), // Light brown
      ),

      // ✅ Future activity
      GanttActivity(
        key: 'task5',
        start: monthLater.subtract(const Duration(days: 5)),
        end: monthLater.add(const Duration(days: 2)),
        title: 'Planned Future Task',
        tooltip: 'Future scheduled task',
        color: const Color(0xFF7986CB), // Indigo
      ),

      // ✅ Long-term task
      GanttActivity(
        key: 'task6',
        start: now.subtract(const Duration(days: 10)),
        end: monthLater,
        title: 'Ongoing Project',
        tooltip: 'Spanning multiple weeks',
        color: const Color(0xFF4FC3F7), // Sky blue
      ),
    ];
    return activities;
  }
}
