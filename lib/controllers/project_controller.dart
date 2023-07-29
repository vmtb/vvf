import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vvf/controllers/user_controller.dart';
import 'package:vvf/models/project_model.dart';
import 'package:vvf/utils/providers.dart';

final getUserProject = FutureProvider<List<Project>>((ref) => ProjectController(ref).getUserProjectLocal());

class ProjectController{
  final Ref ref;

  ProjectController(this.ref);

  Future<String> addProject(Project p) async {
    try {
      await ref.read(projectRef).add(p.toMap());
    } catch (e) {
      return e.toString();
    }
    return "";
  }

  Future<String> updateProject(Project p) async {
    try {
      await ref.read(projectRef).doc(p.key).set(p.toMap());
    } catch (e) {
      return e.toString();
    }
    return "";
  }

  Future<List<Project>> getUserProjectLocal() async {
    List<Project> cats = [];
    await ref
        .read(projectRef)
        .where("userId", isEqualTo: ref.read(me).userId)
        .get()
        .then((value) {
      value.docs.forEach((element) {
        var c = Project.fromMap(element.data() as Map<String, dynamic>)
            .copyWith(key: element.id);
        cats.add(c);
      });
    });
    return cats;
  }

  Future<void> deleteProject(Project e) async {
    await ref.read(projectRef).doc(e.key).delete();
    ref.refresh(getUserProject);
  }

}