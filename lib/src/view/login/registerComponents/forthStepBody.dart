import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ssc/src/view/login/registerScreen.dart';

import '../../../../utilities/hexColor.dart';
import '../../../../utilities/theme/themes.dart';
import '../../../../utilities/util.dart';
import '../../../viewModel/login/loginProvider.dart';
import '../../../viewModel/utilities/theme/themeProvider.dart';
import '../../splash/splashScreen.dart';

class ForthStepBody extends StatefulWidget {
  const ForthStepBody({Key key}) : super(key: key);

  @override
  State<ForthStepBody> createState() => _ForthStepBodyState();
}

class _ForthStepBodyState extends State<ForthStepBody> {

  bool termsChecked = false;
  List<String> validators = ["pwValidator1", "pwValidator2", "pwValidator3", "pwValidator4"];
  List<bool> validatorsCheck = [false, false, false, false];
  getTextStyle(context, isColored){
    return TextStyle(
      color: isColored ? HexColor('#003C97') : HexColor('#595959'),
      fontSize: width(0.03, context)
    );
  }

  @override
  Widget build(BuildContext context) {
    ThemeNotifier themeNotifier = Provider.of<ThemeNotifier>(context);
    LoginProvider loginProvider = Provider.of<LoginProvider>(context, listen: false);

    return WillPopScope(
      onWillPop: () async => false,
      child: RegisterScreen(
        stepNumber: 4,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: height(0.02, context),),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      translate('forthStep', context),
                      style: TextStyle(
                          color: HexColor('#979797'),
                          fontSize: width(0.03, context)
                      ),
                    ),
                    SizedBox(height: height(0.006, context),),
                    Text(
                      translate('setPassword2', context),
                      style: TextStyle(
                          color: HexColor('#5F5F5F'),
                          fontSize: width(0.035, context)
                      ),
                    ),
                  ],
                ),
                SizedBox(height: height(0.01, context),),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox.shrink(),
                    Text(
                      translate('finished', context),
                      style: TextStyle(
                          color: HexColor('#979797'),
                          fontSize: width(0.032, context)
                      ),
                    ),
                  ],
                ),
                SizedBox(height: height(0.02, context),),
                Text(
                  translate('password', context),
                  style: TextStyle(
                      color: HexColor('#363636'),
                      fontSize: width(0.032, context)
                  ),
                ),
                SizedBox(height: height(0.015, context),),
                buildTextFormField(context, themeNotifier, loginProvider, loginProvider.registerPasswordController, '', (val){
                  passwordValidator(val, loginProvider);
                }, isPassword: false),
                SizedBox(height: height(0.02, context),),
                Text(
                  translate('confirmPassword', context),
                  style: TextStyle(
                      color: HexColor('#363636'),
                      fontSize: width(0.032, context)
                  ),
                ),
                SizedBox(height: height(0.015, context),),
                buildTextFormField(context, themeNotifier, loginProvider, loginProvider.registerConfirmPasswordController, '', (val){
                  passwordValidator(val, loginProvider);
                }, isPassword: false),
                SizedBox(height: height(0.01, context),),
                SizedBox(
                  height: height(0.16, context),
                  child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: 4,
                      itemBuilder: (context, index){
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: width(1, context),
                              height: height(0.02, context),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    radius: 5.5,
                                    backgroundColor: HexColor('#A6A6A6'),
                                    child: CircleAvatar(
                                      radius: 5,
                                      backgroundColor: validatorsCheck[index]
                                          ? HexColor('#445740') : HexColor('#A6A6A6'),
                                    ),
                                  ),
                                  SizedBox(width: width(0.01, context),),
                                  Text(
                                    translate(validators[index], context),
                                    style: TextStyle(
                                        color: validatorsCheck[index]
                                            ? HexColor('#445740') : HexColor('#A6A6A6'),
                                        fontSize: width(0.03, context)
                                    ),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(height: height(0.01, context))
                          ],
                        );
                      }
                  ),
                )
              ],
            ),
            SizedBox(height: height(0.13, context),),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  onTap: (){
                    setState(() {
                      termsChecked = !termsChecked;
                    });
                    loginProvider.registerContinueEnabled = (loginProvider.registerPasswordController.text.isNotEmpty &&
                        loginProvider.registerConfirmPasswordController.text.isNotEmpty && termsChecked);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(3.0),
                    decoration: BoxDecoration(
                        color: HexColor('#DADADA'),
                        borderRadius: BorderRadius.circular(3.0)
                    ),
                    child: Container(
                      width: width(0.04, context),
                      height: width(0.04, context),
                      decoration: BoxDecoration(
                          color: termsChecked ? HexColor('#2D452E') : HexColor('#DADADA'),
                          borderRadius: BorderRadius.circular(4.0)
                      ),
                    ),
                  ),
                ),
                SizedBox(width: width(0.05, context),),
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(translate('termsAndConditionsAndPoliciesAgreement1', context), style: getTextStyle(context, false),),
                        Text(translate('termsAndConditionsAndPoliciesAgreement2', context), style: getTextStyle(context, true)),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(translate('termsAndConditionsAndPoliciesAgreement3', context), style: getTextStyle(context, true)),
                        Text(translate('termsAndConditionsAndPoliciesAgreement4', context), style: getTextStyle(context, false))
                      ],
                    )
                  ],
                ),
              ],
            ),
            SizedBox(height: height(0.025, context),),
            textButton(context, themeNotifier, 'continue', MaterialStateProperty.all<Color>(
                !Provider.of<LoginProvider>(context).registerContinueEnabled
                    ? HexColor('#DADADA')
                    : getPrimaryColor(context, themeNotifier)),
                Provider.of<LoginProvider>(context).registerContinueEnabled
                    ? HexColor('#ffffff') : HexColor('#363636'), () async {
                  if(loginProvider.registerContinueEnabled){
                    loginProvider.registerContinueEnabled = false;
                    await loginProvider.getEncryptedPasswordService(loginProvider.registerPasswordController.text).then((value) {
                      loginProvider.registerData.password = value;
                    });
                    if (kDebugMode) {
                      print('loginProvider.registerData: ${jsonEncode(loginProvider.registerData)}');
                    }
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => const SplashScreen()),
                            (route) => false
                    );
                  }
                }),
          ],
        ),
      ),
    );
  }

  passwordValidator(value, LoginProvider loginProvider){
    loginProvider.notifyMe();
    if(loginProvider.registerPasswordController.text.length >= 8){
      setState(() {
        validatorsCheck[0] = true;
      });
    } else{
      setState(() {
        validatorsCheck[0] = false;
      });
    }
    if(loginProvider.registerPasswordController.text.contains(RegExp("(?:[^A-Z]*[A-Z]){1}"))){
      setState(() {
        validatorsCheck[1] = true;
      });
    } else{
      setState(() {
        validatorsCheck[1] = false;
      });
    }
    if(loginProvider.registerPasswordController.text.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))){
      setState(() {
        validatorsCheck[2] = true;
      });
    } else{
      setState(() {
        validatorsCheck[2] = false;
      });
    }
    if(loginProvider.registerPasswordController.text ==
        loginProvider.registerConfirmPasswordController.text &&
        loginProvider.registerPasswordController.text.isNotEmpty &&
        loginProvider.registerConfirmPasswordController.text.isNotEmpty){
      setState(() {
        validatorsCheck[3] = true;
      });
    } else{
      setState(() {
        validatorsCheck[3] = false;
      });
    }
    loginProvider.registerContinueEnabled = !validatorsCheck.contains(false) && termsChecked;
    loginProvider.notifyMe();
  }

}
