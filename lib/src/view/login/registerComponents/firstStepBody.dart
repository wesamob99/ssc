// ignore_for_file: file_names, use_build_context_synchronously

import 'package:drop_down_list/drop_down_list.dart';
import 'package:drop_down_list/model/selected_list_item.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:group_radio_button/group_radio_button.dart';
import 'package:provider/provider.dart';
import 'package:ssc/src/view/login/registerScreen.dart';

import '../../../../infrastructure/userConfig.dart';
import '../../../../utilities/countries.dart';
import '../../../../utilities/hexColor.dart';
import '../../../../utilities/theme/themes.dart';
import '../../../../utilities/util.dart';
import '../../../viewModel/login/loginProvider.dart';
import '../../../viewModel/utilities/theme/themeProvider.dart';
import 'OTPScreen.dart';

class FirstStepBody extends StatefulWidget {
  const FirstStepBody({Key key}) : super(key: key);

  @override
  State<FirstStepBody> createState() => _FirstStepBodyState();
}

class _FirstStepBodyState extends State<FirstStepBody> {

  LoginProvider loginProvider;
  String selectedNationality = 'jordanian';
  SelectedListItem selectedCountryOfResident;
  SelectedListItem selectedExactNationality;
  SelectedListItem selectedCountryForJoMobileNumber;
  SelectedListItem selectedCountryForForeignMobileNumber;

