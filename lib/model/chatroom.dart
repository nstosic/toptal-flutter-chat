import 'package:toptal_chat/model/message.dart';
import 'package:toptal_chat/model/user.dart';

class SelectedChatroom {
  SelectedChatroom(this.id, this.displayName);

  final String id;
  final String displayName;
}

class Chatroom {
  Chatroom(this.participants, [this.messages]);

  final List<User> participants;
  final List<Message> messages;
}
