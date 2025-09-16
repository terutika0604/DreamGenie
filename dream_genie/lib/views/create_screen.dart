import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../viewmodels/gantt_view_model.dart';
import '../constant.dart';
import '../models/init_data.dart';

class CreateScreen extends StatefulWidget {
  const CreateScreen({super.key});

  @override
  State<CreateScreen> createState() => _CreateScreenState();
}

class _CreateScreenState extends State<CreateScreen> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now().add(const Duration(days: 14));
  String _userGoal = '';

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<GanttViewModel>();
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        backgroundColor: theme.colorScheme.primary,
        title: Text(
          "Create New Project",
          style: theme.textTheme.titleMedium?.copyWith(
            color: theme.colorScheme.onPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 2,
      ),
      body: Center(
        child: Container(
          width: 500,
          padding: const EdgeInsets.all(30),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 20,
                offset: Offset(0, 5),
              )
            ],
          ),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  decoration: const InputDecoration(labelText: 'タイトル'),
                  onSaved: (value) => _title = value ?? '',
                  validator: (value) => value!.isEmpty ? '入力してください' : null,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  decoration: const InputDecoration(labelText: '目標'),
                  onSaved: (value) => _userGoal = value ?? '',
                  validator: (value) => value!.isEmpty ? '入力してください' : null,
                ),
                const SizedBox(height: 30),
                _buildDatePicker(
                  context,
                  label: '開始日',
                  date: _startDate,
                  firstDate: DateTime.now(),
                  onPicked: (picked) => setState(() => _startDate = picked),
                ),
                const SizedBox(height: 20),
                _buildDatePicker(
                  context,
                  label: '終了日',
                  date: _endDate,
                  firstDate: _startDate,
                  onPicked: (picked) => setState(() => _endDate = picked),
                ),
                const SizedBox(height: 40),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: theme.elevatedButtonTheme.style,
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        vm.createSchedule(
                          InitData(
                            userId: userId,
                            userGoal: _userGoal,
                            title: _title,
                            startDate: _startDate,
                            endDate: _endDate,
                          ),
                        );
                        Navigator.pushNamed(context, '/gantt');
                      }
                    },
                    child: const Text('計画を立てる'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDatePicker(
    BuildContext context, {
    required String label,
    required DateTime date,
    required DateTime firstDate,
    required void Function(DateTime) onPicked,
  }) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Expanded(
          child: Text(
            "$label: ${DateFormat('yyyy/MM/dd').format(date)}",
            style: theme.textTheme.bodyMedium,
          ),
        ),
        ElevatedButton(
          style: theme.elevatedButtonTheme.style,
          onPressed: () async {
            final picked = await showDatePicker(
              context: context,
              initialDate: date,
              firstDate: firstDate,
              lastDate: DateTime(2100),
            );
            if (picked != null && picked != date) {
              onPicked(picked);
            }
          },
          child: const Text('選択'),
        ),
      ],
    );
  }
}
