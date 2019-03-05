import '../model/user.dart';
import '../model/chatroom.dart';

abstract class CreateChatroomEvent {}

class ChatroomUserListUpdatedEvent extends CreateChatroomEvent {
  ChatroomUserListUpdatedEvent(this.users);

  final List<User> users;
}

class CreateChatroomRequestedEvent extends CreateChatroomEvent {}

class ChatroomSelectedEvent extends CreateChatroomEvent {
  ChatroomSelectedEvent(this.chatroom);

  final SelectedChatroom chatroom;
}

class CancelCreateChatroomEvent extends CreateChatroomEvent {}