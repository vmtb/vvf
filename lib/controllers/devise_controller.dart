import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vvf/utils/providers.dart';

import '../models/devise_model.dart';

final devisesList = StateProvider<List<Devise>>((ref) => []);
final userDevise = StateProvider<Devise>((ref) => Devise.initial());
final mainDevise = StateProvider<Devise>((ref) => Devise.initial());

class DeviseController{
  final Ref ref;

  DeviseController(this.ref);

  addDevise(Devise devise){
    ref.read(deviseRef).add(devise.toMap());
  }

  setupDevise() async {
    List<Devise> devises = [];
    await ref.read(deviseRef).get().then((value){
      value.docs.forEach((element) {
        var d = Devise.fromMap(element.data() as Map<String, dynamic>);
        d.key = element.id;
        devises.add(d);
      });
    });
    ref.read(devisesList.notifier).state = devises;
    var dvs = ref.read(devisesList).where((element) => element.type=="main").toList();
    ref.read(mainDevise.notifier).state = dvs.isNotEmpty?dvs.first:Devise.initial();
    return devises;
  }
}