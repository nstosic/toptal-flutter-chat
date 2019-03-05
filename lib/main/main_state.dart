import '../model/chatroom.dart';

class MainState {
  final bool isLoading;
  final List<Chatroom> chatrooms;
  final SelectedChatroom selected;
  final bool loggedIn;

  MainState._internal(this.isLoading, this.chatrooms, {this.loggedIn = true, this.selected});

  factory MainState.initial() => MainState._internal(false, List<Chatroom>(0));
  factory MainState.isLoading(bool isLoading, MainState state) => MainState._internal(isLoading, state.chatrooms);
  factory MainState.chatrooms(List<Chatroom> chatrooms, MainState state) => MainState._internal(state.isLoading, chatrooms);
  factory MainState.enterChatroom(SelectedChatroom chatroom, MainState state) => MainState._internal(false, state.chatrooms, selected: chatroom);
  factory MainState.logout(MainState state) => MainState._internal(false, state.chatrooms, loggedIn: false);
  factory MainState.reset(MainState state) => MainState._internal(state.isLoading, state.chatrooms);
}