  @override
  void initState() {
    loginProvider = Provider.of<LoginProvider>(context, listen: false);
    loginProvider.readCountriesJson();
    loginProvider.isLoading = false;
    selectedCountryOfResident = selectedExactNationality = selectedCountryForJoMobileNumber = selectedCountryForForeignMobileNumber = SelectedListItem(
      name: UserConfig.instance.checkLanguage() ? "Jordan" : "الأردن",
      value: "962", natCode: 111,
      flag: countries[110].flag,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ThemeNotifier themeNotifier = Provider.of<ThemeNotifier>(context);
    LoginProvider loginProvider = Provider.of<LoginProvider>(
        context, listen: false);

    return Stack(
      children: [
        RegisterScreen(
          body: SizedBox(
            height: height(0.78, context),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: height(0.02, context),),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            translate('firstStep', context),
                            style: TextStyle(
                                color: HexColor('#979797'),
                                fontSize: isTablet(context) ? width(0.025, context) : width(0.03, context)
                            ),
                          ),
                          SizedBox(height: height(0.006, context),),
                          Text(
                            '${translate('nationality', context)}'
                                '${UserConfig.instance.checkLanguage() ? ',' : ''}'
                                ' ${translate('countryOfResidence', context)}'
                                ' ${translate('and', context)}'
                                '${translate('mobileNumber', context)}',
                            style: TextStyle(
                                color: HexColor('#5F5F5F'),
                                fontSize: isTablet(context) ? width(0.028, context) : width(0.035, context)
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: height(0.01, context),),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const SizedBox.shrink(),
                          Text(
                            '${translate('next', context)}: ${translate(
                                'personalInformations', context)}',
                            style: TextStyle(
                                color: HexColor('#979797'),
                                fontSize: isTablet(context) ? width(0.025, context) : width(0.032, context)
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: height(0.02, context),),
                      buildFieldTitle(context, 'nationality', required: false),
                      SizedBox(height: height(0.01, context),),
                      RadioGroup<String>.builder(
                        activeColor: HexColor('#2D452E'),
                        direction: Axis.horizontal,
                        horizontalAlignment: MainAxisAlignment.start,
                        groupValue: selectedNationality,
                        spacebetween: 30,
                        textStyle: isTablet(context)
                          ? TextStyle(
                            fontSize: width(0.025, context)
                          ) : const TextStyle(),
                        onChanged: (value) =>
                            setState(() {
                              selectedNationality = value;
                              loginProvider.registerContinueEnabled = (loginProvider.jordanianMobileNumberController.text.startsWith('0')
                              ? loginProvider.jordanianMobileNumberController.text.length == 10
                              : loginProvider.jordanianMobileNumberController.text.length == 9);
                              loginProvider.notifyMe();
                            }),
                        items: const ['jordanian', 'nonJordanian'],
                        itemBuilder: (item) =>
                            RadioButtonBuilder(
                              translate(item, context),
                            ),
                      ),
                      SizedBox(height: height(0.02, context),),
                      buildFieldTitle(context, 'countryOfResidence', required: false),
                      SizedBox(height: height(0.015, context),),
                      buildCountriesDropDown(1, selectedCountryOfResident, showSelectedName: true),
                      SizedBox(height: height(0.02, context),),
                      if(selectedNationality != 'jordanian')
                      buildFieldTitle(context, 'nationality', required: false),
                      if(selectedNationality != 'jordanian')
                      SizedBox(height: height(0.015, context),),
                      if(selectedNationality != 'jordanian')
                      buildCountriesDropDown(2, selectedExactNationality, showSelectedName: true),
                      if(selectedNationality != 'jordanian')
                      SizedBox(height: height(0.02, context),),
                      buildFieldTitle(context, 'jordanianMobileNumber', required: true, filled: (loginProvider.jordanianMobileNumberController.text.startsWith('0')
                          ? loginProvider.jordanianMobileNumberController.text.length == 10
                          : loginProvider.jordanianMobileNumberController.text.length == 9)),
                      SizedBox(height: height(0.015, context),),
                      Row(
                        children: [
                          Expanded(
                              child: buildTextFormField(
                                  context, themeNotifier, loginProvider.jordanianMobileNumberController,
                                  '', (val) {
                                loginProvider.registerContinueEnabled = (loginProvider.jordanianMobileNumberController.text.startsWith('0')
                                    ? loginProvider.jordanianMobileNumberController.text.length == 10
                                    : loginProvider.jordanianMobileNumberController.text.length == 9);
                                loginProvider.notifyMe();
                              }, inputType: TextInputType.number, ),
                          ),
                          SizedBox(width: width(0.015, context)),
                          buildCountriesDropDown(3, selectedCountryForJoMobileNumber),
                        ],
                      ),
                      SizedBox(height: height(0.02, context),),
                      if(selectedNationality != 'jordanian')
                      buildFieldTitle(context, 'foreignMobileNumber', required: false),
                      if(selectedNationality != 'jordanian')
                      SizedBox(height: height(0.015, context),),
                      if(selectedNationality != 'jordanian')
                      Row(
                        children: [
                          Expanded(
                            child: buildTextFormField(
                                context, themeNotifier, loginProvider.foreignMobileNumberController,
                                '', (val) {
                              loginProvider.registerContinueEnabled = (loginProvider.jordanianMobileNumberController.text.startsWith('0')
                                  ? loginProvider.jordanianMobileNumberController.text.length == 10
                                  : loginProvider.jordanianMobileNumberController.text.length == 9);
                              loginProvider.notifyMe();
                            }, inputType: TextInputType.number),
                          ),
                          SizedBox(width: width(0.015, context)),
                          buildCountriesDropDown(4, selectedCountryForForeignMobileNumber),
                        ],
                      ),
                      SizedBox(height: height(0.015, context),),
                    ],
                  ),
                ),
                textButton(context, themeNotifier, 'continue',
                    MaterialStateProperty.all<Color>(
                        !Provider
                            .of<LoginProvider>(context)
                            .registerContinueEnabled
                            ? HexColor('#DADADA')
                            : getPrimaryColor(context, themeNotifier)),
                    Provider
                        .of<LoginProvider>(context)
                        .registerContinueEnabled
                        ? HexColor('#ffffff') : HexColor('#363636'), () async {
                      if (loginProvider.registerContinueEnabled) {
                        FocusScope.of(context).requestFocus(FocusNode());
                        loginProvider.isLoading = true;
                        loginProvider.notifyMe();
                        String errorMessage = "";
                        try{
                          await loginProvider.sendRegisterMobileOTP(int.parse(loginProvider.jordanianMobileNumberController.text), "00962").whenComplete((){})
                              .then((val) async {
                            if(val["PO_STATUS_DESC_AR"] != null && val['PO_status'] != 1){
                              errorMessage = UserConfig.instance.checkLanguage()
                                  ? val["PO_STATUS_DESC_EN"] : val["PO_STATUS_DESC_AR"];
                              showMyDialog(context, 'registerFailed', errorMessage, 'retryAgain', themeNotifier);
                            } else if(val['PO_status'] == 1){
                              setFirstStepData();
                              errorMessage = '';
                              loginProvider.registerContinueEnabled = false;
                              Navigator.of(context).push(
                                MaterialPageRoute(builder: (context) =>
                                  OTPScreen(
                                    type: 'phone',
                                    contactTarget: loginProvider.jordanianMobileNumberController.text,
                                  ),
                                ),
                              );
                            }
                            loginProvider.notifyMe();
                          });
                          loginProvider.isLoading = false;
                          loginProvider.notifyMe();
                        }catch(e){
                          loginProvider.isLoading = false;
                          loginProvider.notifyMe();
                          if (kDebugMode) {
                            print(e.toString());
                          }
                        }
                      }
                    }
                ),
              ],
            ),
          ),
        ),
        if(loginProvider.isLoading)
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: width(1, context),
          height: height(1, context),
          color: Colors.white70,
          child: Center(
            child: animatedLoader(context),
          ),
        ),
      ],
    );
  }


  setFirstStepData(){
    loginProvider.registerData.nationality = (selectedNationality == 'jordanian' ? 1 : 2);
    loginProvider.registerData.residentCountry = selectedCountryOfResident.natCode;
    loginProvider.registerData.mobileNo = loginProvider.jordanianMobileNumberController.text;
    loginProvider.registerData.nationalMobile = loginProvider.foreignMobileNumberController.text;
    loginProvider.registerData.nationalMobileCode = int.parse(selectedExactNationality.value.toString());
    loginProvider.registerData.nationalNumber = selectedNationality == 'jordanian' ? null : int.parse(selectedExactNationality.natCode.toString());
    loginProvider.notifyMe();
  }

  Widget buildCountriesDropDown(int index, SelectedListItem selectedCountry ,{showSelectedName = false}) {
    List<SelectedListItem> selectedListItem = [];
    for (var element in loginProvider.countries) {
      int inx = countries.indexWhere((value) =>
      value.dialCode == element.callingCode);
      selectedListItem.add(
        SelectedListItem(
          name: UserConfig.instance.checkLanguage() ? countries[inx == -1
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
          if(index != 3) {
            DropDownState(
            DropDown(
              isSearchVisible: true,
              data: selectedListItem ?? [],
              selectedItems: (List<dynamic> selectedList) {
                for (var item in selectedList) {
                  if (item is SelectedListItem) {
                    setState(() {
                      if(index == 1) {
                        selectedCountryOfResident = item;
                      }else if(index == 2){
                        selectedExactNationality = item;
                      }else if(index == 3){
                        selectedCountryForJoMobileNumber = item;
                      }else if(index == 4){
                        selectedCountryForForeignMobileNumber = item;
                      }
                    });
                  }
                }
              },
              enableMultipleSelection: false,
            ),
          ).showModal(context);
          }
        },
        child: Opacity(
          opacity: index != 3 ? 1 : 0.3,
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
                  Row(
                    children: [
                      Text(
                        selectedCountry.flag,
                        style: const TextStyle(
                          fontSize: 25,
                        ),
                      ),
                      SizedBox(width: width(0.01, context),),
                      Text(
                        showSelectedName
                            ? '${selectedCountry.value} | ${selectedCountry.name}'
                            : selectedCountry.value,
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
        ),
    );
    }
}
