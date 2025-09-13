import 'package:intl/intl.dart';

class InitData {
  final String userId;
  final String userGoal;
  final String title;
  final DateTime startDate;
  final DateTime endDate;

  InitData({
    required this.userId,
    required this.userGoal,
    required this.title,
    required this.startDate,
    required this.endDate,
  });

  Map<String, dynamic> toJson() {
    final formatter = DateFormat('yyyy/MM/dd');
    return {
      'user_id': userId,
      'user_goal': userGoal,
      'title': title,
      'start_date': formatter.format(startDate),
      'end_date': formatter.format(endDate),
    };
  }
}
