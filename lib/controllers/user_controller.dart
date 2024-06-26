
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vvf/controllers/devise_controller.dart';
import 'package:vvf/models/user_model.dart';
import 'package:vvf/utils/providers.dart';

import '../models/devise_model.dart';
import '../utils/app_func.dart';

final me = StateProvider<UserModel>((ref) => UserModel.initial());

class UserController{
  final Ref ref;

  UserController(this.ref);

  saveUser(UserModel user) async {
    await ref.read(userRef).doc(user.userId).set(user.toMap());
  }

  updateUser(UserModel user) async {
    await ref.read(userRef).doc(user.userId).set(user.toMap());
    await setupUser();
  }

  setupUser() async {
    UserModel user = await getCurrentUser();
    ref.read(me.notifier).state = user;
    var dvs = ref.read(devisesList).where((element) => element.key==user.deviseId).toList();
    ref.read(userDevise.notifier).state = dvs.isNotEmpty?dvs.first:Devise.initial();
    log(ref.read(userDevise));
  }

  getCurrentUser() async {
    UserModel user = UserModel.initial();
    try {
      await ref.read(userRef).doc(ref.read(mAuth).currentUser!.uid).get().then((e){
        user = UserModel.fromMap(e.data() as Map<String, dynamic>);
      });
    } catch (e) {
      print(e);
    }
    return user;
  }

  deleteUser() async {
    try {
      await ref.read(mAuth).currentUser!.delete();
    } catch (e) {
      print(e);
    }
    await ref.read(userRef).doc(ref.read(me).userId).delete();
    //delete transactions etc..

  }


}