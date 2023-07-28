import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vvf/controllers/category_controller.dart';
import 'package:vvf/models/category_model.dart';
import 'package:vvf/pages/categories/add_category.dart';

import '../../components/app_image.dart';
import '../../components/app_text.dart';
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
        backgroundColor: AppColor.catgColor,
        title: AppText(
          "Dépense en RESTAURATION",
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
            Container(
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
                  Expanded(
                    child: SingleChildScrollView(
                      child: ref.watch(getAllCats).when(data: (data){
                        log(data);
                        return Wrap(
                          children: data.map((e) => SingleCat(e)).toList(),
                        );
                      }, error: errorLoading, loading: loadingError),
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
                              return AppText("Principal");
                            }
                            return AppText("Entreprise");
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

  Widget SingleCat(Category e) {
    return Container(
      width:  60,
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
    );
  }
}
