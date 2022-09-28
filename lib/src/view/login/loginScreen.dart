import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ssc/src/viewModel/login/loginProvider.dart';
import 'package:ssc/src/viewModel/utilities/theme/themeProvider.dart';
import 'package:ssc/utilities/theme/themes.dart';
import 'package:ssc/utilities/util.dart';

import '../../../utilities/constants.dart';
import '../../viewModel/utilities/language/globalAppProvider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  TextEditingController nationalIdController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  late LoginProvider loginProvider;
  final _formKey = GlobalKey<FormState>();
  bool obscurePassword = true;

  Future<SharedPreferences> prefs = SharedPreferences.getInstance();
  String? selectedLanguage;

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
    getAppLanguage();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    ThemeNotifier themeNotifier = Provider.of<ThemeNotifier>(context);
    GlobalAppProvider globalAppProvider = Provider.of<GlobalAppProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(translate('login', context)),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 14.0),
          child: Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        translate('enterNationalId', context),
                        style: TextStyle(
                          color: getGrey5Color(context),
                        ),
                      ),
                      SizedBox(height: height(0.01, context)),
                      buildTextFormField(themeNotifier,  nationalIdController, TextInputType.number),
                    ],
                  ),
                  SizedBox(height: height(0.025, context)),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        translate('enterPassword', context),
                        style: TextStyle(
                          color: getGrey5Color(context),
                        ),
                      ),
                      SizedBox(height: height(0.01, context)),
                      buildTextFormField(themeNotifier, passwordController, TextInputType.visiblePassword),
                    ],
                  ),
                  SizedBox(height: height(0.06, context)),
                  TextButton(
                    onPressed: () async {
                      var token = await loginProvider.login(nationalIdController.text, passwordController.text);
                      if(token != null){
                        loginProvider.token = token;
                      }else{
                        loginProvider.token = "null";
                      }
                      loginProvider.notifyMe();
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: getPrimaryColor(context, themeNotifier),
                      foregroundColor: Colors.white,
                      fixedSize: Size(width(0.3, context), height(0.04, context))
                    ),
                    child: const Text('LogIn'),
                  )
                ],
              ),
              Container(
                alignment: Alignment.topLeft,
                child: Row(
                  children: [
                    Icon(
                      Icons.language,
                      color: getGrey5Color(context),
                      size: 23,
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
                  ],
                )
              )
            ],
          ),
        ),
      ),
    );
  }

  buildTextFormField(themeNotifier, controller, inputType){
    return TextFormField(
      controller: controller,
      keyboardType: inputType,
      obscureText: controller == passwordController ? obscurePassword : false,
      decoration: InputDecoration(
        hintText: controller == nationalIdController ? translate('nationalIdEx', context) : '',
        hintStyle: TextStyle(
          color: getGrey2Color(context),
          fontSize: 14
        ),
        suffixIcon: InkWell(
          onTap: (){
            setState(() {
              obscurePassword = !obscurePassword;
            });
          },
          child: Icon(
            obscurePassword ? Icons.remove_red_eye : Icons.remove_red_eye_outlined,
            size: controller == passwordController ? 23 : 0,
            color: getPrimaryColor(context, themeNotifier),
          ),
        ),
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
    );
  }
}
