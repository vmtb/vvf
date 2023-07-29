import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vvf/controllers/user_controller.dart';
import 'package:vvf/utils/app_func.dart';
import 'package:vvf/utils/providers.dart';

import '../models/category_model.dart';
final getAllCats = StreamProvider<List<Category>>((ref) => CategoryController(ref).getUserCategories());


class CategoryController {
  final Ref ref;

  CategoryController(this.ref);

  Future<String> addCategory(Category category) async {
    try {
      await ref.read(catRef).add(category.toMap());
    } catch (e) {
      return e.toString();
    }
    return "";
  }

  Stream<List<Category>> getUserCategories() {
    return ref
        .read(catRef)
        .where("userId", isEqualTo: ref.read(me).userId)
        .snapshots()
        .map((value) {
      List<Category> cats = [];
      value.docs.forEach((element) {
        var c = Category.fromMap(element.data() as Map<String, dynamic>)
            .copyWith(key: element.id);
        cats.add(c);
        log(c);
      });
      var c1 = cats.where((element) => element.type.isEmpty).toList();
      var c2 = cats.where((element) => element.type == CatType.project.toString()).toList();
      var c3 = cats.where((element) => element.type == CatType.other.toString()).toList();
      c1.addAll(c2);
      c1.addAll(c3);
      return c1;
    });
  }

  Future<List<Category>> getUserCategoriesFuture() async  {
    List<Category> cats = [];
    await ref
        .read(catRef)
        .where("userId", isEqualTo: ref.read(me).userId)
        .get()
        .then((value) {
      for (var element in value.docs) {
        var c = Category.fromMap(element.data() as Map<String, dynamic>)
            .copyWith(key: element.id);
        cats.add(c);
        log(c);
      }
    });

    var c1 = cats.where((element) => element.type.isEmpty).toList();
    var c2 = cats.where((element) => element.type == CatType.project.toString()).toList();
    var c3 = cats.where((element) => element.type == CatType.other.toString()).toList();
    c1.addAll(c2);
    c1.addAll(c3);
    return c1;

  }

  setupCategory(String userId) async {
    int time = DateTime.now().millisecondsSinceEpoch;
    List<Category> cats = [
      Category(nom: "Cuisine", iconData: 58256, type: "", userId: userId, key: "", time: time, colorR: 76, colorG: 175, colorA: 255, colorB: 80),
      Category(nom: "Projet", iconData: 57548, type: CatType.project.toString(), userId: userId, key: "", time: time, colorR: 0, colorG: 150, colorA: 255, colorB: 136),
      Category(nom: "Sante", iconData: 58117, type: "", userId: userId, key: "", time: time, colorR: 233, colorG: 30, colorA: 255, colorB: 99),
      Category(nom: "Sport", iconData: 58859, type: "", userId: userId, key: "", time: time, colorR: 0, colorG: 150, colorA: 255, colorB: 136),
      Category(nom: "Transport", iconData: 59613, type: "", userId: userId, key: "", time: time, colorR: 103, colorG: 58, colorA: 255, colorB: 183),
      Category(nom: "Vestimentaires", iconData: 984410, type: "", userId: userId, key: "", time: time, colorR: 121, colorG: 85, colorA: 255, colorB: 72),
      Category(nom: "Shopping", iconData: 983409, type: "", userId: userId, key: "", time: time, colorR: 255, colorG: 193, colorA: 255, colorB: 7),
      Category(nom: "Restaurant", iconData: 58674, type: "", userId: userId, key: "", time: time, colorR: 255, colorG: 152, colorA: 255, colorB: 0),
      Category(nom: "Autres", iconData: 59910, type: CatType.other.toString(), userId: userId, key: "", time: time, colorR: 0, colorG: 0, colorA: 255, colorB: 0,),
    ];

    WriteBatch batch = getFirestore().batch();
    cats.forEach((cat) {
      String key = ref.read(catRef).doc().id;
      batch.set(ref.read(catRef).doc(key), cat.toMap());
    });
    await batch.commit();
  }





}

enum CatType{
  auto,
  other,
  project
}