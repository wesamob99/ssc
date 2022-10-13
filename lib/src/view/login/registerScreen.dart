import 'package:drop_down_list/drop_down_list.dart';
import 'package:drop_down_list/model/selected_list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:group_radio_button/group_radio_button.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ssc/infrastructure/userConfig.dart';
import 'package:ssc/models/login/countries.dart';

import '../../../utilities/constants.dart';
import '../../../utilities/hexColor.dart';
import '../../../utilities/theme/themes.dart';
import '../../../utilities/util.dart';
import '../../viewModel/login/loginProvider.dart';
import '../../viewModel/utilities/language/globalAppProvider.dart';
import '../../viewModel/utilities/theme/themeProvider.dart';
import '../home/components/homeLoaderWidget.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {

  LoginProvider loginProvider;
  Future<SharedPreferences> prefs = SharedPreferences.getInstance();
  TextEditingController mobileNumberController = TextEditingController();
  String selectedLanguage;
  String selectedNationality = 'jordanian';
  SelectedListItem selectedCountry = SelectedListItem(
      name: UserConfig.instance.checkLanguage() ? "Jordan" : "الأردن",
      value: "962",
      isSelected: false
  );
  Future countriesFuture;

  getAppLanguage(){
    prefs.then((value) {
      setState((){
        selectedLanguage = value.getString('language_code') ?? 'en';
      });
    });
  }

  @override
  void initState() {
    loginProvider = Provider.of<LoginProvider>(context, listen: false);
    countriesFuture = loginProvider.getCountries();
    loginProvider.enabledSubmitButton = false;
    loginProvider.showResetPasswordBody = false;
    getAppLanguage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ThemeNotifier themeNotifier = Provider.of<ThemeNotifier>(context);
    GlobalAppProvider globalAppProvider = Provider.of<GlobalAppProvider>(context);
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(20.0),
        child: AppBar(
          backgroundColor: Colors.transparent,
          leading: const SizedBox.shrink(),
        ),
      ),
      body: Stack(
        children: [
          Container(
            alignment: Alignment.bottomLeft,
            child: SvgPicture.asset(
                'assets/logo/logo_tree.svg'
            ),
          ),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: FutureBuilder(
                  future: countriesFuture,
                  builder: (context, snapshot){
                    switch(snapshot.connectionState){
                      case ConnectionState.none:
                        return somethingWrongWidget(context, 'somethingWrongHappened', 'somethingWrongHappenedDesc'); break;
                      case ConnectionState.waiting:
                      case ConnectionState.active:
                        return const HomeLoaderWidget(); break;
                      case ConnectionState.done:
                        if(!snapshot.hasError && snapshot.hasData){
                          List<Countries> countries = snapshot.data;
                          List<SelectedListItem> selectedListItem = [];
                          for (var element in countries) {
                            selectedListItem.add(
                              SelectedListItem(
                                name: UserConfig.instance.checkLanguage() ? element.countryEn : element.country,
                                value: element.callingCode,
                                isSelected: false
                              )
                            );
                          }
                          return SizedBox(
                            height: height(0.75, context),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                // SizedBox(height: height(0.08, context),),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                            alignment: Alignment.topLeft,
                                            child: Row(
                                              children: [
                                                InkWell(
                                                  onTap: (){
                                                    Navigator.pop(context);
                                                    if(loginProvider.showResetPasswordBody){
                                                      loginProvider.showResetPasswordBody = false;
                                                      loginProvider.notifyMe();
                                                    }else{
                                                      setState(() {
                                                        loginProvider.nationalIdController.clear();
                                                        loginProvider.passwordController.clear();
                                                        loginProvider.enabledSubmitButton = false;
                                                        loginProvider.showBottomNavigationBar = true;
                                                        loginProvider.notifyMe();
                                                      });
                                                    }
                                                  },
                                                  child: SvgPicture.asset(
                                                      'assets/icons/back.svg'
                                                  ),
                                                ),
                                                SizedBox(width: width(0.03, context)),
                                                Text(
                                                  translate('createAnAccount', context),
                                                  style: const TextStyle(
                                                      fontWeight: FontWeight.w700
                                                  ),
                                                ),
                                              ],
                                            )
                                        ),
                                        Container(
                                            alignment: Alignment.topLeft,
                                            child: Row(
                                              children: [
                                                SvgPicture.asset(
                                                    'assets/icons/global.svg'
                                                ),
                                                const SizedBox(width: 4.0),
                                                DropdownButton<String>(
                                                  isDense: true,
                                                  value: selectedLanguage,
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
                                                  onChanged: (String value) async{
                                                    setState(() {
                                                      selectedLanguage = value;
                                                    });
                                                    globalAppProvider.changeLanguage(Locale(selectedLanguage));
                                                    globalAppProvider.notifyMe();
                                                    prefs.then((value) {
                                                      value.setString('language_code', selectedLanguage);
                                                    });
                                                  },
                                                  items: Constants.LANGUAGES.map<DropdownMenuItem<String>>((String value) {
                                                    return DropdownMenuItem<String>(
                                                      value: value,
                                                      child: Text(
                                                        value == 'en' ? 'English' : 'عربي',
                                                        style: TextStyle(
                                                          color: themeNotifier.isLight()
                                                              ? primaryColor
                                                              : Colors.white,
                                                        ),
                                                      ),
                                                    );
                                                  }).toList(),
                                                ),
                                              ],
                                            )
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: height(0.02, context),),
                                    Divider(
                                        color: HexColor('#DADADA')
                                    ),
                                    SizedBox(height: height(0.02, context),),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          translate('firstStep', context),
                                          style: TextStyle(
                                              color: HexColor('#979797'),
                                              fontSize: width(0.032, context)
                                          ),
                                        ),
                                        SizedBox(height: height(0.006, context),),
                                        Text(
                                          '${translate('nationality', context)}'
                                              ' ${translate('countryOfResidence', context)}'
                                              ' ${translate('and', context)}'
                                              '${translate('mobileNumber', context)}',
                                          style: TextStyle(
                                              color: HexColor('#5F5F5F'),
                                              fontSize: width(0.032, context)
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
                                          '${translate('next', context)}: ${translate('personalInformations', context)}',
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
                                      direction: Axis.horizontal,
                                      horizontalAlignment: MainAxisAlignment.start,
                                      groupValue: selectedNationality,
                                      spacebetween: 30,
                                      onChanged: (value) => setState(() {
                                        selectedNationality = value;
                                      }),
                                      items: const ['jordanian', 'nonJordanian'],
                                      itemBuilder: (item) => RadioButtonBuilder(
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
                                    InkWell(
                                      onTap: (){
                                        DropDownState(
                                          DropDown(
                                            isSearchVisible: false,
                                            data: selectedListItem ?? [],
                                            selectedItems: (List<dynamic> selectedList) {
                                              for(var item in selectedList) {
                                                if(item is SelectedListItem) {
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
                                        padding: const EdgeInsets.all(16.0),
                                        decoration: BoxDecoration(
                                            color: Colors.transparent,
                                            borderRadius: BorderRadius.circular(8.0),
                                            border: Border.all(
                                                color: HexColor('#979797')
                                            )
                                        ),
                                        child: Text(
                                          '${selectedCountry.value} | ${selectedCountry.name}',
                                          style: TextStyle(
                                              color: HexColor('#363636'),
                                              fontSize: width(0.032, context)
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: height(0.02, context),),
                                    Text(
                                      translate('mobileNumber', context),
                                      style: TextStyle(
                                          color: HexColor('#363636'),
                                          fontSize: width(0.032, context)
                                      ),
                                    ),
                                    SizedBox(height: height(0.015, context),),
                                    buildTextFormField(themeNotifier, loginProvider, mobileNumberController),
                                  ],
                                ),
                                textButton(themeNotifier, 'continue', MaterialStateProperty.all<Color>(
                                    mobileNumberController.text.isEmpty
                                        ? HexColor('#DADADA')
                                        : getPrimaryColor(context, themeNotifier)),
                                    HexColor('#ffffff'), (){}),
                              ],
                            ),
                          );
                        }
                        break;
                    }
                    return somethingWrongWidget(context, 'somethingWrongHappened', 'somethingWrongHappenedDesc');
                  }
              ),
            ),
          ),
        ],
      ),
    );
  }

  TextFormField buildTextFormField(themeNotifier, loginProvider, controller){
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
          contentPadding: const EdgeInsets.only(left: 16.0, right: 16.0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
            borderSide: BorderSide(
              color: getPrimaryColor(context, themeNotifier),
              width: 0.5,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
            borderSide: BorderSide(
              color: getPrimaryColor(context, themeNotifier),
              width: 0.8,
            ),
          )
      ),
      onChanged: (val){
        loginProvider.notifyMe();
      },
    );
  }

  TextButton textButton(themeNotifier, text, buttonColor, textColor, onPressed){
    return  TextButton(
      onPressed: onPressed,
      style: ButtonStyle(
          backgroundColor: buttonColor,
          foregroundColor:  MaterialStateProperty.all<Color>(
              Colors.white
          ),
          fixedSize:  MaterialStateProperty.all<Size>(
            Size(width(0.7, context), height(0.055, context)),
          ),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(
                    color: Colors.grey.shade600,
                    width: 0.4
                )
            ),
          )
      ),
      child: Text(
        translate(text, context),
        style: TextStyle(
            color: textColor
        ),
      ),
    );
  }

}
