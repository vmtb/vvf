import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vvf/controllers/user_controller.dart';
import 'package:vvf/models/caisse_model.dart';
import 'package:vvf/utils/providers.dart';

final getMyCaisses = StreamProvider<List<Caisse>>((ref) => CaisseController(ref).getUserCaisses());

class CaisseController{
  final Ref ref;

  CaisseController(this.ref);

  Future<String> addCaisse(Caisse caisse) async {
    try {
      await ref.read(caisseRef).add(caisse.toMap());
    } catch (e) {
      return e.toString();
    }
    return "";
  }

  Stream<List<Caisse>> getUserCaisses() {
    return ref
        .read(caisseRef)
        .where("userId", isEqualTo: ref.read(me).userId)
        .snapshots()
        .map((value) {
      List<Caisse> cats = [];
      value.docs.forEach((element) {
        var c = Caisse.fromMap(element.data() as Map<String, dynamic>)
            .copyWith(key: element.id);
        cats.add(c);
      });
      var c1 = cats.where((element) => element.type.isEmpty).toList();
      var c2 = cats.where((element) => element.type == CaisseType.main.toString()).toList();
      c2.addAll(c1);
      return c2;
    });
  }

  Future<String> setupCaisse(String userId) async {
    String caisseId = ref.read(caisseRef).id;
    Caisse c = Caisse(name: "Principale", type: CaisseType.main.toString(), time: DateTime.now().millisecondsSinceEpoch, userId: userId, key: caisseId);
    await ref.read(catRef).doc(caisseId).set(c.toMap());
    return caisseId;
  }
}

enum CaisseType{
  auto,
  main,
}