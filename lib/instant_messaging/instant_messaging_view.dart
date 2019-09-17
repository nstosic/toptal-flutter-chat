import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../util/constants.dart';
import '../model/message.dart';
import 'instant_messaging_bloc.dart';
import 'instant_messaging_state.dart';

class InstantMessagingScreen extends StatefulWidget {
  InstantMessagingScreen({Key key, @required this.displayName, @required this.chatroomId})
      : super(key: key);

  final String displayName;
  final String chatroomId;
  final TextEditingController _textEditingController = IMTextEditingController();

  @override
  State<StatefulWidget> createState() => _InstantMessagingState(chatroomId);
}

class _InstantMessagingState extends State<InstantMessagingScreen> {
  final String chatroomId;

  _InstantMessagingState(this.chatroomId);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<InstantMessagingBloc>(
      builder: (context) => InstantMessagingBloc(chatroomId),
      child: InstantMessagingWidget(widget: widget),
    );
  }

}

class InstantMessagingWidget extends StatelessWidget {
  const InstantMessagingWidget({Key key, @required this.widget}) : super(key: key);

  final InstantMessagingScreen widget;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.displayName)),
      body: BlocBuilder(
        bloc: BlocProvider.of<InstantMessagingBloc>(context),
        builder: (context, InstantMessagingState state) {
          if (state.error) {
            return Center(
              child: Text("An error ocurred"),
            );
          } else {
            return Column(
              mainAxisSize: MainAxisSize.max,
              verticalDirection: VerticalDirection.up,
              children: <Widget>[
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(bottom: UIConstants.STANDARD_PADDING),
                        padding: EdgeInsets.symmetric(
                            vertical: UIConstants.SMALLER_PADDING,
                            horizontal: UIConstants.SMALLER_PADDING),
                        child: TextField(
                          maxLines: null,
                          controller: widget._textEditingController,
                          focusNode: FocusNode(),
                          style: TextStyle(color: Colors.black),
                          cursorColor: Colors.blueAccent,
                          decoration: InputDecoration(hintText: "Your message..."),
                          textCapitalization: TextCapitalization.sentences,
                        ),
                      ),
                    ),
                    Container(
                      child: IconButton(
                          icon: Icon(Icons.image),
                          onPressed: () {
                            _openPictureDialog(context);
                          }),
                      decoration: BoxDecoration(shape: BoxShape.circle),
                    ),
                    Container(
                      child: IconButton(
                          icon: Icon(Icons.send),
                          onPressed: () {
                            _send(context, widget._textEditingController.text);
                          }),
                      decoration: BoxDecoration(shape: BoxShape.circle),
                    )
                  ],
                ),
                Expanded(
                  child: Container(
                    child: ListView.builder(
                      padding: EdgeInsets.symmetric(
                        horizontal: UIConstants.SMALLER_PADDING,
                        vertical: UIConstants.SMALLER_PADDING,
                      ),
                      itemBuilder: (context, index) =>
                          _buildMessageItem(state.messages[state.messages.length - 1 - index]),
                      itemCount: state.messages.length,
                      reverse: true,
                    ),
                  ),
                )
              ],
            );
          }
        },
      ),
    );
  }

  Widget _buildMessageItem(Message message) {
    if (message.value.startsWith("_uri:")) {
      final String url = message.value.substring("_uri:".length);
      if (message.outgoing) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0)
              ),
              child: Image.network(url, width: 256),
            ),
          ],
        );
      } else {
        return Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0)
              ),
              child: Image.network(url, width: 256),
            ),
          ],
        );
      }
    }
    if (message.outgoing) {
      return Container(
        child: Text(
          message.value,
          style: TextStyle(color: Colors.white),
          textAlign: TextAlign.end,
        ),
        decoration: BoxDecoration(
            color: Colors.lightBlueAccent, borderRadius: BorderRadius.all(Radius.circular(6.0))),
        padding: EdgeInsets.all(UIConstants.SMALLER_PADDING),
        margin: EdgeInsets.symmetric(
          vertical: UIConstants.SMALLER_PADDING / 2.0,
          horizontal: 0.0,
        ),
      );
    } else {
      return Container(
        child: Text(
          message.value,
          style: TextStyle(color: Colors.white),
        ),
        decoration: BoxDecoration(
            color: Colors.blueAccent, borderRadius: BorderRadius.all(Radius.circular(6.0))),
        padding: EdgeInsets.all(UIConstants.SMALLER_PADDING),
        margin: EdgeInsets.symmetric(
          vertical: UIConstants.SMALLER_PADDING / 2.0,
          horizontal: 0.0,
        ),
      );
    }
  }

  void _send(BuildContext context, String text) {
    if (text.isNotEmpty) {
      BlocProvider.of<InstantMessagingBloc>(context).send(text);
      widget._textEditingController.text = "";
    }
  }

  void _sendFile(BuildContext context, File file) {
    BlocProvider.of<InstantMessagingBloc>(context).sendFile(file);
  }

  void _openPictureDialog(BuildContext context) async {
    File target = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (target != null) {
      _sendFile(context, target);
    }
  }
}

class IMTextEditingController extends TextEditingController {}
