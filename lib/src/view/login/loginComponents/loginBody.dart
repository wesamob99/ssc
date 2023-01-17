// ignore_for_file: file_names, use_build_context_synchronously
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../infrastructure/userConfig.dart';
import '../../../../infrastructure/userSecuredStorage.dart';
import '../../../../models/login/userData.dart';
import '../../../../utilities/constants.dart';
import '../../../../utilities/hexColor.dart';
import '../../../../utilities/theme/themes.dart';
import '../../../../utilities/util.dart';
import '../../../viewModel/accountSettings/accountSettingsProvider.dart';
import '../../../viewModel/login/loginProvider.dart';
import '../../../viewModel/utilities/language/globalAppProvider.dart';
import '../../../viewModel/utilities/theme/themeProvider.dart';
import '../../main/mainScreen.dart';
import '../forgotPasswordScreen.dart';
import '../registerComponents/firstStepBody.dart';

class LoginBody extends StatefulWidget {
  const LoginBody({Key key}) : super(key: key);

  @override
  State<LoginBody> createState() => _LoginBodyState();
}

class _LoginBodyState extends State<LoginBody> {

  LoginProvider loginProvider;
  bool obscurePassword = true;

  Future<SharedPreferences> prefs = SharedPreferences.getInstance();
  UserSecuredStorage userSecuredStorage = UserSecuredStorage.instance;
  String selectedLanguage;

  getAppLanguage(){
    prefs.then((value) {
      selectedLanguage = value.getString('language_code') ?? 'en';
    });
  }

