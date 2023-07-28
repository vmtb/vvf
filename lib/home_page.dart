import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vvf/components/app_image.dart';
import 'package:vvf/components/app_text.dart';
import 'package:vvf/pages/caisses/home_caisse.dart';
import 'package:vvf/pages/categories/home_category.dart';
import 'package:vvf/pages/setting/home_settings.dart';
import 'package:vvf/utils/app_const.dart';
import 'package:vvf/utils/app_func.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> with SingleTickerProviderStateMixin {
  late TabController controller;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = TabController(length: 5, vsync: this);
    controller.addListener(() {
      log("Move to tab ${controller.index}");
      changePeriode(controller.index);
    });
  }
  @override
  Widget build(BuildContext context) {
    double hCard = 0.55 * getSize(context).height;

    var menus = [
      ["salary.png", "Caisses", AppColor.caisseColor, HomeCaisse()],
      ["planning.png", "Projets", AppColor.projecColor, Container()],
      ["categories.png", "Catégories", AppColor.catgColor, HomeCategory()],
      ["setting.png", "Paramètres", AppColor.settingColor, HomeSetting()],
    ];

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: CircleAvatar(
          backgroundColor: Colors.transparent,
          child: ClipRRect(
              borderRadius: BorderRadius.circular(40),
              child: AppImage(
                url: "assets/img/logo.png",
                width: 35,
                fit: BoxFit.cover,
                height: 35,
              )),
        ),
        title: AppText(
          "Solde caisse epargne",
          color: AppColor.white,
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.account_circle_rounded,
              size: 40,
            ),
          ),
          SizedBox(
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
                    decoration: BoxDecoration(
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
                          "100000 €",
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
            SpacerHeight(
              height: 40,
            ),
            Center(child: AppText("Version 1.0")),
            SpacerHeight(
              height: 40,
            ),
          ],
        ),
      ),
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
            SpacerHeight(),
            AppText(menu[1],
                color: AppColor.white,
                size: 22,
                weight: FontWeight.bold,
                maxLines: 1,
                overflow: TextOverflow.ellipsis),
            SpacerHeight(),
          ],
        ),
      ),
    );
  }

  buildHistograms() {
    final List<double> data = [10, 45];

    return Container(
      padding: EdgeInsets.all(16.0),
      child: Column(
        children: [
          TabBar(tabs: [
            Tab(text: "Jour",),
            Tab(text: "Semaine",),
            Tab(text: "Mois",),
            Tab(text: "Année",),
            Tab(text: "Période",),
          ], controller: controller, labelColor: Colors.black,),
          AppText("Aujourd'hui xxxx/xxx/xxx"),
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
                          return AppText("Entrées");
                        }
                        return AppText("Sorties");
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
        ],
      ),
    );
  }

  void changePeriode(int index) {}
}
