// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';

import '../../../../../utilities/hexColor.dart';
import '../../../../../utilities/util.dart';
import '../../../../utilities/theme/themes.dart';
import '../../../viewModel/services/servicesProvider.dart';
import '../../../viewModel/utilities/theme/themeProvider.dart';

class VerifyMobileNumberScreen extends StatefulWidget {
  final String nextStep;
  final int numberOfSteps;
  final String mobileNo;
  const VerifyMobileNumberScreen({Key key, this.nextStep, this.numberOfSteps, this.mobileNo}) : super(key: key);

  @override
  State<VerifyMobileNumberScreen> createState() => _VerifyMobileNumberScreenState();
}

class _VerifyMobileNumberScreenState extends State<VerifyMobileNumberScreen> {
  ServicesProvider servicesProvider;

  @override
  void initState() {
    servicesProvider = Provider.of<ServicesProvider>(context, listen: false);
    servicesProvider.pinPutFilled = false;
    servicesProvider.pinPutCodeController.clear();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ThemeNotifier themeNotifier = Provider.of<ThemeNotifier>(context);
    return Container(
      alignment: Alignment.topCenter,
      height: isTablet(context) ? height(0.78, context) : isScreenHasSmallHeight(context) ? height(0.73, context) : height(0.75, context),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: height(0.02, context),),
                Text(
                  getTranslated('mobileNumberVerify', context),
                  style: TextStyle(
                      color: HexColor('#5F5F5F'),
                      fontSize: width(0.035, context)
                  ),
                ),
                SizedBox(height: height(0.01, context),),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox.shrink(),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '1/${widget.numberOfSteps}',
                          style: TextStyle(
                              color: HexColor('#979797'),
                              fontSize: width(0.025, context)
                          ),
                        ),
                        Text(
                          '${getTranslated('next', context)}: ${getTranslated(widget.nextStep, context)}',
                          style: TextStyle(
                              color: HexColor('#979797'),
                              fontSize: width(0.032, context)
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: isTablet(context) ? height(0.6, context) : isScreenHasSmallHeight(context) ? height(0.55, context) : height(0.57, context),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    getTranslated('mobileNumberVerify', context),
                    style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: width(0.04, context)
                    ),
                  ),
                  SizedBox(height: height(0.03, context),),
                  Column(
                    children: [
                      Text(
                        getTranslated('enterMobileVerificationCode', context),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: width(0.034, context)
                        ),
                      ),
                      SizedBox(height: height(0.03, context),),
                      Text(
                        widget.mobileNo,
                        textDirection: TextDirection.ltr,
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: width(0.034, context),
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: height(0.04, context),),
                  pinPut(themeNotifier),
                ],
              ),
            ),
          ],
        ),
      ),
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
        controller: servicesProvider.pinPutCodeController,
        inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[0-9]'))],
        focusNode: FocusNode(),
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
        },
        onChanged: (value) {
          debugPrint('onChanged: $value');
          if(value.toString().length != 4){
            servicesProvider.pinPutFilled = false;
          } else{
            servicesProvider.pinPutFilled = true;
          }
          servicesProvider.notifyMe();
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
}
