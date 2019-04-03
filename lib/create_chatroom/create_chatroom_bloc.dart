import 'dart:async';
import 'package:bloc/bloc.dart';

import 'create_chatroom_event.dart';
import 'create_chatroom_state.dart';
import 'create_chatroom_view.dart';
import '../model/chat_repo.dart';
import '../model/user.dart';
import '../model/user_repo.dart';

class CreateChatroomBloc
    extends Bloc<CreateChatroomEvent, CreateChatroomState> {
  User currentUser;
  StreamSubscription<List<User>> chatUserSubscription;

  void dispatchCancelEvent() {
    dispatch(CancelCreateChatroomEvent());
  }

  void resetState() {
    dispatchCancelEvent();
  }

  @override
  CreateChatroomState get initialState {
    _initialize();
    return CreateChatroomState.initial();
  }

  void _initialize() async {
    currentUser = await UserRepo.getInstance().getCurrentUser();
    chatUserSubscription = ChatRepo.getInstance().getChatUsers().listen((users) {
      List<User> processedListOfUsers = users.where((user) => user.uid != currentUser.uid).toList();
      dispatch(ChatroomUserListUpdatedEvent(processedListOfUsers));
    });
  }

  void startChat(User user, CreateChatroomWidget view) {
    dispatch(CreateChatroomRequestedEvent());
    assert(currentUser != null);
    assert(currentUser != user);
    List<User> chatroomUsers = List<User>(2);
    chatroomUsers[0] = user;
    chatroomUsers[1] = currentUser;
    ChatRepo.getInstance().startChatroomForUsers(chatroomUsers).then((chatroom) {
      view.navigateToSelectedChatroom(chatroom);
    });
  }

  @override
  Stream<CreateChatroomState> mapEventToState(CreateChatroomEvent event) async* {
    if (event is ChatroomUserListUpdatedEvent) {
      yield CreateChatroomState.isLoading(false, CreateChatroomState.users(event.users, currentState));
    } else if (event is CreateChatroomRequestedEvent) {
      yield CreateChatroomState.isLoading(true, currentState);
    }
  }

  @override
  void dispose() {
    if (chatUserSubscription != null) {
      chatUserSubscription.cancel();
    }
    super.dispose();
  }
}
