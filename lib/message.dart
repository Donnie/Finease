enum MessageType { user, automated }

class Message {
  String text;
  MessageType type;

  Message(this.text, this.type);

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      "text": text,
      "type": type.toString(),
    };
    return map;
  }

  Message.fromMap(Map<String, dynamic> map)
      : text = map["text"],
        type = map["type"] == "MessageType.user" ? MessageType.user : MessageType.automated;
}
