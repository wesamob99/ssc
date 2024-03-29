// ignore_for_file: file_names

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ssc/source/view/home/homeComponents/homeChartWidget.dart';
import 'package:ssc/source/view/home/homeComponents/homeLoaderWidget.dart';
import 'package:ssc/source/view/home/homeComponents/homeSlideShowWidget.dart';
import 'package:ssc/source/view/pay/payScreen.dart';

import '../../../infrastructure/userConfig.dart';
import '../../../models/home/payOffFinancialInformations.dart';
import '../../../models/home/userInformationsDashboard.dart';
import '../../../utilities/hexColor.dart';
import '../../../utilities/theme/themes.dart';
import '../../../utilities/util.dart';
import '../../viewModel/home/homeProvider.dart';
import '../../viewModel/utilities/theme/themeProvider.dart';
import '../services/shared/servicesListConstants.dart';
import 'homeComponents/homeOverviewWidget.dart';
import 'homeComponents/quickAccessWidget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future statisticsFuture;
  Future amountToBePaidFuture;
  Future<SharedPreferences> prefs = SharedPreferences.getInstance();
  HomeProvider homeProvider;

  @override
  void initState(){
    homeProvider = Provider.of<HomeProvider>(context, listen: false);
    statisticsFuture = homeProvider.getStatistics();
    amountToBePaidFuture = homeProvider.getAmountToBePaid();
    homeProvider.isEditQuickAccessActive = false;

    if(UserConfig.instance.getQuickAccessItems() == 'null'){
      List<String> items = [];
      for (var element in ServicesList.quickAccessServices) {
        if(!items.contains(element.title)) {
          items.add(element.title);
        }
        element.isSelected = true;
      }
      homeProvider.isQuickAccessListEmpty = false;
      UserConfig.instance.setQuickAccessItems(items);
    }else{
      homeProvider.isQuickAccessListEmpty = true;
      List<String> items = UserConfig.instance.getQuickAccessItems();
      for (var element in ServicesList.quickAccessServices) {
        if(items.contains(element.title)){
          element.isSelected = true;
          homeProvider.isQuickAccessListEmpty = false;
        }else{
          element.isSelected = false;
        }
      }
    }

    prefs.then((value){
      homeProvider.showFloatingButton = value.getBool('amountToBePaid') ?? true;
      homeProvider.notifyMe();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ThemeNotifier themeNotifier = Provider.of<ThemeNotifier>(context);
    HomeProvider homeProviderListener = Provider.of<HomeProvider>(context);

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: FutureBuilder(
              future: statisticsFuture,
              builder: (context, snapshot){
                switch(snapshot.connectionState){
                  case ConnectionState.none:
                    return somethingWrongWidget(context, 'somethingWrongHappened', 'somethingWrongHappenedDesc'); break;
                  case ConnectionState.waiting:
                  case ConnectionState.active:
                    return const HomeLoaderWidget(); break;
                  case ConnectionState.done:
                    if(!snapshot.hasError && snapshot.hasData){

                      UserInformation userInformation = snapshot.data;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // ImageSlideshow(
                          //   width: double.infinity,
                          //   height: height(isTablet(context) ? 0.2 : 0.29, context),
                          //   initialPage: 0,
                          //   indicatorColor: primaryColor,
                          //   indicatorBackgroundColor: Colors.grey,
                          //   onPageChanged: (value) {},
                          //   autoPlayInterval: 1000000000,
                          //   isLoop: true,
                          //   children: [
                          //     Column(
                          //       crossAxisAlignment: CrossAxisAlignment.start,
                          //       children: [
                          //         Padding(
                          //           padding: EdgeInsets.only(bottom: height(0.01, context)),
                          //           child: Text(translate('myAccount', context),
                          //               style: TextStyle(
                          //                   fontSize: isTablet(context) ? 20 : 14)),
                          //         ),
                          //         HomeOverviewWidget(data: userInformation),
                          //       ],
                          //     ),
                          //     Column(
                          //       crossAxisAlignment: CrossAxisAlignment.start,
                          //       children: [
                          //         Padding(
                          //           padding: EdgeInsets.only(bottom: height(0.01, context)),
                          //           child: Text(translate('pastYearsPays', context),
                          //               style: TextStyle(
                          //                   fontSize: isTablet(context) ? 20 : 14)),
                          //         ),
                          //         HomeChartWidget(data: userInformation),
                          //       ],
                          //     ),
                          //   ],
                          // ),
                          Padding(
                            padding: EdgeInsets.only(bottom: height(0.01, context)),
                            child: Text(getTranslated('myAccount', context),
                                style: TextStyle(
                                    fontSize: isTablet(context) ? 20 : 14)),
                          ),
                          HomeOverviewWidget(data: userInformation),
                          SizedBox(
                            height: height(0.017, context),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 1.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(getTranslated('quickAccess', context),
                                    style: TextStyle(
                                        fontSize: isTablet(context) ? 20 : 14)),
                                InkWell(
                                  onTap: (){
                                    homeProvider.isEditQuickAccessActive = !homeProvider.isEditQuickAccessActive;
                                    homeProvider.notifyMe();
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 4.0),
                                    child: Text(
                                        homeProviderListener.isEditQuickAccessActive
                                        ? getTranslated('editComplete', context) : getTranslated('edit', context),
                                        style: TextStyle(
                                          fontSize: isTablet(context) ? 20 : 14,
                                          color: themeNotifier.isLight() 
                                            ? HexColor('#003C97')
                                            : HexColor('#00b0ff'),
                                        )
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ),
                          // ignore: prefer_const_constructors
                          QuickAccessWidget(),
                          Padding(
                            padding: EdgeInsets.only(bottom: height(0.007, context)),
                            child: Text(getTranslated('advertisements', context),
                                style: TextStyle(
                                    fontSize: isTablet(context) ? 20 : 14)),
                          ),
                          const HomeSlideShowWidget(),
                          if(userInformation.curGetdata.isNotEmpty)
                          SizedBox(
                            height: height(0.02, context),
                          ),
                          if(userInformation.curGetdata.isNotEmpty)
                          Text(getTranslated('pastYearsPays', context),
                              style: TextStyle(
                                  fontSize: isTablet(context) ? 20 : 14)),
                          if(userInformation.curGetdata.isNotEmpty)
                          HomeChartWidget(data: userInformation),
                          SizedBox(
                            height: height(Provider.of<HomeProvider>(context).showFloatingButton ? 0.1 : 0.0, context),
                          ),
                        ],
                      );
                    }
                    break;
                }
                return somethingWrongWidget(context, 'somethingWrongHappened', 'somethingWrongHappenedDesc');
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
    return FutureBuilder(
        future: amountToBePaidFuture,
        builder: (context, snapshot){
          switch(snapshot.connectionState){
            case ConnectionState.none:
              return const SizedBox.shrink(); break;
            case ConnectionState.waiting:
            case ConnectionState.active:
              return const SizedBox.shrink(); break;
            case ConnectionState.done:
              if(!snapshot.hasError && snapshot.hasData){
                PayOffFinancialInformation financialInformation = snapshot.data;
                if (kDebugMode) {
                  print('financialInformation: ${financialInformation.mainPayCur[0][0].amt}');
                }
                if(double.parse((financialInformation.mainPayCur[0][0].amt ?? '0').toString()).toStringAsFixed(2) == '0.00'){
                  Provider.of<HomeProvider>(context).showFloatingButton = false;
                }
                return
                  double.parse((financialInformation.mainPayCur[0][0].amt ?? '0').toString()).toStringAsFixed(2) != '0.00'
                  ? Padding(
                    padding: EdgeInsets.only(
                      right: UserConfig.instance.isLanguageEnglish() ? 0 : width(0.075, context),
                      left: UserConfig.instance.isLanguageEnglish() ? width(0.075, context) : 0,
                      bottom: 8.0
                    ),
                    child: Slidable(
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
                          label: getTranslated('hide', context),
                        ),
                      ],
                    ),
                    child: Container(
                      width: width(0.93, context),
                      height: height(isScreenHasSmallHeight(context) ? 0.075 : 0.065, context),
                      decoration: BoxDecoration(
                          color: getPrimaryColor(context, themeNotifier),
                          borderRadius: BorderRadius.circular(12)
                      ),
                      child: Padding(
                        padding:  EdgeInsets.symmetric(
                            horizontal: width(isScreenHasSmallWidth(context) ? 0.03 : 0.035, context),
                            vertical: height(0.012, context)
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                Text(
                                  getTranslated('totalAmountToPay', context),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: height(0.015, context),
                                  ),
                                ),
                                SizedBox(
                                  width: width(0.05, context),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      double.parse((financialInformation.mainPayCur[0][0].amt ?? '0').toString()).toStringAsFixed(3),
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: height(0.015, context),
                                      ),
                                    ),
                                    Text(
                                      getTranslated('jd', context),
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: height(0.015, context),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                            InkWell(
                              onTap: (){
                                Navigator.of(context).push(
                                  MaterialPageRoute(builder: (context) => PayScreen(payments: financialInformation.subPayCur[0]))
                                );
                              },
                              child: Container(
                                alignment: Alignment.center,
                                width: width(0.2, context),
                                decoration: BoxDecoration(
                                  color: const Color.fromRGBO(219, 200, 156, 0.29),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  getTranslated('pay', context),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: height(0.015, context),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                ),
                  )
                  : const SizedBox.shrink();
              }
              break;
          }
          return const SizedBox.shrink();
        }
    );
  }

}