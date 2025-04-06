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
    _loadMessages();
  }

  Future<void> _loadMessages() async {
    var msg = MessageService();
    var loadedMessages = await msg.getMessages();
    setState(() {
      messages.clear();
      messages.addAll(loadedMessages);
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _controller.dispose();
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
        onRefresh: _loadMessages,
        scaffoldKey: scaffoldStateKey,
        selectedIndex: destIndex,
        destinations: destinations,
        onDestinationSelected: updateBody,
      ),
      body: RefreshIndicator(
        onRefresh: _loadMessages,
        child: Column(
          children: <Widget>[
            Expanded(
              child: MessagesListView(messages: messages),
            ),
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
