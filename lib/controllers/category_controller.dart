import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vvf/controllers/user_controller.dart';
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
        cats.add(Category.fromMap(element.data() as Map<String, dynamic>)
            .copyWith(key: element.id));
      });
      return cats;
    });
  }
}
