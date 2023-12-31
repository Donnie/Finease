import 'package:flutter/material.dart';
import 'package:fineas/db/messages.dart';

class MessagesListView extends StatelessWidget {
  final List<Message> messages;

  const MessagesListView({Key? key, required this.messages}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        reverse: true,
        itemCount: messages.length,
        itemBuilder: (context, index) {
          final message = messages[index];
          return Align(
            alignment: message.type == MessageType.user
                ? Alignment.centerRight
                : Alignment.centerLeft,
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
              decoration: BoxDecoration(
                color: message.type == MessageType.automated
                    ? Colors.lightBlueAccent
                    : Colors.lightGreenAccent,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Text(
                message.content,
                style: const TextStyle(color: Colors.black, fontSize: 10),
              ),
            ),
          );
        },
      ),
    );
  }
}
