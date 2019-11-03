import '../model/message.dart';

class InstantMessagingState {
  final bool isLoading;
  final List<Message> messages;
  final bool error;

  InstantMessagingState._internal(this.isLoading, this.messages, {this.error = false});

  factory InstantMessagingState.initial() => InstantMessagingState._internal(true, List<Message>(0));

  factory InstantMessagingState.messages(List<Message> messages) => InstantMessagingState._internal(false, messages);

  factory InstantMessagingState.error(InstantMessagingState state) => InstantMessagingState._internal(state.isLoading, state.messages, error: true);
}