import 'package:flutter/material.dart';
import 'package:flutter_gantt/flutter_gantt.dart';

import '../models/ai_response.dart';
import '../models/chat_message.dart';
import '../models/init_data.dart';
import '../repositories/ai_repository.dart';
import '../utils/json_parser.dart';

class GanttViewModel extends ChangeNotifier {
  final IAIRepository repository;

  GanttViewModel(this.repository);

  bool isLoading = false;
  String? errorMessage;
  List<GanttActivity> activities = [];
  AiResponse _aiResponse = AiResponse(aiComent: '', tasks: []);

  List<ChatMessage> messages = [];

  void addMessages(ChatMessage newMessage) {
    messages.add(newMessage);
  }

  Future<void> create(InitData initdata) async {
    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      final json = await repository.create(initdata);
      _aiResponse = JsonParser.parseGanttActivities(json);

      activities = _aiResponse.tasks;
      addMessages(ChatMessage(sender: 'ai', text: _aiResponse.aiComent));

      isLoading = false;
      notifyListeners();
    } catch (e) {
      isLoading = false;
      errorMessage = e.toString();
      notifyListeners();
    }
  }

  Future<void> update() async {
    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      final json = await repository.update();
      _aiResponse = JsonParser.parseGanttActivities(json);

      isLoading = false;
      notifyListeners();
    } catch (e) {
      isLoading = false;
      errorMessage = e.toString();
      notifyListeners();
    }
  }
}
