import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

import 'package:toptal_chat/main/main_event.dart';
import 'package:toptal_chat/main/main_state.dart';
import 'package:toptal_chat/model/user.dart';
import 'package:toptal_chat/model/chatroom.dart';
import 'package:toptal_chat/model/login_repo.dart';
import 'package:toptal_chat/model/user_repo.dart';
import 'package:toptal_chat/model/chat_repo.dart';
import 'package:toptal_chat/util/util.dart';

class MainBloc extends Bloc<MainEvent, MainState> {
  MainBloc(MainState initialState) : super(initialState) {
    retrieveUserChatrooms();
  }

  StreamSubscription<List<Chatroom>> chatroomsSubscription;

  void logout(VoidCallback onLogout) {
    LoginRepo.getInstance().signOut().then((success) {
      if (success) {
        onLogout();
      }
    });
  }

  void retrieveUserChatrooms() async {
    add(ClearChatroomsEvent());
    final user = await UserRepo.getInstance().getCurrentUser();
    if (user != null) {
      chatroomsSubscription = ChatRepo.getInstance().getChatroomsForUser(user).listen((chatrooms) {
        chatrooms.forEach((room) {
          if (room.participants.first.uid == user.uid) {
            Util.swapElementsInList(room.participants, 0, 1);
          }
        });
        add(ChatroomsUpdatedEvent(chatrooms));
      });
    } else {
      add(MainErrorEvent());
    }
  }

  void retrieveChatroomForParticipant(User user, Function(SelectedChatroom) onChatroomProcessed) async {
    final currentUser = await UserRepo.getInstance().getCurrentUser();
    List<User> users = List<User>(2);
    users[0] = user;
    users[1] = currentUser;
    ChatRepo.getInstance().startChatroomForUsers(users).then((chatroom) {
      onChatroomProcessed(chatroom);
    });
  }

  @override
  Stream<MainState> mapEventToState(MainEvent event) async* {
    if (event is ClearChatroomsEvent) {
      yield MainState.isLoading(true, MainState.initial());
    } else if (event is ChatroomsUpdatedEvent) {
      yield MainState.isLoading(false, MainState.chatrooms(event.chatrooms, state));
    } else if (event is MainErrorEvent) {
      yield MainState.isLoading(false, state);
    }
  }

  @override
  Future<void> close() async {
    if (chatroomsSubscription != null) {
      chatroomsSubscription.cancel();
    }
    return super.close();
  }
}
