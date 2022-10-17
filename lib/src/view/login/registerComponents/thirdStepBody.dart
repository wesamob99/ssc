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

class ThirdStepBody extends StatefulWidget {
  const ThirdStepBody({Key key}) : super(key: key);

  @override
  State<ThirdStepBody> createState() => _ThirdStepBodyState();
}

class _ThirdStepBodyState extends State<ThirdStepBody> {

  final List _selectedValues = [];
  Map item1 = {"title": 'sms', "value": false};
  Map item2 = {"title": 'email', "value": false};


  @override
  void initState() {
    LoginProvider loginProvider = Provider.of<LoginProvider>(context, listen: false);
    loginProvider.registerContinueEnabled = true;
    super.initState();
  }


  void _onItemCheckedChange(itemValue, bool checked, loginProvider) {
    setState(() {
      itemValue['value'] = checked;
      if (checked) {
        _selectedValues.add(itemValue);
      } else {
        _selectedValues.remove(itemValue);
      }

      if(!item2['value']){
        loginProvider.registerContinueEnabled = true;
      } else{
        loginProvider.registerContinueEnabled = loginProvider.emailController.text.isNotEmpty;
      }
    });
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
              SizedBox(height: height(0.01, context),),
              CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                checkColor: Colors.white,
                activeColor: HexColor('##445740'),
                value: true,
                title: Text(translate(item1['title'], context)),
                controlAffinity: ListTileControlAffinity.leading,
                onChanged: (checked) => _onItemCheckedChange(item1, checked, loginProvider),
              ),
              CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                checkColor: Colors.white,
                activeColor: HexColor('##445740'),
                value: item2['value'],
                title: Text(translate(item2['title'], context)),
                controlAffinity: ListTileControlAffinity.leading,
                onChanged: (checked) => _onItemCheckedChange(item2, checked, loginProvider),
              ),
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
                  buildTextFormField(context, themeNotifier, loginProvider, loginProvider.emailController, 'example@example.com', (value){
                    if(item2['value'] == true){
                      loginProvider.registerContinueEnabled = isEmail(loginProvider.emailController.text);
                    } else{
                      loginProvider.registerContinueEnabled = true;
                    }
                    loginProvider.notifyMe();
                  }),
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
                if(loginProvider.registerContinueEnabled){
                  loginProvider.registerContinueEnabled = false;
                  loginProvider.registerData.nationalId = int.tryParse(loginProvider.registerNationalIdController.text);
                  loginProvider.registerData.personalCardNo = loginProvider.civilIdNumberController.text;
                  loginProvider.registerData.relativeNatId = int.tryParse(loginProvider.relativeNatIdController.text);
                  loginProvider.notifyMe();
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
