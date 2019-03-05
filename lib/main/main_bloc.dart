import 'dart:async';
import 'package:bloc/bloc.dart';

import 'events/main_event.dart';
import 'main_state.dart';
import '../model/user.dart';
import '../model/login_repo.dart';
import '../model/user_repo.dart';
import '../model/chat_repo.dart';
import '../util/util.dart';

class MainBloc extends Bloc<MainEvent, MainState> {

  void resetState() {
    dispatch(ResetStateEvent());
  }

  void logout() {
    LoginRepo.getInstance().signOut().then((success) {
      if (success) {
        UserRepo.getInstance().clearCurrentUser();
        dispatch(LogoutEvent());
      }
    });
  }

  @override
  MainState get initialState {
    retrieveUserChatrooms();
    return MainState.initial();
  }

  void retrieveUserChatrooms() async {
    dispatch(ClearChatroomsEvent());
    final user = await UserRepo.getInstance().getCurrentUser();
    if (user != null) {
      ChatRepo.getInstance().getChatroomsForUser(user).listen((chatrooms) {
        chatrooms.forEach((room) {
          if (room.participants.first.uid == user.uid) {
            Util.swapElementsInList(room.participants, 0, 1);
          }
        });
        dispatch(ChatroomsUpdatedEvent(chatrooms));
      });
    } else {
      dispatch(MainErrorEvent());
    }
  }

  void retrieveChatroomForParticipant(User user) async {
    final currentUser = await UserRepo.getInstance().getCurrentUser();
    List<User> users = List<User>(2);
    users[0] = user;
    users[1] = currentUser;
    ChatRepo.getInstance().startChatroomForUsers(users).then((chatroom) {
      dispatch(EnterChatEvent(chatroom));
    });
  }

  @override
  Stream<MainState> mapEventToState(
      MainState currentState,
      MainEvent event) async* {
    if (event is ClearChatroomsEvent) {
      yield MainState.isLoading(true, MainState.initial());
    } else if (event is ChatroomsUpdatedEvent) {
      yield MainState.isLoading(
          false, MainState.chatrooms(event.chatrooms, currentState));
    } else if (event is EnterChatEvent) {
      yield MainState.enterChatroom(event.chatroom, currentState);
    } else if (event is ResetStateEvent) {
      yield MainState.reset(currentState);
    } else if (event is LogoutEvent) {
      yield MainState.logout(currentState);
    } else if (event is MainErrorEvent) {
      yield MainState.isLoading(false, currentState);
    }
  }
}
