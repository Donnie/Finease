import 'package:flutter/material.dart';
import 'package:finease/db/db.dart';

class MessageService {
  final DatabaseHelper _databaseHelper;

  MessageService({DatabaseHelper? databaseHelper})
      : _databaseHelper = databaseHelper ?? DatabaseHelper();

  Future<int> saveMessage(Message message) async {
    final dbClient = await _databaseHelper.db;
    return dbClient.insert('Messages', message.toMap());
  }

  Future<List<Message>> getMessages() async {
    final dbClient = await _databaseHelper.db;
    final list = await dbClient.rawQuery('SELECT * FROM Messages ORDER BY created_at DESC');
    return list.map((item) => Message.fromMap(item)).toList();
  }
}

Future<void> sendMessage({
  required String content,
  required List<Message> messageList,
  required VoidCallback onStateUpdated,
}) async {
  if (content.isNotEmpty) {
    final userMessage = Message(content: content, type: MessageType.user);
    messageList.insert(0, userMessage);
    await MessageService().saveMessage(userMessage);

    final responseMessage = Message(content: "You said: $content", type: MessageType.automated);
    messageList.insert(0, responseMessage);
    await MessageService().saveMessage(responseMessage);

    onStateUpdated();
  }
}

enum MessageType { user, automated }

class Message {
  final String content;
  final MessageType type;
  final int createdAt;

  Message({required this.content, required this.type, int? createdAt})
      : createdAt = createdAt ?? DateTime.now().millisecondsSinceEpoch;

  Map<String, dynamic> toMap() {
    return {
      'content': content,
      'type': type.index,
      'created_at': createdAt,
    };
  }

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      content: map['content'],
      type: MessageType.values[map['type']],
      createdAt: map['created_at'],
    );
  }
}
