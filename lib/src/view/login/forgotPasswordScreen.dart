// ignore_for_file: use_build_context_synchronously, file_names

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../infrastructure/userConfig.dart';
import '../../../infrastructure/userSecuredStorage.dart';
import '../../../models/login/resetPasswordGetDetail.dart';
import '../../../utilities/constants.dart';
import '../../../utilities/hexColor.dart';
import '../../../utilities/theme/themes.dart';
import '../../../utilities/util.dart';
import '../../viewModel/login/loginProvider.dart';
import '../../viewModel/utilities/language/globalAppProvider.dart';
import '../../viewModel/utilities/theme/themeProvider.dart';
import 'forgotPasswordComponents/forgotPasswordBody.dart';
import 'dart:math' as math;

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key key}) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {

  LoginProvider loginProvider;
  bool showError = false;

  Future<SharedPreferences> prefs = SharedPreferences.getInstance();
  UserSecuredStorage userSecuredStorage = UserSecuredStorage.instance;
  String selectedLanguage;
  bool showResetPasswordBody;

  getAppLanguage(){
    prefs.then((value) {
      selectedLanguage = value.getString('language_code') ?? 'en';
    });
  }

  @override
  void initState() {
    loginProvider = Provider.of<LoginProvider>(context, listen: false);
    ///login
    loginProvider.passwordController.clear();
    loginProvider.numberOfAttempts = 0;
    loginProvider.nationalIdController.clear();
    loginProvider.enabledSubmitButton = false;
    /// forgot password
    loginProvider.enabledSendCodeButton = false;
    loginProvider.nationalIdController.clear();
    loginProvider.enabledSubmitButton = false;
    showResetPasswordBody = false;
    getAppLanguage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ThemeNotifier themeNotifier = Provider.of<ThemeNotifier>(context);
    GlobalAppProvider globalAppProvider = Provider.of<GlobalAppProvider>(context);
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(10.0),
        child: AppBar(
          backgroundColor: Colors.transparent,
          leading: const SizedBox.shrink(),
        ),
      ),
      body: Stack(
        children: [
          Opacity(
            opacity: 0.5,
            child: Container(
              alignment: Alignment.bottomLeft,
              child: SvgPicture.asset(
                  'assets/logo/logo_tree.svg'
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 14.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if(!showResetPasswordBody)
                        Container(
                            alignment: Alignment.topLeft,
                            child: Row(
                              children: [
                                InkWell(
                                  onTap: (){
                                    Navigator.pop(context);
                                    setState(() {
                                      loginProvider.nationalIdController.clear();
                                      loginProvider.passwordController.clear();
                                      loginProvider.enabledSubmitButton = false;
                                      loginProvider.notifyMe();
                                    });
                                  },
                                  child: Transform.rotate(
                                    angle: UserConfig.instance.checkLanguage()
                                        ? -math.pi / 1.0 : 0,
                                    child: SvgPicture.asset(
                                      'assets/icons/back.svg',
                                    ),
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
                                value: UserConfig.instance.checkLanguage() ? 'en' : 'ar',
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
                  if(!showResetPasswordBody)
                  Divider(
                    color: HexColor('#DADADA')
                  ),
                  SizedBox(height: height(0.03, context),),
                  if(!showResetPasswordBody)
                  SingleChildScrollView(
                    child: Column(
                      children: [
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
                        SizedBox(height: height(0.1, context)),
                        submitButton(themeNotifier),
                        SizedBox(height: height(0.04, context)),
                      ],
                    ),
                  ),
                  if(showResetPasswordBody)
                  const ForgotPasswordBody()
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  TextButton submitButton(themeNotifier){
    return  TextButton(
      onPressed: () async {
        if(loginProvider.enabledSubmitButton){
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
                await loginProvider.resetPasswordSendMobileOTP(loginProvider.nationalIdController.text);
              }
              if(resetPasswordGetDetail.poStatus == 1){
                setState((){
                  showResetPasswordBody = true;
                });
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
            Provider.of<LoginProvider>(context).enabledSubmitButton
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
      decoration: InputDecoration(
          hintText: translate('ex', context) + '9661001073',
          hintStyle: TextStyle(
              color: getGrey2Color(context).withOpacity(
                  themeNotifier.isLight()
                      ? 1 : 0.5
              ),
              fontSize: 14
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
        loginProvider.enabledSubmitButton =  loginProvider.nationalIdController.text.isNotEmpty;
        loginProvider.notifyMe();
      },
    );
  }
}
