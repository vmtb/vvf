import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:vvf/controllers/devise_controller.dart';
import 'package:vvf/controllers/project_controller.dart';
import 'package:vvf/models/project_model.dart';
import 'package:vvf/pages/projet/add_project.dart';

import '../../components/app_image.dart';
import '../../components/app_text.dart';
import '../../utils/app_const.dart';
import '../../utils/app_func.dart';
import '../../utils/providers.dart';

class HomeProject extends ConsumerStatefulWidget {
  const HomeProject({super.key});

  @override
  ConsumerState createState() => _HomeProjectState();
}

class _HomeProjectState extends ConsumerState<HomeProject> with SingleTickerProviderStateMixin {
  late TabController tabController;
  var formatter = DateFormat("E, dd MMM yyyy");
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tabController=TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    double hCard = 0.99 * getSize(context).height;

    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: AppColor.projecColor,
          title: AppText(
            "Projets".toUpperCase(),
            color: AppColor.white,
            size: 18,
          ),
          centerTitle: true,
        ),
        floatingActionButton: FloatingActionButton(onPressed: () {
            navigateToWidget(context, AddProject(Project.initial()));
        }, backgroundColor: AppColor.projecColor, child: Icon(Icons.add, color: AppColor.white,),),
        body: Container(
          width: getSize(context).width,
          height: hCard ,
          child: Stack(
            children: [
              Container(
                width: getSize(context).width,
                height: 100,
                decoration: const BoxDecoration(
                    color: AppColor.projecColor,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(40),
                      bottomRight: Radius.circular(40),
                    )),
              ),
              Positioned(
                left: 0,
                right: 0,
                child: Column(
                  children: [
                    const SpacerHeight(),
                    Container(
                        height: hCard - 100,
                        width: getSize(context).width,
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 1)
                            ]),
                        child:  ref.watch(getUserProject).when(data: (data){
                          return Column(
                            children: [
                              TabBar(tabs: const [
                                Tab(text: "En attente",),
                                Tab(text: "Réalisés/Echéance",),
                              ], controller: tabController, labelColor: Colors.black,),
                              Expanded(
                                child: TabBarView(children: [
                                  buildProject(0, data),
                                  buildProject(1, data),
                                ], controller: tabController,),
                              )
                            ],
                          );
                        }, error: errorLoading, loading: loadingError)
                    )
                  ],
                ),
              )
            ],
          ),
        ),
    );
  }

  Widget buildProject(int i, List<Project> data) {

    List<Project> ps = [];
    if(i==0){
      ps = data.where((element) => element.montantSpent<element.montant && element.echeance>DateTime.now().millisecondsSinceEpoch ).toList();
    }else{
      ps = data.where((element) => element.montantSpent>=element.montant || element.echeance<=DateTime.now().millisecondsSinceEpoch ).toList();
    }
    if(ps.isEmpty){
      return Center(child: AppText("Aucun projet pour le moment", color: Colors.black,));
    }

    ps.sort((p1, p2)=>p1.echeance.compareTo(p2.echeance));


    return SingleChildScrollView(
      child: Column(
        children: ps.map((e) => SingleProjet(e)).toList(),
      ),
    );
  }

  Widget SingleProjet(Project e) {

    return InkWell(
      onTap: (){
        showOptions(e);
      },
      child: Container(
        padding: const EdgeInsets.all(8),
        margin: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.withOpacity(0.2)),
          borderRadius: BorderRadius.circular(8)
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText(formatter.format(DateTime.fromMillisecondsSinceEpoch(e.echeance),), size: 10,),
            Row(
              children: [
                Container(width: 2, height: 55, color: getRandomColor(),),
                SizedBox(width: 10,),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText(e.name,size: 18, weight: FontWeight.bold, maxLines: 1, overflow: TextOverflow.ellipsis,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          AppText("Montant du projet: "),
                          AppText((e.montant/ref.watch(userDevise).rate).toStringAsFixed(2)+" "+ref.read(userDevise).symbol)
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          AppText("Montant dépensé: "),
                          AppText((e.montantSpent/ref.watch(userDevise).rate).toStringAsFixed(2)+" "+ref.read(userDevise).symbol)
                        ],
                      )

                    ],
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color getRandomColor() {
    Random random = Random();
    int alea = random.nextInt(4);
    int red = random.nextInt(256);
    int green = random.nextInt(256);
    if(alea%2==0){
      red = random.nextInt(180);
      green = random.nextInt(180);
    }
    int blue = random.nextInt(256);

    return Color.fromARGB(255, red, green, blue);
  }

  void showOptions(Project e) {
    showDialog(context: context, builder: (context2){
      return SimpleDialog(
        title: AppText("Options pour ${e.name}", weight: FontWeight.bold,),
        children: [
          SimpleDialogOption(onPressed: (){
            Navigator.pop(context2);
            navigateToWidget(context, AddProject(e));
          }, child: AppText("Modifier"),),
          SimpleDialogOption(onPressed: (){
            Navigator.pop(context2);
            showConfirm(context, "Voulez-vous vraiment supprimer ce projet?", (){
              Navigator.pop(context);
              ref.read(projectController).deleteProject(e);
            });
          }, child: AppText("Supprimer"),),
        ],
      );
    });
  }
}
