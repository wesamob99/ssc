import 'package:ai_progress/ai_progress.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ssc/src/view/home/components/homeChartWidget.dart';
import 'package:ssc/src/view/home/components/homeLoaderWidget.dart';
import 'package:ssc/src/view/home/components/homeSlideShowWidget.dart';
import 'package:ssc/utilities/hexColor.dart';

import '../../../infrastructure/userConfig.dart';
import '../../../utilities/theme/themes.dart';
import '../../../utilities/util.dart';
import '../../viewModel/home/homeProvider.dart';
import '../../viewModel/utilities/theme/themeProvider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  late Future statisticsFuture;
  Future<SharedPreferences> prefs = SharedPreferences.getInstance();

  @override
  void initState(){
    HomeProvider homeProvider = Provider.of<HomeProvider>(context, listen: false);
    statisticsFuture = homeProvider.getStatistics();
    prefs.then((value){
      homeProvider.showFloatingButton = value.getBool('amountToBePaid') ?? true;
      homeProvider.notifyMe();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ThemeNotifier themeNotifier = Provider.of<ThemeNotifier>(context);

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: FutureBuilder(
              future: statisticsFuture,
              builder: (context, snapshot){
                if(snapshot.hasData && !snapshot.hasError){
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Text(translate('overview', context)),
                      ),
                      overViewWidget(themeNotifier, snapshot.data),
                      SizedBox(
                        height: height(0.015, context),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Text(translate('advertisements', context)),
                      ),
                      const HomeSlideShowWidget(),
                      SizedBox(
                        height: height(0.015, context),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Text(translate('pastYearsPays', context)),
                      ),
                      HomeChartWidget(data: snapshot.data),
                      SizedBox(
                        height: height(
                            Provider.of<HomeProvider>(context).showFloatingButton
                                ? 0.075 : 0.0,
                          context
                        ),
                      ),
                    ],
                  );
                } else{
                  return const HomeLoaderWidget();
                }
              }
          ),
        ),
      ),
      floatingActionButton: Provider.of<HomeProvider>(context).showFloatingButton
        ? floatingSlidablePayButton(themeNotifier)
        : const SizedBox.shrink(),
    );
  }

  overViewWidget(ThemeNotifier themeNotifier, data){
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
                                data['po_months_count'].toString(),
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
                                    data['po_idle_balance'].toStringAsFixed(2),
                                    style: TextStyle(
                                        color: data['po_idle_balance'] >= 0
                                        ? HexColor('#37662D') : HexColor('#BC0D0D'),
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
                                    data['po_salary'].toStringAsFixed(2),
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
                                    data['po_reg_amt'].toStringAsFixed(2),
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

  floatingSlidablePayButton(themeNotifier){
    return Slidable(
      key: const ValueKey(0),
      startActionPane: ActionPane(
        motion: const ScrollMotion(),
        dismissible: DismissiblePane(
          onDismissed: () {
            prefs.then((value){
              value.setBool('amountToBePaid', false);
            });
            Provider.of<HomeProvider>(context, listen: false).showFloatingButton = false;
            Provider.of<HomeProvider>(context, listen: false).notifyMe();
          }
        ),
        children: [
          SlidableAction(
            onPressed: (_){
              prefs.then((value){
                value.setBool('amountToBePaid', false);
              });
              Provider.of<HomeProvider>(context, listen: false).showFloatingButton = false;
              Provider.of<HomeProvider>(context, listen: false).notifyMe();
            },
            backgroundColor: Colors.black26,
            foregroundColor: Colors.white,
            icon: Icons.not_interested,
            label: translate('hide', context),
          ),
        ],
      ),
      child: Container(
        margin: EdgeInsets.only(
          right: UserConfig.instance.checkLanguage() ? 0 : width(0.07, context),
          left: UserConfig.instance.checkLanguage() ? width(0.07, context) : 0
        ),
        width: width(0.93, context),
        height: height(0.068, context),
        decoration: BoxDecoration(
            color: getPrimaryColor(context, themeNotifier),
            borderRadius: BorderRadius.circular(15)
        ),
        child: Padding(
          padding:  EdgeInsets.symmetric(
              horizontal: width(0.035, context),
              vertical: height(0.015, context)
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  Text(
                    translate('totalAmountToPay', context),
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                  SizedBox(
                    width: width(0.05, context),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        '455',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                      Text(
                        translate('jd', context),
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                    ],
                  )
                ],
              ),
              Container(
                alignment: Alignment.center,
                width: width(0.2, context),
                decoration: BoxDecoration(
                  color: HexColor('#DBC89C4A').withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: InkWell(
                  onTap: (){},
                  child: Text(
                    translate('pay', context),
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

}