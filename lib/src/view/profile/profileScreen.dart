// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ssc/infrastructure/userConfig.dart';
import 'package:ssc/utilities/hexColor.dart';

import '../../../infrastructure/userSecuredStorage.dart';
import '../../../utilities/constants.dart';
import '../../../utilities/util.dart';
import 'dart:math' as math;

import '../../viewModel/utilities/language/globalAppProvider.dart';

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
                      buildNavigationButton('paymentManagement', (){}),
                      buildNavigationButton('paymentMethodsManagement', (){}),
                      buildNavigationButton('accountStatement', (){}),
                    ],
                  )
              ),
              buildButtonsContainer(
                  'securityAndProtection',
                  'assets/icons/profileIcons/security.svg',
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildNavigationButton('passwordAndSecurity', (){}),
                      buildCustomizableButton(SvgPicture.asset('assets/icons/profileIcons/disableToggle.svg', height: 13, width: 13,), 'enableFingerprintLogin', (){}),
                      buildCustomizableButton(SvgPicture.asset('assets/icons/profileIcons/enableToggle.svg', height: 13, width: 13,), 'enablePasscodeLogin', (){}),
                    ],
                  )
              ),
              buildButtonsContainer(
                  'language',
                  'assets/icons/profileIcons/language.svg',
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildCustomizableButton(
                          !UserConfig.instance.checkLanguage() ? SvgPicture.asset(
                            'assets/icons/profileIcons/checked.svg', height: 22, width: 22,
                          ) : const SizedBox.shrink(),
                          'العربية', (){
                            Provider.of<GlobalAppProvider>(context, listen: false).changeLanguage(const Locale("ar"));
                            Provider.of<GlobalAppProvider>(context, listen: false).notifyMe();
                            prefs.then((value) {
                              value.setString('language_code', "ar");
                            });
                          }, noTranslate: true),
                      buildCustomizableButton(
                          UserConfig.instance.checkLanguage() ? SvgPicture.asset(
                            'assets/icons/profileIcons/checked.svg', height: 22, width: 22,
                          ) : const SizedBox.shrink(),
                          'English', (){
                            Provider.of<GlobalAppProvider>(context, listen: false).changeLanguage(const Locale("en"));
                            Provider.of<GlobalAppProvider>(context, listen: false).notifyMe();
                            prefs.then((value) {
                              value.setString('language_code', "en");
                            });
                          }, noTranslate: true),
                    ],
                  )
              ),
              buildButtonsContainer(
                  'supportAndAssistance',
                  'assets/icons/profileIcons/headphone.svg',
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildNavigationButton('callUs', (){}),
                      buildNavigationButton('suggestionsAndComplaints', (){}),
                      buildNavigationButton('frequentlyAskedQuestions', (){}),
                    ],
                  )
              ),
              buildButtonsContainer(
                  'aboutUs',
                  'assets/icons/profileIcons/help.svg',
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildNavigationButton('aboutSscApplication', (){}),
                      buildNavigationButton('termsAndConditions', (){}),
                      buildNavigationButton('privacyPolicy', (){}),
                      buildNavigationButton('explanationOfFeatures', (){}),
                    ],
                  )
              ),
              InkWell(
                onTap: (){},
                child: Container(
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

  Widget buildNavigationButton(String text, void Function() onTap){
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 5.0),
        padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              translate(text, context),
              style: TextStyle(
                  color: HexColor('#445740')
              ),
            ),
            Transform.rotate(
              angle: UserConfig.instance.checkLanguage()
                  ? -math.pi / 1.0 : 0,
              child: SvgPicture.asset('assets/icons/profileIcons/arrow.svg'),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildCustomizableButton(Widget icon, String text, void Function() onTap, {bool noTranslate = false}){
    return InkWell(
      onTap: onTap,
      child: Container(
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
            icon,
          ],
        ),
      ),
    );
  }

}