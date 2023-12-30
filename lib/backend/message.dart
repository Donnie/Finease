import 'package:finease/db.dart';

Future<void> sendMessage({
  required String text,
  required List<Message> messages,
  required Function updateState,
}) async {
  if (text.isNotEmpty) {
    var userMessage = Message(text, MessageType.user);
    messages.insert(0, userMessage);
    await DatabaseHelper().saveMessage(userMessage);

    var responseMessage = Message("You said: $text", MessageType.automated);
    messages.insert(0, responseMessage);
    await DatabaseHelper().saveMessage(responseMessage);

    updateState();
  }
}

enum MessageType { user, automated }

class Message {
  String text;
  MessageType type;
  int createdAt;

  Message(this.text, this.type, [int? createdAt])
      : createdAt = createdAt ?? DateTime.now().millisecondsSinceEpoch;

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      "text": text,
      "type": type.toString(),
      "created_at": createdAt,
    };
    return map;
  }

  Message.fromMap(Map<String, dynamic> map)
      : text = map["text"],
        type = map["type"] == "MessageType.user"
            ? MessageType.user
            : MessageType.automated,
        createdAt = map["created_at"];
}
