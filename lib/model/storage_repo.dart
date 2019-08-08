import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class StorageRepo {
  static StorageRepo _instance;

  final FirebaseStorage _firebaseStorage;

  StorageRepo._internal(this._firebaseStorage);

  factory StorageRepo.getInstance() {
    if (_instance == null) {
      _instance = StorageRepo._internal(FirebaseStorage.instance);
    }
    return _instance;
  }

  Future<Uri> uploadFile(File file) async {
    final StorageUploadTask uploadTask = _firebaseStorage.ref().putFile(file);
    StorageTaskSnapshot result = await uploadTask.onComplete;
    if (result.error == 0) {
      return null;
    }
    return result.uploadSessionUri;
  }
}