  @override
  void initState() {
    loginProvider = Provider.of<LoginProvider>(context, listen: false);
    loginProvider.enabledSubmitButton = false;
    loginProvider.nationalIdController = TextEditingController();
    loginProvider.passwordController = TextEditingController();
    loginProvider.isLoading = false;
    getAppLanguage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ThemeNotifier themeNotifier = Provider.of<ThemeNotifier>(context);
    GlobalAppProvider globalAppProvider = Provider.of<GlobalAppProvider>(context);
    return Stack(
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                            alignment: Alignment.topLeft,
                            child: Row(
                              children: [
                                SvgPicture.asset(
                                  'assets/icons/global.svg',
                                  color: themeNotifier.isLight()
                                      ? HexColor('#5D6470')
                                      : Colors.white,
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
                    SizedBox(height: height(0.03, context),),
                    SingleChildScrollView(
                      child: Column(
                        children: [
                          // SvgPicture.asset('assets/logo/logo_with_name.svg'),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset('assets/logo/logo.svg'),
                              const SizedBox(width: 10.0),
                              SvgPicture.asset(
                                'assets/logo/name.svg',
                                color: themeNotifier.isLight()
                                    ? HexColor('#51504E')
                                    : HexColor('ffffff'),
                              ),
                            ],
                          ),
                          SizedBox(height: height(0.04, context)),
                          Text(
                            translate('login', context),
                            style: TextStyle(
                                fontSize: width(0.045, context),
                                fontWeight: FontWeight.w700
                            ),
                          ),
                          SizedBox(height: height(0.04, context)),
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
                          SizedBox(height: height(0.025, context)),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                translate('password', context),
                              ),
                              SizedBox(height: height(0.015, context)),
                              buildTextFormField(themeNotifier, loginProvider,  loginProvider.passwordController, TextInputType.visiblePassword),
                            ],
                          ),
                          SizedBox(height: height(0.015, context)),
                          InkWell(
                            onTap: (){
                              loginProvider.passwordController.clear();
                              loginProvider.nationalIdController.clear();
                              loginProvider.notifyMe();
                              Navigator.of(context).push(
                                MaterialPageRoute(builder: (context)=> const ForgotPasswordScreen()),
                              );
                            },
                            child: Container(
                              alignment: UserConfig.instance.checkLanguage()
                                  ? Alignment.bottomRight : Alignment.bottomLeft,
                              child: Text(
                                translate('forgotPassword', context) + (UserConfig.instance.checkLanguage() ? ' ?' : ' ؟'),
                                style: TextStyle(
                                  color: themeNotifier.isLight() ? HexColor('#363636') : HexColor('#ffffff')
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: height(0.05, context)),
                          submitButton(themeNotifier),
                          SizedBox(height: height(0.03, context)),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                translate('dontHaveAnAccount', context),
                              ),
                              SizedBox(width: width(0.005, context)),
                              InkWell(
                                onTap: (){
                                  loginProvider.flag = 0;
                                  loginProvider.notifyMe();
                                  Navigator.of(context).push(
                                      MaterialPageRoute(builder: (context) => const FirstStepBody())
                                  );
                                },
                                child: Text(
                                  translate('register', context),
                                  style: TextStyle(
                                      color: themeNotifier.isLight() ? HexColor('#003C97') : HexColor('#00b0ff')
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
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
        )
      ],
    );
  }

  SizedBox submitButton(themeNotifier){
    return  SizedBox(
      width: width(0.7, context),
      child: TextButton(
        onPressed: () async {
          if(loginProvider.enabledSubmitButton && loginProvider.numberOfAttempts < 5){
            String errorMessage = "";
            loginProvider.isLoading = true;
            loginProvider.notifyMe();
            try{
              await loginProvider.login(loginProvider.nationalIdController.text,  loginProvider.passwordController.text)
                  .whenComplete((){})
                  .then((val) async {
                UserData userData = val;
                userSecuredStorage.token = userData?.token ?? ''; // user token
                if(userData.data != null){
                  userSecuredStorage.userName = userData.data.poName ?? ''; // poName -> user name
                  userSecuredStorage.nationalId = userData.data.poUserName ?? ''; // poUserName -> user national ID
                  userSecuredStorage.insuranceNumber = userData.data.poInternalKey ?? ''; // poInternalKey -> user insurance number
                  await Provider.of<AccountSettingsProvider>(context, listen: false).getAccountData(internalKey: userSecuredStorage.nationalId.toString()).whenComplete((){}).then((result){
                    var data = result.curGetdata[0][0];
                    userSecuredStorage.userFullName = '${data.firstname??''} ${data.fathername??''} ${data.grandfathername??''} ${data.familyname??''}'; // user's full name params
                    userSecuredStorage.realMobileNumber = data.mobilenumber.toString() ?? ''; // poRealMobileno -> user mobile number
                    userSecuredStorage.internationalCode = data.internationalcode.toString() ?? ''; // poInternationalcode -> country code
                    userSecuredStorage.gender = data.gender.toString() ?? ''; // gender -> user gender // 1 -> male & 2 -> female
                  });
                }
                if(userData.poStatusDescEn != null){
                  errorMessage = UserConfig.instance.checkLanguage()
                      ? userData.poStatusDescEn : userData.poStatusDescAr;
                } else{
                  errorMessage = '';
                }
                if(userData.token != null){
                  prefs.then((value) {
                    value.setString(Constants.FIRST_LOGIN, 'true');
                  });
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => const MainScreen()), (route) => false);
                }else{
                  loginProvider.numberOfAttempts++;
                  if(loginProvider.numberOfAttempts > 4){
                    showMyDialog(context, 'loginFailed', translate('exceedNumberOfAllowedAttempts', context), 'resetPassword', themeNotifier).then((value){
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context)=> const ForgotPasswordScreen(submitButtonEnabled: true)),
                      );
                    });
                  }else{
                    showMyDialog(context, 'loginFailed', errorMessage, 'retryAgain', themeNotifier);
                  }
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
            // when user press continue to submit natID to reset password
          }
        },
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(
              Provider.of<LoginProvider>(context).enabledSubmitButton &&
                  Provider.of<LoginProvider>(context).numberOfAttempts < 5
                  ? themeNotifier.isLight()
                  ? primaryColor : HexColor('#445740')
                  : HexColor('#DADADA'),
            ),
            foregroundColor:  MaterialStateProperty.all<Color>(
                Provider.of<LoginProvider>(context).enabledSubmitButton &&
                    Provider.of<LoginProvider>(context).numberOfAttempts < 5
                    ? Colors.white : HexColor('#363636'),
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
      enableInteractiveSelection: controller ==  loginProvider.passwordController ? false : true,
      controller: controller,
      keyboardType: inputType,
      obscureText: controller ==  loginProvider.passwordController ? obscurePassword : false,
      cursorColor: themeNotifier.isLight()
          ? getPrimaryColor(context, themeNotifier)
          : Colors.white,
      cursorWidth: 1,
      style: const TextStyle(
        fontSize: 15
      ),
      decoration: InputDecoration(
        hintText: controller ==  loginProvider.nationalIdController
            ? translate('ex', context) + '9999999999'
            : '',
        hintStyle: TextStyle(
          color: getGrey2Color(context).withOpacity(
            themeNotifier.isLight() ? 1 : 0.7,
          ),
          fontSize: 14,
        ),
        suffixIcon: controller ==  loginProvider.passwordController
        ? InkWell(
          onTap: (){
            setState(() {
              obscurePassword = !obscurePassword;
            });
          },
          child: Icon(
            obscurePassword ? Icons.remove_red_eye : Icons.remove_red_eye_outlined,
            size: 20,
            color: themeNotifier.isLight()
                ? getPrimaryColor(context, themeNotifier)
                : Colors.white,
          ),
        ) : const SizedBox.shrink(),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
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
        loginProvider.enabledSubmitButton = ( loginProvider.nationalIdController.text.isNotEmpty &&
            loginProvider.passwordController.text.isNotEmpty);
        loginProvider.notifyMe();
      },
    );
  }

}
