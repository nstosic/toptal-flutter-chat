import '../model/user.dart';
import '../model/chatroom.dart';

class CreateChatroomAction {
  CreateChatroomAction(this.chatroom, this.canceled);

  final SelectedChatroom chatroom;
  final bool canceled;
}

class CreateChatroomState {
  final List<User> users;
  final bool isLoading;
  final CreateChatroomAction action;

  CreateChatroomState._internal(this.users, this.isLoading, {this.action});

  factory CreateChatroomState.initial() =>
      CreateChatroomState._internal(List<User>(0), true);

  factory CreateChatroomState.isLoading(
          bool isLoading, CreateChatroomState state) =>
      CreateChatroomState._internal(state.users, isLoading);

  factory CreateChatroomState.users(
          List<User> users, CreateChatroomState state) =>
      CreateChatroomState._internal(users, state.isLoading);
}
