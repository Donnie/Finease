import 'package:flutter/material.dart';

class ChatInputArea extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final Function(String) onSubmitted;
  final bool isProcessing;

  const ChatInputArea({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.onSubmitted,
    this.isProcessing = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              controller: controller,
              enabled: !isProcessing,
              decoration: InputDecoration(
                hintText: isProcessing ? 'Processing...' : 'Type a message',
              ),
              focusNode: focusNode,
              onSubmitted: onSubmitted,
              textInputAction: TextInputAction.send,
              keyboardType: TextInputType.multiline,
              maxLines: null,
            ),
          ),
          IconButton(
            icon: Icon(
              isProcessing ? Icons.hourglass_top : Icons.send,
              color: isProcessing ? Colors.grey : Theme.of(context).primaryColor,
            ),
            onPressed: isProcessing ? null : () => onSubmitted(controller.text),
          ),
        ],
      ),
    );
  }
}
