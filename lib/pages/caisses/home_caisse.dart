import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:vvf/controllers/caisse_controller.dart';
import 'package:vvf/controllers/category_controller.dart';
import 'package:vvf/models/caisse_model.dart';
import 'package:vvf/models/category_model.dart';
import 'package:vvf/pages/caisses/add_caisse.dart';
import 'package:vvf/pages/categories/add_category.dart';

import '../../components/app_image.dart';
import '../../components/app_text.dart';
import '../../controllers/devise_controller.dart';
import '../../models/trans_model.dart';
import '../../utils/app_const.dart';
import '../../utils/app_func.dart';
import '../../utils/providers.dart';
import '../transactions/add_transaction.dart';

class HomeCaisse extends ConsumerStatefulWidget {
  const HomeCaisse({super.key});

  @override
  ConsumerState createState() => _HomeCaisseState();
}

class _HomeCaisseState extends ConsumerState<HomeCaisse>
    with SingleTickerProviderStateMixin {
  late TabController controller;

  var currentCaisseIndex = 0;


  List<Trans> trans = [];

  var currentDate = DateTime.now();
  var minDate = DateTime.now();
  var maxDate = DateTime.now();
  var format = DateFormat("E, dd MMM yyyy");

  int currentPeriodType = 0;
  bool firstTime = true;


  List<Caisse> caisses = [];
  List<Category> cats = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAllCategs();
    controller = TabController(length: 5, vsync: this);
    controller.addListener(() {
      changePeriode(controller.index);
    });
  }
  Future<void> getAllCategs() async {
    cats = await ref.read(catController).getUserCategoriesFuture();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    double hCard = 0.55 * getSize(context).height;
    return Scaffold(
        body:    ref.watch(getMyCaisses).when(data: (data){
          caisses = data;
          updateGraphInfos();
          return Scaffold(
            appBar: AppBar(
              elevation: 0,
              backgroundColor: AppColor.caisseColor,
              title: AppText(
                "CAISSE ${caisses[currentCaisseIndex].name}".toUpperCase(),
                color: AppColor.white,
                size: 18,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              centerTitle: true,
            ),
            body: Container(
              height: getSize(context).height,
              child: Column(
                children: [

                  Expanded(
                    child: FutureBuilder<List<Trans>>(
                        future: ref.read(transController).getUserTransactionRange(minDate.millisecondsSinceEpoch, maxDate.millisecondsSinceEpoch),
                      builder: (context, snap) {
                          if(!snap.hasData){
                            return const CupertinoActivityIndicator();
                          }
                          trans = snap.data!;
                          trans = trans.where((element) => element.caisseId==caisses[currentCaisseIndex].key).toList();

                          Map<int, List<Trans>> transGroup = {};
                          trans.sort((t1, t2)=>t2.time.compareTo(t1.time));
                          for (var element in trans) {
                            List<Trans>? trans = transGroup[element.time];
                            trans ??= [];
                            trans.add(element);
                            transGroup[element.time] = trans;
                          }
                        return SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Histogram of caisse
                              Container(
                                width: getSize(context).width,
                                height: hCard - 40,
                                child: Stack(
                                  children: [
                                    Container(
                                      width: getSize(context).width,
                                      height: 100,
                                      decoration: const BoxDecoration(
                                          color: AppColor.caisseColor,
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
                                          AppText(
                                            "${(caisses[currentCaisseIndex].solde/ref.watch(userDevise).rate).toStringAsFixed(2)} ${ref.watch(userDevise).symbol}",
                                            color: Colors.white,
                                            size: 35,
                                            weight: FontWeight.bold,
                                          ),
                                          const SpacerHeight(),
                                          Container(
                                            height: hCard - 100,
                                            width: getSize(context).width,
                                            margin: const EdgeInsets.symmetric(
                                                horizontal: 20),
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.circular(20),
                                                boxShadow: [
                                                  BoxShadow(
                                                      color:
                                                      Colors.black.withOpacity(0.1),
                                                      blurRadius: 1)
                                                ]),
                                            child: buildHistograms(),
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),

                              //Transaction List
                              Container(
                                margin: const EdgeInsets.symmetric(horizontal: 20),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.black.withOpacity(0.1),
                                          blurRadius: 1)
                                    ]),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children:  transGroup.keys.map((time) => buildTransListGroup(time, transGroup)).toList()
                                ),
                              ),
                              SpacerHeight(height: 15,),
                            ],
                          ),
                        );
                      }
                    ),
                  ),

                  //Caisse List
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withOpacity(0.1), blurRadius: 1)
                        ]),
                    child:Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //List des caisse
                        for(var i=0; i<caisses.length; i++)
                          buildCaisse(caisses[i], i),
                        InkWell(
                          onTap: () {
                            navigateToWidget(context, const AddCaisse());
                          },
                          child: Container(
                            height: 110,
                            width: 110,
                            margin: const EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                                border: Border.all(color: AppColor.caisseColor),
                                borderRadius: BorderRadius.circular(20)),
                            child: const Icon(
                              Icons.add_circle_rounded,
                              size: 40,
                              color: AppColor.catgColor,
                            ),
                          ),
                        ),
                      ],
                    )
                  ),

                  const SpacerHeight()
                ],
              ),
            ),
          );
        }, error: errorLoading, loading: loadingError)
    );
  }

  buildHistograms() {



    List<Trans> transCaisseList = trans.where((element) => element.caisseId == caisses[currentCaisseIndex].key).toList();

    double ent = 0;
    double sort = 0;

    transCaisseList.forEach((element) {
      if (element.type == 1) {
        ent += element.amount;
      } else if (element.type == 0) {
        sort += element.amount;
      }
    });
    ent = ent/ref.read(userDevise).rate;
    sort = sort/ref.read(userDevise).rate;
    final List<double> data = [ent, sort];


    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TabBar(tabs: const [
            Tab(text: "Jour",),
            Tab(text: "Semaine",),
            Tab(text: "Mois",),
            Tab(text: "Année",),
            Tab(text: "Période",),
          ], controller: controller, labelColor: Colors.black,),
          Container(
            width: getSize(context).width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(onPressed: (){
                  addDate(-1);
                }, icon: const Icon(Icons.arrow_back_ios, size: 16, )),
                Expanded(
                  child: InkWell(
                      onTap: (){
                        if(currentPeriodType!=4){
                          selectDate();
                        }else{
                          selectRangeDate();
                        }
                      },
                      child: AppText(getTextPeriod(), align: TextAlign.center, size: 16, weight: FontWeight.bold,)),
                ),
                IconButton(onPressed: (){
                  addDate(1);
                }, icon: const Icon(Icons.arrow_forward_ios_outlined,size: 16,  )),
              ],
            ),
          ),
          Expanded(
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.center,
                barTouchData: BarTouchData(enabled: false),
                titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: ((d, data){
                            log(d);
                            if(d==0){
                              return const AppText("Entrées");
                            }
                            return const AppText("Sorties");
                          })
                      ),
                    ),
                    leftTitles: null, // Hide left axis labels
                    rightTitles: null
                ),
                borderData: FlBorderData(show: false),
                barGroups: data
                    .asMap()
                    .map((index, value) => MapEntry(
                  index,
                  BarChartGroupData(
                    x: index,
                    barRods: [
                      BarChartRodData(
                          toY: value.toDouble(),
                          color: index==1?Colors.red:Colors.green,
                          width: 40,
                          borderRadius: BorderRadius.circular(2)),
                    ],
                  ),
                ))
                    .values
                    .toList(),
              ),
            ),
          ),
          Row(
            children: [
              const AppText("Entrées: ", weight: FontWeight.bold, color: AppColor.caisseColor,),
              AppText(ent.toStringAsFixed(2)+" "+ref.read(userDevise).symbol),
            ],
          ),
          Row(
            children: [
              const AppText("Sortie: ", weight: FontWeight.bold, color: Colors.red,),
              AppText(sort.toStringAsFixed(2)+" "+ref.read(userDevise).symbol),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              FloatingActionButton.small(onPressed: (){
                navigateToWidget(context, AddTransaction(caisses[currentCaisseIndex]));
              }, elevation: 0, child: const Icon(Icons.add),)
            ],
          ),
        ],
      ),
    );
  }


  buildCaisse(Caisse caisse, int i) {
    return InkWell(
      onTap: () {
        currentCaisseIndex = i;
        setState(() {

        });
      },
      child: Container(
        height: 110,
        width: 110,
        margin: i==0?const EdgeInsets.only(right: 5): const EdgeInsets.symmetric(horizontal: 5),
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
            border: Border.all(color: AppColor.caisseColor),
            color: currentCaisseIndex==i?AppColor.caisseColor:Colors.transparent,
            borderRadius: BorderRadius.circular(20)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const AppImage(url: 'assets/img/salary.png', width: 50, ),
            const SpacerHeight(),
            AppText("Caisse ${caisse.name}",
              weight: FontWeight.w700,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              align: TextAlign.center, color: currentCaisseIndex==i?Colors.white:Colors.black,),
          ],
        ),
      ),
    );
  }


  void changePeriode(int index) {
    currentPeriodType = index;
    setState(() {});
  }
  void addDate(int i) {
    if (currentPeriodType==0) {
      currentDate = currentDate.add(Duration(days: i));
    } else if (currentPeriodType==1) {
      currentDate = currentDate.add(Duration(days: i*7));
    } else if (currentPeriodType==2) {
      currentDate = DateTime(currentDate.year, currentDate.month+i, currentDate.day);
    } else if (currentPeriodType==3) {
      currentDate = DateTime(currentDate.year+i, currentDate.month, currentDate.day);
    }else if(currentPeriodType==4){
    }

    setState(() {});
  }
  String getTextPeriod() {
    String text = "";
    if (currentPeriodType==0) {
      text  = format.format(currentDate);
    } else if (currentPeriodType==1) {
      text  = "Semaine du "+format.format(minDate);
    } else if (currentPeriodType==2) {
      text  = "Mois du "+format.format(getFirstDayOfWeek(currentDate));
    } else if (currentPeriodType==3) {
      text  = "Année ${minDate.year}";
    }else{
      text = "${format.format(minDate)} au ${format.format(maxDate)}";
    }
    return text;
  }
  void selectDate() {
    showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime(2020),
        lastDate: DateTime.now().add(const Duration(days: 10*365))).then((value){
      if(value!=null){
        currentDate = value;
        setState(() {});
      }
    });
  }
  void selectRangeDate(){
    showDateRangePicker(context: context, firstDate: DateTime(2020), lastDate: DateTime.now().add(const Duration(days: 30*36))).then((value){
      if(value==null){
        controller.animateTo(0);
      }else{
        minDate = value.start;
        maxDate = value.end;
        setState(() {});
      }
    });
  }
  updateGraphInfos() async {

    if (currentPeriodType==0) {
      minDate = DateTime(currentDate.year, currentDate.month, currentDate.day);
      maxDate = minDate.add(const Duration(days: 1));
    } else if (currentPeriodType==1) {
      minDate = getFirstDayOfWeek(currentDate);
      maxDate = getLastDayOfWeek(currentDate);
    } else if (currentPeriodType==2) {
      minDate = getFirstDayOfMonth(currentDate);
      maxDate = getLastDayOfMonth(currentDate);
    } else if (currentPeriodType==3) {
      minDate = DateTime(currentDate.year);
      maxDate = getLastDayOfWeek(currentDate);
    }


    //setState(() {});
  }

  Widget buildTransListGroup(int time, Map<int, List<Trans>> value) {
    var transact = value[time];
    double ent= 0;
    double sort= 0;
    transact!.forEach((element) {
      if(element.type==1){
        ent+=element.amount;
      }else{
        sort+=element.amount;
      }
    });
    ent = ent/ref.watch(userDevise).rate;
    sort = sort/ref.watch(userDevise).rate;
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppText(format.format(DateTime.fromMillisecondsSinceEpoch(time)), weight: FontWeight.bold, size: 16,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                    AppText("+ "+ent.toStringAsFixed(1), color: Colors.green,),
                    AppText("-"+sort.toStringAsFixed(1), color: Colors.red,),
                ],
              )
            ],
          ),
          const Divider(thickness: 1.5,),
          SpacerHeight(),
          Column(
            children: transact.map((e) => SingleTrans(e)).toList(),
          )
        ],
      ),
    );
  }

  Widget SingleTrans(Trans e) {
    var cts = cats.where((element) => element.key==e.catId).toList();
    Category category = cts.isNotEmpty?cts.first:Category.initial();
    Color catColor = Color.fromARGB(category.colorA, category.colorR, category.colorG, category.colorB);
    double solde = e.amount/ref.watch(userDevise).rate;

    return InkWell(
      onTap: (){
        showOptions(e);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 5),
        child: Row(
          children: [
            SizedBox(
              width: 40,
              height: 40,
              child: CircleAvatar(
                backgroundColor: catColor,
                child: Icon(
                  IconData(
                    category.iconData,
                    fontFamily: "MaterialIcons",
                  ),
                  color: Colors.white,
                  size: 30,
                ),
              ),
            ),
            const SizedBox(width: 15,),
            Expanded(child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(category.nom, weight: FontWeight.bold, ),
                AppText(e.comment.isEmpty?"Sans commentaire":e.comment, maxLines: 2, ),
              ],
            )),
            const SizedBox(width: 15,),
            AppText( "${e.type==0?"-":"+"}${solde.toStringAsFixed(1)} ${ref.read(userDevise).symbol}",
            color: e.type==0?Colors.red:Colors.green,
              weight: FontWeight.bold,
            )
          ],
        ),
      ),
    );
  }

  void showOptions(Trans e) {

    showDialog(context: context, builder: (context2){
      return SimpleDialog(
        title: AppText("Options", weight: FontWeight.bold,),
        children: [
          SimpleDialogOption(onPressed: (){
            Navigator.pop(context2);
            showConfirm(context, "Voulez-vous vraiment supprimer cette transaction?", () async {
              Navigator.pop(context);
              await ref.read(transController).deleteTrans(e);
              setState(() {});
            });
          }, child: AppText("Supprimer"),),
        ],
      );
    });
  }
}
