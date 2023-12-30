import 'package:finease/db.dart';
import 'package:finease/message.dart';

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
