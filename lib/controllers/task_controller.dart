import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vvf/controllers/auth_controller.dart';
import 'package:vvf/models/task.dart';

import '../utils/providers.dart';

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


}