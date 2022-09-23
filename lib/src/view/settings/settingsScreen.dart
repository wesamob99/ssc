import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ssc/utilities/hexColor.dart';
import 'package:ssc/utilities/util.dart';

import '../../../utilities/constants.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {

  Future<SharedPreferences> prefs = SharedPreferences.getInstance();
  String? selectedTheme = Constants.SYSTEM_DEFAULT;
  String? selectedLanguage = 'en';

  getAppTheme(){
    prefs.then((value) {
      setState((){
        selectedTheme = value.getString(Constants.APP_THEME);
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
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          width: width(0.9, context),
          margin: const EdgeInsets.only(top: 5.0),
          padding: const EdgeInsets.symmetric(horizontal: 5.0),
          decoration: BoxDecoration(
            border: Border.all(
              color: HexColor('#445740'),
            ),
            borderRadius: BorderRadius.circular(8)
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                translate('select_app_theme', context)+': ',
              ),
              DropdownButton<String>(
                value: selectedTheme,
                icon: Icon(
                  Icons.arrow_drop_down_outlined,
                  color: HexColor('#445740'),
                ),
                elevation: 16,
                style: const TextStyle(color: Colors.black),
                underline: Container(
                  height: 2,
                  color: HexColor('#445740'),
                ),
                onChanged: (String? value) async{
                  setState(() {
                    selectedTheme = value!;
                  });
                  prefs.then((value) {
                    value.setString(Constants.APP_THEME, selectedTheme!);
                  });
                },
                items: Constants.THEMES.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      style: TextStyle(
                        color: selectedTheme == value
                            ? HexColor('#445740')
                            : Colors.black,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
        Container(
          width: width(0.9, context),
          margin: const EdgeInsets.only(top: 5.0),
          padding: const EdgeInsets.symmetric(horizontal: 5.0),
          decoration: BoxDecoration(
              border: Border.all(
                color: HexColor('#445740'),
              ),
              borderRadius: BorderRadius.circular(8)
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                translate('select_app_language', context)+': ',
              ),
              DropdownButton<String>(
                value: selectedLanguage,
                icon: Icon(
                  Icons.arrow_drop_down_outlined,
                  color: HexColor('#445740'),
                ),
                elevation: 16,
                style: const TextStyle(color: Colors.black),
                underline: Container(
                  height: 2,
                  color: HexColor('#445740'),
                ),
                onChanged: (String? value) async{
                  setState(() {
                    selectedLanguage = value!;
                  });
                  prefs.then((value) {
                    value.setString('language_code', selectedLanguage!);
                  });
                },
                items: Constants.LANGUAGES.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      style: TextStyle(
                        color: selectedLanguage == value
                            ? HexColor('#445740')
                            : Colors.black,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
        // dropDownButton(selectedLanguage),
      ],
    );
  }
}
