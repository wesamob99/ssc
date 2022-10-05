import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../../utilities/theme/themes.dart';
import '../../../../utilities/util.dart';
import '../../../viewModel/utilities/theme/themeProvider.dart';

class HomeChartWidget extends StatelessWidget {
  final data;
  const HomeChartWidget({Key? key, required this.data}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    ThemeNotifier themeNotifier = Provider.of<ThemeNotifier>(context);
    TooltipBehavior tooltipBehavior = TooltipBehavior(enable: true);

    List<SalaryData> dataSource = [];
    data['cur_getdata'][0].forEach((element){
      dataSource.add(
          SalaryData(element['FOR_YEAR'], double.parse(element['SALARY'].toString()))
      );
    });

    return SizedBox(
      height: height(0.23, context),
      child: Center(
          child: SfCartesianChart(
            primaryXAxis: CategoryAxis(),
            legend: Legend(isVisible: false),
            tooltipBehavior: tooltipBehavior,
            series: <LineSeries<SalaryData, String>>[
              LineSeries<SalaryData, String>(
                name: 'Salary',
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