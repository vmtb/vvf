import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:testproject/utils/providers.dart';

final getUserId = StateProvider((ref) => ref.read(mAuth).currentUser!.uid);

class AuthController {
  final Ref ref;

  AuthController(this.ref);

  Future<String> register(String email, String password) async {
    String error = "";
    try {
      await ref
          .read(mAuth)
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) {});
    } catch (e) {
      print(e);
      error = e.toString();
    }
    return error;
  }

  Future<String> login(String email, String password) async {
    String error = "";
    try {
      await ref
          .read(mAuth)
          .signInWithEmailAndPassword(email: email, password: password)
          .then((value) {});
    } catch (e) {
      print(e);
      error = e.toString();
    }
    return error;
  }

  Future<String?> uploadImageToFirebase(XFile? imageFile) async {
    if (imageFile == null) return null;

    final timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    final imageName = 'image_$timestamp.jpg';
    final uploadTask = ref.read(mStorage).child('images/$imageName').putFile(File(imageFile.path));
    uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
      final progress = (snapshot.bytesTransferred / snapshot.totalBytes) * 100;
      print('Upload progress: $progress%');
    });

    try {
      await uploadTask;
      final imageUrl = await ref.read(mStorage).child('images/$imageName').getDownloadURL();
      return imageUrl;
    } catch (e) {
      print('Error uploading image to Firebase Storage: $e');
      return null;
    }
  }

}
