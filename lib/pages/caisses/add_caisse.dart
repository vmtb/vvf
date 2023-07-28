import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_iconpicker_plus/flutter_iconpicker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_validator/form_validator.dart';
import 'package:vvf/components/app_button.dart';
import 'package:vvf/components/app_input.dart';
import 'package:vvf/components/app_text.dart';
import 'package:vvf/controllers/user_controller.dart';
import 'package:vvf/models/caisse_model.dart';
import 'package:vvf/models/category_model.dart';
import 'package:vvf/utils/app_func.dart';

import '../../utils/app_const.dart';
import '../../utils/providers.dart';

class AddCaisse extends ConsumerStatefulWidget {
  const AddCaisse({super.key});

  @override
  ConsumerState createState() => _AddCaisseState();
}

class _AddCaisseState extends ConsumerState<AddCaisse> {
  var key = GlobalKey<FormState>();

  var nameController = TextEditingController();

  var isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.caisseColor,
        title: AppText(
          "Nouvelle caisse",
          color: AppColor.white,
          size: 18,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        child: Form(
          key: key,
          child: Column(
            children: [
              const SpacerHeight(),
              SimpleFilledFormField(
                controller: nameController,
                helperText: "Nom; Ex: Entreprise ou Famille",
                hintText: "Nom de la caisse",
                validation: ValidationBuilder(requiredMessage: "Nom requis"),
              ),
              const SpacerHeight(),
              AppButtonRound(text: "Ajouter", onTap: () async {
                if(key.currentState!.validate()){

                  setState(() {
                    isLoading = true;
                  });

                  Caisse c = Caisse(name: nameController.text.trim(), type: "", time: DateTime.now().millisecondsSinceEpoch, userId: ref.read(me).userId, key: "");
                  String error =  await ref.read(caisseController).addCaisse(c);

                  setState(() {
                    isLoading = false;
                  });

                  if(error.isEmpty){
                    showSuccessError(context, "Caisse ajoutée avec succès", onTap: (){
                      Navigator.pop(context);
                      Navigator.pop(context);
                    });
                  }else{
                    showSnackbar(context, error);
                  }



                }
              }, isLoading: isLoading, backgroundColor: AppColor.caisseColor,)
            ],
          ),
        ),
      ),
    );
  }

}
