import 'dart:async';
import 'dart:io';
import 'package:bloc/bloc.dart';

import 'package:toptal_chat/instant_messaging/instant_messaging_event.dart';
import 'package:toptal_chat/instant_messaging/instant_messaging_state.dart';
import 'package:toptal_chat/model/user.dart';
import 'package:toptal_chat/model/message.dart';
import 'package:toptal_chat/model/chatroom.dart';
import 'package:toptal_chat/model/chat_repo.dart';
import 'package:toptal_chat/model/user_repo.dart';
import 'package:toptal_chat/model/storage_repo.dart';

class InstantMessagingBloc extends Bloc<InstantMessagingEvent, InstantMessagingState> {
  InstantMessagingBloc(InstantMessagingState state, this.chatroomId) : super(state) {
    _retrieveMessagesForThisChatroom();
  }

  final String chatroomId;
  StreamSubscription<Chatroom> chatroomSubscription;

  void _retrieveMessagesForThisChatroom() async {
    final User user = await UserRepo.getInstance().getCurrentUser();
    chatroomSubscription = ChatRepo.getInstance().getMessagesForChatroom(chatroomId).listen((chatroom) async {
      if (chatroom != null) {
        Stream<Message> processedMessagesStream = Stream.fromIterable(chatroom.messages).asyncMap((message) async {
          if (message.value.startsWith("_uri:")) {
            final String uri = message.value.substring("_uri:".length);
            final String downloadUri = await StorageRepo.getInstance().decodeUri(uri);
            return Message(message.author, message.timestamp, "_uri:$downloadUri", message.author.uid == user.uid);
          }
          return Message(message.author, message.timestamp, message.value, message.author.uid == user.uid);
        });
        final List<Message> processedMessages = await processedMessagesStream.toList();
        add(MessageReceivedEvent(processedMessages));
      }
    });
  }

  void send(String text) async {
    final User user = await UserRepo.getInstance().getCurrentUser();
    final bool success = await ChatRepo.getInstance().sendMessageToChatroom(chatroomId, user, text);
    if (!success) {
      add(MessageSendErrorEvent());
    }
  }

  void sendFile(File file) async {
    final String storagePath = await StorageRepo.getInstance().uploadFile(file);
    if (storagePath != null) {
      _sendFileUri(storagePath);
    } else {
      add(MessageSendErrorEvent());
    }
  }

  void _sendFileUri(String uri) async {
    send("_uri:$uri");
  }

  @override
  Stream<InstantMessagingState> mapEventToState(InstantMessagingEvent event) async* {
    if (event is MessageReceivedEvent) {
      yield InstantMessagingState.messages(event.messages);
    } else if (event is MessageSendErrorEvent) {
      yield InstantMessagingState.error(state);
    }
  }

  @override
  Future<void> close() async {
    if (chatroomSubscription != null) {
      chatroomSubscription.cancel();
    }
    return super.close();
  }
}
