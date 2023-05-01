// ignore_for_file: file_names

import 'dart:convert';

import 'package:drop_down_list/drop_down_list.dart';
import 'package:drop_down_list/model/selected_list_item.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../infrastructure/userConfig.dart';
import '../../../../models/login/countries.dart';
import '../../../../utilities/hexColor.dart';
import '../../../../utilities/theme/themes.dart';
import '../../../../utilities/util.dart';
import '../../../../utilities/countries.dart';
import '../../../viewModel/accountSettings/accountSettingsProvider.dart';
import '../../../viewModel/login/loginProvider.dart';
import '../../../viewModel/utilities/theme/themeProvider.dart';
import '../../splash/splashScreen.dart';

class UpdateCountryOfResidence extends StatefulWidget {
  final int natCode;
  const UpdateCountryOfResidence({Key key, this.natCode}) : super(key: key);

  @override
  State<UpdateCountryOfResidence> createState() => _UpdateCountryOfResidenceState();
}

class _UpdateCountryOfResidenceState extends State<UpdateCountryOfResidence> {

  SelectedListItem selectedCountryOfResident;
  AccountSettingsProvider accountSettingsProvider;

  @override
  void initState() {
    accountSettingsProvider = Provider.of<AccountSettingsProvider>(context, listen: false);
    accountSettingsProvider.isLoading = false;
    Provider.of<LoginProvider>(context, listen: false).readCountriesJson().then((List<Countries> value){
      Countries c = value.where((element) => element.natcode == widget.natCode).first;
      Country country = countries.where((element) => element.dialCode == c.callingCode).first;
      if (kDebugMode) {
        print(jsonEncode(c));
        print((country.name));
      }
      setState((){
        selectedCountryOfResident = SelectedListItem(
          name: UserConfig.instance.isLanguageEnglish() ? c.countryEn : c.country,
          natCode: c.natcode,
          value: c.callingCode,
          flag: country.flag,
        );
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ThemeNotifier themeNotifier = Provider.of<ThemeNotifier>(context);

    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(getTranslated('countryOfResidence', context), style: const TextStyle(fontSize: 14)),
        leading: leadingBackIcon(context),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0).copyWith(top: 25),
            child: SingleChildScrollView(
              child: SizedBox(
                height: height(1, context),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    buildCountriesDropDown(selectedCountryOfResident),
                    Padding(
                      padding: EdgeInsets.only(bottom: height(0.25, context)),
                      child: textButton(context, themeNotifier, 'update', getPrimaryColor(context, themeNotifier),
                        HexColor('#ffffff'), () async {
                        /// TODO :
                          accountSettingsProvider.isLoading = true;
                          accountSettingsProvider.notifyMe();
                          String message = '';
                          try{
                          accountSettingsProvider.updateUserInfo(1, selectedCountryOfResident.natCode).whenComplete((){}).then((value){
                              if(value["PO_STATUS"] == 0){
                                showMyDialog(context, 'yourResidentialAddressHasBeenChangedSuccessfully', message, 'ok', themeNotifier, titleColor: '#2D452E', icon: 'assets/icons/profileIcons/locationUpdated.svg').then((value) {
                                  Navigator.of(context).pushAndRemoveUntil(
                                      MaterialPageRoute(builder: (context) => const SplashScreen()),
                                          (route) => false
                                  );
                                });
                              }else{
                                message = UserConfig.instance.isLanguageEnglish()
                                    ? value["PO_STATUS_DESC_EN"] : value["PO_STATUS_DESC_AR"];
                                showMyDialog(context, 'failedToChangeYourResidentialAddress', message, 'retryAgain', themeNotifier);
                              }
                              accountSettingsProvider.isLoading = false;
                              accountSettingsProvider.notifyMe();
                            });
                          }catch(e){
                            accountSettingsProvider.isLoading = false;
                            accountSettingsProvider.notifyMe();
                            if (kDebugMode) {
                              print(e.toString());
                            }
                          }
                        }
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if(Provider.of<AccountSettingsProvider>(context).isLoading)
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: width(1, context),
            height: height(1, context),
            color: themeNotifier.isLight() ? Colors.white70 : Colors.black45,
            child: Center(
              child: animatedLoader(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildCountriesDropDown(SelectedListItem selectedCountry) {
    List<SelectedListItem> selectedListItem = [];
    for (var element in Provider.of<LoginProvider>(context, listen: false).countries) {
      int inx = countries.indexWhere((value) => value.dialCode == element.callingCode);
      selectedListItem.add(
        SelectedListItem(
          name: UserConfig.instance.isLanguageEnglish() ? countries[inx == -1
              ? 0
              : inx].name : element.country,
          natCode: element.natcode,
          value: countries[inx == -1 ? 0 : inx].dialCode,
          isSelected: false,
          flag: countries[inx == -1 ? 0 : inx].flag,
        ),
      );
    }
    return InkWell(
      onTap: () {
        DropDownState(
          DropDown(
            isSearchVisible: true,
            data: selectedListItem ?? [],
            selectedItems: (List<dynamic> selectedList) {
              for (var item in selectedList) {
                if (item is SelectedListItem) {
                  setState(() {
                    selectedCountryOfResident = item;
                  });
                }
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
              Row(
                children: [
                  Text(
                    selectedCountry?.flag ?? "",
                    style: const TextStyle(
                      fontSize: 25,
                    ),
                  ),
                  SizedBox(width: width(0.01, context),),
                  Text(
                    '${selectedCountry?.value ?? ""} | ${selectedCountry?.name ?? ""}',
                    style: TextStyle(
                        color: HexColor('#363636'),
                        fontSize: 15
                    ),
                  ),
                ],
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
