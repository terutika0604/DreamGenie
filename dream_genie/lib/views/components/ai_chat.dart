import 'package:flutter/material.dart';
import 'package:flutter_gantt/flutter_gantt.dart';
import 'package:provider/provider.dart';

import '../../models/chat_message.dart';
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
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<GanttViewModel>();

    return Positioned(
      top: 0,
      right: 0,
      bottom: 0,
      child: Container(
        width: 300,
        color: Colors.white,
        child: Column(mainAxisSize: MainAxisSize.max, children: [
          Container(
            height: 50,
            color: Colors.blue,
            alignment: Alignment.center,
            child: const Text("AI Chat", style: TextStyle(color: Colors.white)),
          ),

          // チャットメッセージ一覧
          Expanded(
            child: ListView.builder(
              itemCount: vm.messages.length,
              itemBuilder: (context, index) {
                final msg = vm.messages[index];
                return ListTile(
                  title: Text(msg.text),
                  subtitle: Text(msg.sender),
                );
              },
            ),
          ),

          // 入力欄
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _inputController,
                    decoration:
                        const InputDecoration(hintText: "Type a message"),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () async {
                    vm.addMessages(ChatMessage(
                        sender: 'user', text: _inputController.text));
                    _inputController.text = '';
                    await vm.update();
                    widget.controller.update();
                  },
                ),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
