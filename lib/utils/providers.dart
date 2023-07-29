

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vvf/controllers/caisse_controller.dart';
import 'package:vvf/controllers/category_controller.dart';
import 'package:vvf/controllers/devise_controller.dart';
import 'package:vvf/controllers/main_controller.dart';
import 'package:vvf/controllers/project_controller.dart';
import 'package:vvf/controllers/task_controller.dart';
import 'package:vvf/controllers/trans_controller.dart';
import 'package:vvf/controllers/user_controller.dart';

import '../controllers/auth_controller.dart';

final mAuth = Provider((ref) => FirebaseAuth.instance);
final mStorage = Provider((ref) => FirebaseStorage.instance.ref().child("Files"));
final firebaseMessaging = Provider((ref) => FirebaseMessaging.instance);

final taskRef = Provider<CollectionReference>((ref) => getFirestore().collection("Tasks"));
final userRef = Provider<CollectionReference>((ref) => getFirestore().collection("Users"));
final catRef = Provider <CollectionReference>((ref) => getFirestore().collection("Categories"));
final caisseRef = Provider <CollectionReference>((ref) => getFirestore().collection("Caisses"));
final deviseRef = Provider <CollectionReference>((ref) => getFirestore().collection("Devises"));
final transRef = Provider <CollectionReference>((ref) => getFirestore().collection("Transactions"));
final projectRef = Provider <CollectionReference>((ref) => getFirestore().collection("Projects"));
final appRef = Provider <CollectionReference>((ref) => getFirestore().collection("Apps"));


final authController = Provider((ref) => AuthController(ref));
final taskController = Provider((ref) => TaskController(ref));
final userController = Provider((ref) => UserController(ref));
final catController = Provider((ref) => CategoryController(ref));
final caisseController = Provider((ref) => CaisseController(ref));
final deviseController = Provider((ref) => DeviseController(ref));
final transController = Provider((ref) => TransController(ref));
final projectController = Provider((ref) => ProjectController(ref));

final mainController = Provider((ref) => MainController(ref));


FirebaseFirestore getFirestore(){
  return FirebaseFirestore.instance;
}