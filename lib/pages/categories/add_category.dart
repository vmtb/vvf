import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_iconpicker_plus/flutter_iconpicker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_validator/form_validator.dart';
import 'package:vvf/components/app_button.dart';
import 'package:vvf/components/app_input.dart';
import 'package:vvf/components/app_text.dart';
import 'package:vvf/controllers/user_controller.dart';
import 'package:vvf/models/category_model.dart';
import 'package:vvf/utils/app_func.dart';

import '../../utils/app_const.dart';
import '../../utils/providers.dart';

class AddCategory extends ConsumerStatefulWidget {
  const AddCategory({super.key});

  @override
  ConsumerState createState() => _AddCategoryState();
}

class _AddCategoryState extends ConsumerState<AddCategory> {
  var key = GlobalKey<FormState>();

  var nameController = TextEditingController();
  Color selectedColor = AppColor.projecColor;
  var isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.catgColor,
        title: AppText(
          "Nouvelle catégorie",
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
                helperText: "Nom; Ex: Restauration ou Sport",
                hintText: "Nom de la catégorie",
                validation: ValidationBuilder(requiredMessage: "Nom requis"),
              ),
              const SpacerHeight(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      TextButton(
                        onPressed: () => _pickIcon(),
                        child: AppText(
                          "Icône de la catégorie",
                          color: AppColor.white,
                        ),
                        style:
                        TextButton.styleFrom(backgroundColor: AppColor.catgColor),
                      ),
                      const SpacerHeight(),
                      InkWell(
                        onTap: () => _pickIcon(),
                        child: Container(
                          height: 100,
                          width: 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(),
                          ),
                          child: _icon==null?null: Icon(_icon!, size: 100,color: selectedColor,),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      TextButton(
                        onPressed: () => showColorPickerDialog(context),
                        child: AppText(
                          "Couleur de la catégorie",
                          color: AppColor.white,
                        ),
                        style:
                        TextButton.styleFrom(backgroundColor: AppColor.catgColor),
                      ),
                      const SpacerHeight(),
                      InkWell(
                        onTap: ()=> showColorPickerDialog(context),
                        child: SizedBox(
                          width: 100,
                          height: 100,
                          child: CircleAvatar(
                            backgroundColor: selectedColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SpacerHeight(
                height: 20,
              ),
              AppButtonRound(text: "Ajouter", onTap: () async {
                if(key.currentState!.validate()){
                  if(_icon==null){
                    showSnackbar(context, "Veuillez choisir une icône");
                    return;
                  }


                  setState(() {
                    isLoading = true;
                  });

                  Category c = Category(
                      nom: nameController.text.trim(),
                      colorA: selectedColor.alpha,
                      colorB: selectedColor.blue,
                      colorR: selectedColor.red,
                      colorG: selectedColor.green,
                      iconData: _icon!.codePoint,
                      type: "",
                      key: "",
                      userId: ref.read(me).userId,
                      time: DateTime.now().millisecondsSinceEpoch);

                  String error = await ref.read(catController).addCategory(c);

                  setState(() {
                    isLoading = false;
                  });

                  if(error.isEmpty){
                    showSuccessError(context, "Catégorie ajoutée avec succès", onTap: (){
                      Navigator.pop(context);
                      Navigator.pop(context);
                    });
                  }else{
                    showSnackbar(context, error);
                  }



                }
              }, isLoading: isLoading, backgroundColor: AppColor.catgColor,)
            ],
          ),
        ),
      ),
    );
  }

  IconData? _icon;

  _pickIcon() async {
    _icon = await FlutterIconPicker.showIconPicker(context,
        iconPackModes: [IconPack.material]);

    setState(() {});

  }

  void showColorPickerDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Choisissez une couleur'),
          content: SingleChildScrollView(
            child: BlockPicker(
              pickerColor: selectedColor,
              onColorChanged: (color) {
                selectedColor = color;
              },
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {

                });
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
