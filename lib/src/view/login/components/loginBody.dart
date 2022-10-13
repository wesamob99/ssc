// ignore_for_file: file_names, use_build_context_synchronously
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../infrastructure/userConfig.dart';
import '../../../../infrastructure/userSecuredStorage.dart';
import '../../../../models/login/resetPasswordGetDetail.dart';
import '../../../../models/login/userData.dart';
import '../../../../utilities/constants.dart';
import '../../../../utilities/hexColor.dart';
import '../../../../utilities/theme/themes.dart';
import '../../../../utilities/util.dart';
import '../../../viewModel/login/loginProvider.dart';
import '../../../viewModel/utilities/language/globalAppProvider.dart';
import '../../../viewModel/utilities/theme/themeProvider.dart';
import '../../main/mainScreen.dart';
import '../registerScreen.dart';
import 'resetPasswordBody.dart';

class LoginBody extends StatefulWidget {
  const LoginBody({Key key}) : super(key: key);

  @override
  State<LoginBody> createState() => _LoginBodyState();
}

class _LoginBodyState extends State<LoginBody> {

  LoginProvider loginProvider;
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
    return Stack(
      children: [
        Container(
          alignment: Alignment.bottomLeft,
          child: SvgPicture.asset(
              'assets/logo/logo_tree.svg'
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 14.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // SizedBox(height: height(0.08, context),),
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
                                      loginProvider.nationalIdController.clear();
                                      loginProvider.passwordController.clear();
                                      loginProvider.enabledSubmitButton = false;
                                      forgotPassword = false;
                                      loginProvider.showBottomNavigationBar = true;
                                      loginProvider.notifyMe();
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
                SizedBox(height: height(0.03, context),),
                if(forgotPassword)
                  Divider(
                    color: HexColor('#DADADA')
                  ),
                SizedBox(height: height(0.03, context),),
                Provider.of<LoginProvider>(context).showResetPasswordBody
                    ? const ResetPasswordBody()
                    : loginBodyWidget(themeNotifier)
              ],
            ),
          ),
        ),
      ],
    );
  }

  SingleChildScrollView loginBodyWidget(themeNotifier){
    return SingleChildScrollView(
      child: Column(
        children: [
          if(!forgotPassword)
            SvgPicture.asset('assets/logo/logo_with_name.svg'),
          if(!forgotPassword)
            SizedBox(height: height(0.04, context)),
          if(!forgotPassword)
            Text(
              translate('login', context),
              style: TextStyle(
                  fontSize: width(0.045, context),
                  fontWeight: FontWeight.w700
              ),
            ),
          if(!forgotPassword)
            SizedBox(height: height(0.04, context)),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                translate('enterNationalId', context),
              ),
              SizedBox(height: height(0.015, context)),
              buildTextFormField(themeNotifier, loginProvider,  loginProvider.nationalIdController, TextInputType.number),
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
                SizedBox(height: height(0.015, context)),
                buildTextFormField(themeNotifier, loginProvider,  loginProvider.passwordController, TextInputType.visiblePassword),
              ],
            ),
          // if(!forgotPassword)
          SizedBox(height: height(0.015, context)),
          if(!forgotPassword)
            InkWell(
              onTap: (){
                setState(() {
                  forgotPassword = true;
                  loginProvider.showBottomNavigationBar = false;
                  loginProvider.nationalIdController.clear();
                  loginProvider.passwordController.clear();
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
                InkWell(
                  onTap: (){
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => const RegisterScreen())
                    );
                  },
                  child: Text(
                    translate('register', context),
                    style: TextStyle(
                        color: HexColor('#003C97')
                    ),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  TextButton submitButton(themeNotifier){
    return  TextButton(
      onPressed: () async {
        // when user press continue to login
        if(loginProvider.enabledSubmitButton && !forgotPassword && loginProvider.numberOfAttempts < 5){
          String errorMessage = "";
          try{
            await loginProvider.login( loginProvider.nationalIdController.text,  loginProvider.passwordController.text)
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
                errorMessage = UserConfig.instance.checkLanguage()
                    ? userData.poStatusDescEn : userData.poStatusDescAr;
              } else{
                errorMessage = '';
              }
              if(userData.token != null){
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => const MainScreen()), (route) => false);
              }else{
                loginProvider.numberOfAttempts++;
                if(loginProvider.numberOfAttempts > 4){
                  showMyDialog(context, 'exceedNumberOfAllowedAttempts', loginProvider.numberOfAttempts > 4 ? "" : errorMessage, 'resetPassword', themeNotifier);
                }else{
                  showMyDialog(context, 'loginFailed', errorMessage, 'retryAgain', themeNotifier);
                }
              }
              loginProvider.notifyMe();
            });
          }catch(e){
            if (kDebugMode) {
              print(e.toString());
            }
          }
          // when user press continue to submit natID to reset password
        } else if(loginProvider.enabledSubmitButton && forgotPassword){
          String errorMessage = "";
          try{
            await loginProvider.resetPasswordGetDetail( loginProvider.nationalIdController.text).whenComplete((){})
                .then((val) async {
              ResetPasswordGetDetail resetPasswordGetDetail = val;
              if(resetPasswordGetDetail.poStatusDescEn != null && resetPasswordGetDetail.poStatus == -1){
                errorMessage = UserConfig.instance.checkLanguage()
                    ? resetPasswordGetDetail.poStatusDescEn : resetPasswordGetDetail.poStatusDescAr;
              } else{
                errorMessage = '';
                userSecuredStorage.email = resetPasswordGetDetail.poEmail ?? ''; // poEmail -> user email
                userSecuredStorage.mobileNumber = resetPasswordGetDetail.poMobileno ?? ''; // poMobileno -> user mobile number
                userSecuredStorage.nationalId =  loginProvider.nationalIdController.text ?? ''; // poUserName -> user national ID
                await loginProvider.resetPasswordSendMobileOTP( loginProvider.nationalIdController.text).then((value){
                  print(value);
                });
              }
              if(resetPasswordGetDetail.poStatus == 1){
                loginProvider.showResetPasswordBody = true;
                forgotPassword = false;
                loginProvider.showBottomNavigationBar = false;
              }else{
                showMyDialog(context, 'resetPasswordFailed', errorMessage, 'retryAgain', themeNotifier);
              }
              loginProvider.notifyMe();
            });
          }catch(e){
            if (kDebugMode) {
              print(e.toString());
            }
          }
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
    return TextFormField(
      controller: controller,
      keyboardType: inputType,
      obscureText: controller ==  loginProvider.passwordController ? obscurePassword : false,
      decoration: InputDecoration(
          hintText: controller ==  loginProvider.nationalIdController
              ? translate('ex', context) + '9661001073'
              : '',
          hintStyle: TextStyle(
              color: getGrey2Color(context).withOpacity(
                  themeNotifier.isLight()
                      ? 1 : 0.5
              ),
              fontSize: 14
          ),
          suffixIcon: controller ==  loginProvider.passwordController
          ? InkWell(
            onTap: (){
              setState(() {
                obscurePassword = !obscurePassword;
              });
            },
            child: Icon(
              obscurePassword ? Icons.remove_red_eye : Icons.remove_red_eye_outlined,
              size: 23,
              color: themeNotifier.isLight()
                  ? getPrimaryColor(context, themeNotifier)
                  : Colors.white,
            ),
          ) : const SizedBox.shrink(),
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
          loginProvider.enabledSubmitButton = ( loginProvider.nationalIdController.text.isNotEmpty &&
              loginProvider.passwordController.text.isNotEmpty);
        }else{
          loginProvider.enabledSubmitButton =  loginProvider.nationalIdController.text.isNotEmpty;
        }
        loginProvider.notifyMe();
      },
    );
  }

}