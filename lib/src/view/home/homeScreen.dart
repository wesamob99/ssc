import 'package:ai_progress/ai_progress.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:provider/provider.dart';
import 'package:ssc/utilities/hexColor.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../infrastructure/userConfig.dart';
import '../../../utilities/theme/themes.dart';
import '../../../utilities/util.dart';
import '../../viewModel/utilities/theme/themeProvider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  List<String> images = [
    'assets/images/test_slider_images/1.jpg',
    'assets/images/test_slider_images/2.jpg',
    'assets/images/test_slider_images/3.jpg',
  ];
  late TooltipBehavior _tooltipBehavior;

  @override
  void initState(){
    _tooltipBehavior = TooltipBehavior(enable: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ThemeNotifier themeNotifier = Provider.of<ThemeNotifier>(context);

    List<Widget> ads = [];
    for (int i = 0; i < images.length; i++) {
      ads.add(
        InkWell(
          onTap: () {},
          child: Image.asset(
            images[i],
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) {
              return const Icon(
                Icons.error_outline,
                color: Colors.red,
                size: 36,
              );
            },
          ),
        ),
      );
    }

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text(translate('overview', context)),
            ),
            overViewWidget(themeNotifier),
            SizedBox(
              height: height(0.015, context),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text(translate('advertisements', context)),
            ),
            imageSlideShow(ads, themeNotifier),
            SizedBox(
              height: height(0.015, context),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text(translate('pastYearsPays', context)),
            ),
            pastYearsChart(),
          ],
        ),
      ),
    );
  }

  overViewWidget(ThemeNotifier themeNotifier){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: width(1, context),
          height: height(0.16, context),
          child: Row(
            children: [
              SizedBox(
                width: width(0.35, context),
                child: Column(
                  children: [
                    Flexible(
                      child: Material(
                        elevation: 0.7,
                        borderRadius: BorderRadius.circular(14),
                        child: Container(
                          width: width(0.35, context),
                          decoration: BoxDecoration(
                            color: getContainerColor(context),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(translate('subscriptions', context),
                                  style: TextStyle(
                                      fontSize: width(0.03, context))),
                              SizedBox(
                                height: height(0.002, context),
                              ),
                              Text(
                                '40',
                                style: TextStyle(
                                    color: HexColor('#37662D'),
                                    fontWeight: FontWeight.bold,
                                    fontSize: width(0.03, context)),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: height(0.005, context),
                    ),
                    Flexible(
                      child: Material(
                        elevation: 0.7,
                        borderRadius: BorderRadius.circular(14),
                        child: Container(
                          width: width(0.35, context),
                          decoration: BoxDecoration(
                            color: getContainerColor(context),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(translate('idleBalance', context),
                                  style: TextStyle(
                                      fontSize: width(0.03, context))),
                              SizedBox(
                                height: height(0.002, context),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    '455-',
                                    style: TextStyle(
                                        color: HexColor('#BC0D0D'),
                                        fontWeight: FontWeight.bold,
                                        fontSize: width(0.03, context)),
                                  ),
                                  Text(
                                    translate('jd', context),
                                    style: TextStyle(
                                        color: themeNotifier.isLight()
                                            ? Colors.black
                                            : Colors.white,
                                        fontSize: width(0.03, context)),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                width: width(0.015, context),
              ),
              Expanded(
                child: Material(
                  elevation: 0.7,
                  borderRadius: BorderRadius.circular(14),
                  child: Container(
                    decoration: BoxDecoration(
                      color: getContainerColor(context),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: width(0.03, context)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(UserConfig.instance.checkLanguage()
                              ? 'Al-Qawasmi Company'
                              : 'شركة القواسمي وشركاة',
                              style: TextStyle(fontSize: width(0.03, context))),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(translate('salary', context),
                                  style: TextStyle(
                                      fontSize: width(0.03, context))),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    '1400',
                                    style: TextStyle(
                                        color: HexColor('#37662D'),
                                        fontWeight: FontWeight.bold,
                                        fontSize: width(0.03, context)),
                                  ),
                                  Text(
                                    translate('jd', context),
                                    style: TextStyle(
                                        color: themeNotifier.isLight()
                                            ? Colors.black
                                            : Colors.white,
                                        fontSize: width(0.03, context)),
                                  ),
                                ],
                              )
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(translate('deductionValue', context),
                                  style: TextStyle(
                                      fontSize: width(0.03, context))),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    '105',
                                    style: TextStyle(
                                        color: HexColor('#BE8703'),
                                        fontWeight: FontWeight.bold,
                                        fontSize: width(0.03, context)),
                                  ),
                                  Text(
                                    translate('jd', context),
                                    style: TextStyle(
                                        color: themeNotifier.isLight()
                                            ? Colors.black
                                            : Colors.white,
                                        fontSize: width(0.03, context)),
                                  ),
                                ],
                              )
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(translate('lastPayment', context),
                                  style: TextStyle(
                                      fontSize: width(0.03, context))),
                              Text('22/7/2022',
                                  style: TextStyle(
                                      fontSize: width(0.03, context))),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
        SizedBox(
          height: height(0.01, context),
        ),
        SizedBox(
          width: width(1, context),
          child: Row(
            children: [
              Expanded(
                child: Material(
                  elevation: 0.7,
                  borderRadius: BorderRadius.circular(14),
                  child: Container(
                    decoration: BoxDecoration(
                      color: getContainerColor(context),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: width(0.03, context),
                        vertical: width(0.01, context),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            translate('number_of_contributions_to_retirement', context),
                            style: TextStyle(fontSize: width(0.03, context)),
                          ),
                          SizedBox(
                            width: width(1, context),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  '300/40',
                                  style: TextStyle(
                                      fontSize: width(0.025, context)),
                                ),
                                Container(
                                  width: width(1, context),
                                  height: 15,
                                  padding: const EdgeInsets.all(5),
                                  child: AirLinearStateProgressIndicator(
                                    size: const Size(0, 0),
                                    value: 40,
                                    valueColor: HexColor('#2D452E'),
                                    pathColor: HexColor('#EAEAEA'),
                                    pathStrokeWidth: height(0.008, context),
                                    valueStrokeWidth: height(0.008, context),
                                    roundCap: true,
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  imageSlideShow(List<Widget> children, ThemeNotifier themeNotifier) {
    return ImageSlideshow(
        width: double.infinity,
        height: height(.22, context),
        initialPage: 0,
        indicatorColor: getPrimaryColor(context, themeNotifier),
        indicatorBackgroundColor: Colors.white,
        onPageChanged: (value) {
          // print('Page changed: $value');
        },
        autoPlayInterval: 3000,
        isLoop: true,
        children: children);
  }

  pastYearsChart(){
    return SizedBox(
      height: height(0.23, context),
      child: Center(
          child: SfCartesianChart(
            primaryXAxis: CategoryAxis(),
            // legend: Legend(isVisible: true),
            tooltipBehavior: _tooltipBehavior,
            series: <LineSeries<SalaryData, String>>[
              LineSeries<SalaryData, String>(
                dataSource:  <SalaryData>[
                  SalaryData('2010', 500),
                  SalaryData('2012', 600),
                  SalaryData('2014', 1000),
                  SalaryData('2016', 2000),
                  SalaryData('2018', 4300),
                  SalaryData('2020', 2600)
                ],
                xValueMapper: (SalaryData sales, _) => sales.year,
                yValueMapper: (SalaryData sales, _) => sales.salary,
                dataLabelSettings: const DataLabelSettings(isVisible: true)
              )
            ],
        )
      ),
    );
  }
}

class SalaryData {
  SalaryData(this.year, this.salary);
  final String year;
  final double salary;
}