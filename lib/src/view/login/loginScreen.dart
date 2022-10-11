// ignore_for_file: file_names, use_build_context_synchronously

import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ssc/infrastructure/userSecuredStorage.dart';
import 'package:ssc/models/login/userData.dart';
import 'package:ssc/src/view/login/resetPasswordBody.dart';
import 'package:ssc/src/view/main/mainScreen.dart';
import 'package:ssc/src/viewModel/login/loginProvider.dart';
import 'package:ssc/src/viewModel/utilities/theme/themeProvider.dart';
import 'package:ssc/utilities/hexColor.dart';
import 'package:ssc/utilities/theme/themes.dart';
import 'package:ssc/utilities/util.dart';

import '../../../infrastructure/userConfig.dart';
import '../../../models/login/resetPasswordGetDetail.dart';
import '../../../utilities/constants.dart';
import '../../viewModel/utilities/language/globalAppProvider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  TextEditingController nationalIdController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  LoginProvider loginProvider;
  final _formKey = GlobalKey<FormState>();
  bool obscurePassword = true;
  bool showError = false;
  bool forgotPassword = false;

  Future<SharedPreferences> prefs = SharedPreferences.getInstance();
  UserSecuredStorage userSecuredStorage = UserSecuredStorage.instance;
  String selectedLanguage;

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
    loginProvider.enabledSubmitButton = false;
    loginProvider.showResetPasswordBody = false;
    getAppLanguage();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    ThemeNotifier themeNotifier = Provider.of<ThemeNotifier>(context);
    GlobalAppProvider globalAppProvider = Provider.of<GlobalAppProvider>(context);

    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: Colors.transparent,
      // ),
      body: Stack(
        children: [
          Container(
            alignment: Alignment.bottomLeft,
            child: SvgPicture.asset(
                'assets/logo/logo_tree.svg'
            ),
          ),
          SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 14.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(height: height(0.08, context),),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if(forgotPassword)
                        Container(
                              alignment: Alignment.topLeft,
                              child: Row(
                                children: [
                                  InkWell(
                                    onTap: (){
                                      if(loginProvider.showResetPasswordBody){
                                        loginProvider.showResetPasswordBody = false;
                                        loginProvider.notifyMe();
                                      }else{
                                        setState(() {
                                          nationalIdController.clear();
                                          passwordController.clear();
                                          loginProvider.enabledSubmitButton = false;
                                          forgotPassword = false;
                                        });
                                      }
                                    },
                                    child: SvgPicture.asset(
                                        'assets/icons/back.svg'
                                    ),
                                  ),
                                  SizedBox(width: width(0.03, context)),
                                  Text(
                                    translate('forgotPassword', context),
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w700
                                    ),
                                  ),
                                ],
                              )
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
                            ],
                          )
                        ),
                      ],
                    ),
                    SizedBox(height: height(0.08, context),),
                    Provider.of<LoginProvider>(context).showResetPasswordBody
                    ? const ResetPasswordBody()
                    : loginBody(themeNotifier)
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Column loginBody(themeNotifier){
    return Column(
      children: [
        if(!forgotPassword)
          SvgPicture.asset('assets/logo/logo_with_name.svg'),
        if(!forgotPassword)
          SizedBox(height: height(0.05, context)),
        if(!forgotPassword)
          Text(
            translate('login', context),
            style: TextStyle(
                fontSize: width(0.045, context),
                fontWeight: FontWeight.w700
            ),
          ),
        if(!forgotPassword)
          SizedBox(height: height(0.05, context)),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              translate('enterNationalId', context),
            ),
            SizedBox(height: height(0.01, context)),
            buildTextFormField(themeNotifier, loginProvider,  nationalIdController, TextInputType.number),
          ],
        ),
        // if(!forgotPassword)
        SizedBox(height: height(0.025, context)),
        if(!forgotPassword)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                translate('password', context),
              ),
              SizedBox(height: height(0.01, context)),
              buildTextFormField(themeNotifier, loginProvider, passwordController, TextInputType.visiblePassword),
            ],
          ),
        // if(!forgotPassword)
        SizedBox(height: height(0.01, context)),
        if(!forgotPassword)
          InkWell(
            onTap: (){
              setState(() {
                forgotPassword = true;
                nationalIdController.clear();
                passwordController.clear();
                loginProvider.enabledSubmitButton = false;
                loginProvider.notifyMe();
              });
            },
            child: Container(
              alignment: UserConfig.instance.checkLanguage()
                  ? Alignment.bottomLeft : Alignment.bottomRight,
              child: Text(
                translate('forgotPassword', context) + (UserConfig.instance.checkLanguage() ? ' ?' : ' ؟'),
              ),
            ),
          ),
        SizedBox(height: height(0.05, context)),
        submitButton(themeNotifier),
        SizedBox(height: height(0.04, context)),
        if(!forgotPassword)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                translate('dontHaveAnAccount', context),
              ),
              SizedBox(width: width(0.005, context)),
              Text(
                translate('register', context),
                style: TextStyle(
                    color: HexColor('#003C97')
                ),
              ),
            ],
          ),
      ],
    );
  }

  TextButton submitButton(themeNotifier){
    return  TextButton(
      onPressed: () async {
        // when user press continue to login
        if(loginProvider.enabledSubmitButton && !forgotPassword && loginProvider.numberOfAttempts < 5){
          try{
            await loginProvider.login(nationalIdController.text, passwordController.text)
                .whenComplete((){})
                .then((val){
              UserData userData = val;
              userSecuredStorage.token = userData.token ?? ''; // user token
              if(userData.data != null){
                userSecuredStorage.userName = userData.data.poName ?? ''; // poName -> user name
                userSecuredStorage.nationalId = userData.data.poUserName ?? ''; // poUserName -> user national ID
                userSecuredStorage.internalKey = userData.data.poInternalKey ?? ''; // poInternalKey -> user national ID
              }
              if(userData.poStatusDescEn != null){
                loginProvider.errorMessage = UserConfig.instance.checkLanguage()
                    ? userData.poStatusDescEn : userData.poStatusDescAr;
              } else{
                loginProvider.errorMessage = '';
              }
              loginProvider.formValid = userData.token != null ? 'true' : 'false';
            });
          }catch(e){
            if (kDebugMode) {
              print(e.toString());
            }
          }
          loginProvider.errorType.clear();
          if(loginProvider.formValid == 'true'){
            loginProvider.formValid = 'null';
            loginProvider.errorType.length = 0;
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const MainScreen()), (route) => false);
          } else{
            loginProvider.numberOfAttempts++;
            if(loginProvider.numberOfAttempts > 4){
              _showMyDialog('exceedNumberOfAllowedAttempts', loginProvider.numberOfAttempts > 4 ? "" : loginProvider.errorMessage, 'resetPassword', themeNotifier);
            }else{
              _showMyDialog('loginFailed', loginProvider.errorMessage, 'retryAgain', themeNotifier);
            }
            if(nationalIdController.text.isEmpty){
              loginProvider.errorType.add(1);
            }
            if(passwordController.text.isEmpty){
              loginProvider.errorType.add(2);
            }
            if(loginProvider.formValid == 'false'){
              loginProvider.errorType.add(0);
            }
          }
          loginProvider.notifyMe();
          // when user press continue to submit natID to reset password
        } else if(loginProvider.enabledSubmitButton && forgotPassword){
          try{
            await loginProvider.resetPasswordGetDetail(nationalIdController.text).whenComplete((){})
                .then((val){
              ResetPasswordGetDetail resetPasswordGetDetail = val;
              if(resetPasswordGetDetail.poStatusDescEn != null && resetPasswordGetDetail.poStatus == -1){
                loginProvider.errorMessage = UserConfig.instance.checkLanguage()
                    ? resetPasswordGetDetail.poStatusDescEn : resetPasswordGetDetail.poStatusDescAr;
              } else{
                loginProvider.errorMessage = '';
                userSecuredStorage.email = resetPasswordGetDetail.poEmail ?? ''; // poEmail -> user email
                userSecuredStorage.mobileNumber = resetPasswordGetDetail.poMobileno ?? ''; // poMobileno -> user mobile number
              }
              loginProvider.formValid = resetPasswordGetDetail.poStatus == 1 ? 'true' : 'false';
            });
          }catch(e){
            if (kDebugMode) {
              print(e.toString());
            }
          }
          loginProvider.errorType.clear();
          if(loginProvider.formValid == 'true'){
            loginProvider.formValid = 'null';
            loginProvider.errorType.length = 0;
            loginProvider.showResetPasswordBody = true;
          } else{
            _showMyDialog('resetPasswordFailed', loginProvider.errorMessage, 'retryAgain', themeNotifier);
            if(nationalIdController.text.isEmpty){
              loginProvider.errorType.add(1);
            }
            if(loginProvider.formValid == 'false'){
              loginProvider.errorType.add(0);
            }
          }
          loginProvider.notifyMe();
        }
      },
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(
            Provider.of<LoginProvider>(context).enabledSubmitButton &&
                (Provider.of<LoginProvider>(context).numberOfAttempts < 5 || forgotPassword)
                ? getPrimaryColor(context, themeNotifier) : Colors.grey,
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
    );
  }

  TextFormField buildTextFormField(themeNotifier, loginProvider, controller, inputType){
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
      // validator: (_){
      //   if(loginProvider.loginComplete == 'false'){
      //     return translate('loginError', context);
      //   }
      //   return null;
      // },
      decoration: InputDecoration(
        hintText: controller == nationalIdController
            ? translate('ex', context) + '9661001073'
            : '',
        // errorStyle: const TextStyle(fontSize: 0),
        // Provider.of<LoginProvider>(context).loginComplete == 'false'
        //     ? loginProvider.errorMessage
        //     : null,
        // errorText: Provider.of<LoginProvider>(context).loginComplete == 'false'
        //       ? loginProvider.errorMessage
        //       : null,
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
      onChanged: (val){
        if(!forgotPassword){
          loginProvider.enabledSubmitButton = (nationalIdController.text.isNotEmpty &&
              passwordController.text.isNotEmpty);
        }else{
          loginProvider.enabledSubmitButton = nationalIdController.text.isNotEmpty;
        }
        loginProvider.notifyMe();
      },
    );
  }

  Future<void> _showMyDialog(String title, String body, String buttonText, ThemeNotifier themeNotifier) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.white24,
      builder: (BuildContext context) {
        return BackdropFilter(
          filter: ui.ImageFilter.blur(
            sigmaX: 5.0,
            sigmaY: 5.0,
          ),
          child: AlertDialog(
            elevation: 20,
            alignment: Alignment.center,
            actionsAlignment: MainAxisAlignment.center,
            iconPadding: EdgeInsets.symmetric(vertical: height(0.035, context)),
            contentPadding: EdgeInsets.symmetric(
              horizontal: width(0.07, context),
              vertical: height(0.025, context),
            ),
            actionsPadding: EdgeInsets.symmetric(
              vertical: height(0.03, context),
              horizontal: width(0.07, context)
            ).copyWith(top: 0),
            icon: SvgPicture.asset('assets/icons/loginError.svg'),
            title: Text(
              translate(title, context),
              style: TextStyle(
                color: HexColor('#ED3124'),
                fontWeight: FontWeight.bold
              ),
            ),
            content: body != ''
            ? SingleChildScrollView(
              child: Container(
                alignment: Alignment.center,
                child: Text(
                  body,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: HexColor('#5F5F5F'),
                    fontWeight: FontWeight.w500
                  ),
                ),
              )
            ) : const SizedBox.shrink(),
            actions: <Widget>[
              TextButton(
                onPressed: () async {
                  Navigator.of(context).pop();
                },
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                      getPrimaryColor(context, themeNotifier),
                    ),
                    foregroundColor:  MaterialStateProperty.all<Color>(
                        Colors.white
                    ),
                    fixedSize:  MaterialStateProperty.all<Size>(
                      Size(width(1, context), height(0.05, context)),
                    ),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)
                        )
                    )
                ),
                child: Text(translate(buttonText, context)),
              ),
            ],
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0)),
            ),
          ),
        );
      },
    );
  }

}
