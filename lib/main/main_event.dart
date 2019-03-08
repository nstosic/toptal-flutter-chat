import '../../model/chatroom.dart';

abstract class MainEvent {}

class ClearChatroomsEvent extends MainEvent {}

class ChatroomsUpdatedEvent extends MainEvent {
  ChatroomsUpdatedEvent(this.chatrooms);

  final List<Chatroom> chatrooms;
}

class EnterChatEvent extends MainEvent {
  EnterChatEvent(this.chatroom);

  final SelectedChatroom chatroom;
}

class ResetStateEvent extends MainEvent {}

class LogoutEvent extends MainEvent {}

class MainErrorEvent extends MainEvent {}
