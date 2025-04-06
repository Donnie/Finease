import 'package:finease/db/messages.dart';
import 'package:finease/parts/app_drawer.dart';
import 'package:finease/parts/app_top_bar.dart';
import 'package:finease/parts/input.dart';
import 'package:finease/parts/list.dart';
import 'package:finease/pages/home/frame/destinations.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  ChatScreenState createState() => ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> {
  final List<Message> messages = [];
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _loadDemoMessages();
    // Request focus when the screen is first loaded
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  void _loadDemoMessages() {
    setState(() {
      messages.clear();
      messages.addAll([
        Message(
          content: "Welcome to the chat!",
          type: MessageType.automated,
        ),
        Message(
          content: "This is a demo chat interface.",
          type: MessageType.automated,
        ),
        Message(
          content: "Try sending a message to see how it works.",
          type: MessageType.automated,
        ),
      ]);
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _sendMessage() {
    if (_controller.text.isEmpty) return;
    
    setState(() {
      // Add user message
      messages.insert(0, Message(
        content: _controller.text,
        type: MessageType.user,
      ));
      
      // Add automated response
      messages.insert(0, Message(
        content: "You said: ${_controller.text}",
        type: MessageType.automated,
      ));
      
      _controller.clear();
    });
    
    // Request focus after state update
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldStateKey = GlobalKey<ScaffoldState>();
    int destIndex = 4; // Index of chat in destinations list

    void updateBody(int index) {
      setState(() {
        destIndex = index;
      });
      context.goNamed(
        destinations[destIndex].routeName.name,
        extra: () => {},
      );
    }

    return Scaffold(
      key: scaffoldStateKey,
      appBar: appBar(context, "chat"),
      drawer: AppDrawer(
        onRefresh: () {
          _loadDemoMessages();
        },
        scaffoldKey: scaffoldStateKey,
        selectedIndex: destIndex,
        destinations: destinations,
        onDestinationSelected: updateBody,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          _loadDemoMessages();
        },
        child: Column(
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
      ),
    );
  }
}
