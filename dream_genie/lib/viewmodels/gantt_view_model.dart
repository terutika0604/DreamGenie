import 'package:flutter/material.dart';
import 'package:flutter_gantt/flutter_gantt.dart';

import '../models/chat_message.dart';
import '../models/init_data.dart';
import '../models/response_data.dart';
import '../models/update_data.dart';
import '../repositories/ai_repository.dart';
import '../utils/json_parser.dart';

class GanttViewModel extends ChangeNotifier {
  final IAIRepository repository;

  GanttViewModel(this.repository);

  late final String _projectId;
  late final String _projectName;
  late final String _userGoal;
  bool _isLoading = false;
  bool _isChanging = false;
  String? _errorMessage;
  List<GanttActivity> _oldActivities = [];
  List<GanttActivity> _activities = [];
  final List<ChatMessage> _messages = [];
  Map<String, dynamic> _changingJson = {};
  ResponseData _aiResponse =
      ResponseData(projectId: '', aiComment: '', tasks: []);

  get projectId => _projectId;
  get projectName => _projectName;
  get userGoal => _userGoal;
  get isLoading => _isLoading;
  get isChanging => _isChanging;
  get errorMessage => _errorMessage;
  get activities => _activities;
  get messages => _messages;

  void addMessages(ChatMessage newMessage) {
    _messages.add(newMessage);
  }

  Future<void> createSchedule(InitData initData) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      _projectName = initData.title;
      _userGoal = initData.userGoal;

      final json = await repository.createSchedule(initData);
      try {
        _aiResponse = JsonParser.parseResponseData(json);
      } catch (e) {
        debugPrint('parse error: $e');
      }
      _projectId = _aiResponse.projectId;
      _activities = _aiResponse.tasks;
      addMessages(ChatMessage(sender: 'ai', text: _aiResponse.aiComment));

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  Future<void> updateSchedule(UpdateData updateData) async {
    try {
      _isLoading = true;
      _oldActivities = _activities;
      _errorMessage = null;
      notifyListeners();

      final json = await repository.updateSchedule(updateData);
      _changingJson = json;
      try {
        _aiResponse = JsonParser.parseResponseData(json);
      } catch (e) {
        debugPrint('parse error: $e');
      }

      _isChanging = true;
      _activities = _aiResponse.tasks;
      addMessages(ChatMessage(sender: 'ai', text: _aiResponse.aiComment));
      addMessages(ChatMessage(sender: 'ai', text: "これで確定しますか？"));

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  void acceptUpdate() async {
    _isChanging = false;
    await repository.acceptUpdate(_changingJson);
    _resetOldData();
    addMessages(ChatMessage(sender: 'ai', text: "確定しました！"));
    notifyListeners();
  }

  void rejectUpdate() {
    _isChanging = false;
    _activities = _oldActivities;
    _resetOldData();
    addMessages(ChatMessage(
        sender: 'ai', text: "元に戻しました！具体的な指示をしていただければご要望にそった変更がしやすくなります。"));
    notifyListeners();
  }

  void _resetOldData() {
    _changingJson = {};
    _oldActivities = [];
  }
}
