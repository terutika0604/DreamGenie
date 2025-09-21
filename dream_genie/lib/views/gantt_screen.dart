import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_gantt/flutter_gantt.dart';
import 'package:provider/provider.dart';

import '../constant.dart';
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
  late final GanttController _controller;
  int _daysView = 10;

  @override
  void initState() {
    super.initState();

    _controller = GanttController(
      startDate: now.subtract(const Duration(days: 14)),
      daysViews: _daysView,
    );

    _controller.addOnActivityChangedListener(_onActivityChanged);
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
    _controller.removeOnActivityChangedListener(_onActivityChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Consumer<GanttViewModel>(
      builder: (context, vm, child) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: theme.colorScheme.primary,
            title: Text(
              vm.projectName,
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.onPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
            automaticallyImplyLeading: false,
          ),
          body: Stack(
            children: [
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 4.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: theme.colorScheme.primary,
                          ),
                          onPressed: () {
                            setState(() {
                              _daysView = (_daysView > 2) ? _daysView - 2 : 2;
                              _controller.daysViews = _daysView;
                            });
                          },
                          child: const Icon(Icons.remove),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: theme.colorScheme.primary,
                          ),
                          onPressed: () {
                            setState(() {
                              _daysView += 2;
                              _controller.daysViews = _daysView;
                            });
                          },
                          child: const Icon(Icons.add),
                        ),
                      ],
                    ),
                  ),
                  GanttRangeSelector(controller: _controller),
                  Expanded(
                    child: vm.isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : Gantt(
                            theme: GanttTheme.of(context),
                            controller: _controller,
                            activitiesAsync:
                                (startDate, endDate, activity) async =>
                                    vm.activities,
                            holidaysAsync:
                                (startDate, endDate, holidays) async =>
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
                                vm.activities.getFromKey(activity.key)!.end =
                                    end;
                              }
                              _controller.update();
                            },
                          ),
                  ),
                ],
              ),
              AiChatComponent(controller: _controller),
            ],
          ),
        );
      },
    );
  }
}
