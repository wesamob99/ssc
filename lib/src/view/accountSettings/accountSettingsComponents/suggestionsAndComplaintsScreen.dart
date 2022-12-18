// ignore_for_file: file_names

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
    accountSettingsProvider.complaintsDescController.text = "";
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
          child: SizedBox(
            width: width(1, context),
            height: height(1, context),
            child: SingleChildScrollView(
              child: Column(
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
                    child: buildTextFormField(context, themeNotifier, accountSettingsProvider.complaintsDescController, '', (val){}, minLines: 6),
                  ),
                  const SizedBox(height: 10.0,),
                  buildFieldTitle(context, 'attachPhoto', required: false),
                  Padding(
                      padding: const EdgeInsets.only(bottom: 15.0, top: 10.0),
                      child: DottedBorder(
                        radius: const Radius.circular(8.0),
                        padding: EdgeInsets.zero,
                        color: HexColor('#979797'),
                        borderType: BorderType.RRect,
                        dashPattern: const [8],
                        strokeWidth: 1.2,
                        child: Container(
                          width: width(1, context),
                          height: height(0.16, context),
                          decoration: BoxDecoration(
                              color: const Color.fromRGBO(166, 166, 166, 0.17),
                              borderRadius: BorderRadius.circular(8.0)
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SvgPicture.asset('assets/icons/profileIcons/imageGallery.svg'),
                              const SizedBox(height: 5.0),
                              Text(translate('attachPhoto', context))
                            ],
                          ),
                        ),
                      )
                  ),
                  const SizedBox(height: 10.0,),
                  buildFieldTitle(context, 'firstName', required: false),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 15.0, top: 10.0),
                    child: buildTextFormField(context, themeNotifier, TextEditingController(), '', (val){}),
                  ),
                  const SizedBox(height: 10.0,),
                  buildFieldTitle(context, 'familyName', required: false),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 15.0, top: 10.0),
                    child: buildTextFormField(context, themeNotifier, TextEditingController(), '', (val){}),
                  ),
                  buildFieldTitle(context, 'mobileNumber', required: false),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 15.0, top: 10.0),
                    child: buildTextFormField(context, themeNotifier, TextEditingController(), '', (val){}),
                  ),
                  const SizedBox(height: 10.0,),
                  buildFieldTitle(context, 'email', required: false),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 15.0, top: 10.0),
                    child: buildTextFormField(context, themeNotifier, TextEditingController(), '', (val){}),
                  ),
                  const SizedBox(height: 10.0,),
                  buildFieldTitle(context, 'theRightTimeToCall', required: false),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 15.0, top: 10.0),
                    child: buildTextFormField(context, themeNotifier, TextEditingController(), '', (val){}),
                  ),
                  const SizedBox(height: 25.0,),
                  textButton(context, themeNotifier, 'update', !Provider.of<AccountSettingsProvider>(context).updatePasswordEnabled
                      ? HexColor('#DADADA')
                      : getPrimaryColor(context, themeNotifier),
                      Provider.of<AccountSettingsProvider>(context).updatePasswordEnabled
                          ? HexColor('#ffffff') : HexColor('#363636'), () async {}
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
