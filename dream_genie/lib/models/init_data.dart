import 'package:intl/intl.dart';

class InitData {
  final String userId;
  final String title;
  final DateTime startDate;
  final DateTime endDate;
  final String userMessage;

  InitData({
    required this.userId,
    required this.title,
    required this.startDate,
    required this.endDate,
    required this.userMessage,
  });

  Map<String, dynamic> toJson() {
    final formatter = DateFormat('yyyy/MM/dd');
    return {
      'user_id': userId,
      'title': title,
      'start_date': formatter.format(startDate),
      'end_date': formatter.format(endDate),
      'user_message': userMessage,
    };
  }
}
