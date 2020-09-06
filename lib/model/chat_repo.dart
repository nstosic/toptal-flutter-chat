import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';

import 'package:toptal_chat/util/constants.dart';
import 'package:toptal_chat/util/serialization_util.dart';
import 'package:toptal_chat/model/chatroom.dart';
import 'package:toptal_chat/model/firebase_repo.dart';
import 'package:toptal_chat/model/user.dart';

class ChatRepo {
  static ChatRepo _instance;

  final FirebaseFirestore _firestore;

  final _chatUsersSubject = BehaviorSubject<List<User>>();

  ChatRepo._internal(this._firestore);

  factory ChatRepo.getInstance() {
    if (_instance == null) {
      _instance = ChatRepo._internal(FirebaseRepo.getInstance().firestore);
      _instance._getChatUsersInternal();
    }
    return _instance;
  }

  void _getChatUsersInternal() {
    _firestore
        .collection(FirestorePaths.USERS_COLLECTION)
        .orderBy("displayName")
        .snapshots()
        .map((data) => Deserializer.deserializeUsers(data.docs))
        .listen((users) {
      _chatUsersSubject.sink.add(users);
    });
  }

  Stream<List<User>> getChatUsers() {
    return _chatUsersSubject.stream;
  }

  Future<SelectedChatroom> getChatroom(String chatroomId, User currentUser, User otherUser) async {
    DocumentReference chatroomRef = _firestore.doc(FirestorePaths.CHATROOMS_COLLECTION + "/" + chatroomId);
    if (chatroomRef != null) {
      List<User> users = List(2);
      users[0] = otherUser;
      users[1] = currentUser;
      try {
        return SelectedChatroom(chatroomId, otherUser.displayName);
      } catch (error) {
        print(error);
        return null;
      }
    } else {
      return null;
    }
  }

  Stream<List<Chatroom>> getChatroomsForUser(User user) {
    DocumentReference userRef = _firestore.doc(FirestorePaths.USERS_COLLECTION + "/" + user.uid);
    return _firestore
        .collection(FirestorePaths.CHATROOMS_COLLECTION)
        .where(
          "participants",
          arrayContains: userRef,
        )
        .snapshots()
        .map((data) => Deserializer.deserializeChatrooms(data.docs, _chatUsersSubject.value));
  }

  Stream<Chatroom> getMessagesForChatroom(String chatroomId) {
    return _firestore.collection(FirestorePaths.CHATROOMS_COLLECTION).doc(chatroomId).snapshots().map((data) {
      Chatroom chatroom = Deserializer.deserializeChatroomMessages(data, _chatUsersSubject.value);
      chatroom.messages.sort((message1, message2) => message1.timestamp.compareTo(message2.timestamp));
      return chatroom;
    });
  }

  Future<SelectedChatroom> startChatroomForUsers(List<User> users) async {
    DocumentReference userRef = _firestore.collection(FirestorePaths.USERS_COLLECTION).doc(users[1].uid);
    QuerySnapshot queryResults = await _firestore
        .collection(FirestorePaths.CHATROOMS_COLLECTION)
        .where("participants", arrayContains: userRef)
        .get();
    DocumentReference otherUserRef = _firestore.collection(FirestorePaths.USERS_COLLECTION).doc(users[0].uid);
    DocumentSnapshot roomSnapshot = queryResults.docs.firstWhere((room) {
      return room.data()["participants"].contains(otherUserRef);
    }, orElse: () => null);
    if (roomSnapshot != null) {
      return SelectedChatroom(roomSnapshot.id, users[0].displayName);
    } else {
      Map<String, dynamic> chatroomMap = Map<String, dynamic>();
      chatroomMap["messages"] = List<String>(0);
      List<DocumentReference> participants = List<DocumentReference>(2);
      participants[0] = otherUserRef;
      participants[1] = userRef;
      chatroomMap["participants"] = participants;
      DocumentReference reference = await _firestore.collection(FirestorePaths.CHATROOMS_COLLECTION).add(chatroomMap);
      DocumentSnapshot chatroomSnapshot = await reference.get();
      return SelectedChatroom(chatroomSnapshot.id, users[0].displayName);
    }
  }

  Future<bool> sendMessageToChatroom(String chatroomId, User user, String message) async {
    try {
      DocumentReference authorRef = _firestore.collection(FirestorePaths.USERS_COLLECTION).doc(user.uid);
      DocumentReference chatroomRef = _firestore.collection(FirestorePaths.CHATROOMS_COLLECTION).doc(chatroomId);
      Map<String, dynamic> serializedMessage = {"author": authorRef, "timestamp": DateTime.now(), "value": message};
      chatroomRef.update({
        "messages": FieldValue.arrayUnion([serializedMessage])
      });
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  void dismiss() {
    _chatUsersSubject.close();
  }
}
