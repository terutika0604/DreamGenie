import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_gantt/flutter_gantt.dart';

import '../constant.dart';
import '../viewmodels/gantt_view_model.dart';

class AppCustomScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        PointerDeviceKind.trackpad,
        PointerDeviceKind.unknown,
      };
}

class GanttScreen extends StatefulWidget {
  const GanttScreen({super.key});

  @override
  State<GanttScreen> createState() => _GanttScreenState();
}

class _GanttScreenState extends State<GanttScreen> {
  late final GanttController controller;

  @override
  void initState() {
    super.initState();

    controller = GanttController(
      startDate: now.subtract(const Duration(days: 14)),
      //daysViews: 10, // Optional: you can set the number of days to be displayed
    );

    controller.addOnActivityChangedListener(_onActivityChanged);
  }

  void _onActivityChanged(activity, DateTime? start, DateTime? end) {
    if (start != null && end != null) {
      debugPrint('$activity was moved (Event on controller)');
    } else if (start != null) {
      debugPrint('$activity start was moved (Event on controller)');
    } else if (end != null) {
      debugPrint('$activity end was moved (Event on controller)');
    }
  }

  @override
  void dispose() {
    controller.removeOnActivityChangedListener(_onActivityChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text("Your Project"),
        ),
        body: Column(
          children: [
            GanttRangeSelector(controller: controller),
            Expanded(
              child: Gantt(
                theme: GanttTheme.of(context),
                controller: controller,
                activitiesAsync: (startDate, endDate, activity) async =>
                    activities,
                holidaysAsync: (startDate, endDate, holidays) async => holidays,
                onActivityChanged: (activity, start, end) {
                  if (start != null && end != null) {
                    debugPrint('$activity was moved (Event on widget)');
                  } else if (start != null) {
                    debugPrint(
                      '$activity start was moved (Event on widget)',
                    );
                  } else if (end != null) {
                    debugPrint('$activity end was moved (Event on widget)');
                  }
                  if (start != null) {
                    activities.getFromKey(activity.key)!.start = start;
                  }
                  if (end != null) {
                    activities.getFromKey(activity.key)!.end = end;
                  }
                  controller.update();
                },
              ),
            ),
          ],
        ),
      );
}
