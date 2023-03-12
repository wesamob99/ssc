// ignore_for_file: file_names

import 'package:drop_down_list/drop_down_list.dart';
import 'package:drop_down_list/model/selected_list_item.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:ssc/models/services/pensionPaymentModel.dart';
import 'package:ssc/source/viewModel/services/servicesProvider.dart';
import 'package:ssc/source/viewModel/utilities/theme/themeProvider.dart';

import '../../../../../infrastructure/userConfig.dart';
import '../../../../../utilities/hexColor.dart';
import '../../../../../utilities/theme/themes.dart';
import '../../../../../utilities/util.dart';

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
    for(int i=DateFormat("dd/MM/yyyy").parse(servicesProvider.result['cur_getdata'][0][0]['STARDT']).year ; i<=2022 ; i++){
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
                                    return Card(
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
                                    );
                                    // return Column(
                                    //   crossAxisAlignment: CrossAxisAlignment.start,
                                    //   children: [
                                    //     Text(pensionPayment.curGetdata1[0][index].netpay1),
                                    //     const SizedBox(height: 10.0,),
                                    //   ],
                                    // );
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
          alignment: UserConfig.instance.checkLanguage()
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

}
