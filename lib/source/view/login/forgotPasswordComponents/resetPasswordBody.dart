// ignore_for_file: file_names

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:ssc/source/view/login/loginScreen.dart';

import '../../../../infrastructure/userConfig.dart';
import '../../../../infrastructure/userSecuredStorage.dart';
import '../../../../utilities/hexColor.dart';
import '../../../../utilities/theme/themes.dart';
import '../../../../utilities/util.dart';
import '../../../viewModel/login/loginProvider.dart';
import '../../../viewModel/utilities/theme/themeProvider.dart';
import '../../splash/splashScreen.dart';
import 'dart:math' as math;

class ResetPasswordBody extends StatefulWidget {
  final String otpCode;
  final String email;
  final bool useMobile;
  const ResetPasswordBody({Key key, this.otpCode, this.useMobile = false, this.email}) : super(key: key);

  @override
  State<ResetPasswordBody> createState() => _ResetPasswordBodyState();
}

class _ResetPasswordBodyState extends State<ResetPasswordBody> {

  List<String> validators = ["pwValidator1", "pwValidator2", "pwValidator3", "pwValidator4", "pwValidator5", "pwValidator6"];
  List<bool> validatorsCheck = [false, false, false, false, false, false];

  @override
  void initState() {
    Provider.of<LoginProvider>(context, listen: false).clearForgotPasswordData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ThemeNotifier themeNotifier = Provider.of<ThemeNotifier>(context);
    LoginProvider loginProvider = Provider.of<LoginProvider>(context, listen: false);
    UserSecuredStorage userSecuredStorage = UserSecuredStorage.instance;

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
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
              Opacity(
                opacity: 0.5,
                child: Container(
                  alignment: Alignment.bottomLeft,
                  child: SvgPicture.asset(
                      'assets/logo/logo_tree.svg'
                  ),
                ),
              ),
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                              alignment: Alignment.topLeft,
                              child: Row(
                                children: [
                                  InkWell(
                                    onTap: (){
                                      Navigator.of(context).pushAndRemoveUntil(
                                          MaterialPageRoute(builder: (context) => const LoginScreen()),
                                              (route) => false
                                      );
                                    },
                                    child: Transform.rotate(
                                      angle: UserConfig.instance.isLanguageEnglish()
                                          ? -math.pi / 1.0 : 0,
                                      child: SvgPicture.asset(
                                          'assets/icons/back.svg'
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: width(0.03, context)),
                                  Text(
                                    getTranslated('resetPassword', context),
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
                      SizedBox(height: height(0.02, context),),
                      Divider(
                          color: HexColor('#DADADA')
                      ),
                      SizedBox(
                        height: height(0.78, context),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: height(0.02, context),),
                                Text(
                                  getTranslated('password', context),
                                  style: TextStyle(
                                      color: HexColor('#363636'),
                                      fontSize: width(0.032, context)
                                  ),
                                ),
                                SizedBox(height: height(0.015, context),),
                                buildTextFormField(context, themeNotifier, loginProvider.resetPasswordController, 'XC454F@11', (val){
                                  passwordValidator(val, loginProvider);
                                }, isPassword: true, flag: 1),
                                SizedBox(height: height(0.02, context),),
                                Text(
                                  getTranslated('confirmPassword', context),
                                  style: TextStyle(
                                      color: HexColor('#363636'),
                                      fontSize: width(0.032, context)
                                  ),
                                ),
                                SizedBox(height: height(0.015, context),),
                                buildTextFormField(context, themeNotifier, loginProvider.resetConfirmPasswordController, 'XC454F@11', (val){
                                  passwordValidator(val, loginProvider);
                                }, isPassword: true, flag: 1),
                                SizedBox(height: height(0.01, context),),
                                SizedBox(height: height(0.015, context),),
                                SizedBox(
                                  height: height(0.25, context),
                                  child: GridView.builder(
                                      physics: const NeverScrollableScrollPhysics(),
                                      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                                          maxCrossAxisExtent: width(0.3, context),
                                          childAspectRatio: 100 / (isTablet(context) ? height(0.02, context) : height(0.04, context)),
                                          crossAxisSpacing: 6,
                                          mainAxisSpacing: 12
                                      ),
                                      itemCount: validators.length,
                                      itemBuilder: (BuildContext ctx, index) {
                                        return Container(
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                                color: validatorsCheck[index]
                                                    ? HexColor('#946800') : HexColor('#EDEDED'),
                                                borderRadius: BorderRadius.circular(8.0)
                                            ),
                                            child: Text(
                                              getTranslated(validators[index], context),
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color: validatorsCheck[index]
                                                      ? HexColor('#FFFFFF') : HexColor('#595959'),
                                                  fontSize: height(isTablet(context) ? 0.01 : 0.012, context)
                                              ),
                                            )
                                        );
                                      }),
                                ),
                              ],
                            ),
                            textButton(context, themeNotifier, 'continue', !Provider.of<LoginProvider>(context).resetContinueEnabled
                                ? HexColor('#DADADA')
                                : getPrimaryColor(context, themeNotifier),
                                Provider.of<LoginProvider>(context).resetContinueEnabled
                                    ? HexColor('#ffffff') : HexColor('#363636'), () async {
                                  if(loginProvider.resetContinueEnabled){
                                    loginProvider.isLoading = true;
                                    loginProvider.notifyMe();
                                    String message = '';
                                    try{
                                      await loginProvider.resetPassword(
                                        userSecuredStorage.nationalId.toString(),
                                        loginProvider.resetPasswordController.text,
                                        widget.useMobile ? int.tryParse(userSecuredStorage.realMobileNumber.toString()) : null,
                                        userSecuredStorage.internationalCode.toString(),
                                        int.tryParse(widget.otpCode),
                                        widget.useMobile ? null : widget.email,
                                      ).whenComplete((){}).then((value){
                                        message = UserConfig.instance.isLanguageEnglish()
                                            ? value["PO_STATUS_DESC_EN"] : value["PO_STATUS_DESC_AR"];
                                        if(value["PO_STATUS"] == 1){
                                          showMyDialog(context, 'resetPassword', message, 'login', themeNotifier).then((value) {
                                            Navigator.of(context).pushAndRemoveUntil(
                                                MaterialPageRoute(builder: (context) => const SplashScreen()),
                                                    (route) => false
                                            );
                                          });
                                        }else{
                                          showMyDialog(context, 'resetPasswordFailed', message, 'retryAgain', themeNotifier);
                                        }
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
                                }),
                          ],
                        ),
                      ),
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
          ),
        )
      ),
    );
  }

  passwordValidator(value, loginProvider){
    loginProvider.notifyMe();
    if(loginProvider.resetPasswordController.text.length >= 8){ //At least 8 character
      setState(() {
        validatorsCheck[0] = true;
      });
    } else{
      setState(() {
        validatorsCheck[0] = false;
      });
    }
    if(loginProvider.resetPasswordController.text.contains(RegExp("(?:[^a-z]*[a-z]){1}"))){ //Lowercase letter (a-z)
      setState(() {
        validatorsCheck[1] = true;
      });
    } else{
      setState(() {
        validatorsCheck[1] = false;
      });
    }
    if(loginProvider.resetPasswordController.text.contains(RegExp("(?:[^A-Z]*[A-Z]){1}"))){ //Uppercase letter (A-Z)
      setState(() {
        validatorsCheck[2] = true;
      });
    } else{
      setState(() {
        validatorsCheck[2] = false;
      });
    }
    if(loginProvider.resetPasswordController.text.contains(RegExp(r'[-+=!@#$%^&*(),.?":{}|<>]'))){ //Special character (*!&#^@)
      setState(() {
        validatorsCheck[3] = true;
      });
    } else{
      setState(() {
        validatorsCheck[3] = false;
      });
    }
    if(loginProvider.resetPasswordController.text.contains(RegExp("(?:[0-9]){1}"))){ //Number (1-9)
      setState(() {
        validatorsCheck[4] = true;
      });
    } else{
      setState(() {
        validatorsCheck[4] = false;
      });
    }
    if(loginProvider.resetPasswordController.text ==
        loginProvider.resetConfirmPasswordController.text &&
        loginProvider.resetPasswordController.text.isNotEmpty &&
        loginProvider.resetConfirmPasswordController.text.isNotEmpty){  //Password is the same as the confirm password
      setState(() {
        validatorsCheck[5] = true;
      });
    } else{
      setState(() {
        validatorsCheck[5] = false;
      });
    }
    loginProvider.resetContinueEnabled = !validatorsCheck.contains(false);
    loginProvider.notifyMe();
  }

}
