// ignore_for_file: file_names

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ssc/infrastructure/userConfig.dart';
import 'package:ssc/source/view/accountSettings/accountSettingsComponents/aboutTheApplicationScreen.dart';
import 'package:ssc/source/view/accountSettings/accountSettingsComponents/accountStatementScreen.dart';
import 'package:ssc/source/view/accountSettings/accountSettingsComponents/paymentManagementScreen.dart';
import 'package:ssc/utilities/hexColor.dart';
import 'package:ssc/utilities/theme/themes.dart';

import '../../../infrastructure/userSecuredStorage.dart';
import '../../../utilities/util.dart';
import 'dart:math' as math;

import '../../viewModel/accountSettings/accountSettingsProvider.dart';
import '../../viewModel/utilities/language/globalAppProvider.dart';
import '../../viewModel/utilities/theme/themeProvider.dart';
import '../splash/splashScreen.dart';
import 'accountSettingsComponents/callUsScreen.dart';
import 'accountSettingsComponents/frequentlyAskedQuestionsScreen.dart';
import 'accountSettingsComponents/myFinances/myFinancesListScreen.dart';
import 'accountSettingsComponents/profileScreen.dart';
import 'accountSettingsComponents/suggestionsAndComplaintsScreen.dart';
import 'accountSettingsComponents/termsAndConditionsScreen.dart';
import 'accountSettingsComponents/updatePasswordScreen.dart';

class AccountSettingsScreen extends StatefulWidget {
  const AccountSettingsScreen({Key key}) : super(key: key);

  @override
  State<AccountSettingsScreen> createState() => _AccountSettingsScreenState();
}

class _AccountSettingsScreenState extends State<AccountSettingsScreen> {
  UserSecuredStorage userSecuredStorage = UserSecuredStorage.instance;
  Future<SharedPreferences> prefs = SharedPreferences.getInstance();
  AccountSettingsProvider accountSettingsProvider;
  ThemeNotifier themeNotifier;

  @override
  void initState(){
    accountSettingsProvider = Provider.of<AccountSettingsProvider>(context, listen: false);
    themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);

