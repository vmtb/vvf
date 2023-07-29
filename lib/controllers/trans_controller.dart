
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vvf/controllers/user_controller.dart';
import 'package:vvf/models/trans_model.dart';
import 'package:vvf/utils/providers.dart';

final getUserTransactions = FutureProvider<List<Trans>>((ref) => TransController(ref).getUserTransactions());

class TransController{
  final Ref ref;

  TransController(this.ref);

  Future<String> addTransaction(Trans trans) async {
    try {
      await ref.read(transRef).add(trans.toMap());
      //Update caisse
      await ref.read(caisseRef).doc(trans.caisseId).update({
        "solde":FieldValue.increment(trans.amount*(trans.type==1?1:-1))
      });
    } catch (e) {
      return e.toString();
    }
    return "";
  }

  Future<List<Trans>> getUserTransactions() async {
    List<Trans> trans= [];
    await ref.read(transRef)
        .where("userId", isEqualTo: ref.read(me).userId)
        .get().then((value){
      value.docs.forEach((element) {
        Trans t = Trans.fromMap(element.data() as Map<String, dynamic>);
        t.key = element.id;
        trans.add(t);
      });
    });
    return trans;
  }

  Future<List<Trans>> getUserTransactionRange(int minDate, int maxDate) async {
    List<Trans> trans= [];
    await ref.read(transRef)
        .where("userId", isEqualTo: ref.read(me).userId)
        .where("time", isGreaterThanOrEqualTo: minDate)
        .where("time", isLessThan: maxDate)
        .get().then((value){
      value.docs.forEach((element) {
        Trans t = Trans.fromMap(element.data() as Map<String, dynamic>);
        t.key = element.id;
        trans.add(t);
      });
    });
    return trans;
  }
}