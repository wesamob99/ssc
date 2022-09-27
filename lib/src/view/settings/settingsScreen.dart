import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ssc/src/viewModel/utilities/language/globalAppProvider.dart';
import 'package:ssc/src/viewModel/utilities/theme/themeProvider.dart';
import 'package:ssc/utilities/theme/themes.dart';
import 'package:ssc/utilities/util.dart';

import '../../../utilities/constants.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {

  Future<SharedPreferences> prefs = SharedPreferences.getInstance();
  String? selectedTheme;
  String? selectedLanguage;

  getAppTheme(){
    prefs.then((value) {
      setState((){
        selectedTheme = value.getString(Constants.APP_THEME) ?? Constants.SYSTEM_DEFAULT;
        selectedLanguage = value.getString('language_code') ?? 'en';
      });
    });
  }

  @override
  void initState() {
    getAppTheme();

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    ThemeNotifier themeNotifier = Provider.of<ThemeNotifier>(context);
    GlobalAppProvider globalAppProvider = Provider.of<GlobalAppProvider>(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(top: height(0.004, context)),
          padding: EdgeInsets.all(height(0.004, context)),
          color: getPrimaryColor(context, themeNotifier).withOpacity(0.5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    themeNotifier.isLight()
                        ? Icons.light_mode_outlined
                        : Icons.dark_mode_outlined,
                    color: themeNotifier.isLight()
                        ? primaryColor
                        : Colors.white,
                  ),
                  const SizedBox(
                    width: 5.0,
                  ),
                  Text(
                    translate('select_app_theme', context),
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold
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
                  onChanged: (String? value) async{
                    setState(() {
                      selectedTheme = value!;
                    });
                    themeNotifier.setThemeMode(
                        selectedTheme == 'Light'
                            ? ThemeMode.light : selectedTheme == 'Dark'
                            ? ThemeMode.dark : ThemeMode.system
                    );
                    prefs.then((value) {
                      value.setString(Constants.APP_THEME, selectedTheme!);
                    });
                  },
                  items: Constants.THEMES.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        translate(value, context),
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
                children: [
                  Icon(
                    Icons.language,
                    color: themeNotifier.isLight()
                      ? primaryColor
                      : Colors.white,
                  ),
                  const SizedBox(
                    width: 5.0,
                  ),
                  Text(
                    translate('select_app_language', context),
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold
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
                  onChanged: (String? value) async{
                    setState(() {
                      selectedLanguage = value!;
                    });
                    globalAppProvider.changeLanguage(Locale(selectedLanguage!));
                    globalAppProvider.notifyMe();
                    prefs.then((value) {
                      value.setString('language_code', selectedLanguage!);
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
      ],
    );
  }
}
