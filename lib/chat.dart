import 'package:finease/core/constants/constants.dart';
import 'package:finease/db/db.dart';
import 'package:finease/db/messages.dart';
import 'package:finease/widgets/drawer.dart';
import 'package:finease/widgets/input.dart';
import 'package:finease/widgets/list.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  ChatScreenState createState() => ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> {
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
    var msg = MessageService();
    var loadedMessages = await msg.getMessages();
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
      content: _controller.text,
      messageList: messages,
      onStateUpdated: () {
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
        title: Text(language["appTitle"]),
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
