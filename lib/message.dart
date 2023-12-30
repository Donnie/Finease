enum MessageType { user, automated }

class Message {
  String text;
  MessageType type;
  int createdAt; // Timestamp in milliseconds

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
        type = map["type"] == "MessageType.user" ? MessageType.user : MessageType.automated,
        createdAt = map["created_at"];
}
