// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ssc/src/view/home/components/homeChartWidget.dart';
import 'package:ssc/src/view/home/components/homeLoaderWidget.dart';
import 'package:ssc/src/view/home/components/homeSlideShowWidget.dart';
import 'package:ssc/utilities/hexColor.dart';

import '../../../infrastructure/userConfig.dart';
import '../../../models/home/userInformationsDashboard.dart';
import '../../../utilities/theme/themes.dart';
import '../../../utilities/util.dart';
import '../../viewModel/home/homeProvider.dart';
import '../../viewModel/utilities/theme/themeProvider.dart';
import 'components/homeOverviewWidget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  Future statisticsFuture;
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
                if(snapshot.hasData){
                  UserInformation userInformation = snapshot.data;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(bottom: height(0.003, context)),
                        child: Text(translate('overview', context)),
                      ),
                      HomeOverviewWidget(data: userInformation),
                      SizedBox(
                        height: height(0.02, context),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: height(0.006, context)),
                        child: Text(translate('advertisements', context)),
                      ),
                      const HomeSlideShowWidget(),
                      SizedBox(
                        height: height(0.02, context),
                      ),
                      Padding(
                        padding: EdgeInsets.zero,
                        child: Text(translate('pastYearsPays', context)),
                      ),
                      HomeChartWidget(data: userInformation),
                      SizedBox(
                        height: height(Provider.of<HomeProvider>(context).showFloatingButton ? 0.075 : 0.0, context),
                      ),
                    ],
                  );
                } else{
                  print(snapshot.error);
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
          right: UserConfig.instance.checkLanguage() ? 0 : width(0.075, context),
          left: UserConfig.instance.checkLanguage() ? width(0.075, context) : 0
        ),
        width: width(0.93, context),
        height: height(0.07, context),
        decoration: BoxDecoration(
            color: getPrimaryColor(context, themeNotifier),
            borderRadius: BorderRadius.circular(12)
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
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: width(0.035, context),
                    ),
                  ),
                  SizedBox(
                    width: width(0.05, context),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '455',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: width(0.035, context),
                        ),
                      ),
                      Text(
                        translate('jd', context),
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: width(0.035, context),
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
                  borderRadius: BorderRadius.circular(6),
                ),
                child: InkWell(
                  onTap: (){},
                  child: Text(
                    translate('pay', context),
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: width(0.035, context),
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