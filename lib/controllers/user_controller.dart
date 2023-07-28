
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
    var dvs = ref.read(devisesList).where((element) => element.key==ref.read(me).deviseId).toList();
    ref.read(userDevise.notifier).state = dvs.isNotEmpty?dvs.first:Devise.initial();
    log(ref.read(userDevise));
  }

  setupUser() async {
    UserModel user = await getCurrentUser();
    ref.read(me.notifier).state = user;
  }

  getCurrentUser() async {
    UserModel user = UserModel.initial();
    await ref.read(userRef).doc(ref.read(mAuth).currentUser!.uid).get().then((e){
      user = UserModel.fromMap(e.data() as Map<String, dynamic>);
    });
    return user;
  }


}