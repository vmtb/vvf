import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vvf/models/user_model.dart';
import 'package:vvf/utils/providers.dart';

StateProvider me = StateProvider((ref) => UserModel.initial());

class UserController{
  final Ref ref;

  UserController(this.ref);

  saveUser(UserModel user) async {
    await ref.read(userRef).doc(user.userId).set(user.toMap());
  }

  updateUser(UserModel user) async {
    await ref.read(userRef).doc(user.userId).set(user.toMap());
  }

  setupUser() async {
    UserModel user = await getCurrentUser();
    ref.read(me.notifier).state = me;
  }

  getCurrentUser() async {
    UserModel user = UserModel.initial();
    await ref.read(userRef).doc(ref.read(mAuth).currentUser!.uid).get().then((e){
      user = UserModel.fromMap(e.data());
    });
    return user;
  }


}