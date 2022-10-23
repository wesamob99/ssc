import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../infrastructure/userConfig.dart';
import '../../../../utilities/constants.dart';
import '../../../../utilities/hexColor.dart';
import '../../../../utilities/theme/themes.dart';
import '../../../../utilities/util.dart';
import '../../../viewModel/login/loginProvider.dart';
import '../../../viewModel/utilities/language/globalAppProvider.dart';
import '../../../viewModel/utilities/theme/themeProvider.dart';
import '../../splash/splashScreen.dart';
import 'dart:math' as math;

class ResetPasswordBody extends StatefulWidget {
  const ResetPasswordBody({Key key}) : super(key: key);

  @override
  State<ResetPasswordBody> createState() => _ResetPasswordBodyState();
}

class _ResetPasswordBodyState extends State<ResetPasswordBody> {

  Future<SharedPreferences> prefs = SharedPreferences.getInstance();
  String selectedLanguage;
  List<String> validators = ["pwValidator1", "pwValidator2", "pwValidator3", "pwValidator4"];
  List<bool> validatorsCheck = [false, false, false, false];

  getAppLanguage(){
    prefs.then((value) {
      selectedLanguage = value.getString('language_code') ?? 'en';
    });
  }

  @override
  void initState() {
    getAppLanguage();
    Provider.of<LoginProvider>(context, listen: false).clearForgotPasswordData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ThemeNotifier themeNotifier = Provider.of<ThemeNotifier>(context);
    LoginProvider loginProvider = Provider.of<LoginProvider>(context, listen: false);
    GlobalAppProvider globalAppProvider = Provider.of<GlobalAppProvider>(context);

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
                                      Navigator.of(context).pop();
                                      Navigator.of(context).pop();
                                    },
                                    child: Transform.rotate(
                                      angle: UserConfig.instance.checkLanguage()
                                          ? -math.pi / 1.0 : 0,
                                      child: SvgPicture.asset(
                                          'assets/icons/back.svg'
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: width(0.03, context)),
                                  Text(
                                    translate('resetPassword', context),
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
                      SizedBox(height: height(0.02, context),),
                      Divider(
                          color: HexColor('#DADADA')
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: height(0.02, context),),
                              Text(
                                translate('password', context),
                                style: TextStyle(
                                    color: HexColor('#363636'),
                                    fontSize: width(0.032, context)
                                ),
                              ),
                              SizedBox(height: height(0.015, context),),
                              buildTextFormField(context, themeNotifier, loginProvider, loginProvider.resetPasswordController, '', (val){
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
                              buildTextFormField(context, themeNotifier, loginProvider, loginProvider.resetConfirmPasswordController, '', (val){
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
                          SizedBox(height: height(0.1, context),),
                          textButton(context, themeNotifier, 'continue', MaterialStateProperty.all<Color>(
                              !Provider.of<LoginProvider>(context).resetContinueEnabled
                                  ? HexColor('#DADADA')
                                  : getPrimaryColor(context, themeNotifier)),
                              Provider.of<LoginProvider>(context).resetContinueEnabled
                                  ? HexColor('#ffffff') : HexColor('#363636'), (){
                                if(loginProvider.resetContinueEnabled){
                                  /// TODO: call resetPassword API
                                  Navigator.of(context).pushAndRemoveUntil(
                                      MaterialPageRoute(builder: (context) => const SplashScreen()),
                                          (route) => false
                                  );
                                }
                              }),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        )
      ),
    );
  }

  passwordValidator(value, loginProvider){
    if(loginProvider.resetPasswordController.text.length >= 8){
      setState(() {
        validatorsCheck[0] = true;
      });
    } else{
      setState(() {
        validatorsCheck[0] = false;
      });
    }
    if(loginProvider.resetPasswordController.text.contains(RegExp("(?:[^A-Z]*[A-Z]){1}"))){
      setState(() {
        validatorsCheck[1] = true;
      });
    } else{
      setState(() {
        validatorsCheck[1] = false;
      });
    }
    if(loginProvider.resetPasswordController.text.contains(RegExp(r'[-+=!@#$%^&*(),.?":{}|<>]'))){
      setState(() {
        validatorsCheck[2] = true;
      });
    } else{
      setState(() {
        validatorsCheck[2] = false;
      });
    }
    if(loginProvider.resetPasswordController.text ==
        loginProvider.resetConfirmPasswordController.text &&
        loginProvider.resetPasswordController.text.isNotEmpty &&
        loginProvider.resetConfirmPasswordController.text.isNotEmpty){
      setState(() {
        validatorsCheck[3] = true;
      });
    } else{
      setState(() {
        validatorsCheck[3] = false;
      });
    }
    loginProvider.resetContinueEnabled = !validatorsCheck.contains(false);
    loginProvider.notifyMe();
  }

}
