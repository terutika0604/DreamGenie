import 'package:flutter_gantt/flutter_gantt.dart';

final now = DateTime.now();
final currentYear = DateTime.now().year;
final monthAgo = now.subtract(const Duration(days: 30));
final monthLater = now.add(const Duration(days: 30));

final holidays = <GantDateHoliday>[
  GantDateHoliday(
    date: DateTime(currentYear, 1, 1),
    holiday: 'New Year\'s Day',
  ),
  GantDateHoliday(
    date: DateTime(currentYear, 3, 8),
    holiday: 'International Women\'s Day',
  ),
  GantDateHoliday(
    date: DateTime(currentYear, 5, 1),
    holiday: 'International Workers\' Day',
  ),
  GantDateHoliday(
    date: DateTime(currentYear, 6, 5),
    holiday: 'World Environment Day',
  ),
  GantDateHoliday(
    date: DateTime(currentYear, 10, 1),
    holiday: 'International Day of Older Persons',
  ),
  GantDateHoliday(
    date: DateTime(currentYear, 10, 24),
    holiday: 'United Nations Day',
  ),
  GantDateHoliday(
    date: DateTime(currentYear, 11, 11),
    holiday: 'Remembrance Day / Armistice Day',
  ),
  GantDateHoliday(
    date: DateTime(currentYear, 12, 25),
    holiday: 'Christmas Day',
  ),
  GantDateHoliday(
    date: DateTime(currentYear, 12, 31),
    holiday: 'New Year\'s Eve',
  ),
];
