// ignore_for_file: file_names

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ssc/models/login/registerData.dart';
import 'package:ssc/src/view/login/registerScreen.dart';

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

  Map item1 = {"title": 'sms', "value": true};
  Map item2 = {"title": 'email', "value": false};


  @override
  void initState() {
    LoginProvider loginProvider = Provider.of<LoginProvider>(context, listen: false);
    if(!item2['value']){
      loginProvider.registerContinueEnabled = true;
    } else{
      loginProvider.registerContinueEnabled = loginProvider.emailController.text.isNotEmpty;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ThemeNotifier themeNotifier = Provider.of<ThemeNotifier>(context);
    LoginProvider loginProvider = Provider.of<LoginProvider>(context, listen: false);

    return RegisterScreen(
      stepNumber: 3,
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
                    translate('thirdStep', context),
                    style: TextStyle(
                        color: HexColor('#979797'),
                        fontSize: width(0.03, context)
                    ),
                  ),
                  SizedBox(height: height(0.006, context),),
                  Text(
                    translate('contactInformations', context),
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
                    '${translate('next', context)}: ${translate('setPassword', context)}',
                    style: TextStyle(
                        color: HexColor('#979797'),
                        fontSize: width(0.032, context)
                    ),
                  ),
                ],
              ),
              SizedBox(height: height(0.02, context),),
              Text(
                translate('chooseHowToReceiveMessages', context),
                style: TextStyle(
                    color: HexColor('#363636'),
                    fontSize: width(0.032, context)
                ),
              ),
              SizedBox(height: height(0.02, context),),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: (){
                      setState(() {
                        if(!item2['value']){
                          loginProvider.registerContinueEnabled = true;
                        } else{
                          loginProvider.registerContinueEnabled = loginProvider.emailController.text.isNotEmpty;
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
                            color: item1['value'] ? HexColor('#2D452E') : HexColor('#DADADA'),
                            borderRadius: BorderRadius.circular(4.0)
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: width(0.03, context),),
                  Text(translate(item1['title'], context)),
                ],
              ),
              SizedBox(height: height(0.01, context),),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: (){
                      setState(() {
                        item2['value'] = !item2['value'];
                        if(!item2['value']){
                          loginProvider.registerContinueEnabled = true;
                        } else{
                          loginProvider.registerContinueEnabled = loginProvider.emailController.text.isNotEmpty;
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
                  Text(translate(item2['title'], context)),
                ],
              ),
              SizedBox(height: height(0.015, context),),
              Text(
                translate('choosingEmailPreferable', context),
                style: TextStyle(
                    color: HexColor('##003C97'),
                    fontSize: width(0.026, context)
                ),
              ),
              if(item2['value'])
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: height(0.025, context),),
                  Text(
                    translate('email', context),
                    style: TextStyle(
                        color: HexColor('#363636'),
                        fontSize: width(0.032, context)
                    ),
                  ),
                  SizedBox(height: height(0.015, context),),
                  buildTextFormField(context, themeNotifier, loginProvider.emailController, 'example@example.com', (value){
                    if(item2['value']){
                      loginProvider.registerContinueEnabled = isEmail(loginProvider.emailController.text);
                    } else{
                      loginProvider.registerContinueEnabled = true;
                    }
                    loginProvider.notifyMe();
                  }, inputType: TextInputType.emailAddress),
                ],
              ),
            ],
          ),
          SizedBox(height: height(item2['value'] == true ? 0.242 : 0.35, context),),
          textButton(context, themeNotifier, 'continue', MaterialStateProperty.all<Color>(
              !Provider.of<LoginProvider>(context).registerContinueEnabled
                  ? HexColor('#DADADA')
                  : getPrimaryColor(context, themeNotifier)),
              Provider.of<LoginProvider>(context).registerContinueEnabled
                  ? HexColor('#ffffff') : HexColor('#363636'), (){
                if(loginProvider.registerContinueEnabled || !item2['value']){
                  List activationBy = [1];
                  if(item2['value']) activationBy.add(2);
                  loginProvider.registerContinueEnabled = false;
                  loginProvider.registerData.email = loginProvider.emailController.text;
                  loginProvider.registerData.activationBy = 1; //activationBy
                  loginProvider.notifyMe();
                  if(item2['value']) {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => OTPScreen(
                          type: 'email',
                          contactTarget: loginProvider.emailController.text))
                  );
                  }else{
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => const ForthStepBody())
                    );
                  }
                }
                if (kDebugMode) {
                  print(registerDataToJson(loginProvider.registerData));
                }
              }),
        ],
      ),
    );
  }
}
