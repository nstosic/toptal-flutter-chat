// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

//import 'package:flutter/material.dart';
//import 'package:flutter_test/flutter_test.dart';
import 'package:test/test.dart';

import 'package:toptal_chat/main.dart';
import 'package:toptal_chat/create_chatroom/create_chatroom_state.dart';
import 'package:toptal_chat/util/util.dart';


void main() {
  group("CreateChatroomState", () {
    test(".cancel(CreateChatroomState) factory sets optional CreateChatroomAction parameter", () {
      CreateChatroomState state = CreateChatroomState.initial();
      CreateChatroomState newState = CreateChatroomState.cancel(state);
      expect(newState.action.chatroom, null);
      expect(newState.action.canceled, true);
    });
  });
  group("Util", () {
    test('.swapElementsInList() swaps correct elements', () {
      List<int> intList = List.from([1, 2, 3, 4]);
      Util.swapElementsInList(intList, 2, 3);
      expect(intList[2], 4);
      expect(intList[3], 3);
    });
    test('.swapElementsInList() swaps correct elements in pairs', () {
      List<int> intPair = List.from([-1, 1]);
      Util.swapElementsInList(intPair, 0, 1);
      expect(intPair[0], 1);
      expect(intPair[1], -1);
    });
  });
}