    accountSettingsProvider.isLoading = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(getTranslated('accountSettings', context), style: const TextStyle(fontSize: 14),),
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
                      color: getContainerColor(context),
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
                                color: themeNotifier.isLight() ? HexColor('#445740') : Colors.white,
                              ),
                            ),
                            InkWell(
                              onTap: (){
                                accountSettingsProvider.isLoading = true;
                                accountSettingsProvider.notifyMe();
                                try{
                                  accountSettingsProvider.getListOfNationalities().then((value){
                                    Navigator.of(context).push(
                                        MaterialPageRoute(builder: (context) => ProfileScreen(nationalities: value))
                                    );
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
                              },
                              child: SvgPicture.asset('assets/icons/profileIcons/edit.svg'),
                            )
                          ],
                        ),
                        const SizedBox(height: 10.0),
                        Text(
                          getTranslated('modifyAndManageYourAccountDetails', context),
                          style: TextStyle(
                            color: themeNotifier.isLight() ? HexColor('#999A9A') : Colors.white70,
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
                          buildNavigationButton('paymentManagement', (){
                            Navigator.of(context).push(
                                MaterialPageRoute(builder: (context) => const PaymentManagementScreen())
                            );
                          }),
                          buildNavigationButton('paymentMethodsManagement', (){}, extraIcon: 'assets/icons/profileIcons/soonIcon.svg'),
                          buildNavigationButton('accountStatement', (){
                            Navigator.of(context).push(
                                MaterialPageRoute(builder: (context) => const AccountStatementScreen())
                            );
                          }),
                          buildNavigationButton('myFinances', (){
                            Navigator.of(context).push(
                                MaterialPageRoute(builder: (context) => const MyFinancesListScreen())
                            );
                          }),
                        ],
                      )
                  ),
                  buildButtonsContainer(
                      'securityAndProtection',
                      'assets/icons/profileIcons/security.svg',
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          buildNavigationButton('passwordAndSecurity', (){
                            Navigator.of(context).push(
                              MaterialPageRoute(builder: (context) => const UpdatePasswordScreen())
                            );
                          }),
                          buildCustomizableButton(SvgPicture.asset('assets/icons/profileIcons/disableToggle.svg', height: 12, width: 12,), 'enableFingerprintLogin', (){}, extraIcon: 'assets/icons/profileIcons/soonIcon.svg'),
                          buildCustomizableButton(SvgPicture.asset('assets/icons/profileIcons/disableToggle.svg', height: 12, width: 12,), 'enablePasscodeLogin', (){}, extraIcon: 'assets/icons/profileIcons/soonIcon.svg'),
                          /// on: 'assets/icons/profileIcons/enableToggle.svg' | color: themeNotifier.isLight() ? HexColor('#445740') : HexColor('6f846b')
                          /// off: 'assets/icons/profileIcons/disableToggle.svg'
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
                              !UserConfig.instance.isLanguageEnglish() ? SvgPicture.asset(
                                'assets/icons/profileIcons/checked.svg', height: 18, width: 18,
                              ) : const SizedBox.shrink(),
                              'العربية', (){
                                Provider.of<GlobalAppProvider>(context, listen: false).changeLanguage(const Locale("ar"));
                                Provider.of<GlobalAppProvider>(context, listen: false).notifyMe();
                                prefs.then((value) {
                                  value.setString('language_code', "ar");
                                });
                              }, noTranslate: true),
                          buildCustomizableButton(
                              UserConfig.instance.isLanguageEnglish() ? SvgPicture.asset(
                                'assets/icons/profileIcons/checked.svg', height: 18, width: 18,
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
                  /// TODO: show app theme
                  // buildButtonsContainer(
                  //     'select_app_theme',
                  //     'assets/icons/profileIcons/language.svg',
                  //     Column(
                  //       crossAxisAlignment: CrossAxisAlignment.start,
                  //       children: [
                  //         buildCustomizableButton(
                  //             themeNotifier.isLight() ? SvgPicture.asset(
                  //               'assets/icons/profileIcons/checked.svg', height: 18, width: 18,
                  //             ) : const SizedBox.shrink(),
                  //             'Light', (){
                  //           themeNotifier.setThemeMode(ThemeMode.light);
                  //           prefs.then((value) {
                  //             value.setString(Constants.APP_THEME, Constants.LIGHT);
                  //           });
                  //           setState(() {});
                  //         }),
                  //         buildCustomizableButton(
                  //             !themeNotifier.isLight() ? SvgPicture.asset(
                  //               'assets/icons/profileIcons/checked.svg', height: 18, width: 18,
                  //             ) : const SizedBox.shrink(),
                  //             'Dark', (){
                  //           themeNotifier.setThemeMode(ThemeMode.dark);
                  //           prefs.then((value) {
                  //             value.setString(Constants.APP_THEME, Constants.DARK);
                  //           });
                  //           setState(() {});
                  //         }),
                  //       ],
                  //     )
                  // ),
                  buildButtonsContainer(
                      'supportAndAssistance',
                      'assets/icons/profileIcons/headphone.svg',
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          buildNavigationButton('callUs', (){
                            Navigator.of(context).push(
                              MaterialPageRoute(builder: (context) => const CallUsScreen())
                            );
                          }),
                          buildNavigationButton('suggestionsAndComplaints', (){
                            Navigator.of(context).push(
                              MaterialPageRoute(builder: (context) => const SuggestionsAndComplaintsScreen())
                            );
                          }),
                          buildNavigationButton('frequentlyAskedQuestions', (){
                            Navigator.of(context).push(
                                MaterialPageRoute(builder: (context) => const FrequentlyAskedQuestionsScreen())
                            );
                          }),
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
                            Navigator.of(context).push(
                              MaterialPageRoute(builder: (context) => const AboutTheApplicationScreen())
                            );
                          }),
                          buildNavigationButton('termsAndConditions', (){
                            Navigator.of(context).push(
                              MaterialPageRoute(builder: (context) => const TermsAndConditionsScreen())
                            );
                          }),
                          buildNavigationButton('privacyPolicy', (){}),
                          buildNavigationButton('explanationOfFeatures', (){}),
                        ],
                      )
                  ),
                  InkWell(
                    onTap: (){},
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 10.0),
                      padding: const EdgeInsets.all(12.0),
                      decoration: BoxDecoration(
                          color: getContainerColor(context),
                          borderRadius: BorderRadius.circular(8.0)
                      ),
                      width: width(1, context),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SvgPicture.asset('assets/icons/profileIcons/star.svg', color: themeNotifier.isLight() ? HexColor('#445740') : Colors.white,),
                          const SizedBox(width: 10.0),
                          Text(
                            getTranslated('rateTheApp', context),
                            style: TextStyle(
                                color: themeNotifier.isLight() ? HexColor('#445740') : Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(15.0),
                    decoration: BoxDecoration(
                        color: getContainerColor(context),
                        borderRadius: BorderRadius.circular(8.0)
                    ),
                    width: width(1, context),
                    child: InkWell(
                      onTap: () async{
                        accountSettingsProvider.isLoading = true;
                        accountSettingsProvider.notifyMe();
                        try{
                          await accountSettingsProvider.logout().then((value) {
                            // if(value.toString() == 'true'){
                            setState(() {
                              UserSecuredStorage.instance.clearUserData();
                            });
                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                    builder: (context) => const SplashScreen()
                                ), (route) => false);
                            // }
                          });
                          accountSettingsProvider.isLoading = false;
                          accountSettingsProvider.notifyMe();
                        }catch(e){
                          accountSettingsProvider.isLoading = false;
                          accountSettingsProvider.notifyMe();
                          if (kDebugMode) {
                            print(e.toString());
                          }
                        }
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SvgPicture.asset('assets/icons/profileIcons/logout.svg', color: themeNotifier.isLight() ? HexColor('#BC0D0D') : HexColor('#e53935')),
                          const SizedBox(width: 10.0),
                          Text(
                            getTranslated('logout', context),
                            style: TextStyle(
                                color: themeNotifier.isLight() ? HexColor('#BC0D0D') : HexColor('#e53935')
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
          if(Provider.of<AccountSettingsProvider>(context).isLoading)
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: width(1, context),
            height: height(1, context),
            color: themeNotifier.isLight() ? Colors.white70 : Colors.black45,
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
              color: getContainerColor(context),
              borderRadius: BorderRadius.circular(8.0)
          ),
          width: width(1, context),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SvgPicture.asset(icon, color: themeNotifier.isLight() ? HexColor('#445740') : Colors.white,),
                  const SizedBox(width: 10.0),
                  Text(
                    getTranslated(title, context),
                    style: TextStyle(
                      color: themeNotifier.isLight() ? HexColor('#445740') : Colors.white,
                      fontSize: UserConfig.instance.isLanguageEnglish() ? 12.0 : 14.0,
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

  Widget buildNavigationButton(String text, void Function() onTap, {String extraIcon = ''}){
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 5.0),
        padding: EdgeInsets.symmetric(vertical: extraIcon != '' ? 0.0 : 15.0, horizontal: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              getTranslated(text, context),
              style: TextStyle(
                color: themeNotifier.isLight() ? HexColor('#445740') : Colors.white,
                fontSize: UserConfig.instance.isLanguageEnglish() ? 12.0 : 14.0,
              ),
            ),
            Row(
              children: [
                if(extraIcon != '')
                SvgPicture.asset(extraIcon),
                const SizedBox(width: 30.0,),
                Transform.rotate(
                  angle: UserConfig.instance.isLanguageEnglish()
                      ? -math.pi / 1.0 : 0,
                  child: SvgPicture.asset('assets/icons/profileIcons/arrow.svg', color: themeNotifier.isLight() ? HexColor('#445740') : Colors.white,),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildCustomizableButton(Widget icon, String text, void Function() onTap, {bool noTranslate = false, String extraIcon = ''}){
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 5.0),
        padding: EdgeInsets.symmetric(vertical: extraIcon != '' ? 0.0 : 15.0, horizontal: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              noTranslate ? text : getTranslated(text, context),
              style: TextStyle(
                color: themeNotifier.isLight() ? HexColor('#445740') : Colors.white,
                fontSize: UserConfig.instance.isLanguageEnglish() ? 12.0 : 14.0,
              ),
            ),
            Row(
              children: [
                if(extraIcon != '')
                SvgPicture.asset(extraIcon),
                const SizedBox(width: 15.0,),
                icon,
              ],
            ),
          ],
        ),
      ),
    );
  }

}