import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_gantt/flutter_gantt.dart';
import 'package:provider/provider.dart';

import '../constant.dart';
import '../repositories/ai_repository.dart';
import '../viewmodels/gantt_view_model.dart';
import 'components/ai_chat.dart';

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
  Widget build(BuildContext context) => ChangeNotifierProvider(
        create: (_) => GanttViewModel(context.read<IAIRepository>()),
        child: _GanttView(controller: controller),
      );
}

class _GanttView extends StatelessWidget {
  const _GanttView({required this.controller});

  final GanttController controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Your Project"),
      ),
      body: Consumer<GanttViewModel>(builder: (context, vm, child) {
        return Stack(
          children: [
            Column(
              children: [
                GanttRangeSelector(controller: controller),
                Expanded(
                  child: vm.isLoading
                      ? const Center(child:  CircularProgressIndicator())
                      : Gantt(
                          theme: GanttTheme.of(context),
                          controller: controller,
                          activitiesAsync:
                              (startDate, endDate, activity) async =>
                                  vm.activities,
                          holidaysAsync: (startDate, endDate, holidays) async =>
                              holidays,
                          onActivityChanged: (activity, start, end) {
                            if (start != null && end != null) {
                              debugPrint(
                                  '$activity was moved (Event on widget)');
                            } else if (start != null) {
                              debugPrint(
                                '$activity start was moved (Event on widget)',
                              );
                            } else if (end != null) {
                              debugPrint(
                                  '$activity end was moved (Event on widget)');
                            }
                            if (start != null) {
                              vm.activities.getFromKey(activity.key)!.start =
                                  start;
                            }
                            if (end != null) {
                              vm.activities.getFromKey(activity.key)!.end = end;
                            }
                            controller.update();
                          },
                        ),
                ),
              ],
            ),
            AiChatComponent(controller: controller),
          ],
        );
      }),
    );
  }
}
