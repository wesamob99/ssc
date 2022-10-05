import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ssc/infrastructure/userSecuredStorage.dart';
import 'package:ssc/src/viewModel/login/loginProvider.dart';
import 'package:ssc/src/viewModel/utilities/theme/themeProvider.dart';
import 'package:ssc/utilities/theme/themes.dart';
import 'package:ssc/utilities/util.dart';

import '../../../infrastructure/userConfig.dart';
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
  bool showError = false;

  Future<SharedPreferences> prefs = SharedPreferences.getInstance();
  UserSecuredStorage userSecuredStorage = UserSecuredStorage.instance;
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
        backgroundColor: Colors.transparent,
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
                  SvgPicture.asset('assets/logo/logo_with_name.svg'),
                  SizedBox(height: height(0.1, context)),
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
                      buildTextFormField(themeNotifier, loginProvider,  nationalIdController, TextInputType.number),
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
                      buildTextFormField(themeNotifier, loginProvider, passwordController, TextInputType.visiblePassword),
                    ],
                  ),
                  SizedBox(height: height(0.05, context)),
                  TextButton(
                    onPressed: () async {
                      try{
                      await loginProvider.login(nationalIdController.text, passwordController.text)
                          .whenComplete((){})
                          .then((val){
                        userSecuredStorage.token = val['token'] ?? ''; // user token
                        if(val['data'] != null){
                          userSecuredStorage.userName = val['data']['PO_NAME'] ?? ''; // PO_NAME -> user name
                          userSecuredStorage.nationalId = val['data']['PO_USER_NAME'] ?? ''; // PO_USER_NAME -> user national ID
                          userSecuredStorage.internalKey = val['data']['PO_INTERNAL_KEY'] ?? ''; // PO_USER_NAME -> user national ID
                        }
                        if(val['PO_STATUS_DESC_EN'] != null){
                          loginProvider.errorMessage = UserConfig.instance.checkLanguage()
                          ? val['PO_STATUS_DESC_EN'] : val['PO_STATUS_DESC_AR'];
                        } else{
                          loginProvider.errorMessage = '';
                        }
                        loginProvider.tokenUpdated = val['token'] != null ? true : false;
                        loginProvider.loginComplete = val['token'] != null ? 'true' : 'false';
                      });
                    }catch(e){
                        if (kDebugMode) {
                          print(e.toString());
                        }
                      }
                      loginProvider.errorType.clear();
                      if(!_formKey.currentState!.validate()){
                        loginProvider.loginComplete = 'null';
                        loginProvider.errorType.length = 0;
                      } else{
                        if(nationalIdController.text.isEmpty){
                          loginProvider.errorType.add(1);
                        }
                        if(passwordController.text.isEmpty){
                          loginProvider.errorType.add(2);
                        }
                        if(loginProvider.loginComplete == 'false'){
                          loginProvider.errorType.add(0);
                        }
                      }
                      loginProvider.notifyMe();
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                        getPrimaryColor(context, themeNotifier),
                      ),
                      foregroundColor:  MaterialStateProperty.all<Color>(
                        Colors.white
                      ),
                      fixedSize:  MaterialStateProperty.all<Size>(
                        Size(width(0.7, context), height(0.055, context)),
                      ),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)
                        )
                      )
                    ),
                    child: Text(translate('continue', context)),
                  )
                ],
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

  buildTextFormField(themeNotifier, loginProvider, controller, inputType){
    // String errorText = '';
    // if(Provider.of<LoginProvider>(context).errorType.contains(1) &&
    // controller == nationalIdController){
    //   errorText = translate('loginErrorEmptyNationalId', context);
    // }
    // if(Provider.of<LoginProvider>(context).errorType.contains(2) &&
    // controller == passwordController){
    //   errorText = translate('loginErrorEmptyPassword', context);
    // }
    // if(Provider.of<LoginProvider>(context).errorType.contains(0) &&
    // Provider.of<LoginProvider>(context).errorType.length == 1){
    //   errorText = translate('loginErrorInvalidInputs', context);
    // }
    return TextFormField(
      controller: controller,
      keyboardType: inputType,
      obscureText: controller == passwordController ? obscurePassword : false,
      validator: (_){
        if(loginProvider.loginComplete != 'null' &&
          loginProvider.loginComplete == 'true'){
          return translate('loginError', context);
        }
        return null;
      },
      decoration: InputDecoration(
        hintText: controller == nationalIdController ? translate('nationalIdEx', context) : '',
        errorText: Provider.of<LoginProvider>(context).loginComplete == 'false'
            ? loginProvider.errorMessage
            : null,
        hintStyle: TextStyle(
          color: getGrey2Color(context).withOpacity(
              themeNotifier.isLight()
              ? 1 : 0.5
          ),
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
            color: themeNotifier.isLight()
                ? getPrimaryColor(context, themeNotifier)
                : Colors.white,
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
