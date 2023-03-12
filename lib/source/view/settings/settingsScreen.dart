// ignore_for_file: file_names

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ssc/infrastructure/userSecuredStorage.dart';
import 'package:ssc/source/view/splash/splashScreen.dart';
import 'package:ssc/source/viewModel/utilities/language/globalAppProvider.dart';
import 'package:ssc/source/viewModel/utilities/theme/themeProvider.dart';
import 'package:ssc/utilities/theme/themes.dart';
import 'package:ssc/utilities/util.dart';

import '../../../utilities/constants.dart';
import '../../viewModel/settings/settingsProvider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {

  Future<SharedPreferences> prefs = SharedPreferences.getInstance();
  UserSecuredStorage userSecuredStorage = UserSecuredStorage.instance;

  SettingsProvider settingsProvider;
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
  void initState() {
    getAppThemeAndLanguage();
    settingsProvider = Provider.of<SettingsProvider>(context, listen: false);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    ThemeNotifier themeNotifier = Provider.of<ThemeNotifier>(context);
    GlobalAppProvider globalAppProvider = Provider.of<GlobalAppProvider>(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          children: [
            Container(
              padding: EdgeInsets.all(height(0.004, context)),
              color: getPrimaryColor(context, themeNotifier).withOpacity(0.5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        themeNotifier.isLight()
                            ? Icons.light_mode_outlined
                            : Icons.dark_mode_outlined,
                        color: themeNotifier.isLight()
                            ? primaryColor
                            : Colors.white,
                        size: width(0.058, context),
                      ),
                      const SizedBox(
                        width: 5.0,
                      ),
                      Text(
                        getTranslated('select_app_theme', context),
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: width(isTablet(context) ? 0.031 : 0.036, context)
                        ),
                      ),
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.all(height(0.004, context)).copyWith(right: 0),
                    padding: EdgeInsets.all(height(0.004, context)),
                    decoration: BoxDecoration(
                        color: themeNotifier.isLight() ? Colors.white : getShadowColor(context),
                        border: Border.all(
                          color: getPrimaryColor(context, themeNotifier),
                        ),
                        borderRadius: BorderRadius.circular(8)
                    ),
                    child: DropdownButton<String>(
                      isDense: true,
                      value: selectedTheme,
                      icon: Icon(
                        Icons.arrow_drop_down_outlined,
                        color: themeNotifier.isLight()
                            ? primaryColor
                            : Colors.white,
                      ),
                      elevation: 16,
                      style: const TextStyle(color: Colors.black),
                      underline: Container(
                        height: 0,
                        color: primaryColor,
                      ),
                      onChanged: (String value) async{
                        setState(() {
                          selectedTheme = value;
                        });
                        themeNotifier.setThemeMode(
                            selectedTheme == 'Light'
                                ? ThemeMode.light : selectedTheme == 'Dark'
                                ? ThemeMode.dark : ThemeMode.system
                        );
                        prefs.then((value) {
                          value.setString(Constants.APP_THEME, selectedTheme);
                        });
                      },
                      items: Constants.THEMES.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            getTranslated(value, context),
                            style: TextStyle(
                              color: themeNotifier.isLight()
                                  ? primaryColor
                                  : Colors.white,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: height(0.004, context)),
              padding: EdgeInsets.all(height(0.004, context)),
              color: getPrimaryColor(context, themeNotifier).withOpacity(0.5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.language,
                        color: themeNotifier.isLight()
                            ? primaryColor
                            : Colors.white,
                        size: width(0.058, context),
                      ),
                      const SizedBox(
                        width: 5.0,
                      ),
                      Text(
                        getTranslated('select_app_language', context),
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: width(isTablet(context) ? 0.031 : 0.036, context)
                        ),
                      ),
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.all(height(0.004, context)).copyWith(right: 0),
                    padding: EdgeInsets.all(height(0.004, context)),
                    decoration: BoxDecoration(
                        color: themeNotifier.isLight()
                            ? Colors.white
                            : getShadowColor(context),
                        border: Border.all(
                          color: getPrimaryColor(context, themeNotifier),
                        ),
                        borderRadius: BorderRadius.circular(8)
                    ),
                    child: DropdownButton<String>(
                      isDense: true,
                      value: selectedLanguage,
                      icon: Icon(
                        Icons.arrow_drop_down_outlined,
                        color: themeNotifier.isLight()
                            ? primaryColor
                            : Colors.white,
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
                  ),
                ],
              ),
            ),
            // Container(
            //   margin: EdgeInsets.only(top: height(0.004, context)),
            //   padding: EdgeInsets.all(height(0.004, context)),
            //   color: getPrimaryColor(context, themeNotifier).withOpacity(0.5),
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //     children: [
            //       Row(
            //         crossAxisAlignment: CrossAxisAlignment.center,
            //         children: [
            //           Icon(
            //             Icons.text_fields,
            //             color: themeNotifier.isLight()
            //                 ? primaryColor
            //                 : Colors.white,
            //             size: width(0.058, context),
            //           ),
            //           const SizedBox(
            //             width: 5.0,
            //           ),
            //           Text(
            //             translate('select_text_size', context),
            //             style: TextStyle(
            //                 color: Colors.white,
            //                 fontWeight: FontWeight.bold,
            //                 fontSize: width(0.036, context)
            //             ),
            //           ),
            //         ],
            //       ),
            //       Container(
            //         margin: EdgeInsets.all(height(0.004, context)).copyWith(right: 0),
            //         padding: EdgeInsets.all(height(0.004, context)),
            //         decoration: BoxDecoration(
            //             color: themeNotifier.isLight()
            //                 ? Colors.white
            //                 : getShadowColor(context),
            //             border: Border.all(
            //               color: getPrimaryColor(context, themeNotifier),
            //             ),
            //             borderRadius: BorderRadius.circular(8)
            //         ),
            //         child: DropdownButton<String>(
            //           isDense: true,
            //           value: selectedTextSize,
            //           icon: Icon(
            //             Icons.arrow_drop_down_outlined,
            //             color: themeNotifier.isLight()
            //                 ? primaryColor
            //                 : Colors.white,
            //           ),
            //           elevation: 16,
            //           style: const TextStyle(color: Colors.black),
            //           underline: Container(
            //             height: 0,
            //             color: primaryColor,
            //           ),
            //           onChanged: (String? value) async{
            //             setState(() {
            //               selectedTextSize = value!;
            //             });
            //             globalAppProvider.changeLanguage(Locale(selectedLanguage!));
            //             // globalAppProvider.notifyMe();
            //             prefs.then((value) {
            //               value.setString('text_size', selectedTextSize!);
            //             });
            //           },
            //           items: Constants.TEXT_SIZE.map<DropdownMenuItem<String>>((String value) {
            //             return DropdownMenuItem<String>(
            //               value: value,
            //               child: Text(
            //                 translate(value, context),
            //                 style: TextStyle(
            //                   color: themeNotifier.isLight()
            //                       ? primaryColor
            //                       : Colors.white,
            //                 ),
            //               ),
            //             );
            //           }).toList(),
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
          ],
        ),
        Container(
          margin: EdgeInsets.only(bottom: height(0.04, context)),
          padding: EdgeInsets.all(height(0.01, context)),
          decoration: BoxDecoration(
            color: getPrimaryColor(context, themeNotifier),
            borderRadius: BorderRadius.circular(500)
          ),
          width: width(0.5, context),
          child: InkWell(
            onTap: () async{
              try{
                await settingsProvider.logout().then((value) {
                  if(value.toString() == 'true'){
                    setState(() {
                      userSecuredStorage.clearUserData();
                    });
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                            builder: (context) => const SplashScreen()
                        ), (route) => false);
                  }
                });
              }catch(e){
                if (kDebugMode) {
                  print(e.toString());
                }
              }
            },
            child:Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  Icons.logout,
                  color: Colors.red,
                  size: width(0.053, context),
                ),
                const SizedBox(
                  width: 5.0,
                ),
                Text(
                  getTranslated('logout', context),
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: width(0.032, context)
                  ),
                ),
              ],
            ),
          )
        ),
      ],
    );
  }
}
