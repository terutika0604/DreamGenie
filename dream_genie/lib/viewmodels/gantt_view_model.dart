import 'package:flutter/material.dart';
import 'package:flutter_gantt/flutter_gantt.dart';

import '../models/chat_message.dart';
import '../models/init_data.dart';
import '../models/response_data.dart';
import '../repositories/ai_repository.dart';
import '../utils/json_parser.dart';

class GanttViewModel extends ChangeNotifier {
  final IAIRepository repository;

  GanttViewModel(this.repository);

  late final String _projectId;
  late final String _projectName;
  late final String _userGoal;
  bool _isLoading = false;
  String? _errorMessage;
  List<GanttActivity> _activities = [];
  final List<ChatMessage> _messages = [];
  ResponseData _aiResponse =
      ResponseData(projectId: '', aiComent: '', tasks: []);

  get projectName => _projectName;
  get userGoal => _userGoal;
  get isLoading => _isLoading;
  get errorMessage => _errorMessage;
  get activities => _activities;
  get messages => _messages;

  void addMessages(ChatMessage newMessage) {
    _messages.add(newMessage);
  }

  Future<void> create(InitData initdata) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      _projectName = initdata.title;
      _userGoal = initdata.userGoal;

      final json = await repository.create(initdata);
      _aiResponse = JsonParser.parseResponseData(json);

      _projectId = _aiResponse.projectId;
      _activities = _aiResponse.tasks;
      addMessages(ChatMessage(sender: 'ai', text: _aiResponse.aiComent));

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  Future<void> update() async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final json = await repository.update();
      _aiResponse = JsonParser.parseResponseData(json);

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
    }
  }
}
