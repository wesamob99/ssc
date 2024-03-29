// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:ssc/infrastructure/userConfig.dart';

import '../../../utilities/hexColor.dart';
import '../../../utilities/util.dart';
import '../../viewModel/login/loginProvider.dart';
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
    loginProvider.selectedDateOfBirth = DateTime.now();
    loginProvider.thirdStepSelection = ['choose', 'optionalChoose'];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                                    angle: UserConfig.instance.isLanguageEnglish()
                                        ? -math.pi / 1.0 : 0,
                                    child: isTablet(context)
                                    ? SvgPicture.asset('assets/icons/back.svg', width: 55,)
                                    : SvgPicture.asset('assets/icons/back.svg',),
                                  ),
                                ),
                                SizedBox(width: width(0.03, context)),
                                Text(
                                  getTranslated(loginProvider.flag == 1 ? 'reRegister' : 'createAnAccount', context),
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
                        updateLanguageWidget(context)
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

