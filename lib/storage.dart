import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';

class Storage {
  final firebase_storage = FirebaseStorage.instance;

  Future<void> uploadFile(String filePath, String fileName) async {
    File file = File(filePath);

    try {
      await firebase_storage.ref('test/$fileName').putFile(file);
    } catch (e) {
      print(e);
    }
  }

  Future<String> downloadUrl(String imageName) async {
    String downloadUrl =
        await firebase_storage.ref('test/$imageName').getDownloadURL();
    return downloadUrl;
  }
}
