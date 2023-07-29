import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vvf/utils/providers.dart';

class MainController{
  final Ref ref;

  MainController(this.ref);

  Future<String> getSetting(String key) async {
    String output = "";
    await ref.read(appRef).doc("infos").get().then((value){
      if(value.get(key)!=null) {
        output = value.get(key).toString();
      }
    });
    return output;
  }

}