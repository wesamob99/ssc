// ignore_for_file: file_names

import 'package:drop_down_list/drop_down_list.dart';
import 'package:drop_down_list/model/selected_list_item.dart';
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
  SelectedListItem selectedCountry = SelectedListItem(
    name: UserConfig.instance.checkLanguage() ? "Jordan" : "الأردن",
    value: "962", natCode: 111,
    flag: countries[110].flag,
  );

  @override
  void initState() {
    loginProvider = Provider.of<LoginProvider>(context, listen: false);
    loginProvider.readCountriesJson();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ThemeNotifier themeNotifier = Provider.of<ThemeNotifier>(context);
    LoginProvider loginProvider = Provider.of<LoginProvider>(
        context, listen: false);

    return RegisterScreen(
      stepNumber: 1,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
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
                        fontSize: width(0.03, context)
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
                        fontSize: width(0.035, context)
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
                        fontSize: width(0.032, context)
                    ),
                  ),
                ],
              ),
              SizedBox(height: height(0.02, context),),
              Text(
                translate('nationality', context),
                style: TextStyle(
                    color: HexColor('#363636'),
                    fontSize: width(0.032, context)
                ),
              ),
              SizedBox(height: height(0.01, context),),
              RadioGroup<String>.builder(
                activeColor: HexColor('#2D452E'),
                direction: Axis.horizontal,
                horizontalAlignment: MainAxisAlignment.start,
                groupValue: selectedNationality,
                spacebetween: 30,
                onChanged: (value) =>
                    setState(() {
                      selectedNationality = value;
                    }),
                items: const ['jordanian', 'nonJordanian'],
                itemBuilder: (item) =>
                    RadioButtonBuilder(
                      translate(item, context),
                    ),
              ),
              SizedBox(height: height(0.02, context),),
              Text(
                translate('countryOfResidence', context),
                style: TextStyle(
                    color: HexColor('#363636'),
                    fontSize: width(0.032, context)
                ),
              ),
              SizedBox(height: height(0.015, context),),
              buildCountriesDropDown(),
              SizedBox(height: height(0.02, context),),
              Text(
                translate('mobileNumber', context),
                style: TextStyle(
                    color: HexColor('#363636'),
                    fontSize: width(0.032, context)
                ),
              ),
              SizedBox(height: height(0.015, context),),
              buildTextFormField(
                  context, themeNotifier, loginProvider.mobileNumberController,
                  '', (val) {
                loginProvider.registerContinueEnabled =
                    loginProvider.mobileNumberController.text.length >= 9;
                loginProvider.notifyMe();
              }, inputType: TextInputType.number),
              SizedBox(height: height(0.015, context),),
            ],
          ),
          SizedBox(height: height(0.2, context),),
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
                  ? HexColor('#ffffff') : HexColor('#363636'), () {
                if (loginProvider.registerContinueEnabled) {
                  loginProvider.registerContinueEnabled = false;
                  loginProvider.registerData.nationality =
                  (selectedNationality == 'jordanian' ? 1 : 2);
                  loginProvider.registerData.residentCountry =
                      selectedCountry.natCode;
                  loginProvider.registerData.mobileNo =
                      loginProvider.mobileNumberController.text;
                  loginProvider.notifyMe();
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) =>
                          OTPScreen(
                              type: 'phone',
                              contactTarget: loginProvider
                                  .mobileNumberController.text))
                  );
                }
              }
          ),
        ],
      ),
    );
  }

  Widget buildCountriesDropDown() {
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
          DropDownState(
            DropDown(
              isSearchVisible: true,
              data: selectedListItem ?? [],
              selectedItems: (List<dynamic> selectedList) {
                for (var item in selectedList) {
                  if (item is SelectedListItem) {
                    setState(() {
                      selectedCountry = item;
                    });
                  }
                }
              },
              enableMultipleSelection: false,
            ),
          ).showModal(context);
        },
        child: Container(
            width: width(1, context),
            alignment: UserConfig.instance.checkLanguage()
                ? Alignment.centerLeft
                : Alignment.centerRight,
            padding: const EdgeInsets.symmetric(
                horizontal: 16.0, vertical: 8.0),
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
                      style: TextStyle(
                          color: HexColor('#363636'),
                          fontSize: 25
                      ),
                    ),
                    SizedBox(width: width(0.01, context),),
                    Text(
                      '${selectedCountry.value} | ${selectedCountry.name}',
                      style: TextStyle(
                          color: HexColor('#363636'),
                          fontSize: 15
                      ),
                    ),
                  ],
                ),
                const Icon(
                    Icons.arrow_drop_down_outlined
                )
              ],
            )
        ),
    );
    }
}
