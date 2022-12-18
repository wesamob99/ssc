// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ssc/src/viewModel/accountSettings/accountSettingsProvider.dart';

import '../../../../utilities/hexColor.dart';
import '../../../../utilities/theme/themes.dart';
import '../../../../utilities/util.dart';
import '../../../viewModel/utilities/theme/themeProvider.dart';

class SuggestionsAndComplaintsScreen extends StatefulWidget {
  const SuggestionsAndComplaintsScreen({Key key}) : super(key: key);

  @override
  State<SuggestionsAndComplaintsScreen> createState() => _SuggestionsAndComplaintsScreenState();
}

class _SuggestionsAndComplaintsScreenState extends State<SuggestionsAndComplaintsScreen> {

  AccountSettingsProvider accountSettingsProvider;
  ThemeNotifier themeNotifier;
  List<String> relatedToList = ['choose', 'eServices', 'financeServices', 'callCenterServices', 'branchServices'];

  @override
  void initState() {
    accountSettingsProvider = Provider.of<AccountSettingsProvider>(context, listen: false);
    themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(translate('suggestionsAndComplaints', context), style: const TextStyle(fontSize: 14),),
        leading: leadingBackIcon(context),
      ),
      body: GestureDetector(
        onTap: (){
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0).copyWith(top: 25),
          child: SingleChildScrollView(
            child: SizedBox(
              width: width(1, context),
              height: height(1, context),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    translate('suggestionOrComplaintInformation', context),
                  ),
                  const SizedBox(height: 20.0,),
                  buildFieldTitle(context, 'relatedTo', required: false),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 15.0, top: 10.0),
                    child: dropDownList(relatedToList, themeNotifier, accountSettingsProvider),
                  ),
                  buildFieldTitle(context, 'descriptionOfTheComplaintOrSuggestion', required: false),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 15.0, top: 10.0),
                    child: Container(), ///
                  ),
                  const SizedBox(height: 10.0,),
                  buildFieldTitle(context, 'attachPhoto', required: false),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 15.0, top: 10.0),
                    child: Container(), ///
                  ),
                  const SizedBox(height: 10.0,),
                  buildFieldTitle(context, 'firstName', required: false),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 15.0, top: 10.0),
                    child: Container(), ///
                  ),
                  const SizedBox(height: 10.0,),
                  buildFieldTitle(context, 'familyName', required: false),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 15.0, top: 10.0),
                    child: Container(), ///
                  ),
                  const SizedBox(height: 10.0,),
                  buildFieldTitle(context, 'theRightTimeToCall', required: false),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 15.0, top: 10.0),
                    child: Container(), ///
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  dropDownList(List<String> menuList, ThemeNotifier themeNotifier, AccountSettingsProvider accountSettingsProvider){
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: isTablet(context) ? 5 : 0.0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: HexColor('#979797'),
            )
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            DropdownButton<String>(
              value: accountSettingsProvider.complaintsRelatedTo,
              icon: const Icon(
                Icons.arrow_drop_down_outlined,
                size: 0,
              ),
              elevation: 16,
              style: const TextStyle(color: Colors.black),
              underline: Container(
                height: 0,
                color: primaryColor,
              ),
              onChanged: (String value){
                setState(() {
                  accountSettingsProvider.complaintsRelatedTo = value;
                  accountSettingsProvider.notifyMe();
                });
                // checkContinueEnable(loginProvider);
                accountSettingsProvider.notifyMe();
              },
              items: menuList.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: SizedBox(
                    width: width(0.7, context),
                    child: Text(
                      translate(value, context),
                      style: TextStyle(
                        color: value != 'choose'
                            ? (themeNotifier.isLight()
                            ? primaryColor
                            : Colors.white) : HexColor('#A6A6A6'),
                        fontSize: isTablet(context) ? 20 : 15,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const Icon(Icons.arrow_drop_down_outlined)
          ],
        )
    );
  }

}
