import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/chatroom.dart';
import '../model/message.dart';
import '../model/user.dart';

class Deserializer {

  static List<User> deserializeUsersFromReference(List<DocumentReference> references, List<User> users) {
    return users.where((item) => references.any((reference) => reference.documentID == item.uid)).toList();
  }

  static List<User> deserializeUsers(List<DocumentSnapshot> users) {
    return users.map((document) => deserializeUser(document)).toList();
  }

  static User deserializeUser(DocumentSnapshot document) {
    return User(document['uid'], document['displayName'], document['photoUrl'], document['fcmToken']);
  }

  static List<Chatroom> deserializeChatrooms(List<DocumentSnapshot> chatrooms, List<User> users) {
    return chatrooms.map((document) => deserializeChatroom(document, users)).toList();
  }

  static Chatroom deserializeChatroom(DocumentSnapshot document, List<User> users) {
    List<DocumentReference> participantReferences = List<DocumentReference>(2);
    participantReferences[0] = document['participants'][0];
    participantReferences[1] = document['participants'][1];
    return Chatroom(deserializeUsersFromReference(participantReferences, users).toList(), List<Message>());
  }

  static Chatroom deserializeChatroomMessages(DocumentSnapshot document, List<User> users) {
    List<DocumentReference> participantReferences = List<DocumentReference>(2);
    participantReferences[0] = document['participants'][0];
    participantReferences[1] = document['participants'][1];
    Chatroom chatroom = Chatroom(deserializeUsersFromReference(participantReferences, users).toList(), List<Message>());
    chatroom.messages.addAll(deserializeMessages(document['messages'], users));
    return chatroom;
  }

  static List<Message> deserializeMessages(List<dynamic> messages, List<User> users) {
    return messages.map((data) {
      return deserializeMessage(Map<String, dynamic>.from(data), users);
    }).toList();
  }

  static Message deserializeMessage(Map<String, dynamic> document, List<User> users) {
    DocumentReference authorReference = document['author'];
    User author = users.firstWhere((user) => user.uid == authorReference.documentID);
    return Message(author, document['timestamp'], document['value']);
  }

}
