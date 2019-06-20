import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../util/constants.dart';
import '../navigation_helper.dart';
import '../model/user.dart';
import '../model/chatroom.dart';
import '../main/main_user_item.dart';
import 'create_chatroom_bloc.dart';
import 'create_chatroom_state.dart';

class CreateChatroomScreen extends StatefulWidget {
  CreateChatroomScreen({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _CreateChatroomState();
}

class _CreateChatroomState extends State<CreateChatroomScreen> {

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CreateChatroomBloc>(
      builder: (context) => CreateChatroomBloc(),
      child: CreateChatroomWidget(widget: widget, widgetState: this)
    );
  }

}

class CreateChatroomWidget extends StatelessWidget {
  const CreateChatroomWidget({Key key, @required this.widget, @required this.widgetState}) : super(key: key);

  final CreateChatroomScreen widget;
  final _CreateChatroomState widgetState;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Select user"),
        ),
        body: BlocBuilder(
            bloc: BlocProvider.of<CreateChatroomBloc>(context),
            builder: (context, CreateChatroomState state) {
              if (state.isLoading) {
                return Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 4.0,
                  ),
                );
              }
              return ListView.builder(
                itemBuilder: (context, index) {
                  return InkWell(
                      child: _buildItem(state.users[index]),
                      onTap: () {
                        BlocProvider.of<CreateChatroomBloc>(context).startChat(state.users[index], this);
                      }
                  );
                },
                itemCount: state.users.length,
                padding: EdgeInsets.all(UIConstants.SMALLER_PADDING),
              );
            }));
  }

  Widget _buildItem(User user) {
    return UserItem(user: user);
  }

  void navigateToSelectedChatroom(SelectedChatroom chatroom) {
    NavigationHelper.navigateToInstantMessaging(widgetState.context, chatroom.displayName, chatroom.id);
  }
}
