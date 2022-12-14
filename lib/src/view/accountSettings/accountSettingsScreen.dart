// ignore_for_file: file_names

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ssc/infrastructure/userConfig.dart';
import 'package:ssc/src/view/accountSettings/accountSettingsComponents/aboutTheApplicationScreen.dart';
import 'package:ssc/src/viewModel/profile/profileProvider.dart';
import 'package:ssc/utilities/hexColor.dart';

import '../../../infrastructure/userSecuredStorage.dart';
import '../../../utilities/util.dart';
import 'dart:math' as math;

import '../../viewModel/utilities/language/globalAppProvider.dart';
import 'accountSettingsComponents/profileScreen.dart';

class AccountSettingsScreen extends StatefulWidget {
  const AccountSettingsScreen({Key key}) : super(key: key);

  @override
  State<AccountSettingsScreen> createState() => _AccountSettingsScreenState();
}

class _AccountSettingsScreenState extends State<AccountSettingsScreen> {
  UserSecuredStorage userSecuredStorage = UserSecuredStorage.instance;
  Future<SharedPreferences> prefs = SharedPreferences.getInstance();
  ProfileProvider profileProvider;

  @override
  void initState(){
    profileProvider = Provider.of<ProfileProvider>(context, listen: false);
    profileProvider.isLoading = false;
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
      body: Stack(
        children: [
          Padding(
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
                            InkWell(
                              onTap: (){
                                profileProvider.isLoading = true;
                                profileProvider.notifyMe();
                                try{
                                  profileProvider.getListOfNationalities().then((value){
                                    Navigator.of(context).push(
                                        MaterialPageRoute(builder: (context) => ProfileScreen(nationalities: value))
                                    );
                                    profileProvider.isLoading = false;
                                    profileProvider.notifyMe();
                                  });
                                }catch(e){
                                  profileProvider.isLoading = false;
                                  profileProvider.notifyMe();
                                  if (kDebugMode) {
                                    print(e.toString());
                                  }
                                }
                              },
                              child: SvgPicture.asset('assets/icons/profileIcons/edit.svg'),
                            )
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
                          buildCustomizableButton(SvgPicture.asset('assets/icons/profileIcons/disableToggle.svg', height: 12, width: 12,), 'enableFingerprintLogin', (){}),
                          buildCustomizableButton(SvgPicture.asset('assets/icons/profileIcons/enableToggle.svg', height: 12, width: 12,), 'enablePasscodeLogin', (){}),
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
                          buildNavigationButton('aboutSscApplication', (){
                            Navigator.of(context).push(MaterialPageRoute(builder: (context) => const AboutTheApplicationScreen()));
                          }),
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
          if(Provider.of<ProfileProvider>(context).isLoading)
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: width(1, context),
            height: height(0.8, context),
            color: Colors.white70,
            child: Center(
              child: animatedLoader(context),
            ),
          )
        ],
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