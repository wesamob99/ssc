// ignore_for_file: file_names
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';
import 'package:ssc/source/view/login/forgotPasswordComponents/resetPasswordBody.dart';
import 'package:ssc/source/view/login/registerComponents/secondStepBody.dart';
import 'package:ssc/source/viewModel/accountSettings/accountSettingsProvider.dart';
import 'package:ssc/utilities/hexColor.dart';
import 'package:ssc/utilities/theme/themes.dart';

import '../../../../infrastructure/userConfig.dart';
import '../../../../utilities/util.dart';
import '../../../viewModel/login/loginProvider.dart';
import '../../../viewModel/services/servicesProvider.dart';
import '../../../viewModel/utilities/theme/themeProvider.dart';
import '../../splash/splashScreen.dart';
import 'forthStepBody.dart';

class OTPScreen extends StatefulWidget {
  final String contactTarget;
  final String type;
  final int flag; /// 1 for register & 2 for update (mobile number & email) from profile screen
  const OTPScreen({Key key, this.contactTarget, this.type, this.flag = 1}) : super(key: key);

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {

  final pinController = TextEditingController();
  LoginProvider loginProvider;
  final focusNode = FocusNode();
  bool enableContinue = false;
  String errorMessage = "";

  @override
  void initState() {
    loginProvider = Provider.of<LoginProvider>(context, listen: false);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    ThemeNotifier themeNotifier = Provider.of<ThemeNotifier>(context);

    return Stack(
      children: [
        GestureDetector(
          onTap: (){
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: WillPopScope(
            onWillPop: () async => false,
            child: Scaffold(
              appBar: PreferredSize(
                preferredSize: const Size.fromHeight(10.0),
                child: AppBar(
                  backgroundColor: Colors.transparent,
                  leading: const SizedBox.shrink(),
                ),
              ),
              body: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 14.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          updateLanguageWidget(context)
                        ],
                      ),
                      SizedBox(height: height(0.06, context),),
                      SingleChildScrollView(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: width(0.05, context)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(height: height(0.05, context),),
                              Text(
                                widget.type == 'phone'
                                    ? translate('mobileNumberVerify', context)
                                    : translate('emailVerify', context),
                                style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: width(0.04, context)
                                ),
                              ),
                              SizedBox(height: height(0.04, context),),
                              Column(
                                children: [
                                  Text(
                                    widget.type == 'phone'
                                    ? translate('enterMobileVerificationCode', context)
                                    : translate('enterEmailVerificationCode2', context),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: width(0.034, context)
                                    ),
                                  ),
                                  SizedBox(height: height(0.015, context),),
                                  Text(
                                     widget.contactTarget != ''
                                     ? widget.type == 'phone'
                                        ? widget.contactTarget.replaceRange(0, widget.contactTarget.length - 2, '*' * (widget.contactTarget.length - 2))
                                        : widget.contactTarget.replaceRange(2, widget.contactTarget.indexOf('@'), '*' * (widget.contactTarget.indexOf('@')))
                                    : "**********",
                                    textDirection: TextDirection.ltr,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: width(0.034, context),
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(height: height(0.025, context),),
                              pinPut(themeNotifier),
                              SizedBox(height: height(0.072, context),),
                              textButton(
                                  themeNotifier, 'continue',
                                  MaterialStateProperty.all<Color>(pinController.text.length == 4
                                      ? getPrimaryColor(context, themeNotifier) : HexColor('#DADADA'),),
                                  pinController.text.length == 4 ? Colors.white : HexColor('#363636'),
                                      () async {if(pinController.length == 4){
                                        if(widget.flag == 1){
                                          errorMessage = "";
                                          loginProvider.isLoading = true;
                                          loginProvider.notifyMe();
                                          try{
                                            if(widget.type == 'phone') {
                                              await loginProvider.checkMobileOTP(
                                                  int.parse(widget.contactTarget),
                                                  "00962", int.parse(pinController.text), 0)
                                                  .then((value){
                                                if(value["PO_status_code"] == 0){
                                                  errorMessage = UserConfig.instance.checkLanguage()
                                                      ? "${value["PO_status_desc_en"]}" : "${value["PO_status_desc_ar"]}";
                                                  showMyDialog(context, 'registerFailed', errorMessage, 'retryAgain', themeNotifier);
                                                }else{
                                                  Navigator.of(context).push(
                                                    MaterialPageRoute(builder: (context) => const SecondStepBody()),
                                                  );
                                                }
                                              });
                                            } else{
                                              await loginProvider.checkRegisterEmailOTP(
                                                  widget.contactTarget,
                                                  int.parse(pinController.text), widget.type == "emailFromReset" ? 1 : 0)
                                                  .then((value){
                                                if(value["PO_status_code"] == 0){
                                                  errorMessage = UserConfig.instance.checkLanguage()
                                                      ? "${value["PO_status_desc_en"]}" : "${value["PO_status_desc_ar"]}";
                                                  showMyDialog(context, 'registerFailed', errorMessage, 'retryAgain', themeNotifier);
                                                }else{
                                                  Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                      builder: (context) => widget.type == "emailFromReset"
                                                          ? ResetPasswordBody(otpCode: pinController.text, email: widget.contactTarget,)
                                                          : const ForthStepBody(),
                                                    ),
                                                  );
                                                }
                                              });
                                            }
                                            loginProvider.isLoading = false;
                                            loginProvider.notifyMe();
                                          }catch(e){
                                            loginProvider.isLoading = false;
                                            loginProvider.notifyMe();
                                            if (kDebugMode) {
                                              print(e.toString());
                                            }
                                          }
                                        } else if(widget.flag == 2){
                                          AccountSettingsProvider accountSettingsProvider = Provider.of<AccountSettingsProvider>(context, listen: false);
                                          loginProvider.isLoading = true;
                                          loginProvider.notifyMe();
                                          String message = '';
                                          try{
                                            if(widget.type == 'phone'){
                                              await Provider.of<ServicesProvider>(context, listen: false).updateUserMobileNumberCheckOTP(pinController.text)
                                                  .whenComplete((){}).then((val){
                                                if(val['PO_STATUS'] == 1){
                                                  accountSettingsProvider.updateUserInfo(2, accountSettingsProvider.mobileNumberController.text).whenComplete((){}).then((value){
                                                    if(value["PO_STATUS"] == 0){
                                                      showMyDialog(context, 'mobileNumberUpdatedSuccessfully', message, 'ok', themeNotifier, titleColor: '#2D452E', icon: 'assets/icons/profileIcons/mobileNumberUpdated.svg').then((value) {
                                                        Navigator.of(context).pushAndRemoveUntil(
                                                            MaterialPageRoute(builder: (context) => const SplashScreen()),
                                                                (route) => false
                                                        );
                                                      });
                                                    }else{
                                                      message = UserConfig.instance.checkLanguage()
                                                          ? value["PO_STATUS_DESC_EN"] : value["PO_STATUS_DESC_AR"];
                                                      showMyDialog(context, 'updateMobileNumberFailed', message, 'retryAgain', themeNotifier);
                                                    }
                                                  });
                                                }else{
                                                  errorMessage = UserConfig.instance.checkLanguage()
                                                      ? val["PO_STATUS_DESC_EN"] : val["PO_STATUS_DESC_AR"];
                                                  showMyDialog(context, 'updateMobileNumberFailed', errorMessage, 'retryAgain', themeNotifier);
                                                }
                                              });
                                            } else{
                                              await Provider.of<ServicesProvider>(context, listen: false).updateUserEmailCheckOTP(accountSettingsProvider.emailController.text, int.tryParse(pinController.text), 1)
                                                  .whenComplete((){}).then((val){
                                                if(val['PO_status_code'] == 1){
                                                  accountSettingsProvider.updateUserInfo(3, accountSettingsProvider.emailController.text).whenComplete((){}).then((value){
                                                    if(value["PO_STATUS"] == 0){
                                                      showMyDialog(context, 'emailUpdatedSuccessfully', message, 'ok', themeNotifier, titleColor: '#2D452E', icon: 'assets/icons/profileIcons/emailUpdated.svg').then((value) {
                                                        Navigator.of(context).pushAndRemoveUntil(
                                                            MaterialPageRoute(builder: (context) => const SplashScreen()),
                                                                (route) => false
                                                        );
                                                      });
                                                    }else{
                                                      message = UserConfig.instance.checkLanguage()
                                                          ? value["PO_STATUS_DESC_EN"] : value["PO_STATUS_DESC_AR"];
                                                      showMyDialog(context, 'emailUpdateFailed', message, 'retryAgain', themeNotifier);
                                                    }
                                                  });
                                                }else{
                                                  message = UserConfig.instance.checkLanguage()
                                                      ? val["PO_status_desc_en"] : val["PO_status_desc_ar"];
                                                  showMyDialog(context, 'emailUpdateFailed', message, 'retryAgain', themeNotifier);
                                                }
                                              });
                                            }
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
                                  }}
                              ),
                              SizedBox(height: height(0.018, context),),
                              textButton(themeNotifier, 'cancel', MaterialStateProperty.all<Color>(
                                  HexColor('#DADADA')), HexColor('#363636'), (){
                                Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(builder: (context) => const SplashScreen()),
                                        (route) => false
                                );
                              }),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        if(context.watch<LoginProvider>().isLoading)
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
    );
  }

  Directionality pinPut(themeNotifier){
    Color focusedBorderColor = getPrimaryColor(context, themeNotifier);
    Color fillColor = const Color.fromRGBO(243, 246, 249, 0);
    Color borderColor = HexColor('#979797');

    final defaultPinTheme = PinTheme(
      width: width(isTablet(context) ? 0.11 : 0.14, context),
      height: width(isTablet(context) ? 0.11 : 0.14, context),
      textStyle: TextStyle(
        fontSize: width(0.08, context),
        color: getPrimaryColor(context, themeNotifier),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: borderColor),
      ),
    );
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Pinput(
        controller: pinController,
        inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[0-9]'))],
        focusNode: focusNode,
        androidSmsAutofillMethod:
        AndroidSmsAutofillMethod.smsUserConsentApi,
        listenForMultipleSmsOnAndroid: true,
        defaultPinTheme: defaultPinTheme,
        // onClipboardFound: (value) {
        //   debugPrint('onClipboardFound: $value');
        //   pinController.setText(value);
        // },
        hapticFeedbackType: HapticFeedbackType.lightImpact,
        onCompleted: (pin) {
          debugPrint('onCompleted: $pin');
          setState(() {
            enableContinue = true;
          });
        },
        onChanged: (value) {
          debugPrint('onChanged: $value');
          if(value.toString().length != 4){
            setState(() {
              enableContinue = true;
            });
          }
        },
        cursor: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 9),
              width: width(0.055, context),
              height: 1,
              color: focusedBorderColor,
            ),
          ],
        ),
        focusedPinTheme: defaultPinTheme.copyWith(
          decoration: defaultPinTheme.decoration.copyWith(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: focusedBorderColor),
          ),
        ),
        submittedPinTheme: defaultPinTheme.copyWith(
          decoration: defaultPinTheme.decoration.copyWith(
            color: fillColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: focusedBorderColor),
          ),
        ),
        errorPinTheme: defaultPinTheme.copyBorderWith(
          border: Border.all(color: Colors.redAccent),
        ),
      ),
    );
  }

  SizedBox textButton(themeNotifier, text, buttonColor, textColor, onPressed){
    return  SizedBox(
      width: width(0.7, context),
      child: TextButton(
        onPressed: onPressed,
        style: ButtonStyle(
            backgroundColor: buttonColor,
            foregroundColor:  MaterialStateProperty.all<Color>(
                Colors.white
            ),
            padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.symmetric(vertical: isTablet(context) ? 24 : 16.0)),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(
                      color: Colors.grey.shade600,
                      width: 0.4
                  )
              ),
            )
        ),
        child: Text(
          translate(text, context),
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.w300
          ),
        ),
      ),
    );
  }
}
