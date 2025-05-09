import 'package:flutter/material.dart';
import 'package:sticker_app/features/chat/widgets/chat_appbar.dart';
import 'package:sticker_app/features/chat/widgets/chat_body.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  Widget build(BuildContext buildContext) {
    return _buildUI(buildContext);
  }

  Widget _buildUI(BuildContext buildContext) {
    return Scaffold(appBar: chatAppBar(buildContext), body: const ChatBody());
  }
}
