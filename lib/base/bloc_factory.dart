import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:toptal_chat/create_chatroom/create_chatroom_bloc.dart';
import 'package:toptal_chat/create_chatroom/create_chatroom_state.dart';
import 'package:toptal_chat/instant_messaging/instant_messaging_bloc.dart';
import 'package:toptal_chat/instant_messaging/instant_messaging_state.dart';
import 'package:toptal_chat/login/login_bloc.dart';
import 'package:toptal_chat/login/login_state.dart';
import 'package:toptal_chat/main/main_bloc.dart';
import 'package:toptal_chat/main/main_state.dart';

abstract class BlocFactory {
  static const error = 'BlocFactoryError';

  static T create<T extends Cubit>(Map<String, dynamic> data) {
    switch (T) {
      case MainBloc:
        return MainBloc(MainState.initial()) as T;
      case LoginBloc:
        return LoginBloc(LoginState.initial()) as T;
      case CreateChatroomBloc:
        return CreateChatroomBloc(CreateChatroomState.initial()) as T;
      case InstantMessagingBloc:
        return InstantMessagingBloc(InstantMessagingState.initial(), data['chatroomId']) as T;
      default:
        throw new PlatformException(
            code: BlocFactory.error, message: 'Requested bloc for unsupported type ${T.runtimeType}');
    }
  }
}
