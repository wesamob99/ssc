// ignore_for_file: use_build_context_synchronously, file_names

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../../../infrastructure/userConfig.dart';
import '../../../infrastructure/userSecuredStorage.dart';
import '../../../models/login/resetPasswordGetDetail.dart';
import '../../../utilities/hexColor.dart';
import '../../../utilities/theme/themes.dart';
import '../../../utilities/util.dart';
import '../../viewModel/login/loginProvider.dart';
import '../../viewModel/utilities/theme/themeProvider.dart';
import 'forgotPasswordComponents/forgotPasswordBody.dart';
import 'dart:math' as math;

class ForgotPasswordScreen extends StatefulWidget {
  final bool submitButtonEnabled;
  const ForgotPasswordScreen({Key key, this.submitButtonEnabled = false}) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {

  LoginProvider loginProvider;
  bool showError = false;

  UserSecuredStorage userSecuredStorage = UserSecuredStorage.instance;
  bool showResetPasswordBody;

  @override
  void initState() {
    loginProvider = Provider.of<LoginProvider>(context, listen: false);
    ///login
    loginProvider.numberOfAttempts = 0;
    loginProvider.enabledSubmitButton = false;
    /// forgot password
    loginProvider.enabledSendCodeButton = false;
    loginProvider.enabledSubmitButton = widget.submitButtonEnabled;
    showResetPasswordBody = false;
    /// all
    loginProvider.isLoading = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ThemeNotifier themeNotifier = Provider.of<ThemeNotifier>(context);
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(10.0),
        child: AppBar(
          backgroundColor: Colors.transparent,
          leading: const SizedBox.shrink(),
        ),
      ),
      body: GestureDetector(
        onTap: (){
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Stack(
          children: [
            Stack(
              children: [
                Opacity(
                  opacity: 0.5,
                  child: Container(
                    alignment: Alignment.bottomLeft,
                    child: SvgPicture.asset(
                      'assets/logo/logo_tree.svg',
                      color: themeNotifier.isLight()
                          ? HexColor('#5D6470')
                          : Colors.white,
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
                          mainAxisAlignment: !showResetPasswordBody ? MainAxisAlignment.spaceBetween : MainAxisAlignment.end,
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
                                              color: themeNotifier.isLight()
                                              ? HexColor('#5D6470')
                                              : Colors.white,
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
                            updateLanguageWidget(context)
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
            if(loginProvider.isLoading)
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: width(1, context),
              height: height(1, context),
              color: themeNotifier.isLight() ? Colors.white70 : Colors.black45,
              child: Center(
                child: animatedLoader(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  SizedBox submitButton(themeNotifier){
    return  SizedBox(
      width: width(0.7, context),
      child: TextButton(
        onPressed: () async {
          if(loginProvider.enabledSubmitButton){
            String errorMessage = "";
            loginProvider.isLoading = true;
            loginProvider.notifyMe();
            try{
              // ignore: prefer_typing_uninitialized_variables
              var response;
              await loginProvider.resetPasswordGetDetail(loginProvider.nationalIdController.text).whenComplete((){})
                  .then((val) async {
                ResetPasswordGetDetail resetPasswordGetDetail = val;
                if(resetPasswordGetDetail.poStatusDescEn != null && resetPasswordGetDetail.poStatus == -1){
                  errorMessage = UserConfig.instance.checkLanguage()
                      ? resetPasswordGetDetail.poStatusDescEn : resetPasswordGetDetail.poStatusDescAr;
                } else{
                  errorMessage = '';
                  userSecuredStorage.email = resetPasswordGetDetail.poEmail ?? ''; // poEmail -> user email
                  userSecuredStorage.mobileNumber = resetPasswordGetDetail.poMobileno ?? ''; // poMobileno -> user mobile number
                  userSecuredStorage.realMobileNumber = resetPasswordGetDetail.poRealMobileno.toString() ?? ''; // realMobileNumber -> user real mobile number
                  userSecuredStorage.nationalId =  loginProvider.nationalIdController.text ?? ''; // poUserName -> user national ID
                  userSecuredStorage.internationalCode =  resetPasswordGetDetail.poInternationalcode ?? ''; // poInternationalcode -> country code
                  response = await loginProvider.sendMobileOTP(int.parse(userSecuredStorage.realMobileNumber), userSecuredStorage.internationalCode.toString(), 1);
                }
                if(resetPasswordGetDetail.poStatus == 1 && response != null && response["PO_status"] != null && response["PO_status"] == 1){
                  setState((){
                    showResetPasswordBody = true;
                  });
                }else{
                  if(errorMessage == ''){
                    errorMessage = UserConfig.instance.checkLanguage()
                        ? response["PO_STATUS_DESC_EN"] : response["PO_STATUS_DESC_AR"];
                  }
                  showMyDialog(context, 'resetPasswordFailed', errorMessage, 'retryAgain', themeNotifier);
                }
                loginProvider.notifyMe();
              });
              loginProvider.isLoading = false;
              loginProvider.notifyMe();
            }catch(e){
              loginProvider.isLoading = false;
              loginProvider.notifyMe();
              if (kDebugMode) {
                print(e.toString());
              }
            }
          }
        },
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(
              Provider.of<LoginProvider>(context).enabledSubmitButton
                  ? themeNotifier.isLight()
                  ? primaryColor : HexColor('#445740') : Colors.grey,
            ),
            foregroundColor:  MaterialStateProperty.all<Color>(
                Colors.white
            ),
            padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.symmetric(vertical: isTablet(context) ? 24 : 16.0)),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)
                )
            )
        ),
        child: Text(translate('continue', context), style: const TextStyle(
            fontWeight: FontWeight.w300),),
      ),
    );
  }

  TextFormField buildTextFormField(themeNotifier, loginProvider, controller, inputType){
    return TextFormField(
      controller: controller,
      keyboardType: inputType,
      inputFormatters: (inputType == TextInputType.number) ? [FilteringTextInputFormatter.allow(RegExp('[0-9]'))] : [],
      style: const TextStyle(
        fontSize: 15
      ),
      cursorColor: themeNotifier.isLight()
          ? getPrimaryColor(context, themeNotifier)
          : Colors.white,
      cursorWidth: 1,
      decoration: InputDecoration(
          hintText: translate('ex', context) + '9999999999',
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
              color: themeNotifier.isLight()
                  ? getPrimaryColor(context, themeNotifier)
                  : Colors.white,
              width: 0.5,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
            borderSide: BorderSide(
              color: themeNotifier.isLight()
                  ? getPrimaryColor(context, themeNotifier)
                  : Colors.white,
              width: 0.8,
            ),
          )
      ),
      onChanged: (val){
        loginProvider.enabledSubmitButton =  loginProvider.nationalIdController.text.length == 10;
        loginProvider.notifyMe();
      },
    );
  }
}
