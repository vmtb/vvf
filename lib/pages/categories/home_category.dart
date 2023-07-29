import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:vvf/controllers/category_controller.dart';
import 'package:vvf/models/category_model.dart';
import 'package:vvf/pages/categories/add_category.dart';
import 'package:vvf/utils/providers.dart';

import '../../components/app_image.dart';
import '../../components/app_text.dart';
import '../../controllers/devise_controller.dart';
import '../../models/caisse_model.dart';
import '../../models/trans_model.dart';
import '../../utils/app_const.dart';
import '../../utils/app_func.dart';

class HomeCategory extends ConsumerStatefulWidget {
  const HomeCategory({super.key});

  @override
  ConsumerState createState() => _HomeCategoryState();
}

class _HomeCategoryState extends ConsumerState<HomeCategory>
    with SingleTickerProviderStateMixin {
  late TabController controller;

  List<Caisse> caisses = [];
  List<Category> cats = [];


  int currentCatIndex = 0;

  List<Trans> trans = [];

  var currentDate = DateTime.now();
  var minDate = DateTime.now();
  var maxDate = DateTime.now();
  var format = DateFormat("E, dd MMM yyyy");

  int currentPeriodType = 0;
  bool firstTime = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = TabController(length: 5, vsync: this);
    controller.addListener(() {
      log("Move to tab ${controller.index}");
      changePeriode(controller.index);
    });
    getAllCaisse();
  }

  @override
  Widget build(BuildContext context) {
    double hCard = 0.5 * getSize(context).height;

    return Scaffold(
        body:    ref.watch(getAllCats).when(data: (data){
          cats = data;
          updateGraphInfos();
          return Scaffold(
            appBar: AppBar(
              elevation: 0,
              backgroundColor: AppColor.catgColor,
              title: AppText(
                "Dépense en ${cats[currentCatIndex].nom}",
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Histogram of caisse
                  FutureBuilder<List<Trans>>(
                      future: ref.read(transController).getUserTransactionRange(minDate.millisecondsSinceEpoch, maxDate.millisecondsSinceEpoch),
                      builder: (context, snap) {
                        if(!snap.hasData){
                          return Center(child: const CupertinoActivityIndicator());
                        }
                        trans = snap.data!;
                        var transCat = trans.where((element) => element.catId==cats[currentCatIndex].key && element.type==0).toList();
                        double solde = 0;
                        transCat.forEach((element) {
                          solde += element.amount;
                        });
                        solde=solde/ref.read(userDevise).rate;


                        return  Container(
                            width: getSize(context).width,
                            height: hCard - 40,
                            child: Stack(
                              children: [
                                Container(
                                  width: getSize(context).width,
                                  height: 100,
                                  decoration: BoxDecoration(
                                      color: AppColor.catgColor,
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
                                        "${solde.toStringAsFixed(2)} ${ref.read(userDevise).symbol}",
                                        color: Colors.white,
                                        size: 35,
                                        weight: FontWeight.bold,
                                      ),
                                      SpacerHeight(),
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
                                        child: buildHistograms(),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          );
                      }
                  ),

                  //Categories List
                  Expanded(
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black.withOpacity(0.1), blurRadius: 1)
                            ]),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            //List des Catégories
                            SizedBox(
                              width: getSize(context).width,
                              child: Expanded(
                                child: Wrap(
                                  children: cats.map((e) => SingleCat(e)).toList(),
                                  alignment: WrapAlignment.center,
                                ),
                              ),
                            ),
                            Divider(),
                            Center(
                              child: IconButton(
                                  onPressed: () {
                                    navigateToWidget(context, AddCategory());
                                  },
                                  icon: Icon(
                                    Icons.add_circle_rounded,
                                    size: 40,
                                    color: AppColor.catgColor,
                                  )),
                            ),
                            SpacerHeight()
                          ],
                        ),
                      ))
                ],
              ),
            ),
          );
        }, error: errorLoading, loading: loadingError)
    );
  }

  buildHistograms() {


    List<Trans> transDepList = trans.where((element) => element.type == 0).toList();
    double ent = 0;

    final List<double> data = caisses.map((element) {
      double sort = transDepList
          .where((trans) => trans.caisseId == element.key)
          .fold(0, (previousValue, element) => previousValue + element.amount);
      return sort / ref.read(userDevise).rate;
    }).toList();

    Map<String, double> catTrans = {};
    cats.forEach((element) {
      double solde = transDepList
          .where((trans) => trans.catId == element.key)
          .fold(0, (previousValue, element) => previousValue + element.amount);
      catTrans[element.key] = solde / ref.read(userDevise).rate;
    });

    var sortedCatTrans = catTrans.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    var sortedMap = Map.fromEntries(sortedCatTrans);
    Category c = cats.where((element) => element.key==sortedMap.keys.first).toList().first;
    double montant = sortedMap.values.first;

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
                            return AppText(caisses[d.toInt()].name);
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
                          color: index%2==0?Colors.blue:Colors.green,
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
              const AppText("Plus de dépense: ", weight: FontWeight.bold, color: AppColor.caisseColor,),
              Flexible(child: AppText("${c.nom} (${montant.toStringAsFixed(2)} ${ref.read(userDevise).symbol})", maxLines: 1, overflow: TextOverflow.ellipsis,)),
            ],
          ),
        ],
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

  Widget SingleCat(Category e) {
    return InkWell(
      onTap: (){
        currentCatIndex = cats.indexOf(e);
        setState(() {});
      },
      child: Container(
        width:  50,
        margin: const EdgeInsets.all(8),
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

  Future<void> getAllCaisse() async {
    caisses = await ref.read(caisseController).getUserCaissesFuture();
    setState(() {});
  }
}
