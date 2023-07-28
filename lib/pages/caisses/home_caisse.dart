import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vvf/controllers/caisse_controller.dart';
import 'package:vvf/controllers/category_controller.dart';
import 'package:vvf/models/caisse_model.dart';
import 'package:vvf/models/category_model.dart';
import 'package:vvf/pages/caisses/add_caisse.dart';
import 'package:vvf/pages/categories/add_category.dart';

import '../../components/app_image.dart';
import '../../components/app_text.dart';
import '../../utils/app_const.dart';
import '../../utils/app_func.dart';

class HomeCaisse extends ConsumerStatefulWidget {
  const HomeCaisse({super.key});

  @override
  ConsumerState createState() => _HomeCaisseState();
}

class _HomeCaisseState extends ConsumerState<HomeCaisse>
    with SingleTickerProviderStateMixin {
  late TabController controller;

  var currentCaisseIndex = 0;

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
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColor.caisseColor,
        title: AppText(
          "CAISSE PRINCIPALE",
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
              child: SingleChildScrollView(
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
                                  "100000 €",
                                  color: Colors.white,
                                  size: 35,
                                  weight: FontWeight.bold,
                                ),
                                SpacerHeight(),
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
                        children: [
                          //List des transactions
                        ],
                      ),
                    )
                  ],
                ),
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
              child: ref.watch(getMyCaisses).when(data: (data){
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //List des caisse
                    for(var i=0; i<data.length; i++)
                      buildCaisse(data[i], i),
                    InkWell(
                      onTap: () {
                        navigateToWidget(context, AddCaisse());
                      },
                      child: Container(
                        height: 110,
                        width: 110,
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                            border: Border.all(color: AppColor.caisseColor),
                            borderRadius: BorderRadius.circular(20)),
                        child: Icon(
                          Icons.add_circle_rounded,
                          size: 40,
                          color: AppColor.catgColor,
                        ),
                      ),
                    ),
                  ],
                );
              }, error: errorLoading, loading: loadingError),
            ),

            SpacerHeight()
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
          TabBar(
            tabs: [
              Tab(
                text: "Jour",
              ),
              Tab(
                text: "Semaine",
              ),
              Tab(
                text: "Mois",
              ),
              Tab(
                text: "Année",
              ),
              Tab(
                text: "Période",
              ),
            ],
            controller: controller,
            labelColor: Colors.black,
          ),
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
                          getTitlesWidget: ((d, data) {
                            log(d);
                            if (d == 0) {
                              return AppText("Entrées");
                            }
                            return AppText("Sorties");
                          })),
                    ),
                    leftTitles: null, // Hide left axis labels
                    rightTitles: null),
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
                                  color: index == 1 ? Colors.red : Colors.green,
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
            AppImage(url: 'assets/img/salary.png', width: 50, ),
            SpacerHeight(),
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
}
