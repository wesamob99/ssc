// ignore_for_file: file_names

import 'package:ai_progress/ai_progress.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../infrastructure/userConfig.dart';
import '../../../../models/home/userInformationsDashboard.dart';
import '../../../../utilities/hexColor.dart';
import '../../../../utilities/theme/themes.dart';
import '../../../../utilities/util.dart';
import '../../../viewModel/utilities/theme/themeProvider.dart';

class HomeOverviewWidget extends StatefulWidget {
  final UserInformation data;
  const HomeOverviewWidget({Key key, @required this.data}) : super(key: key);

  @override
  State<HomeOverviewWidget> createState() => _HomeOverviewWidgetState();
}

class _HomeOverviewWidgetState extends State<HomeOverviewWidget> {

  overViewWidget(ThemeNotifier themeNotifier, UserInformation data){

    ///TODO: ISsTablet
    bool isTablet = false;
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
                        elevation: 1.3,
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          width: width(0.35, context),
                          decoration: BoxDecoration(
                            color: getContainerColor(context),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(translate('subscriptions', context),
                                  style: TextStyle(
                                      fontSize: width(isTablet ? 0.028 : 0.031, context))),
                              Text(
                                data.poMonthsCount.toString(),
                                style: TextStyle(
                                    color: HexColor('#37662D'),
                                    fontWeight: FontWeight.bold,
                                    fontSize: width(0.036, context)),
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
                        elevation: 1.3,
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          width: width(0.35, context),
                          decoration: BoxDecoration(
                            color: getContainerColor(context),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(translate('idleBalance', context),
                                  style: TextStyle(
                                      fontSize: width(isTablet ? 0.028 : 0.031, context))),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    data.poIdleBalance.toStringAsFixed(2),
                                    style: TextStyle(
                                        color: data.poIdleBalance >= 0
                                            ? HexColor('#37662D') : HexColor('#BC0D0D'),
                                        fontWeight: FontWeight.bold,
                                        fontSize: width(0.036, context)),
                                  ),
                                  Text(
                                    translate('jd', context),
                                    style: TextStyle(
                                        color: themeNotifier.isLight()
                                            ? Colors.black
                                            : Colors.white,
                                        fontSize: width(isTablet ? 0.028 : 0.031, context)),
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
                  elevation: 1.3,
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    decoration: BoxDecoration(
                      color: getContainerColor(context),
                      borderRadius: BorderRadius.circular(10),
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
                              style: TextStyle(fontSize: width(isTablet ? 0.028 : 0.031, context))),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(translate('salary', context),
                                  style: TextStyle(
                                      fontSize: width(isTablet ? 0.028 : 0.031, context))),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    (data.poSalary ?? 0).toStringAsFixed(2),
                                    style: TextStyle(
                                        color: HexColor('#37662D'),
                                        fontWeight: FontWeight.bold,
                                        fontSize: width(0.036, context)),
                                  ),
                                  Text(
                                    translate('jd', context),
                                    style: TextStyle(
                                        color: themeNotifier.isLight()
                                            ? Colors.black
                                            : Colors.white,
                                        fontSize: width(isTablet ? 0.028 : 0.031, context)),
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
                                      fontSize: width(isTablet ? 0.028 : 0.031, context))),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    (data.poRegAmt ?? 0).toStringAsFixed(2),
                                    style: TextStyle(
                                        color: HexColor('#BE8703'),
                                        fontWeight: FontWeight.bold,
                                        fontSize: width(0.036, context)),
                                  ),
                                  Text(
                                    translate('jd', context),
                                    style: TextStyle(
                                        color: themeNotifier.isLight()
                                            ? Colors.black
                                            : Colors.white,
                                        fontSize: width(isTablet ? 0.028 : 0.031, context)),
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
                                      fontSize: width(isTablet ? 0.028 : 0.031, context))),
                              Text('22/7/2022',
                                  style: TextStyle(
                                      fontSize: width(isTablet ? 0.028 : 0.031, context))),
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
                  elevation: 1.3,
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    decoration: BoxDecoration(
                      color: getContainerColor(context),
                      borderRadius: BorderRadius.circular(10),
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
                            style: TextStyle(fontSize: width(isTablet ? 0.028 : 0.031, context)),
                          ),
                          SizedBox(height: height(0.01, context),),
                          SizedBox(
                            width: width(1, context),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  '300/40',
                                  style: TextStyle(
                                      fontSize: width(0.03, context)),
                                ),
                                Container(
                                  width: width(1, context),
                                  height: 10,
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

  @override
  Widget build(BuildContext context) {
    ThemeNotifier themeNotifier = Provider.of<ThemeNotifier>(context);
    return overViewWidget(themeNotifier, widget.data);
  }
}
