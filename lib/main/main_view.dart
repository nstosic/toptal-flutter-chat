import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'main_bloc.dart';
import 'main_state.dart';
import 'main_user_item.dart';
import '../util/constants.dart';
import '../navigation_helper.dart';
import '../model/chatroom.dart';

class MainScreen extends StatefulWidget {
  MainScreen({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MainState();
}

class _MainState extends State<MainScreen> {

  @override
  Widget build(BuildContext context) {
    return BlocProvider<MainBloc>(
      builder: (context) => MainBloc(),
      child: MainWidget(widget: widget, widgetState: this)
    );
  }

}

class MainWidget extends StatelessWidget {
  const MainWidget({Key key, @required this.widget, @required this.widgetState}) : super(key: key);

  final MainScreen widget;
  final _MainState widgetState;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Toptal Chat'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.lock_open),
            onPressed: () {
              BlocProvider.of<MainBloc>(context).logout(this);
            },
          )
        ],
      ),
      body: BlocBuilder(
          bloc: BlocProvider.of<MainBloc>(context),
          builder: (context, MainState state) {
            Widget content;
            if (state.isLoading) {
              content = Center(
                child: CircularProgressIndicator(
                  strokeWidth: 4.0,
                ),
              );
            } else if (state.chatrooms.isEmpty) {
              content = Center(
                child: Text(
                  "Looks like you don't have any active chatrooms\nLet's start one right now!",
                  textAlign: TextAlign.center,
                ),
              );
            } else {
              content = ListView.builder(
                padding: EdgeInsets.all(UIConstants.SMALLER_PADDING),
                itemBuilder: (context, index) {
                  return InkWell(
                      child: _buildItem(state.chatrooms[index]),
                      onTap: () {
                        BlocProvider.of<MainBloc>(context).retrieveChatroomForParticipant(
                            state.chatrooms[index].participants.first, this);
                      });
                },
                itemCount: state.chatrooms.length,
              );
            }
            return _wrapContentWithFab(context, content);
          }),
    );
  }

  Widget _wrapContentWithFab(BuildContext context, Widget content) {
    return Stack(
      children: <Widget>[
        content,
        Container(
          alignment: Alignment.bottomRight,
          padding: EdgeInsets.all(UIConstants.STANDARD_PADDING),
          child: FloatingActionButton(
              onPressed: _clickAddChat,
              child: Icon(Icons.add, color: Colors.white),
              backgroundColor: Colors.blueAccent,
              elevation: UIConstants.STANDARD_ELEVATION),
        )
      ],
    );
  }

  void _clickAddChat() {
    NavigationHelper.navigateToAddChat(widgetState.context, addToBackStack: true);
  }

  UserItem _buildItem(Chatroom chatroom) {
    return UserItem(user: chatroom.participants.first);
  }

  void navigateToLogin() {
    NavigationHelper.navigateToLogin(widgetState.context);
  }

  void navigateToChatroom(SelectedChatroom chatroom) {
    NavigationHelper.navigateToInstantMessaging(widgetState.context, chatroom.displayName, chatroom.id, addToBackStack: true);
  }
}
