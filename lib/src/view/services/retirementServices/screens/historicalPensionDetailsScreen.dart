import 'package:drop_down_list/drop_down_list.dart';
import 'package:drop_down_list/model/selected_list_item.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
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
  SelectedListItem selectedYear = SelectedListItem(name: '0', natCode: null, flag: '');

  @override
  void initState() {
    servicesProvider = Provider.of<ServicesProvider>(context, listen: false);
    listOfYears = [];
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
            buildDropDown(context, listOfYears, 1, servicesProvider),
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
