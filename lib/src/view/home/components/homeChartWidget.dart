// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:ssc/utilities/hexColor.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../../models/home/userInformationsDashboard.dart';
import '../../../../utilities/util.dart';

class HomeChartWidget extends StatelessWidget {
  final UserInformation data;
  const HomeChartWidget({Key key, @required this.data}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    TooltipBehavior tooltipBehavior = TooltipBehavior(enable: true);

    List<SalaryData> dataSource = [];
    if(data.curGetdata.isNotEmpty) {
      data.curGetdata[0].forEach((element){
      dataSource.add(
          SalaryData(element['FOR_YEAR'], double.parse(element['SALARY'].toString()))
      );
    });
    }

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Container(
        height: height(0.22, context),
        padding: const EdgeInsets.all(5.0).copyWith(right: 10.0),
        child: Center(
            child: SfCartesianChart(
              margin: const EdgeInsets.only(top: 14),
              primaryXAxis: CategoryAxis(isVisible: true),
              legend: Legend(isVisible: false),
              tooltipBehavior: tooltipBehavior,
              series: <LineSeries<SalaryData, String>>[
                LineSeries<SalaryData, String>(
                  name: translate('salary', context),
                  dataSource: dataSource,
                  xValueMapper: (SalaryData sales, _) => sales.year,
                  yValueMapper: (SalaryData sales, _) => sales.salary,
                  pointColorMapper: (SalaryData sales, _) => HexColor('#946800'),
                  dataLabelSettings: const DataLabelSettings(isVisible: true)
                )
              ],
            )
        ),
      ),
    );
  }
}

class SalaryData {
  SalaryData(this.year, this.salary);
  final String year;
  final double salary;
}