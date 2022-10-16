import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ssc/models/login/registerData.dart';
import 'package:ssc/src/view/login/registerComponents/thirdStepBody.dart';
import 'package:ssc/src/view/login/registerScreen.dart';

import '../../../../utilities/hexColor.dart';
import '../../../../utilities/theme/themes.dart';
import '../../../../utilities/util.dart';
import '../../../viewModel/login/loginProvider.dart';
import '../../../viewModel/utilities/theme/themeProvider.dart';

class SecondStepBody extends StatefulWidget {
  const SecondStepBody({Key key}) : super(key: key);

  @override
  State<SecondStepBody> createState() => _SecondStepBodyState();
}

class _SecondStepBodyState extends State<SecondStepBody> {

  String selectedRelativeType = 'choose';
  String selectedAcademicLevel = 'choose';

  List<String> relationTypes = ['choose', 'parent', 'brother', 'wife', 'child'];
  List<String> academicLevels = ['choose', 'phd', 'master', 'hDiploma', 'mDiploma', 'ba', 'highSchool', 'lessHighSchool', 'professionalCertificate'];

  @override
  Widget build(BuildContext context) {
    ThemeNotifier themeNotifier = Provider.of<ThemeNotifier>(context);
    LoginProvider loginProvider = Provider.of<LoginProvider>(context, listen: false);

    return RegisterScreen(
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
                    translate('secondStep', context),
                    style: TextStyle(
                        color: HexColor('#979797'),
                        fontSize: width(0.03, context)
                    ),
                  ),
                  SizedBox(height: height(0.006, context),),
                  Text(
                    translate('personalInformations', context),
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
                    '${translate('next', context)}: ${translate('contactInformations', context)}',
                    style: TextStyle(
                        color: HexColor('#979797'),
                        fontSize: width(0.032, context)
                    ),
                  ),
                ],
              ),
              SizedBox(height: height(0.02, context),),
              Text(
                translate('enterNationalId', context),
                style: TextStyle(
                    color: HexColor('#363636'),
                    fontSize: width(0.032, context)
                ),
              ),
              SizedBox(height: height(0.015, context),),
              buildTextFormField(themeNotifier, loginProvider, loginProvider.registerNationalIdController, '9661001073'),
              SizedBox(height: height(0.02, context),),
              Text(
                translate('civilIdNumber', context),
                style: TextStyle(
                    color: HexColor('#363636'),
                    fontSize: width(0.032, context)
                ),
              ),
              SizedBox(height: height(0.015, context),),
              buildTextFormField(themeNotifier, loginProvider, loginProvider.civilIdNumberController, 'XC454F'),
              SizedBox(height: height(0.02, context),),
              Text(
                translate('relativeNationalNumber', context),
                style: TextStyle(
                    color: HexColor('#363636'),
                    fontSize: width(0.032, context)
                ),
              ),
              SizedBox(height: height(0.015, context),),
              buildTextFormField(themeNotifier, loginProvider, loginProvider.relativeNatIdController, '9661001073'),
              SizedBox(height: height(0.02, context),),
              /// ***>
              Text(
                translate('relativeRelation', context),
                style: TextStyle(
                    color: HexColor('#363636'),
                    fontSize: width(0.032, context)
                ),
              ),
              SizedBox(height: height(0.015, context),),
              dropDownList(selectedRelativeType, relationTypes, themeNotifier, loginProvider),
              SizedBox(height: height(0.02, context),),
              Text(
                translate('academicLevel', context),
                style: TextStyle(
                    color: HexColor('#363636'),
                    fontSize: width(0.032, context)
                ),
              ),
              SizedBox(height: height(0.015, context),),
              dropDownList(selectedAcademicLevel, academicLevels, themeNotifier, loginProvider),
            ],
          ),
          SizedBox(height: height(0.04, context),),
          textButton(context, themeNotifier, 'continue', MaterialStateProperty.all<Color>(
              !Provider.of<LoginProvider>(context).registerContinueEnabled
                  ? HexColor('#DADADA')
                  : getPrimaryColor(context, themeNotifier)),
              HexColor('#ffffff'), (){
                if(loginProvider.registerContinueEnabled){
                  loginProvider.registerContinueEnabled = false;
                  loginProvider.registerData.nationalId = int.tryParse(loginProvider.registerNationalIdController.text);
                  loginProvider.registerData.personalCardNo = loginProvider.civilIdNumberController.text;
                  loginProvider.registerData.relativeNatId = int.tryParse(loginProvider.relativeNatIdController.text);
                  loginProvider.notifyMe();
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => const ThirdStepBody())
                  );
                }
                print(registerDataToJson(loginProvider.registerData));
              }),
        ],
      ),
    );
  }

  SizedBox buildTextFormField(ThemeNotifier themeNotifier, LoginProvider loginProvider, TextEditingController controller, String hintText){
    return SizedBox(
      height: height(0.05, context),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
            hintText: translate('ex', context) + hintText,
            hintStyle: TextStyle(
              color: getGrey2Color(context).withOpacity(
                themeNotifier.isLight() ? 1 : 0.5,
              ),
              fontSize: 14,
            ),
            contentPadding: const EdgeInsets.only(left: 16.0, right: 16.0),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4),
              borderSide: BorderSide(
                color: getPrimaryColor(context, themeNotifier),
                width: 0.5,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4),
              borderSide: BorderSide(
                color: getPrimaryColor(context, themeNotifier),
                width: 0.8,
              ),
            )
        ),
        onChanged: (val){
          loginProvider.registerContinueEnabled =  (
              loginProvider.registerNationalIdController.text.isNotEmpty &&
              loginProvider.civilIdNumberController.text.isNotEmpty &&
              loginProvider.relativeNatIdController.text.isNotEmpty &&
              selectedAcademicLevel != 'choose' &&
              selectedRelativeType != 'choose'
          );
          loginProvider.notifyMe();
        },
      ),
    );
  }

  dropDownList(dropDownValue, List<String> menuList, themeNotifier, loginProvider){
    return Container(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0),
      height: height(0.05, context),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: HexColor('#979797'),
        )
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            DropdownButton<String>(
              value: dropDownValue,
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
              onChanged: (String value){
                setState(() {
                  if(dropDownValue == selectedRelativeType){
                    selectedRelativeType = value;
                  } else if(dropDownValue == selectedAcademicLevel){
                    selectedAcademicLevel = value;
                  }
                });
                loginProvider.registerContinueEnabled =  (
                    loginProvider.registerNationalIdController.text.isNotEmpty &&
                        loginProvider.civilIdNumberController.text.isNotEmpty &&
                        loginProvider.relativeNatIdController.text.isNotEmpty &&
                        selectedAcademicLevel != 'choose' &&
                        selectedRelativeType != 'choose'
                );
                loginProvider.notifyMe();
              },
              items: menuList.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: SizedBox(
                    width: width(0.7, context),
                    child: Text(
                      translate(value, context),
                      style: TextStyle(
                        color: value != 'choose'
                            ? (themeNotifier.isLight()
                            ? primaryColor
                              : Colors.white) : HexColor('#A6A6A6'),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const Icon(Icons.arrow_drop_down_outlined)
          ],
        )
    );
  }
}
