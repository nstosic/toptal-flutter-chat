import 'dart:async';
import 'package:bloc/bloc.dart';

import 'instant_messaging_event.dart';
import 'instant_messaging_state.dart';
import '../model/user.dart';
import '../model/message.dart';
import '../model/chatroom.dart';
import '../model/chat_repo.dart';
import '../model/user_repo.dart';

class InstantMessagingBloc extends Bloc<InstantMessagingEvent, InstantMessagingState> {
  InstantMessagingBloc(this.chatroomId);

  final String chatroomId;
  StreamSubscription<Chatroom> chatroomSubscription;

  void _retrieveMessagesForThisChatroom() async {
    final User user = await UserRepo.getInstance().getCurrentUser();
    chatroomSubscription = ChatRepo.getInstance().getMessagesForChatroom(chatroomId).listen((chatroom) {
      if (chatroom != null) {
        List<Message> processedMessages = chatroom.messages
            .map((message) => Message(
                message.author, message.timestamp, message.value, message.author.uid == user.uid))
            .toList();
        dispatch(MessageReceivedEvent(processedMessages));
      }
    });
  }
  
  void send(String text) async {
    final User user = await UserRepo.getInstance().getCurrentUser();
    final bool success = await ChatRepo.getInstance().sendMessageToChatroom(chatroomId, user, text);
    if (!success) {
      dispatch(MessageSendErrorEvent());
    }
  }

  @override
  InstantMessagingState get initialState {
    _retrieveMessagesForThisChatroom();
    return InstantMessagingState.initial();
  }

  @override
  Stream<InstantMessagingState> mapEventToState(InstantMessagingEvent event) async* {
    if (event is MessageReceivedEvent) {
      yield InstantMessagingState.messages(event.messages);
    } else if (event is MessageSendErrorEvent) {
      yield InstantMessagingState.error(currentState);
    }
  }

  @override
  void dispose() {
    if (chatroomSubscription != null) {
      chatroomSubscription.cancel();
    }
    super.dispose();
  }
}
