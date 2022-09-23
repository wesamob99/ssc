import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ssc/utilities/hexColor.dart';

import '../../../utilities/constants.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {

  Future<SharedPreferences> prefs = SharedPreferences.getInstance();
  String? selectedTheme = Constants.SYSTEM_DEFAULT;

  getAppTheme(){
    prefs.then((value) {
      setState((){
        selectedTheme = value.getString(Constants.APP_THEME);
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
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
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
        )
      ],
    );
  }
}
