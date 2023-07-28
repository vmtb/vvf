import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vvf/controllers/devise_controller.dart';
import 'package:vvf/controllers/user_controller.dart';
import 'package:vvf/models/user_model.dart';
import 'package:vvf/utils/providers.dart';

import '../../components/app_text.dart';
import '../../models/devise_model.dart';
import '../../utils/app_const.dart';

class HomeSetting extends ConsumerStatefulWidget {
  const HomeSetting({super.key});

  @override
  ConsumerState createState() => _HomeSettingState();
}

class _HomeSettingState extends ConsumerState<HomeSetting> {
  List<Devise> devises = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    devises = ref.read(devisesList);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColor.settingColor,
        title: AppText(
          "Paramètres".toUpperCase(),
          color: AppColor.white,
          size: 18,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Column(
            children: [
              ListTile(
                leading: const Icon(Icons.monetization_on),
                title: const AppText("Votre devise"),
                subtitle: AppText("${ref.watch(userDevise).name} (${ref.watch(userDevise).symbol}) -- Changer"),
                onTap: () {
                  showChangeDevisesDialog();
                },
              ),
              const Divider(),
              const ListTile(
                leading: Icon(Icons.security),
                title: AppText("Politique de confidentialité"),
              ),
              const ListTile(
                leading: Icon(Icons.logout),
                title: AppText("Se déconnecter"),
              ),
            ],
          ),
          const ListTile(
            leading: Icon(Icons.delete),
            title: AppText("Supprimer mon compte et mes données"),
          ),
        ],
      ),
    );
  }

  void showChangeDevisesDialog() {
    String userDeviceKey = ref.read(userDevise).key;
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const AppText("Changer votre devise", size: 20, weight: FontWeight.bold,),
            content: StatefulBuilder(
              builder: (context, setState2) {
                return SizedBox(
                  height: 200,
                  child: Column(
                    children: devises
                        .map((e) => RadioListTile(
                            value: e.key,
                            title: AppText("${e.name} (${e.symbol})"),
                            groupValue: userDeviceKey,
                            onChanged: (e) {
                              userDeviceKey = e!;
                              setState2(() {});
                            }))
                        .toList(),
                  ),
                );
              }
            ),
            actions: [
              TextButton(onPressed: (){
                Navigator.pop(context);
              }, child: const AppText("Annuler")),
              TextButton(onPressed: (){
                UserModel u = ref.read(me);
                u.deviseId = userDeviceKey;
                ref.read(userController).updateUser(u);
                Navigator.pop(context);
              }, child: const AppText("Changer")),
            ],
          );
        });
  }
}
