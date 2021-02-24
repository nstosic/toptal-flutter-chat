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

  Future<String> uploadFile(File file) async {
    final UploadTask uploadTask = _firebaseStorage.ref().child(file.uri.pathSegments.last).putFile(file);
    TaskSnapshot result = await uploadTask;
    if (result.bytesTransferred != result.totalBytes) {
      return null;
    }
    return result.ref.fullPath;
  }

  Future<String> decodeUri(String uri) async {
    return _firebaseStorage.ref().child(uri).getDownloadURL().then((result) => result.toString());
  }
}
