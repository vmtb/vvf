import 'package:carousel_slider/carousel_slider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:vvf/components/app_image.dart';
import 'package:vvf/components/app_text.dart';
import 'package:vvf/controllers/caisse_controller.dart';
import 'package:vvf/controllers/devise_controller.dart';
import 'package:vvf/models/trans_model.dart';
import 'package:vvf/pages/caisses/home_caisse.dart';
import 'package:vvf/pages/categories/home_category.dart';
import 'package:vvf/pages/setting/home_settings.dart';
import 'package:vvf/utils/app_const.dart';
import 'package:vvf/utils/app_func.dart';
import 'package:vvf/utils/providers.dart';

import 'controllers/trans_controller.dart';
import 'models/caisse_model.dart';
import 'pages/transactions/add_transaction.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> with SingleTickerProviderStateMixin {
  late TabController controller;
  int _currentCaisseIndex = 0;
  List<Caisse> caisses = [];

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
      changePeriode(controller.index);
    });
  }
  @override
  Widget build(BuildContext context) {
    double hCard = 0.58 * getSize(context).height;
    // 18000
    var menus = [
      ["salary.png", "Caisses", AppColor.caisseColor, const HomeCaisse()],
      ["planning.png", "Projets", AppColor.projecColor, Container()],
      ["categories.png", "Catégories", AppColor.catgColor, const HomeCategory()],
      ["setting.png", "Paramètres", AppColor.settingColor, const HomeSetting()],
    ];
    return Scaffold(
      body:    ref.watch(getMyCaisses).when(data: (data){
      caisses = data;
      updateGraphInfos();
      return Scaffold(
          appBar: AppBar(
            elevation: 0,
            leading: CircleAvatar(
              backgroundColor: Colors.transparent,
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(40),
                  child: const AppImage(
                    url: "assets/img/logo.png",
                    width: 35,
                    fit: BoxFit.cover,
                    height: 35,
                  )),
            ),
            title: AppText(
              "Solde caisse ${caisses.isNotEmpty?caisses[_currentCaisseIndex].name:""}",
              color: AppColor.white,
              size: 18,
            ),
            centerTitle: true,
            actions: [
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.account_circle_rounded,
                  size: 40,
                ),
              ),
              const SizedBox(
                width: 10,
              ),
            ],
          ),
          body: SingleChildScrollView(
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
                            color: AppColor.primary,
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
                              "${(caisses[_currentCaisseIndex].solde/ref.watch(userDevise).rate).toStringAsFixed(2)} ${ref.watch(userDevise).symbol}",
                              color: Colors.white,
                              size: 35,
                              weight: FontWeight.bold,
                            ),
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
                              child: buildHistograms(),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),

                //Menus
                Container(
                  width: getSize(context).width,
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  child: GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    physics: const NeverScrollableScrollPhysics(),
                    // alignment: WrapAlignment,
                    children: menus.map((e) => buildMenu(e)).toList(),
                  ),
                ),

                //Version
                const SpacerHeight(
                  height: 40,
                ),
                const Center(child: AppText("Version 1.0")),
                const SpacerHeight(
                  height: 40,
                ),
              ],
            ),
          )
      );
    }, error: errorLoading, loading: loadingError)
    );





  }

  Widget buildMenu(var menu) {
    return InkWell(
      onTap: () {
        navigateToWidget(context, menu[3]);
      },
      child: Container(
        width: 150,
        height: 150,
        //margin: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
            color: menu[2], borderRadius: BorderRadius.circular(20)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppImage(
              url: "assets/img/${menu[0]}",
              width: 100,
            ),
            const SpacerHeight(),
            AppText(menu[1],
                color: AppColor.white,
                size: 22,
                weight: FontWeight.bold,
                maxLines: 1,
                overflow: TextOverflow.ellipsis),
            const SpacerHeight(),
          ],
        ),
      ),
    );
  }

  buildHistograms() {

    return FutureBuilder<List<Trans>>(
      future: ref.read(transController).getUserTransactionRange(minDate.millisecondsSinceEpoch, maxDate.millisecondsSinceEpoch),
      builder: (context, snap) {
        if(!snap.hasData){
          return const CupertinoActivityIndicator();
        }

        trans = snap.data!;

        List<Trans> transCaisseList = trans.where((element) => element.caisseId == caisses[_currentCaisseIndex].key).toList();

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
                    }, icon: Icon(Icons.arrow_back_ios, size: 16, )),
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
                    }, icon: Icon(Icons.arrow_forward_ios_outlined,size: 16,  )),
                  ],
                ),
              ),
              Expanded(
                child: CarouselSlider(
                  options: CarouselOptions(
                    height: 200.0,
                    viewportFraction: 1.0,
                    onPageChanged: (index, _) {
                      setState(() {
                        _currentCaisseIndex = index;
                      });
                    },
                  ),
                  items: caisses.map((imageUrl) {
                    return BarChart(
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
                    );
                  }).toList(),
                ),
              ),
              Row(
                children: [
                  AppText("Entrées: ", weight: FontWeight.bold, color: AppColor.caisseColor,),
                  AppText(ent.toStringAsFixed(2)+" "+ref.read(userDevise).symbol),
                ],
              ),
              Row(
                children: [
                  AppText("Sortie: ", weight: FontWeight.bold, color: Colors.red,),
                  AppText(sort.toStringAsFixed(2)+" "+ref.read(userDevise).symbol),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Expanded(child: SizedBox()),
                  const SizedBox(width: 50,),
                  _buildDotIndicator(),
                  const Expanded(child: SizedBox()),
                  FloatingActionButton.small(onPressed: (){
                    navigateToWidget(context, AddTransaction(caisses[_currentCaisseIndex]));
                  }, elevation: 0, child: const Icon(Icons.add),)
                ],
              ),
            ],
          ),
        );
      }
    );
  }

  Widget _buildDotIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: caisses.map((caisse) {
        int index = caisses.indexOf(caisse);
        return Container(
          width: 8.0,
          height: 8.0,
          margin: const EdgeInsets.symmetric(horizontal: 4.0),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _currentCaisseIndex == index ? AppColor.primary : Colors.grey,
          ),
        );
      }).toList(),
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
    showDateRangePicker(context: context, firstDate: DateTime(2020), lastDate: DateTime.now().add(Duration(days: 30*36))).then((value){
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
}
