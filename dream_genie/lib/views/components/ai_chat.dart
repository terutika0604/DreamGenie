import 'package:flutter/material.dart';
import 'package:flutter_gantt/flutter_gantt.dart';
import 'package:provider/provider.dart';

import '../../constant.dart';
import '../../models/chat_message.dart';
import '../../models/update_data.dart';
import '../../theme.dart';
import '../../viewmodels/gantt_view_model.dart';

class AiChatComponent extends StatefulWidget {
  const AiChatComponent({super.key, required this.controller});

  final GanttController controller;

  @override
  State<AiChatComponent> createState() => _AiChatComponentState();
}

class _AiChatComponentState extends State<AiChatComponent> {
  final TextEditingController _inputController = TextEditingController();

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

  Future<void> _sendMessage(GanttViewModel vm, String text) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return;

    vm.addMessages(ChatMessage(sender: 'user', text: trimmed));
    _inputController.clear();

    await vm.updateSchedule(UpdateData(
      projectId: vm.projectId,
      userId: userId,
      userMessage: trimmed,
    ));
    widget.controller.update();
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<GanttViewModel>();
    final theme = Theme.of(context);

    return Positioned(
      top: 5,
      right: 5,
      bottom: 5,
      child: Container(
        width: 350,
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Color.fromARGB(124, 158, 158, 158),
              spreadRadius: 5,
              blurRadius: 10,
              offset: Offset(1, 1),
            ),
          ],
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: Column(
          children: [
            Container(
              height: 50,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                color: AppTheme.chatHeaderColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
              ),
              child:
                  const Text("AI Chat", style: TextStyle(color: Colors.white)),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: vm.messages.length,
                itemBuilder: (context, index) {
                  final msg = vm.messages[index];
                  final isUser = msg.sender == 'user';
                  final theme = Theme.of(context);

                  return Align(
                    alignment:
                        isUser ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 12),
                      decoration: BoxDecoration(
                        color: isUser
                            ? AppTheme.userBubbleColor
                            : AppTheme.aiBubbleColor,
                        borderRadius: BorderRadius.only(
                          topLeft: const Radius.circular(12),
                          topRight: const Radius.circular(12),
                          bottomLeft:
                              isUser ? const Radius.circular(12) : Radius.zero,
                          bottomRight:
                              isUser ? Radius.zero : const Radius.circular(12),
                        ),
                      ),
                      child: Text(
                        msg.text,
                        style: TextStyle(
                          color: isUser
                              ? Colors.white
                              : theme.colorScheme.onSurface,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: vm.isChanging
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () async {
                            vm.addMessages(
                                ChatMessage(sender: 'user', text: 'はい'));
                            vm.acceptUpdate();
                            widget.controller.update();
                          },
                          child: const Text("はい"),
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            vm.addMessages(
                                ChatMessage(sender: 'user', text: 'いいえ'));
                            vm.rejectUpdate();
                            widget.controller.update();
                          },
                          child: const Text("いいえ"),
                        ),
                      ],
                    )
                  : Row(
                      children: [
                        Expanded(
                          child: TextField(
                            textInputAction: TextInputAction.send,
                            controller: _inputController,
                            decoration: InputDecoration(
                              hintText: "Type a message",
                              filled: true,
                              fillColor: Colors.grey[100],
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide.none,
                              ),
                              contentPadding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                            ),
                            onSubmitted: (value) async {
                              await _sendMessage(vm, value);
                            },
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.send,
                              color: theme.colorScheme.primary),
                          onPressed: () async {
                            await _sendMessage(vm, _inputController.text);
                          },
                        ),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
