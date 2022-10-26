// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../../models/home/userInformationsDashboard.dart';
import '../../../../utilities/theme/themes.dart';
import '../../../../utilities/util.dart';
import '../../../viewModel/utilities/theme/themeProvider.dart';

class HomeChartWidget extends StatelessWidget {
  final UserInformation data;
  const HomeChartWidget({Key key, @required this.data}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    ThemeNotifier themeNotifier = Provider.of<ThemeNotifier>(context);
    TooltipBehavior tooltipBehavior = TooltipBehavior(enable: true);

    List<SalaryData> dataSource = [];
    if(data.curGetdata.isNotEmpty) {
      data.curGetdata[0].forEach((element){
      dataSource.add(
          SalaryData(element['FOR_YEAR'], double.parse(element['SALARY'].toString()))
      );
    });
    }

    return SizedBox(
      height: height(0.2, context),
      child: Center(
          child: SfCartesianChart(
            margin: const EdgeInsets.only(top: 14),
            primaryXAxis: CategoryAxis(),
            legend: Legend(isVisible: false),
            tooltipBehavior: tooltipBehavior,
            series: <LineSeries<SalaryData, String>>[
              LineSeries<SalaryData, String>(
                name: translate('salary', context),
                dataSource: dataSource,
                xValueMapper: (SalaryData sales, _) => sales.year,
                yValueMapper: (SalaryData sales, _) => sales.salary,
                pointColorMapper: (SalaryData sales, _) => getPrimaryColor(context, themeNotifier),
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