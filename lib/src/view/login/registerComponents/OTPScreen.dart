// ignore_for_file: file_names
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ssc/src/view/login/registerComponents/secondStepBody.dart';
import 'package:ssc/utilities/hexColor.dart';
import 'package:ssc/utilities/theme/themes.dart';

import '../../../../infrastructure/userConfig.dart';
import '../../../../utilities/constants.dart';
import '../../../../utilities/util.dart';
import '../../../viewModel/login/loginProvider.dart';
import '../../../viewModel/utilities/language/globalAppProvider.dart';
import '../../../viewModel/utilities/theme/themeProvider.dart';
import '../../splash/splashScreen.dart';
import 'forthStepBody.dart';

class OTPScreen extends StatefulWidget {
  final String contactTarget;
  final String type;
  const OTPScreen({Key key, this.contactTarget, this.type}) : super(key: key);

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {

  Future<SharedPreferences> prefs = SharedPreferences.getInstance();
  final pinController = TextEditingController();
  LoginProvider loginProvider;
  final focusNode = FocusNode();
  bool enableContinue = false;
  String errorMessage = "";
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
    getAppLanguage();
    loginProvider = Provider.of<LoginProvider>(context, listen: false);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    ThemeNotifier themeNotifier = Provider.of<ThemeNotifier>(context);
    GlobalAppProvider globalAppProvider = Provider.of<GlobalAppProvider>(context);

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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
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
                                        errorMessage = "";
                                        loginProvider.isLoading = true;
                                        loginProvider.notifyMe();
                                        try{
                                          if(widget.type == 'phone') {
                                            await loginProvider.checkRegisterMobileOTP(
                                              int.parse(widget.contactTarget),
                                              "00962", int.parse(pinController.text))
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
                                                int.parse(pinController.text))
                                                .then((value){
                                              if(value["PO_status_code"] == 0){
                                                errorMessage = UserConfig.instance.checkLanguage()
                                                    ? "${value["PO_status_desc_en"]}" : "${value["PO_status_desc_ar"]}";
                                                showMyDialog(context, 'registerFailed', errorMessage, 'retryAgain', themeNotifier);
                                              }else{
                                                Navigator.of(context).push(
                                                  MaterialPageRoute(builder: (context) => const ForthStepBody()),
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
          height: height(0.78, context),
          color: Colors.white70,
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
            padding: MaterialStateProperty.all<EdgeInsets>(const EdgeInsets.symmetric(vertical: 16.0)),
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
