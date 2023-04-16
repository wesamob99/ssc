// ignore_for_file: file_names

import 'package:drop_down_list/drop_down_list.dart';
import 'package:drop_down_list/model/selected_list_item.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:ssc/models/services/pensionPaymentModel.dart';
import 'package:ssc/source/viewModel/services/servicesProvider.dart';
import 'package:ssc/source/viewModel/utilities/theme/themeProvider.dart';

import '../../../../../infrastructure/userConfig.dart';
import '../../../../../utilities/hexColor.dart';
import '../../../../../utilities/theme/themes.dart';
import '../../../../../utilities/util.dart';
import 'dart:ui' as ui;
import 'dart:math' as math;

class HistoricalPensionDetailsScreen extends StatefulWidget {
  const HistoricalPensionDetailsScreen({Key key}) : super(key: key);

  @override
  State<HistoricalPensionDetailsScreen> createState() => _HistoricalPensionDetailsScreenState();
}

class _HistoricalPensionDetailsScreenState extends State<HistoricalPensionDetailsScreen> {

  ServicesProvider servicesProvider;
  ThemeNotifier themeNotifier;
  List<SelectedListItem> listOfYears = [];
  SelectedListItem selectedYear;

  @override
  void initState() {
    servicesProvider = Provider.of<ServicesProvider>(context, listen: false);
    themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);
    listOfYears = [];
    selectedYear = SelectedListItem(name: DateFormat("dd/MM/yyyy").parse(servicesProvider.result['cur_getdata'][0][0]['STARDT']).year.toString(), natCode: null, flag: '');
    for(int i=DateFormat("dd/MM/yyyy").parse(servicesProvider.result['cur_getdata'][0][0]['STARDT']).year ; i<=DateTime.now().year ; i++){
      listOfYears.add(SelectedListItem(name: '$i', natCode: null, flag: ''));
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(getTranslated('historicalPensionDetails', context)),
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: InkWell(
            onTap: (){
              Navigator.of(context).pop();
            },
            child: Transform.rotate(
              angle: UserConfig.instance.isLanguageEnglish()
                  ? -math.pi / 1.0 : 0,
              child: SvgPicture.asset(
                  'assets/icons/backWhite.svg'
              ),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          // child: Text(servicesProvider.result['cur_getdata'][0][0]['ACCNO']),
          children: [
            buildFieldTitle(context, 'chooseTheYear', required: false),
            const SizedBox(height: 10.0,),
            buildDropDown(context, listOfYears, 1, servicesProvider),
            const SizedBox(height: 15.0,),
            FutureBuilder(
                future: Provider.of<ServicesProvider>(context).getPensionPaymentSP(selectedYear.name),
                builder: (context, snapshot){
                  switch(snapshot.connectionState){
                    case ConnectionState.none:
                      return somethingWrongWidget(context, 'somethingWrongHappened', 'somethingWrongHappenedDesc'); break;
                    case ConnectionState.waiting:
                    case ConnectionState.active:
                      return Expanded(
                        child: Center(
                          child: animatedLoader(context),
                        ),
                      ); break;
                    case ConnectionState.done:
                      if(snapshot.hasData && !snapshot.hasError){
                        PensionPaymentModel pensionPayment = snapshot.data;
                        if(pensionPayment.curGetdata1.isNotEmpty){
                          return Expanded(
                            child: Stack(
                              children: [
                                ListView.builder(
                                  itemCount: pensionPayment.curGetdata1[0].length,
                                  itemBuilder: (context, index){
                                    return Padding(
                                      padding: const EdgeInsets.only(bottom: 5.0),
                                      child: InkWell(
                                        onTap: () async {
                                          servicesProvider.isLoading = true;
                                          servicesProvider.notifyMe();
                                          try{
                                            List<String> monthAndYear = pensionPayment.curGetdata1[0][index].mth.split("/");
                                            await servicesProvider.getPensionSalaryDetails(
                                              monthAndYear[0],
                                              monthAndYear[1],
                                              pensionPayment.curGetdata1[0][index].penType,
                                            ).whenComplete((){}).then((value) {
                                              showSalaryDetailsModalBottomSheet(value);
                                            });
                                            servicesProvider.isLoading = false;
                                            servicesProvider.notifyMe();
                                          }catch(e){
                                            servicesProvider.isLoading = true;
                                            servicesProvider.notifyMe();
                                            if (kDebugMode) {
                                              print(e.toString());
                                            }
                                          }
                                        },
                                        child: Card(
                                            elevation: 6.0,
                                            shadowColor: Colors.black45,
                                            color: getContainerColor(context),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(15.0),
                                            ),
                                            child: Container(
                                              width: width(1, context),
                                              padding: const EdgeInsets.all(20.0),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    pensionPayment.curGetdata1[0][index].cod.toString(),
                                                    style: TextStyle(
                                                      height: 1.4,
                                                      color: themeNotifier.isLight() ? HexColor('#363636') : Colors.white,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 15.0,),
                                                  Text(
                                                    pensionPayment.curGetdata1[0][index].mth.toString(),
                                                    style: TextStyle(
                                                      color: themeNotifier.isLight() ? HexColor('#716F6F') : Colors.white70,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 15.0,),
                                                  Divider(
                                                    color: HexColor('#A6A6A6'),
                                                    thickness: 1,
                                                  ),
                                                  const SizedBox(height: 10.0,),
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: [
                                                      Text(
                                                        getTranslated('theAmount', context),
                                                        style: TextStyle(
                                                          color: themeNotifier.isLight() ? HexColor('#716F6F') : Colors.white,
                                                        ),
                                                      ),
                                                      Row(
                                                        children: [
                                                          Text(
                                                            pensionPayment.curGetdata1[0][index].netpay1.toString(),
                                                            style: TextStyle(
                                                              color: themeNotifier.isLight() ? HexColor('#716F6F') : Colors.white,
                                                              fontWeight: FontWeight.bold,
                                                              fontSize: 19,
                                                            ),
                                                          ),
                                                          Text(
                                                            ' ${getTranslated('jd', context)}',
                                                            style: TextStyle(
                                                              color: themeNotifier.isLight() ? HexColor('#716F6F') : Colors.white,
                                                              fontWeight: FontWeight.w400,
                                                              fontSize: 13,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            )
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                if(Provider.of<ServicesProvider>(context).isLoading)
                                  Expanded(
                                    child: Center(
                                      child: animatedLoader(context),
                                    ),
                                  ),
                              ],
                            ),
                          );
                        }else {
                          return Text(getTranslated('thereAreNoData', context));
                        }
                      }
                      break;
                  }
                  return somethingWrongWidget(context, 'somethingWrongHappened', 'somethingWrongHappenedDesc');
                }
            ),
          ],
        ),
      ),
    );
  }

  Widget buildDropDown(context, List listOfItems, flag, provider) {
    return InkWell(
      onTap: () {
        DropDownState(
          DropDown(
            isSearchVisible: true,
            data: listOfItems ?? [],
            selectedItems: (List selectedList) {
              for (var item in selectedList) {
                setState((){
                  selectedYear = item;
                });
              }
            },
            enableMultipleSelection: false,
          ),
        ).showModal(context);
      },
      child: Container(
          alignment: UserConfig.instance.isLanguageEnglish()
              ? Alignment.centerLeft
              : Alignment.centerRight,
          padding: const EdgeInsets.symmetric(
              horizontal: 16.0, vertical: 9.3),
          decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(8.0),
              border: Border.all(
                  color: HexColor('#979797')
              )
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                selectedYear.name,
                style: TextStyle(
                    color: HexColor('#363636'),
                    fontSize: 15
                ),
              ),
              Icon(
                Icons.arrow_drop_down_outlined,
                color: HexColor('#363636'),
              )
            ],
          )
      ),
    );
  }

  showSalaryDetailsModalBottomSheet(value){
    return showModalBottomSheet(
        isScrollControlled: true,
        isDismissible: true,
        enableDrag: true,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(25.0))
        ),
        context: context,
        barrierColor: Colors.black26,
        builder: (context) {
          return GestureDetector(
            onTap: (){
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: BackdropFilter(
              filter: ui.ImageFilter.blur(
                sigmaX: 2.0,
                sigmaY: 2.0,
              ),
              child: Material(
                elevation: 100,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(25.0),
                  topRight: Radius.circular(25.0),
                ),
                color: Colors.white,
                shadowColor: Colors.black,
                child: IntrinsicHeight(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0).copyWith(top: 15.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(),
                            Container(
                              width: 45,
                              height: 6,
                              decoration: BoxDecoration(
                                  color: HexColor('#000000'),
                                  borderRadius: const BorderRadius.all(Radius.circular(25.0))),
                            ),
                            InkWell(
                              onTap: (){
                                Navigator.of(context).pop();
                              },
                              child: SvgPicture.asset('assets/icons/close.svg'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10.0,),
                        if(value['CUR_GETSALDATA'].isNotEmpty)
                        Card(
                          elevation: 4.0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0)
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  getTranslated('salariesAndBonuses', context),
                                  style: const TextStyle(
                                    fontSize: 16
                                  ),
                                ),
                                const SizedBox(height: 20.0,),
                                SizedBox(
                                  height: (value['CUR_GETSALDATA'][0].length * 35.0) + 60.0,
                                  child: ListView.builder(
                                    itemCount: value['CUR_GETSALDATA'][0].length,
                                    shrinkWrap: true,
                                    physics: const NeverScrollableScrollPhysics(),
                                    itemBuilder: (context, index){
                                      double total = 0;
                                      value['CUR_GETSALDATA'][0].forEach((element){
                                        total += double.tryParse(element['AMOUNT'].toString());
                                      });
                                      return Padding(
                                        padding: const EdgeInsets.only(bottom: 15.0),
                                        child: Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(
                                                  UserConfig.instance.isLanguageEnglish()
                                                      ? value['CUR_GETSALDATA'][0][index]['LABEL_ENG']
                                                      : value['CUR_GETSALDATA'][0][index]['LABEL_AR'],
                                                ),
                                                Text(
                                                  '${value['CUR_GETSALDATA'][0][index]['AMOUNT']} ${getTranslated('jd', context)}',
                                                ),
                                              ],
                                            ),
                                            if(index == (value['CUR_GETSALDATA'][0].length - 1))
                                            Container(
                                              padding: const EdgeInsets.all(15.0),
                                              margin: const EdgeInsets.symmetric(vertical: 20.0),
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(14.0),
                                                  border: Border.all(
                                                    color: primaryColor,
                                                  )
                                              ),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text(
                                                    getTranslated('total', context),
                                                  ),
                                                  Text(
                                                    '$total ${getTranslated('jd', context)}',
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        if(value['CUR_GETDEDUCT'].isNotEmpty)
                        Card(
                          elevation: 4.0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0)
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  getTranslated('deductions', context),
                                  style: const TextStyle(
                                      color: Colors.black87,
                                      fontSize: 16
                                  ),
                                ),
                                const SizedBox(height: 20.0,),
                                SizedBox(
                                  height: (value['CUR_GETDEDUCT'][0].length * 35.0) + 60.0,
                                  child: ListView.builder(
                                    itemCount: value['CUR_GETDEDUCT'][0].length,
                                    shrinkWrap: true,
                                    physics: const NeverScrollableScrollPhysics(),
                                    itemBuilder: (context, index){
                                      double total = 0;
                                      value['CUR_GETDEDUCT'][0].forEach((element){
                                        total += double.tryParse(element['AMOUNT'].toString());
                                      });
                                      return Padding(
                                        padding: const EdgeInsets.only(bottom: 15.0),
                                        child: Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(
                                                  UserConfig.instance.isLanguageEnglish()
                                                      ? value['CUR_GETDEDUCT'][0][index]['LABEL_ENG']
                                                      : value['CUR_GETDEDUCT'][0][index]['LABEL_AR'],
                                                ),
                                                Text(
                                                  '${value['CUR_GETDEDUCT'][0][index]['AMOUNT']} ${getTranslated('jd', context)}',
                                                ),
                                              ],
                                            ),
                                            if(index == (value['CUR_GETDEDUCT'][0].length - 1))
                                              Container(
                                                padding: const EdgeInsets.all(15.0),
                                                margin: const EdgeInsets.symmetric(vertical: 20.0),
                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(14.0),
                                                    border: Border.all(
                                                      color: primaryColor,
                                                    )
                                                ),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Text(
                                                      getTranslated('total', context),
                                                    ),
                                                    Text(
                                                      '$total ${getTranslated('jd', context)}',
                                                    ),
                                                  ],
                                                ),
                                              ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 20.0,),
                        Container(
                          padding: const EdgeInsets.all(15.0),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(14.0),
                              border: Border.all(
                                color: primaryColor,
                              )
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                UserConfig.instance.isLanguageEnglish()
                                    ? value['CUR_NETSALARY'][0][0]['LABEL_ENG']
                                    : value['CUR_NETSALARY'][0][0]['LABEL_AR'],
                              ),
                              Text(
                                '${value['CUR_NETSALARY'][0][0]['NET_SALARY']}',
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20.0,),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        }
    );
  }

}
