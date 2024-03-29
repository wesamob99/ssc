// ignore_for_file: file_names

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ssc/models/login/registerData.dart';
import 'package:ssc/source/view/login/registerScreen.dart';

import '../../../../infrastructure/userConfig.dart';
import '../../../../utilities/hexColor.dart';
import '../../../../utilities/theme/themes.dart';
import '../../../../utilities/util.dart';
import '../../../viewModel/login/loginProvider.dart';
import '../../../viewModel/utilities/theme/themeProvider.dart';
import 'OTPScreen.dart';
import 'forthStepBody.dart';

class ThirdStepBody extends StatefulWidget {
  const ThirdStepBody({Key key}) : super(key: key);

  @override
  State<ThirdStepBody> createState() => _ThirdStepBodyState();
}

class _ThirdStepBodyState extends State<ThirdStepBody> {

  Map item1 = {"title": 'want', "value": true};
  Map item2 = {"title": 'dontWant', "value": false};


  @override
  void initState() {
    LoginProvider loginProvider = Provider.of<LoginProvider>(context, listen: false);
    loginProvider.emailController.clear();
    if(item2['value']){
      loginProvider.registerContinueEnabled = true;
    } else{
      loginProvider.registerContinueEnabled = isEmail(loginProvider.emailController.text);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ThemeNotifier themeNotifier = Provider.of<ThemeNotifier>(context);
    LoginProvider loginProvider = Provider.of<LoginProvider>(context, listen: false);

    return Stack(
      children: [
        RegisterScreen(
          body: SizedBox(
            height: height(0.78, context),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: height(0.02, context),),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          getTranslated('thirdStep', context),
                          style: TextStyle(
                              color: HexColor('#979797'),
                              fontSize: width(0.03, context)
                          ),
                        ),
                        SizedBox(height: height(0.006, context),),
                        Text(
                          getTranslated('contactInformations', context),
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
                          '${getTranslated('next', context)}: ${getTranslated('setPassword', context)}',
                          style: TextStyle(
                              color: HexColor('#979797'),
                              fontSize: width(0.032, context)
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: height(0.02, context),),
                    Text(
                      getTranslated('wouldLikeToReceiveMessagesViaE-mail', context),
                      style: TextStyle(
                          color: HexColor('#363636'),
                          fontSize: width(0.032, context)
                      ),
                    ),
                    SizedBox(height: height(0.02, context),),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: (){
                            setState(() {
                              item2['value'] = false;
                              item1["value"] = true;
                              if(item2['value']){
                                loginProvider.registerContinueEnabled = true;
                              } else{
                                loginProvider.registerContinueEnabled = isEmail(loginProvider.emailController.text);
                              }
                            });
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
                                color: item1["value"] ? HexColor('#2D452E') : HexColor('#DADADA'),
                                borderRadius: BorderRadius.circular(4.0),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: width(0.03, context),),
                        Text(
                          getTranslated(item1['title'], context),
                          style: TextStyle(
                            fontSize: width(isTablet(context) ? 0.03 : 0.037, context),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: height(0.01, context),),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: (){
                            setState(() {
                              item1['value'] = false;
                              item2["value"] = true;
                              if(item2['value']){
                                loginProvider.registerContinueEnabled = true;
                              } else{
                                loginProvider.registerContinueEnabled = isEmail(loginProvider.emailController.text);
                              }
                            });
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
                                  color: item2['value'] ? HexColor('#2D452E') : HexColor('#DADADA'),
                                  borderRadius: BorderRadius.circular(4.0)
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: width(0.03, context),),
                        Text(
                          getTranslated(item2['title'], context),
                          style: TextStyle(
                            fontSize: width(isTablet(context) ? 0.03 : 0.037, context),
                          ),
                        ),
                      ],
                    ),
                    // SizedBox(height: height(0.015, context),),
                    // Text(
                    //   translate('choosingEmailPreferable', context),
                    //   style: TextStyle(
                    //       color: HexColor('##003C97'),
                    //       fontSize: width(0.026, context)
                    //   ),
                    // ),
                    if(item1["value"])
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: height(0.025, context),),
                        Text(
                          getTranslated('email', context),
                          style: TextStyle(
                              color: HexColor('#363636'),
                              fontSize: width(0.032, context)
                          ),
                        ),
                        SizedBox(height: height(0.015, context),),
                        buildTextFormField(context, themeNotifier, loginProvider.emailController, 'example@example.com', (value){
                          if(item2['value']){
                            loginProvider.registerContinueEnabled = true;
                          } else{
                            loginProvider.registerContinueEnabled = isEmail(loginProvider.emailController.text);
                          }
                          loginProvider.notifyMe();
                        }, inputType: TextInputType.emailAddress),
                      ],
                    ),
                  ],
                ),
                textButton(context, themeNotifier, 'continue', !Provider.of<LoginProvider>(context).registerContinueEnabled
                    ? HexColor('#DADADA')
                    : getPrimaryColor(context, themeNotifier),
                    Provider.of<LoginProvider>(context).registerContinueEnabled
                        ? HexColor('#ffffff') : HexColor('#363636'), () async {
                      if(loginProvider.registerContinueEnabled){
                        loginProvider.registerData.email = item1['value'] ? loginProvider.emailController.text : null;
                        loginProvider.registerData.activationBy = 3; //activationBy
                        loginProvider.notifyMe();
                        if(item1['value']) {
                          FocusScope.of(context).requestFocus(FocusNode());
                          loginProvider.isLoading = true;
                          loginProvider.notifyMe();
                          String errorMessage = "";
                          try{
                            await loginProvider.sendEmailOTP(loginProvider.emailController.text, 0).whenComplete((){})
                                .then((val) async {
                              if(val['PO_status'] != 1){
                                errorMessage = UserConfig.instance.isLanguageEnglish()
                                    ? val['PO_STATUS_DESC_EN'] : val['PO_STATUS_DESC_AR'];
                                showMyDialog(context, 'registerFailed', errorMessage, 'retryAgain', themeNotifier);
                              } else {
                                errorMessage = '';
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => OTPScreen(
                                      type: 'email',
                                      contactTarget: loginProvider.emailController.text
                                    ),
                                  ),
                                );
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
                        }else{
                          Navigator.of(context).push(
                              MaterialPageRoute(builder: (context) => const ForthStepBody(emailChecked: false))
                          );
                          loginProvider.registerContinueEnabled = false;
                        }
                      }
                      if (kDebugMode) {
                        print(registerDataToJson(loginProvider.registerData));
                      }
                    }),
              ],
            ),
          ),
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
    );
  }
}
