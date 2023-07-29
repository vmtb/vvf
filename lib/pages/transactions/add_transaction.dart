
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:vvf/components/app_button.dart';
import 'package:vvf/controllers/devise_controller.dart';
import 'package:vvf/controllers/trans_controller.dart';
import 'package:vvf/controllers/user_controller.dart';
import 'package:vvf/models/caisse_model.dart';
import 'package:vvf/models/trans_model.dart';
import 'package:vvf/utils/providers.dart';

import '../../components/app_text.dart';
import '../../models/category_model.dart';
import '../../utils/app_const.dart';
import '../../utils/app_func.dart';

class AddTransaction extends ConsumerStatefulWidget {
  final Caisse caisse;
  const AddTransaction(this.caisse, {super.key});

  @override
  ConsumerState createState() => _AddTransactionState();
}

class _AddTransactionState extends ConsumerState<AddTransaction> {
  var currentDate = DateTime.now();
  var format = DateFormat("dd MMM yyyy");
  var transactionType = 0; // 0 = sortie (dépense) et 1=entrée (recette)

  var amountController = TextEditingController();
  var amountConvertController = TextEditingController();
  var commentController = TextEditingController();

  List<Category> cats = [];
  var selectedCatKey="";

  bool isLoading =false;

  @override
  void initState() {
    super.initState();
    getAllCategs();
  }

  @override
  Widget build(BuildContext context) {
    double hCard = 0.55 * getSize(context).height;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColor.caisseColor,
        title: AppText(
          "Nouvelle transaction Caisse ${widget.caisse.name}",
          color: AppColor.white,
          size: 18,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [
            //Date
            Container(
              width: getSize(context).width,
              height: 70,
              decoration: const BoxDecoration(
                  color: AppColor.caisseColor,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(40),
                    bottomRight: Radius.circular(40),
                  )),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(onPressed: (){
                    addDate(-1);
                  }, icon: Icon(Icons.arrow_back_ios, color: AppColor.white,)),
                  InkWell(
                      onTap: (){
                        selectDate();
                      },
                      child: AppText(format.format(currentDate), color: AppColor.white, size: 18, weight: FontWeight.bold,)),
                  IconButton(onPressed: (){
                    addDate(1);
                  }, icon: Icon(Icons.arrow_forward_ios_outlined, color: AppColor.white)),
                ],
              ),
            ),

            //Entrée (Recette) ou //Sortie (Dépense)
            Container(
              width: getSize(context).width,
              child: Row(
                children: [
                  Flexible(
                    child: RadioListTile(value: 0, groupValue: transactionType, onChanged: (e){
                      transactionType = e!;
                      setState(() {});
                    }, title: const AppText("Dépense (Sortie)"),),
                  ),

                  Flexible(
                    child: RadioListTile(value: 1, groupValue: transactionType, onChanged: (e){
                      transactionType = e!;
                      setState(() {});
                    }, title: const AppText("Recette (Entrée)"),),
                  )
                ],
              ),
            ),

            //Montant (devise)
            Container(
              width: getSize(context).width,
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child:  Row(
                children: [
                  Flexible(child: TextFormField(
                    keyboardType: TextInputType.number,
                    controller: amountController,
                    onChanged: (e){
                      double amount = double.tryParse(e.toString())??0;
                      double convertAmount = amount*ref.read(userDevise).rate;
                      amountConvertController.text = convertAmount.toStringAsFixed(2);
                    },
                    style: const TextStyle(fontSize: 40, letterSpacing: 4),
                    decoration: InputDecoration(
                      helperText: amountController.text.trim(),
                      helperStyle: const TextStyle()
                    ),
                  )),
                  const SizedBox(width: 5,),
                  AppText(ref.read(userDevise).symbol, size: 20,),
                  const SizedBox(width: 5,),
                  const AppText("="),
                  const SizedBox(width: 5,),
                  Flexible(child: TextFormField(
                    keyboardType: TextInputType.number,
                    controller: amountConvertController,
                    enabled: false,
                    style: const TextStyle(fontSize: 40, letterSpacing: 4),
                    decoration: InputDecoration(
                        helperText: amountConvertController.text.trim(),
                        helperStyle: const TextStyle()
                    ),
                  )),
                  AppText(ref.read(mainDevise).symbol, size: 20,),
                  const SizedBox(width: 5,),

                ],
              ),
            ),

            //Catégorie
            Wrap(
              children: cats.map((e) => SingleCat(e)).toList(),
            ),

            //Commentaire
            Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: TextFormField(
                  decoration: const InputDecoration(
                    hintText: "Commentaire"
                  ),
                )),
            const SpacerHeight(height: 30,),
            //Save
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: AppButtonRound(text: "Sauvegarder", onTap: () async {
                double amount = double.tryParse(amountController.text.trim().toString())??0;
                if(amount==0){
                  showSnackbar(context, "Veuillez renseigner le montant");
                  return;
                }
                double convertAmount = amount*ref.read(userDevise).rate;
                if(selectedCatKey.isEmpty){
                  showSnackbar(context, "Veuillez choisir la catégorie");
                  return;
                }
                //y, m, day, hh,m,ss
                //
                DateTime datew = DateTime(currentDate.year, currentDate.month, currentDate.day);

                setState(() {
                  isLoading = true;
                });

                Trans t = Trans(key: "", userId: ref.read(me).userId, catId: selectedCatKey,
                    caisseId: widget.caisse.key,
                    time: datew.millisecondsSinceEpoch,
                    type: transactionType,
                    comment: commentController.text.trim(),
                    amount: convertAmount, deviseId: ref.read(mainDevise).key);

                String error = await ref.read(transController).addTransaction(t);

                setState(() {
                  isLoading = false;
                });

                //Refresh .....
                ref.refresh(getUserTransactions);
                if(error.isEmpty){
                  showSuccessError(context, "Transaction ajoutée avec succès", onTap: (){
                    Navigator.pop(context);
                    Navigator.pop(context);
                  });
                }else{
                  showSnackbar(context, error);
                }


              }, isLoading: isLoading,),
            )
          ],
        ),
      ),
    );
  }


  Widget SingleCat(Category e) {
    return InkWell(
      onTap: (){
        selectedCatKey = e.key;
        setState(() {

        });
      },
      child: Container(
        width:  60,
        margin: const EdgeInsets.all(8),
        padding: const EdgeInsets.all(4),
        decoration: selectedCatKey==e.key? BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 2)
          ]
        ):null,
        child: Column(
          children: [
            SizedBox(
              width: 60,
              height: 60,
              child: CircleAvatar(
                backgroundColor: Color.fromARGB(e.colorA, e.colorR, e.colorG, e.colorB),
                child: Icon(
                  IconData(
                    e.iconData,
                    fontFamily: "MaterialIcons",
                  ),
                  color: Colors.white,
                  size: 30,
                ),
              ),
            ),
            AppText(e.nom, maxLines: 1, overflow: TextOverflow.ellipsis,),
          ],
        ),
      ),
    );
  }

  void addDate(int i) {
    currentDate = currentDate.add(Duration(days: i));
    setState(() {});
  }

  void selectDate() {
    showDatePicker(context: context, initialDate: currentDate, firstDate: DateTime(2020),
        lastDate: DateTime.now().add(const Duration(days: 10*365))).then((value){
          if(value!=null){
            currentDate = value;
            setState(() {});
          }
    });
  }

  Future<void> getAllCategs() async {
    cats = await ref.read(catController).getUserCategoriesFuture();
    setState(() {});
  }
}
