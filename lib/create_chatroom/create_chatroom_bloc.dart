import 'package:bloc/bloc.dart';
import 'package:toptal_chat/create_chatroom/create_chatroom_event.dart';
import 'package:toptal_chat/create_chatroom/create_chatroom_state.dart';
import 'package:toptal_chat/model/chat_repo.dart';
import 'package:toptal_chat/model/user.dart';
import 'package:toptal_chat/model/user_repo.dart';

class CreateChatroomBloc
    extends Bloc<CreateChatroomEvent, CreateChatroomState> {
  User currentUser;

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
    ChatRepo.getInstance().getChatUsers().listen((users) {
      List<User> processedListOfUsers = users.where((user) => user.uid != currentUser.uid).toList();
      dispatch(ChatroomUserListUpdatedEvent(processedListOfUsers));
    });
  }

  void startChat(User user) {
    dispatch(CreateChatroomRequestedEvent());
    assert(currentUser != null);
    assert(currentUser != user);
    List<User> chatroomUsers = List<User>(2);
    chatroomUsers[0] = user;
    chatroomUsers[1] = currentUser;
    ChatRepo.getInstance().startChatroomForUsers(chatroomUsers).then((chatroom) {
      dispatch(ChatroomSelectedEvent(chatroom));
    });
  }

  @override
  Stream<CreateChatroomState> mapEventToState(
    CreateChatroomState currentState,
    CreateChatroomEvent event,
  ) async* {
    if (event is ChatroomUserListUpdatedEvent) {
      yield CreateChatroomState.isLoading(false, CreateChatroomState.users(event.users, currentState));
    } else if (event is ChatroomSelectedEvent) {
      yield CreateChatroomState.selected(event.chatroom, currentState);
    } else if (event is CancelCreateChatroomEvent) {
      yield CreateChatroomState.isLoading(false, CreateChatroomState.initial());
    } else if (event is CreateChatroomRequestedEvent) {
      yield CreateChatroomState.isLoading(true, currentState);
    }
  }
}
