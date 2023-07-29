import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_iconpicker_plus/flutter_iconpicker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_validator/form_validator.dart';
import 'package:intl/intl.dart';
import 'package:vvf/components/app_button.dart';
import 'package:vvf/components/app_input.dart';
import 'package:vvf/components/app_text.dart';
import 'package:vvf/controllers/devise_controller.dart';
import 'package:vvf/controllers/project_controller.dart';
import 'package:vvf/controllers/user_controller.dart';
import 'package:vvf/models/caisse_model.dart';
import 'package:vvf/models/category_model.dart';
import 'package:vvf/models/project_model.dart';
import 'package:vvf/utils/app_func.dart';

import '../../utils/app_const.dart';
import '../../utils/providers.dart';

class AddProject extends ConsumerStatefulWidget {
  final Project project;
  const AddProject(this.project, {super.key});

  @override
  ConsumerState createState() => _AddProjectState();
}

class _AddProjectState extends ConsumerState<AddProject> {
  var key = GlobalKey<FormState>();

  var nameController = TextEditingController();
  var amountController = TextEditingController();
  var echeanceController = TextEditingController();

  var selectedDate = DateTime.now();

  var isLoading = false;

  var format = DateFormat("E, dd MMM yyyy");

  @override
  void initState() {
    super.initState();
    if(widget.project.key.isNotEmpty){
      nameController.text = widget.project.name;
      amountController.text = (widget.project.montant/ref.read(userDevise).rate).toStringAsFixed(0);
      selectedDate = DateTime.fromMillisecondsSinceEpoch(widget.project.echeance);
      echeanceController.text = format.format(selectedDate);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.projecColor,
        title: AppText(
          "${widget.project.key==""?"Nouveau":"Modification"} projet",
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
                helperText: "Nom; Ex: Achat voiture ou Projet VVF",
                hintText: "Nom du projet",
                validation: ValidationBuilder(requiredMessage: "Nom requis"),
              ),
              const SpacerHeight(),
              SimpleFilledFormField(
                inputType: TextInputType.number,
                controller: amountController,
                hintText: "Montant du projet",
                style: TextStyle(fontSize: 30),
                suffixI: AppText(ref.read(userDevise).symbol),
                validation: ValidationBuilder(requiredMessage: "Montant requis"),
              ),
              const SpacerHeight(),
              InkWell(
                onTap: (){
                  showDatePicker(context: context, initialDate: selectedDate,
                      firstDate: DateTime(2020), lastDate: DateTime.now().add(const Duration(days: 30*365))).then((value){
                        if(value!=null){
                          selectedDate = value;
                          echeanceController.text = format.format(selectedDate);
                        }
                  });
                },
                child: SimpleFilledFormField(
                  controller: echeanceController,
                  hintText: "Echéance",
                  enable: false,
                  helperText: "Quand envisagez-vous réaliser entièrement..",
                  validation: ValidationBuilder(requiredMessage: "Echéance requise"),
                ),
              ),
              const SpacerHeight(),
              AppButtonRound(text: widget.project.key.isEmpty?"Ajouter":"Modifier", onTap: () async {
                if(key.currentState!.validate()){

                  double montant = double.tryParse(amountController.text.trim())??-1;
                  if(montant<0){
                    showSnackbar(context, "Montant invalide");
                    return;
                  }
                  setState(() {
                    isLoading = true;
                  });

                  montant = montant*ref.read(userDevise).rate;

                  Project p= widget.project.copyWith(name: nameController.text.trim(),
                      userId: ref.read(me).userId,
                      montant: montant, deviseId: ref.read(mainDevise).key,
                      echeance: selectedDate.millisecondsSinceEpoch);
                      String error = "";
                  if(p.key.isEmpty){
                    error =  await ref.read(projectController).addProject(p);
                  }else{
                    error =  await ref.read(projectController).updateProject(p);

                  }

                  ref.refresh(getUserProject);
                  setState(() {
                    isLoading = false;
                  });

                  if(error.isEmpty){
                    showSuccessError(context, "Projet ${p.key.isEmpty?"ajouté":"modifié"} avec succès", onTap: (){
                      Navigator.pop(context);
                      Navigator.pop(context);
                    });
                  }else{
                    showSnackbar(context, error);
                  }



                }
              }, isLoading: isLoading, backgroundColor: AppColor.projecColor,)
            ],
          ),
        ),
      ),
    );
  }

}
