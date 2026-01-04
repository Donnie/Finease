import 'package:flutter/material.dart';
import 'package:finease/db/messages.dart';
import 'package:finease/core/export.dart';

class MessagesListView extends StatelessWidget {
  final List<Message> messages;

  const MessagesListView({super.key, required this.messages});

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
                    ? context.secondaryContainer
                    : context.tertiaryContainer,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Text(
                message.content,
                style: TextStyle(
                  color: context.onSurface, 
                  fontSize: 10,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
