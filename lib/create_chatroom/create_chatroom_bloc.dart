import 'dart:async';
import 'package:bloc/bloc.dart';

import 'package:toptal_chat/create_chatroom/create_chatroom_event.dart';
import 'package:toptal_chat/create_chatroom/create_chatroom_state.dart';
import 'package:toptal_chat/model/chat_repo.dart';
import 'package:toptal_chat/model/chatroom.dart';
import 'package:toptal_chat/model/user.dart';
import 'package:toptal_chat/model/user_repo.dart';

class CreateChatroomBloc extends Bloc<CreateChatroomEvent, CreateChatroomState> {
  User currentUser;
  StreamSubscription<List<User>> chatUserSubscription;

  CreateChatroomBloc(CreateChatroomState initialState) : super(initialState) {
    _initialize();
  }

  void dispatchCancelEvent() {
    add(CancelCreateChatroomEvent());
  }

  void resetState() {
    dispatchCancelEvent();
  }

  void _initialize() async {
    currentUser = await UserRepo.getInstance().getCurrentUser();
    chatUserSubscription = ChatRepo.getInstance().getChatUsers().listen((users) {
      List<User> processedListOfUsers = users.where((user) => user.uid != currentUser.uid).toList();
      add(ChatroomUserListUpdatedEvent(processedListOfUsers));
    });
  }

  void startChat(User user, Function(SelectedChatroom chatroomId) onChatroomIdProcessed) {
    add(CreateChatroomRequestedEvent());
    assert(currentUser != null);
    assert(currentUser != user);
    List<User> chatroomUsers = List<User>(2);
    chatroomUsers[0] = user;
    chatroomUsers[1] = currentUser;
    ChatRepo.getInstance().startChatroomForUsers(chatroomUsers).then((chatroom) {
      onChatroomIdProcessed(chatroom);
    });
  }

  @override
  Stream<CreateChatroomState> mapEventToState(CreateChatroomEvent event) async* {
    if (event is ChatroomUserListUpdatedEvent) {
      yield CreateChatroomState.isLoading(false, CreateChatroomState.users(event.users, state));
    } else if (event is CreateChatroomRequestedEvent) {
      yield CreateChatroomState.isLoading(true, state);
    }
  }

  @override
  Future<void> close() async {
    if (chatUserSubscription != null) {
      chatUserSubscription.cancel();
    }
    return super.close();
  }
}
