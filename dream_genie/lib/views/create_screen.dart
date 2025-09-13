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
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<GanttViewModel>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Create New Project"),
      ),
      body: Center(
        child: Container(
          width: 500,
          padding: const EdgeInsets.all(30),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  decoration: const InputDecoration(labelText: 'タイトル'),
                  onSaved: (value) => _title = value ?? '',
                  validator: (value) => value!.isEmpty ? '入力してください' : null,
                ),
                const SizedBox(height: 30),
                TextFormField(
                  decoration: const InputDecoration(labelText: '目標'),
                  onSaved: (value) => _userGoal = value ?? '',
                  validator: (value) => value!.isEmpty ? '入力してください' : null,
                ),
                const SizedBox(height: 30),
                Row(
                  children: [
                    Text("開始日: ${DateFormat('yyyy/MM/dd').format(_startDate)}"),
                    const SizedBox(width: 30),
                    ElevatedButton(
                      child: const Text('選択'),
                      onPressed: () async {
                        DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: _startDate,
                          firstDate: now,
                          lastDate: DateTime(2100),
                        );
                        if (picked != null && picked != _startDate) {
                          setState(() {
                            _startDate = picked;
                          });
                        }
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                Row(
                  children: [
                    Text("終了日: ${DateFormat('yyyy/MM/dd').format(_endDate)}"),
                    const SizedBox(width: 30),
                    ElevatedButton(
                      child: const Text('選択'),
                      onPressed: () async {
                        DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: _endDate,
                          firstDate: _startDate,
                          lastDate: DateTime(2100),
                        );
                        if (picked != null && picked != _endDate) {
                          setState(() {
                            _endDate = picked;
                          });
                        }
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 100),
                ElevatedButton(
                  child: const Text('計画を立てる'),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();

                      vm.create(
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
