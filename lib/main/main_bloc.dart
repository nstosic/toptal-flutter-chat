import 'dart:async';
import 'package:bloc/bloc.dart';

import 'main_event.dart';
import 'main_state.dart';
import 'main_view.dart';
import '../model/user.dart';
import '../model/chatroom.dart';
import '../model/login_repo.dart';
import '../model/user_repo.dart';
import '../model/chat_repo.dart';
import '../util/util.dart';

class MainBloc extends Bloc<MainEvent, MainState> {
  StreamSubscription<List<Chatroom>> chatroomsSubscription;

  void logout(MainWidget view) {
    LoginRepo.getInstance().signOut().then((success) {
      if (success) {
        view.navigateToLogin();
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
      chatroomsSubscription = ChatRepo.getInstance().getChatroomsForUser(user).listen((chatrooms) {
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

  void retrieveChatroomForParticipant(User user, MainWidget view) async {
    final currentUser = await UserRepo.getInstance().getCurrentUser();
    List<User> users = List<User>(2);
    users[0] = user;
    users[1] = currentUser;
    ChatRepo.getInstance().startChatroomForUsers(users).then((chatroom) {
      view.navigateToChatroom(chatroom);
    });
  }

  @override
  Stream<MainState> mapEventToState(MainEvent event) async* {
    if (event is ClearChatroomsEvent) {
      yield MainState.isLoading(true, MainState.initial());
    } else if (event is ChatroomsUpdatedEvent) {
      yield MainState.isLoading(false, MainState.chatrooms(event.chatrooms, currentState));
    } else if (event is MainErrorEvent) {
      yield MainState.isLoading(false, currentState);
    }
  }

  @override
  void dispose() {
    if (chatroomsSubscription != null) {
      chatroomsSubscription.cancel();
    }
    super.dispose();
  }
}
