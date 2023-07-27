import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vvf/models/user_model.dart';
import 'package:vvf/utils/providers.dart';

final getUserId = StateProvider((ref) => ref.read(mAuth).currentUser!.uid);

class AuthController {
  final Ref ref;

  AuthController(this.ref);

  Future<String> register(String email, String password, String pseudo) async {
    String error = "";
    try {
      await ref
          .read(mAuth)
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) {});
      UserModel user = UserModel(firstname: pseudo, lastname: "", email: email,
          createdAt: DateTime.now().millisecondsSinceEpoch,
          userId: ref.read(mAuth).currentUser!.uid,
          fcm: await getFcm(),
      );
      await ref.read(userController).saveUser(user);
      await ref.read(userController).setupUser();
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
      await ref.read(userController).setupUser();
    } catch (e) {
      print(e);
      error = e.toString();
    }
    return error;
  }

  Future<String> handleGoogleSignIn() async {
    final GoogleSignIn _googleSignIn = GoogleSignIn();
    String error = "";
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        error = "Le processsus d'authentification avec Google a été annulé";
        return error;
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = await ref.read(mAuth).signInWithCredential(credential); // Only needed if using Firebase Authentication
      continueSignIn(userCredential);
    } catch (e) {
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

  getFcm() async {
    return await ref.read(firebaseMessaging).getToken();
  }

  Future<void> continueSignIn(UserCredential userCredential) async {
    UserModel user = await ref.read(userController).getCurrentUser();

    String name = userCredential.user!.displayName??"Anonymat";
    String email = userCredential.user!.email??"";


    if(user.firstname.isEmpty){
      user.firstname = name;
    }
    if(user.email.isEmpty){
      user.email = email;
    }
    user.fcm = await getFcm();
    user.userId = ref.read(mAuth).currentUser!.uid;
    await ref.read(userController).updateUser(user);
    await ref.read(userController).setupUser();

  }

}
