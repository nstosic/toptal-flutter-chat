import '../model/message.dart';

abstract class InstantMessagingEvent {}

class MessageReceivedEvent extends InstantMessagingEvent {
  final List<Message> messages;

  MessageReceivedEvent(this.messages);
}

class MessageSendErrorEvent extends InstantMessagingEvent {}