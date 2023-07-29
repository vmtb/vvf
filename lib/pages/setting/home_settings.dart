import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:share_plus/share_plus.dart';
import 'package:vvf/components/app_button.dart';
import 'package:vvf/controllers/devise_controller.dart';
import 'package:vvf/controllers/user_controller.dart';
import 'package:vvf/models/user_model.dart';
import 'package:vvf/utils/providers.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../components/app_text.dart';
import '../../models/devise_model.dart';
import '../../utils/app_const.dart';
import '../../utils/app_func.dart';

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
                subtitle: AppText("${ref.read(userDevise).name} (${ref.watch(userDevise).symbol}) -- Changer"),
                onTap: () {
                  showChangeDevisesDialog();
                },
              ),
              const Divider(),
              ListTile(
                onTap: () async {
                  String url = await ref.read(mainController).getSetting("privacy");
                  launchUrl(Uri.parse(url));
                },
                leading: const Icon(Icons.security),
                title: const AppText("Politique de confidentialité"),
              ),
              ListTile(
                onTap: () async {
                  String url = await ref.read(mainController).getSetting("share_text");
                  String store ="";
                  if(Platform.isAndroid) {
                    store = await ref.read(mainController).getSetting("play_store");
                  } else {
                    store = await ref.read(mainController).getSetting("app_store");
                  }
                  Share.share("$url\n\nTéléchargez VV Finance $store}");
                },
                leading: const Icon(Icons.share),
                title: const AppText("Partager VV Finance"),
              ),
              ListTile(
                onTap: () async {
                  final InAppReview inAppReview = InAppReview.instance;
                  if (await inAppReview.isAvailable()) {
                    inAppReview.requestReview();
                  }
                },
                leading: const Icon(Icons.star),
                title: const AppText("Noter VV Finance"),
              ),
              ListTile(
                onTap: () async {
                  String contact = await ref.read(mainController).getSetting("contact");
                  final Uri emailLaunchUri = Uri(
                    scheme: 'mailto',
                    path: contact,
                    query: encodeQueryParameters(<String, String>{
                      'subject': 'Bonjour VV Finance!',
                    }),
                  );

                  launchUrl(emailLaunchUri);
                },
                leading: const Icon(Icons.mail),
                title: const AppText("Nous contacter"),
              ),
              ListTile(
                onTap: () async {
                  String url = await ref.read(mainController).getSetting("support");
                  launchUrl(Uri.parse(url));
                },
                leading: const Icon(Icons.assistant),
                title: const AppText("Assistance support"),
              ),
              ListTile(
                onTap: (){
                  showLogoutDialog(ref, context);
                },
                leading: Icon(Icons.logout),
                title: AppText("Se déconnecter"),
              ),
            ],
          ),
            ListTile(
            onTap: (){
              showDeleteAccount(ref, context);
            },
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

  String? encodeQueryParameters(Map<String, String> params) {
    return params.entries
        .map((MapEntry<String, String> e) =>
    '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
        .join('&');
  }

}
