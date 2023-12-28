import 'package:flutter/material.dart';
import 'dart:async';
import 'package:finease/widget/list.dart';
import 'package:finease/widget/input.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<Message> messages = []; // Ensure this list holds Message objects
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 10), (timer) {
      setState(() {
        messages.insert(0, Message('Hello World', MessageType.automated));
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _focusNode.dispose();
    super.dispose();
  }

  void _sendMessage() {
    setState(() {
      if (_controller.text.isNotEmpty) {
        messages.insert(0, Message(_controller.text, MessageType.user));
        _controller.clear();
      }
      _focusNode.requestFocus();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        MessagesListView(messages: messages),
        ChatInputArea(
          controller: _controller,
          focusNode: _focusNode,
          onSubmitted: (value) {
            if (value.isNotEmpty) {
              _sendMessage();
            }
          },
        ),
      ],
    );
  }
}

enum MessageType { user, automated }

class Message {
  String text;
  MessageType type;

  Message(this.text, this.type);
}
