import 'package:flutter/material.dart';
import 'dart:async';
import 'package:finease/widget/drawer.dart';
import 'package:finease/widget/list.dart';
import 'package:finease/widget/input.dart';
import 'package:finease/db.dart';
import 'package:finease/message.dart';
import 'package:finease/backend/message.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  bool isDarkModeEnabled = false;
  final List<Message> messages = []; // Ensure this list holds Message objects
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  void _toggleDarkMode(bool value) {
    setState(() {
      isDarkModeEnabled = value;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadMessages();
  }

  void _loadMessages() async {
    var db = DatabaseHelper();
    var loadedMessages = await db.getMessages();
    setState(() {
      messages.addAll(loadedMessages);
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  void _sendMessage() async {
    await sendMessage(
      text: _controller.text,
      messages: messages,
      updateState: () {
        setState(() {
          _controller.clear();
          _focusNode.requestFocus();
        });
      },
    );
  }

  void _clearDatabase() async {
    await DatabaseHelper().clearDatabase();
    setState(() {
      messages.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Finease'),
      ),
      drawer: ChatDrawer(
        onClearDatabase: _clearDatabase,
        isDarkModeEnabled: isDarkModeEnabled,
        onToggleDarkMode: _toggleDarkMode,
      ),
      body: Column(
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
      ),
    );
  }
}
