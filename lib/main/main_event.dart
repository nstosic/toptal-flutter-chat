import '../model/chatroom.dart';

abstract class MainEvent {}

class ClearChatroomsEvent extends MainEvent {}

class ChatroomsUpdatedEvent extends MainEvent {
  ChatroomsUpdatedEvent(this.chatrooms);

  final List<Chatroom> chatrooms;
}

class MainErrorEvent extends MainEvent {}
