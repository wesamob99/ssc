import 'package:drop_down_list/drop_down_list.dart';
import 'package:drop_down_list/model/selected_list_item.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:ssc/models/services/pensionPaymentModel.dart';
import 'package:ssc/src/viewModel/services/servicesProvider.dart';

import '../../../../../infrastructure/userConfig.dart';
import '../../../../../utilities/hexColor.dart';
import '../../../../../utilities/util.dart';

class HistoricalPensionDetailsScreen extends StatefulWidget {
  const HistoricalPensionDetailsScreen({Key key}) : super(key: key);

  @override
  State<HistoricalPensionDetailsScreen> createState() => _HistoricalPensionDetailsScreenState();
}

class _HistoricalPensionDetailsScreenState extends State<HistoricalPensionDetailsScreen> {

  ServicesProvider servicesProvider;
  List<SelectedListItem> listOfYears = [];
  SelectedListItem selectedYear;

  @override
  void initState() {
    servicesProvider = Provider.of<ServicesProvider>(context, listen: false);
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
        title: Text(translate('historicalPensionDetails', context)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          // child: Text(servicesProvider.result['cur_getdata'][0][0]['ACCNO']),
          children: [
            buildFieldTitle(context, 'ChooseTheYear', required: false),
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
                          return Stack(
                            children: [
                              SizedBox(
                                height: height(0.5, context),
                                child: ListView.builder(
                                  itemCount: pensionPayment.curGetdata1[0].length,
                                  itemBuilder: (context, index){
                                    return Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(pensionPayment.curGetdata1[0][index].netpay1),
                                        const SizedBox(height: 10.0,),
                                      ],
                                    );
                                  },
                                ),
                              ),
                              if(Provider.of<ServicesProvider>(context).isLoading)
                                Expanded(
                                  child: Center(
                                    child: animatedLoader(context),
                                  ),
                                ),
                            ],
                          );
                        }else {
                          return Text(translate('emptyList', context));
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
