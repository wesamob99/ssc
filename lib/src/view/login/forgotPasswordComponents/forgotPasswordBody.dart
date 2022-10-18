// ignore_for_file: file_names
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';
import 'package:ssc/infrastructure/userConfig.dart';
import 'package:ssc/utilities/hexColor.dart';
import 'package:ssc/utilities/theme/themes.dart';

import '../../../../infrastructure/userSecuredStorage.dart';
import '../../../../utilities/util.dart';
import '../../../viewModel/login/loginProvider.dart';
import '../../../viewModel/utilities/theme/themeProvider.dart';
import '../../splash/splashScreen.dart';

class ForgotPasswordBody extends StatefulWidget {
  const ForgotPasswordBody({Key key}) : super(key: key);

  @override
  State<ForgotPasswordBody> createState() => _ForgotPasswordBodyState();
}

class _ForgotPasswordBodyState extends State<ForgotPasswordBody> {
  final pinController = TextEditingController();
  final emailController = TextEditingController();
  LoginProvider loginProvider;
  final focusNode = FocusNode();
  bool enableContinue = false;
  bool useAnotherMethod = false;
  String errorMessage = "";
  int endTime = DateTime.now().millisecondsSinceEpoch + 300000;
  bool isTimerEnded = false;

  @override
  void initState() {
    loginProvider = Provider.of<LoginProvider>(context, listen: false);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    ThemeNotifier themeNotifier = Provider.of<ThemeNotifier>(context);
    UserSecuredStorage userSecuredStorage = UserSecuredStorage.instance;
    return WillPopScope(
      onWillPop: () async => false,
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: width(0.05, context)),
          child: Column(
            children: [
              SizedBox(height: height(0.05, context),),
              Text(
                translate('identityVerify', context),
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: width(0.04, context)
                ),
              ),
              SizedBox(height: height(0.04, context),),
              Column(
                children: [
                  Text(
                    translate(useAnotherMethod ? 'enterEmailVerificationCode' : 'enterMobileVerificationCode', context)
                    + (useAnotherMethod ? '  ${userSecuredStorage.email}' : ''),
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: width(0.034, context)
                    ),
                  ),
                  SizedBox(height: height(0.015, context),),
                  if(!useAnotherMethod)
                  Text(
                    userSecuredStorage.mobileNumber,
                    textDirection: TextDirection.ltr,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: width(0.034, context),
                    ),
                  )
                ],
              ),
              SizedBox(height: height(0.025, context),),
              if(!useAnotherMethod)
              pinPut(themeNotifier),
              if(useAnotherMethod)
              buildTextFormField(themeNotifier, loginProvider, emailController, TextInputType.emailAddress),
              SizedBox(height: height(0.022, context),),
              InkWell(
                onTap: (){
                  setState(() {
                    useAnotherMethod = true;
                  });
                },
                overlayColor: MaterialStateProperty.all<Color>(
                    Colors.transparent
                ),
                splashColor: getPrimaryColor(context, themeNotifier),
                child: Container(
                  alignment: UserConfig.instance.checkLanguage()
                      ? Alignment.topLeft : Alignment.topRight,
                  // padding: EdgeInsets.symmetric(horizontal: width(0.11, context)),
                  child: Text(
                    translate(useAnotherMethod ?'dontHaveAnyMethod' : 'useAnotherMethod', context),
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: width(0.033, context),
                        color: HexColor('#003C97')
                    ),
                  ),
                ),
              ),
              SizedBox(height: height(0.05, context),),
              if(!useAnotherMethod)
              Padding(
                padding: EdgeInsets.symmetric(vertical: height(0.02, context)),
                child: Column(
                  children: [
                    Directionality(
                      textDirection: TextDirection.ltr,
                      child: Container(
                        alignment: Alignment.center,
                        width: width(isTimerEnded ? 0.5 : 0.23, context),
                        height: height(0.04, context),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                                color: HexColor('#A4A4A4')
                            )
                        ),
                        child: CountdownTimer(
                          textStyle: TextStyle(color: HexColor('#FF0000')),
                          endWidget: Container(
                            alignment: Alignment.center,
                            child: Text(
                              'code has been disabled',
                              style: TextStyle(color: HexColor('#FF0000')),
                            ),
                          ),
                          endTime: endTime,
                          onEnd: () {
                            setState(() {
                              isTimerEnded = true;
                            });
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: height(0.01, context),),
                    InkWell(
                      onTap: () async{
                        if(isTimerEnded) {
                          await loginProvider.resetPasswordSendMobileOTP(loginProvider.nationalIdController.text);
                          setState((){
                            endTime = DateTime.now().millisecondsSinceEpoch + 300000;
                          });
                        }
                      },
                      child: Text(
                        'إعاده الارسال',
                        style: TextStyle(color: isTimerEnded ? HexColor('#003C97') : HexColor('#DADADA')),
                      )
                    ),
                  ],
                ),
              ),
              SizedBox(height: height(0.05, context),),
              if(useAnotherMethod)
                textButton(
                  themeNotifier, 'sendCode',
                  MaterialStateProperty.all<Color>(
                    (!Provider.of<LoginProvider>(context).enabledSendCodeButton || !isEmail(emailController.text))
                      ? HexColor('#DADADA') : getPrimaryColor(context, themeNotifier),),
                      (!Provider.of<LoginProvider>(context).enabledSendCodeButton || !isEmail(emailController.text))
                          ? HexColor('#363636') : Colors.white,
                      () async {if(loginProvider.enabledSendCodeButton && isEmail(emailController.text)){
                        errorMessage = "";
                        //TODO: : check if [emailController.text] is the real email before send the code
                        try{
                          await loginProvider.resetPasswordSendEmailCode(userSecuredStorage.nationalId)
                              .then((value){
                            if(value["PO_STATUS"] == 1){
                              errorMessage = UserConfig.instance.checkLanguage()
                                  ? "${value["PO_STATUS_DESC_EN"]}" : "${value["PO_STATUS_DESC_AR"]}";
                              showMyDialog(context, 'resetPassword', errorMessage, 'ok', themeNotifier, titleColor: '#445740', icon: 'assets/icons/emailSent.svg').then((value){
                                if (!mounted) return;
                                Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(builder: (context) => const SplashScreen()),
                                        (route) => false
                                );
                              });
                            }else{
                              errorMessage = UserConfig.instance.checkLanguage()
                                  ? "${value["PO_STATUS_DESC_EN"]}" : "${value["PO_STATUS_DESC_AR"]}";
                              showMyDialog(context, 'resetPasswordFailed', errorMessage, 'retryAgain', themeNotifier);
                            }
                          });
                        }catch(e){
                          if (kDebugMode) {
                            print(e.toString());
                          }
                        }
                  }}),
              if(!useAnotherMethod)
              textButton(
                themeNotifier, 'continue',
                MaterialStateProperty.all<Color>(pinController.text.length == 4
                ? getPrimaryColor(context, themeNotifier) : HexColor('#DADADA'),),
                pinController.text.length == 4 ? Colors.white : HexColor('#363636'),
                  () async {if(pinController.length == 4){
                    errorMessage = "";
                    try{
                    await loginProvider.resetPasswordCheckMobileOTP(
                        userSecuredStorage.nationalId,
                        int.parse(pinController.text))
                        .then((value){
                      if(value["PO_STATUS"] == 0){
                        errorMessage = UserConfig.instance.checkLanguage()
                            ? "${value["PO_STATUS_DESC_EN"]}" : "${value["PO_STATUS_DESC_AR"]}";
                        showMyDialog(context, 'resetPasswordFailed', errorMessage, 'retryAgain', themeNotifier);
                      }else{
                        if (kDebugMode) {
                          print("true OTP");
                        }
                      }
                    });
                    }catch(e){
                      if (kDebugMode) {
                        print(e.toString());
                      }
                    }
                  }}),
              SizedBox(height: height(0.018, context),),
              textButton(themeNotifier, 'cancel', MaterialStateProperty.all<Color>(
                HexColor('#DADADA')), HexColor('#363636'), (){
                if (!mounted) return;
                Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const SplashScreen()),
                        (route) => false
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  Directionality pinPut(themeNotifier){
    Color focusedBorderColor = getPrimaryColor(context, themeNotifier);
    Color fillColor = const Color.fromRGBO(243, 246, 249, 0);
    Color borderColor = HexColor('#979797');

    final defaultPinTheme = PinTheme(
      width: width(0.14, context),
      height: width(0.14, context),
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

  TextButton textButton(themeNotifier, text, buttonColor, textColor, onPressed){
    return  TextButton(
      onPressed: onPressed,
      style: ButtonStyle(
          backgroundColor: buttonColor,
          foregroundColor:  MaterialStateProperty.all<Color>(
              Colors.white
          ),
          fixedSize:  MaterialStateProperty.all<Size>(
            Size(width(0.7, context), height(0.055, context)),
          ),
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
          color: textColor
        ),
      ),
    );
  }

  TextFormField buildTextFormField(themeNotifier, LoginProvider loginProvider, controller, inputType){
    return TextFormField(
      controller: controller,
      keyboardType: inputType,
      decoration: InputDecoration(
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
        loginProvider.enabledSendCodeButton = emailController.text.isNotEmpty;
        loginProvider.notifyMe();
      },
    );
  }

}
