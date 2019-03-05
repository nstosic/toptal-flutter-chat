import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseRepo {
  static FirebaseRepo _instance;
  final Firestore firestore;

  const FirebaseRepo._internal(this.firestore);

  factory FirebaseRepo.getInstance() {
    if (_instance == null) {
      _instance = FirebaseRepo._internal(Firestore.instance);
      _instance.firestore.settings(persistenceEnabled: true, timestampsInSnapshotsEnabled: true);
    }
    return _instance;
  }
}