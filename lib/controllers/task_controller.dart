import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:testproject/controllers/auth_controller.dart';
import 'package:testproject/models/task.dart';

import '../utils/providers.dart';

final getTasks = FutureProvider((ref) => TaskController(ref).getTasksFuture());
final getTasksStream = StreamProvider((ref) => TaskController(ref).getTasksStream());

class TaskController{
  final Ref ref;

  TaskController(this.ref); 
  
  Future<String> addTask(Task task) async {
    String err="";
    try {
      await ref.read(taskRef).add(task.toMap());
    } catch (e) {
      print(e);
      err= e.toString();
    }
    return err;
  }

  void updateTask(Task task){
    ref.read(taskRef).doc(task.key).set(task.toMap());
  }
  
  Future<List<Task>> getTasksFuture() async {
    List<Task> tasks = []; 
    await ref.read(taskRef).where("userId", isEqualTo: ref.read(getUserId)).get().then((value){
      for (var element in value.docs) { 
        Task task = Task.fromMap(element.data()).copyWith(key: element.id);
        tasks.add(task);
      }
    });
    return tasks; 
  }

  Stream<List<Task>> getTasksStream()   {
    return ref.read(taskRef).where("userId", isEqualTo: ref.read(getUserId)).snapshots().map((value){
      List<Task> tasks = [];
      for (var element in value.docs) {
        Task task = Task.fromMap(element.data()).copyWith(key: element.id);
        tasks.add(task);
      }
      return tasks;
    });
  }


}