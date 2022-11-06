// ignore_for_file: file_names

import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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

  List<String> relationTypes = ['choose', 'parent', 'brother', 'wife', 'child'];
  List<String> academicLevels = ['optionalChoose', 'phd', 'master',
    'hDiploma', 'ba', 'mDiploma', 'highSchool', 'lessHighSchool',
    'professionPracticeCertificate', 'apprenticeship', 'post-secondaryDiploma',
    'highSpecialization', 'specialtyCertificate', 'subspecialtyCertificate'];

  bool isJordanian = true;

  @override
  void initState() {
    isJordanian = Provider.of<LoginProvider>(context, listen: false).registerData.nationality == 1;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    ThemeNotifier themeNotifier = Provider.of<ThemeNotifier>(context);
    LoginProvider loginProvider = Provider.of<LoginProvider>(context, listen: false);

    return WillPopScope(
      onWillPop: () async => false,
      child: RegisterScreen(
        stepNumber: 2,
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
                  buildFieldTitle('enterNationalId', filled: loginProvider.registerNationalIdController.text.isNotEmpty),
                  SizedBox(height: height(0.015, context),),
                  buildTextFormField(context, themeNotifier, loginProvider.registerNationalIdController, '9661001073', (val){
                    checkContinueEnable(loginProvider);
                  }, inputType: TextInputType.number),
                  SizedBox(height: height(0.02, context),),
                  if(isJordanian)
                  buildFieldTitle('civilIdNumber', filled: loginProvider.civilIdNumberController.text.isNotEmpty),
                  if(!isJordanian)
                  buildFieldTitle('passportNumber', filled: loginProvider.passportNumberController.text.isNotEmpty),
                  SizedBox(height: height(0.015, context),),
                  buildTextFormField(context, themeNotifier, isJordanian ? loginProvider.civilIdNumberController : loginProvider.passportNumberController, 'AER20995', (val){
                    checkContinueEnable(loginProvider);
                  },),
                  SizedBox(height: height(0.02, context),),
                  if(isJordanian)
                  buildFieldTitle('relativeNationalNumber', filled: loginProvider.relativeNatIdController.text.isNotEmpty),
                  if(!isJordanian)
                  buildFieldTitle('insuranceNumber', required: false),
                  SizedBox(height: height(0.015, context),),
                  buildTextFormField(context, themeNotifier, isJordanian ? loginProvider.relativeNatIdController : loginProvider.insuranceNumberController, '9661001073', (val){
                    checkContinueEnable(loginProvider);
                  },inputType: TextInputType.number),
                  SizedBox(height: height(0.02, context),),
                  if(isJordanian)
                  buildFieldTitle('relativeRelation', filled: loginProvider.thirdStepSelection[0] != 'choose'),
                  if(!isJordanian)
                  buildFieldTitle('DateOfBirth', required: true, filled: loginProvider.dateOfBirthController.text.isNotEmpty),
                  SizedBox(height: height(0.015, context),),
                  if(isJordanian)
                  dropDownList(relationTypes, themeNotifier, loginProvider, 0),
                  if(!isJordanian)
                  DateTimePicker(
                    decoration: InputDecoration(
                      suffixIcon: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: SvgPicture.asset('assets/icons/datePickerIcon.svg'),
                      ),
                      contentPadding: const EdgeInsets.only(left: 16.0, right: 16.0),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: HexColor('#979797'),
                          width: 0.5,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: HexColor('#445740'),
                          width: 0.8,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    style: TextStyle(
                      fontSize: 15,
                      color: HexColor('#363636')
                    ),
                    type: DateTimePickerType.date,
                    dateMask: 'yyyy/MM/dd',
                    controller: loginProvider.dateOfBirthController,
                    firstDate: DateTime(1900),
                    lastDate: DateTime.now(),
                    dateLabelText: 'Date',
                    onChanged: (val) => checkContinueEnable(loginProvider),
                  ),
                  // SizedBox(height: height(0.02, context),),
                  // buildFieldTitle('academicLevel', required: false),
                  // SizedBox(height: height(0.015, context),),
                  // dropDownList(academicLevels, themeNotifier, loginProvider, 1),
                ],
              ),
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
                      loginProvider.registerData.relativeType = relationTypes.indexOf(loginProvider.thirdStepSelection[0]);
                      loginProvider.registerData.academicLevel = relationTypes.indexOf(loginProvider.thirdStepSelection[1]).toString();
                      // print('nationality: ${loginProvider.registerData.nationality}');
                      // loginProvider.registerSubmitSecondStep(
                      //     loginProvider.registerData.nationality,
                      //     int.tryParse(loginProvider.registerNationalIdController.text),
                      //     personalNo,
                      //     loginProvider.civilIdNumberController.text,
                      //     birthDate,
                      //     secNo,
                      //     natCode,
                      //     int.tryParse(loginProvider.relativeNatIdController.text),
                      //     relationTypes.indexOf(loginProvider.thirdStepSelection[0])
                      // );
                      loginProvider.notifyMe();
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => const ThirdStepBody())
                      );
                    }
                    if (kDebugMode) {
                      print(registerDataToJson(loginProvider.registerData));
                    }
                  }),
            ],
          ),
        ),
      ),
    );
  }

  dropDownList(List<String> menuList, ThemeNotifier themeNotifier, LoginProvider loginProvider, index){
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 0.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: HexColor('#979797'),
        )
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            DropdownButton<String>(
              key: ObjectKey(loginProvider.thirdStepSelection[index]),
              value: loginProvider.thirdStepSelection[index],
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
                  if(index == 0){
                    loginProvider.thirdStepSelection[0] = value;
                  } else if(index == 1){
                    loginProvider.thirdStepSelection[1] = value;
                  }
                  loginProvider.notifyMe();
                });
                checkContinueEnable(loginProvider);
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
                        color: value != 'choose' && value != 'optionalChoose'
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

  checkContinueEnable(LoginProvider loginProvider){
    if(isJordanian) {
      loginProvider.registerContinueEnabled =  (
        loginProvider.registerNationalIdController.text.isNotEmpty &&
            loginProvider.civilIdNumberController.text.isNotEmpty &&
            loginProvider.relativeNatIdController.text.isNotEmpty &&
            loginProvider.thirdStepSelection[0] != 'choose'
      );
    }else{
      loginProvider.registerContinueEnabled =  (
          loginProvider.registerNationalIdController.text.isNotEmpty &&
          loginProvider.passportNumberController.text.isNotEmpty &&
          loginProvider.insuranceNumberController.text.isNotEmpty &&
          loginProvider.dateOfBirthController.text.isNotEmpty
      );
    }
    loginProvider.notifyMe();
  }

  Widget buildFieldTitle(title, {required = true, filled = false}){
    return Row(
      children: [
        Text(
          translate(title, context),
          style: TextStyle(
              color: HexColor('#363636'),
              fontSize: width(0.032, context)
          ),
        ),
        if(required)
        Text(
          ' *',
          style: TextStyle(
            color: filled ? HexColor('#445740') : HexColor('#FF1818'),
          ),
        ),
      ],
    );
  }
}
