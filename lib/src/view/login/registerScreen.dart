// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ssc/infrastructure/userConfig.dart';

import '../../../utilities/constants.dart';
import '../../../utilities/hexColor.dart';
import '../../../utilities/theme/themes.dart';
import '../../../utilities/util.dart';
import '../../viewModel/login/loginProvider.dart';
import '../../viewModel/utilities/language/globalAppProvider.dart';
import '../../viewModel/utilities/theme/themeProvider.dart';
import 'dart:math' as math;

class RegisterScreen extends StatefulWidget {
  final Widget body;
  final bool fromOtpScreen;
  const RegisterScreen({Key key, this.body, this.fromOtpScreen = false}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {

  LoginProvider loginProvider;
  Future<SharedPreferences> prefs = SharedPreferences.getInstance();
  String selectedLanguage;

  getAppLanguage(){
    prefs.then((value) {
      selectedLanguage = value.getString('language_code') ?? 'en';
    });
  }

  @override
  void initState() {
    loginProvider = Provider.of<LoginProvider>(context, listen: false);
    ///login
    loginProvider.passwordController = TextEditingController();
    loginProvider.numberOfAttempts = 0;
    if(loginProvider.flag == 0){
      loginProvider.nationalIdController = TextEditingController();
    }
    loginProvider.enabledSubmitButton = false;
    ///register
    loginProvider.jordanianMobileNumberController = TextEditingController();
    loginProvider.foreignMobileNumberController = TextEditingController();
    if(loginProvider.flag == 0) {
      loginProvider.registerNationalIdController = TextEditingController();
    }
    loginProvider.passportNumberController = TextEditingController();
    loginProvider.insuranceNumberController = TextEditingController();
    loginProvider.civilIdNumberController = TextEditingController();
    loginProvider.relativeNatIdController = TextEditingController();
    loginProvider.emailController = TextEditingController();
    loginProvider.registerPasswordController = TextEditingController();
    loginProvider.registerConfirmPasswordController = TextEditingController();
    loginProvider.dateOfBirthController = TextEditingController();
    loginProvider.thirdStepSelection = ['choose', 'optionalChoose'];
    getAppLanguage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ThemeNotifier themeNotifier = Provider.of<ThemeNotifier>(context);
    GlobalAppProvider globalAppProvider = Provider.of<GlobalAppProvider>(context);
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
                                    loginProvider.registerContinueEnabled = false;
                                    Navigator.of(context).pop();
                                    if(widget.fromOtpScreen) {
                                      Navigator.of(context).pop();
                                    }
                                    setState(() {
                                      loginProvider.nationalIdController.clear();
                                      loginProvider.passwordController.clear();
                                      loginProvider.notifyMe();
                                    });
                                  },
                                  child: Transform.rotate(
                                    angle: UserConfig.instance.checkLanguage()
                                        ? -math.pi / 1.0 : 0,
                                    child: isTablet(context)
                                    ? SvgPicture.asset('assets/icons/back.svg', width: 55,)
                                    : SvgPicture.asset('assets/icons/back.svg',),
                                  ),
                                ),
                                SizedBox(width: width(0.03, context)),
                                Text(
                                  translate(loginProvider.flag == 1 ? 'reRegister' : 'createAnAccount', context),
                                  style: isTablet(context)
                                  ? const TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 20
                                  )
                                  : const TextStyle(
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            )
                        ),
                        Container(
                            alignment: Alignment.topLeft,
                            child: Row(
                              children: [
                                isTablet(context)
                                ? SvgPicture.asset('assets/icons/global.svg', width: 35,)
                                : SvgPicture.asset('assets/icons/global.svg'),
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
                                        style: isTablet(context)
                                          ? TextStyle(
                                          color: themeNotifier.isLight()
                                              ? primaryColor
                                              : Colors.white,
                                            fontSize: 20,
                                        ) : TextStyle(
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
                    widget.body,
                    // if(Provider.of<LoginProvider>(context).stepNumber == 1)
                    //   const FirstStepBody(),
                    // if(Provider.of<LoginProvider>(context).stepNumber == 2)
                    //   const SecondStepBody(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

