import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseRepo {
  static FirebaseRepo _instance;
  final FirebaseFirestore firestore;

  const FirebaseRepo._internal(this.firestore);

  factory FirebaseRepo.getInstance() {
    if (_instance == null) {
      _instance = FirebaseRepo._internal(FirebaseFirestore.instance);
    }
    return _instance;
  }
}
