import 'package:flutter/material.dart';
import 'package:sticker_app/features/chat/presentation/widgets/chat_appbar.dart';
import 'package:sticker_app/features/chat/presentation/widgets/chat_body.dart';

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

  // CHAT UI
  Widget _buildUI(BuildContext buildContext) {
    return Scaffold(
      appBar: ChatAppBar(
        onBack: () {
          // Navigator.pop(buildContext);
        },
      ),
      body: _buildChatBodyUI(buildContext),
    );
  }

  Widget _buildChatBodyUI(BuildContext chatBodyContext) {
    return ChatBody();
  }
}
