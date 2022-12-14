// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ssc/infrastructure/userConfig.dart';
import 'package:ssc/utilities/hexColor.dart';

import '../../../infrastructure/userSecuredStorage.dart';
import '../../../utilities/constants.dart';
import '../../../utilities/util.dart';
import 'dart:math' as math;

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  UserSecuredStorage userSecuredStorage = UserSecuredStorage.instance;
  Future<SharedPreferences> prefs = SharedPreferences.getInstance();

  String selectedTheme;
  String selectedLanguage;
  String selectedTextSize;

  getAppThemeAndLanguage(){
    prefs.then((value) {
      setState((){
        selectedTheme = value.getString(Constants.APP_THEME) ?? Constants.SYSTEM_DEFAULT;
        selectedLanguage = value.getString('language_code') ?? 'en';
        selectedTextSize = value.getString('text_size') ?? 's';
      });
    });
  }

  @override
  void initState(){
    getAppThemeAndLanguage();
    // ProfileProvider profileProvider = Provider.of<ProfileProvider>(context, listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(translate('accountSettings', context), style: const TextStyle(fontSize: 14),),
        leading: leadingBackIcon(context),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.0)
                ),
                width: width(1, context),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          userSecuredStorage.userName,
                          style: TextStyle(
                            color: HexColor('#445740'),
                          ),
                        ),
                        SvgPicture.asset('assets/icons/profileIcons/edit.svg')
                      ],
                    ),
                    const SizedBox(height: 10.0),
                    Text(
                      translate('modifyAndManageYourAccountDetails', context),
                      style: TextStyle(
                        color: HexColor('#999A9A'),
                        fontSize: 12.0
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10.0),
              buildButtonsContainer(
                  'invoicesAndPayments',
                  'assets/icons/profileIcons/dollar.svg',
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildButton('paymentManagement', (){}),
                      buildButton('paymentMethodsManagement', (){}),
                      buildButton('accountStatement', (){}),
                    ],
                  )
              ),
              buildButtonsContainer(
                  'securityAndProtection',
                  'assets/icons/profileIcons/security.svg',
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildButton('passwordAndSecurity', (){}),
                      buildButton('enableFingerprintLogin', (){}),
                      buildButton('enablePasscodeLogin', (){}),
                    ],
                  )
              ),
              buildButtonsContainer(
                  'language',
                  'assets/icons/profileIcons/language.svg',
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildButton('العربية', (){}, noTranslate: true),
                      buildButton('English', (){}, noTranslate: true),
                    ],
                  )
              ),
              buildButtonsContainer(
                  'supportAndAssistance',
                  'assets/icons/profileIcons/headphone.svg',
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildButton('callUs', (){}),
                      buildButton('suggestionsAndComplaints', (){}),
                      buildButton('frequentlyAskedQuestions', (){}),
                    ],
                  )
              ),
              buildButtonsContainer(
                  'aboutUs',
                  'assets/icons/profileIcons/help.svg',
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildButton('aboutSscApplication', (){}),
                      buildButton('privacyPolicy', (){}),
                      buildButton('explanationOfFeatures', (){}),
                    ],
                  )
              ),
              Container(
                padding: const EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8.0)
                ),
                width: width(1, context),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SvgPicture.asset('assets/icons/profileIcons/star.svg'),
                    const SizedBox(width: 10.0),
                    Text(
                      translate('rateTheApp', context),
                      style: TextStyle(
                          color: HexColor('#445740')
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20.0),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildButtonsContainer(String title, String icon, Widget buttons){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(12.0),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.0)
          ),
          width: width(1, context),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SvgPicture.asset(icon),
                  const SizedBox(width: 10.0),
                  Text(
                    translate(title, context),
                    style: TextStyle(
                        color: HexColor('#445740')
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10.0),
              buttons,
            ],
          ),
        ),
        const SizedBox(height: 10.0),
      ],
    );
  }

  Widget buildButton(String text, void Function() onTap, {bool withIcon = true, String icon = 'assets/icons/profileIcons/arrow.svg', bool noTranslate = false}){
    return InkWell(
      onTap: onTap,
      child: Container(
        // color: Colors.blue,
        margin: const EdgeInsets.only(bottom: 5.0),
        padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              noTranslate ? text : translate(text, context),
              style: TextStyle(
                  color: HexColor('#445740')
              ),
            ),
            if(withIcon)
            Transform.rotate(
              angle: UserConfig.instance.checkLanguage()
                  ? -math.pi / 1.0 : 0,
              child: SvgPicture.asset(icon),
            ),
          ],
        ),
      ),
    );
  }

}

/*
buildButton('language', (){
                        setState(() {
                          selectedLanguage = UserConfig.instance.checkLanguage() ? "ar" : "en";
                        });
                        Provider.of<GlobalAppProvider>(context, listen: false).changeLanguage(Locale(selectedLanguage));
                        Provider.of<GlobalAppProvider>(context, listen: false).notifyMe();
                        prefs.then((value) {
                          value.setString('language_code', selectedLanguage);
                        });
                      }, withIcon: false),
                      buildButton('select_app_theme', (){
                        setState(() {
                          selectedTheme = selectedTheme == 'Light'
                              ? 'Dark' : selectedTheme == 'Dark'
                              ? 'System default' : selectedTheme == 'System default'
                              ? 'Light' : 'System default';
                        });
                        Provider.of<ThemeNotifier>(context, listen: false).setThemeMode(
                            selectedTheme == 'Light'
                                ? ThemeMode.light : selectedTheme == 'Dark'
                                ? ThemeMode.dark : ThemeMode.system
                        );
                        prefs.then((value) {
                          value.setString(Constants.APP_THEME, selectedTheme);
                        });
                      }, withIcon: false),
 */