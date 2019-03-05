import 'package:flutter/material.dart';

import '../model/user.dart';
import '../util/constants.dart';

class UserItem extends StatelessWidget {
  UserItem({Key key, @required this.user}) : super(key: key);

  final User user;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          padding: EdgeInsets.symmetric(
              horizontal: 0,
              vertical: UIConstants.SMALLER_PADDING),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(48.0),
            child: Image.network(
              user.photoUrl,
              height: 96,
              width: 96,
            ),
          ),
        ),
        Expanded(
          child: Container(
            padding: EdgeInsets.all(UIConstants.SMALLER_PADDING),
            child: Text(
              user.displayName,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: UIConstants.BIGGER_FONT_SIZE, color: Colors.blueAccent),
            ),
          ),
        ),
      ],
    );
  }
}
