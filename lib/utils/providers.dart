

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vvf/controllers/task_controller.dart';
import 'package:vvf/controllers/user_controller.dart';

import '../controllers/auth_controller.dart';

final mAuth = Provider((ref) => FirebaseAuth.instance);
final mStorage = Provider((ref) => FirebaseStorage.instance.ref().child("Files"));
final firebaseMessaging = Provider((ref) => FirebaseMessaging.instance);

final taskRef = Provider((ref) => getFirestore().collection("Tasks"));
final userRef = Provider((ref) => getFirestore().collection("Users"));


final authController = Provider((ref) => AuthController(ref));
final taskController = Provider((ref) => TaskController(ref));
final userController = Provider((ref) => UserController(ref));


getFirestore(){
  return FirebaseFirestore.instance;
}