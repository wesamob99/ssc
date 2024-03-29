// ignore_for_file: file_names

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:ssc/models/login/registerData.dart';
import 'package:ssc/source/view/login/registerComponents/thirdStepBody.dart';
import 'package:ssc/source/view/login/registerScreen.dart';

import '../../../../infrastructure/userConfig.dart';
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

  LoginProvider loginProvider;
  List<String> relationTypes = ['choose', 'parent', 'brother', 'wife', 'child'];
  List<String> academicLevels = ['optionalChoose', 'phd', 'master',
    'hDiploma', 'ba', 'mDiploma', 'highSchool', 'lessHighSchool',
    'professionPracticeCertificate', 'apprenticeship', 'post-secondaryDiploma',
    'highSpecialization', 'specialtyCertificate', 'subspecialtyCertificate'];

  bool isJordanian = true;

  @override
  void initState() {
    loginProvider = Provider.of<LoginProvider>(context, listen: false);
    loginProvider.registerNationalIdController.clear();
    loginProvider.passportNumberController.clear();
    loginProvider.insuranceNumberController.clear();
    loginProvider.civilIdNumberController.clear();
    loginProvider.relativeNatIdController.clear();
    loginProvider.relativeNatIdController.clear();
    loginProvider.selectedDateOfBirth = DateTime.now();
    loginProvider.thirdStepSelection = ['choose', 'optionalChoose'];
    isJordanian = Provider.of<LoginProvider>(context, listen: false).registerData.nationality == 1;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    ThemeNotifier themeNotifier = Provider.of<ThemeNotifier>(context);

    return WillPopScope(
      onWillPop: () async => false,
      child: Stack(
        children: [
          RegisterScreen(
            fromOtpScreen: true,
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
                            getTranslated('secondStep', context),
                            style: TextStyle(
                                color: HexColor('#979797'),
                                fontSize: isTablet(context) ? width(0.025, context) : width(0.03, context)
                            ),
                          ),
                          SizedBox(height: height(0.006, context),),
                          Text(
                            getTranslated('personalInformations', context),
                            style: TextStyle(
                                color: HexColor('#5F5F5F'),
                                fontSize: isTablet(context) ? width(0.028, context) : width(0.035, context)
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
                            '${getTranslated('next', context)}: ${getTranslated('contactInformations', context)}',
                            style: TextStyle(
                                color: HexColor('#979797'),
                                fontSize: isTablet(context) ? width(0.025, context) : width(0.032, context)
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: height(0.02, context),),
                      buildFieldTitle(context, isJordanian ? 'enterJoNationalId' : 'enterNonJoNationalId', filled: (loginProvider.registerNationalIdController.text.length == 10 || loginProvider.flag == 1)),
                      SizedBox(height: height(0.015, context),),
                      buildTextFormField(context, themeNotifier, loginProvider.registerNationalIdController, (loginProvider.flag == 0) ? '9999999999' : 'val${loginProvider.registerData.userId}', (val){
                        checkContinueEnable(loginProvider);
                      }, inputType: TextInputType.number, enabled: (loginProvider.flag == 0)),
                      SizedBox(height: height(0.02, context),),
                      if(isJordanian)
                      buildFieldTitle(context, 'civilIdNumber', filled: loginProvider.civilIdNumberController.text.length == 8),
                      if(!isJordanian)
                      buildFieldTitle(context, 'passportNumber', filled: RegExp(r"^(?!^0+$)[a-zA-Z0-9]{3,20}$").hasMatch(loginProvider.passportNumberController.text)),
                      SizedBox(height: height(0.015, context),),
                      buildTextFormField(context, themeNotifier, isJordanian ? loginProvider.civilIdNumberController : loginProvider.passportNumberController, isJordanian ? 'AER20995' : '', (val){
                        checkContinueEnable(loginProvider);
                      },),
                      SizedBox(height: height(0.02, context),),
                      if(isJordanian)
                      buildFieldTitle(context, 'relativeNationalNumber', filled: loginProvider.relativeNatIdController.text.length == 10),
                      if(!isJordanian)
                      buildFieldTitle(context, 'insuranceNumber', required: loginProvider.insuranceNumberController.text.isNotEmpty, filled: loginProvider.insuranceNumberController.text.length == 10),
                      SizedBox(height: height(0.015, context),),
                      buildTextFormField(context, themeNotifier, isJordanian ? loginProvider.relativeNatIdController : loginProvider.insuranceNumberController, '9999999999', (val){
                        checkContinueEnable(loginProvider);
                      },inputType: TextInputType.number),
                      SizedBox(height: height(0.02, context),),
                      if(isJordanian)
                      buildFieldTitle(context, 'relativeRelation', filled: loginProvider.thirdStepSelection[0] != 'choose'),
                      if(!isJordanian)
                      buildFieldTitle(context, 'DateOfBirth', required: true, filled: DateFormat('dd/MM/yyyy').format(loginProvider.selectedDateOfBirth).isNotEmpty),
                      SizedBox(height: height(0.015, context),),
                      if(isJordanian)
                      dropDownList(relationTypes, themeNotifier, loginProvider, 0),
                      if(!isJordanian)
                      InkWell(
                        onTap: () {
                          DatePicker.showDatePicker(
                            context,
                            showTitleActions: true,
                            theme: DatePickerTheme(
                              headerColor: primaryColor,
                              backgroundColor: Colors.white,
                              itemStyle: TextStyle(
                                color: primaryColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                              doneStyle: const TextStyle(color: Colors.white, fontSize: 16,),
                              cancelStyle: const TextStyle(color: Colors.white, fontSize: 16),
                            ),
                            maxTime: DateTime.now(),
                            onConfirm: (date) {
                              checkContinueEnable(loginProvider);
                              loginProvider.selectedDateOfBirth = date;
                              loginProvider.notifyMe();
                            },
                            currentTime: loginProvider.selectedDateOfBirth,
                            locale: UserConfig.instance.isLanguageEnglish() ? LocaleType.en : LocaleType.ar,
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(12.0),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: HexColor('#979797'),
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                DateFormat('dd/MM/yyyy').format(loginProvider.selectedDateOfBirth),
                              ),
                              SvgPicture.asset('assets/icons/datePickerIcon.svg'),
                            ],
                          ),
                        ),
                      ),
                      // SizedBox(height: height(0.02, context),),
                      // buildFieldTitle('academicLevel', required: false),
                      // SizedBox(height: height(0.015, context),),
                      // dropDownList(academicLevels, themeNotifier, loginProvider, 1),
                    ],
                  ),
                  textButton(context, themeNotifier, 'continue', !Provider.of<LoginProvider>(context).registerContinueEnabled
                      ? HexColor('#DADADA')
                      : getPrimaryColor(context, themeNotifier),
                      Provider.of<LoginProvider>(context).registerContinueEnabled
                          ? HexColor('#ffffff') : HexColor('#363636'), () async {
                        if(loginProvider.registerContinueEnabled){
                          FocusScope.of(context).requestFocus(FocusNode());
                          loginProvider.isLoading = true;
                          loginProvider.notifyMe();
                          String errorMessage = "";
                          try{
                            setSecondStepData(loginProvider);
                            await loginProvider.registerSubmitSecondStep(
                                loginProvider.registerData.nationality,
                                loginProvider.registerData.nationalId,
                                loginProvider.registerData.personalNumber,
                                loginProvider.registerData.personalCardNo,
                                loginProvider.registerData.dateOfBirth,
                                loginProvider.registerData.insuranceNo,
                                loginProvider.registerData.nationalNumber,
                                loginProvider.registerData.relativeNatId,
                                loginProvider.registerData.relativeType
                            ).whenComplete((){})
                                .then((val) async {
                              if(val['PO_STATUS'] != 0){
                                errorMessage = UserConfig.instance.isLanguageEnglish()
                                    ? val["PO_STATUS_DESC_EN"] : val["PO_STATUS_DESC_AR"];
                                showMyDialog(context, 'registerFailed', errorMessage, 'retryAgain', themeNotifier);
                              } else{
                                errorMessage = '';
                                loginProvider.registerContinueEnabled = false;
                                Navigator.of(context).push(
                                    MaterialPageRoute(builder: (context) => const ThirdStepBody())
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
      ),
    );
  }

  setSecondStepData(LoginProvider loginProvider){
    if(loginProvider.flag == 0){
      loginProvider.registerData.nationalId = isJordanian ? int.tryParse(loginProvider.registerNationalIdController.text) : null;
      loginProvider.registerData.personalNumber = isJordanian ? null : int.tryParse(loginProvider.registerNationalIdController.text);
      loginProvider.registerData.userId = int.tryParse(loginProvider.registerNationalIdController.text);
    }
    loginProvider.registerData.personalCardNo = isJordanian ? loginProvider.civilIdNumberController.text : null;
    loginProvider.registerData.relativeNatId = isJordanian ? int.tryParse(loginProvider.relativeNatIdController.text) : null;
    loginProvider.registerData.relativeType = isJordanian ? relationTypes.indexOf(loginProvider.thirdStepSelection[0]) : null;
    loginProvider.registerData.dateOfBirth = isJordanian ? null : DateFormat('dd/MM/yyyy').format(loginProvider.selectedDateOfBirth);
    loginProvider.registerData.insuranceNo = isJordanian ? null : int.tryParse(loginProvider.insuranceNumberController.text);
    loginProvider.registerData.passportNo = isJordanian ? null : int.tryParse(loginProvider.passportNumberController.text);
    loginProvider.notifyMe();
  }

  dropDownList(List<String> menuList, ThemeNotifier themeNotifier, LoginProvider loginProvider, index){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: isTablet(context) ? 5 : 0.0),
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
                      getTranslated(value, context),
                      style: TextStyle(
                        color: value != 'choose' && value != 'optionalChoose'
                            ? (themeNotifier.isLight()
                            ? primaryColor
                              : Colors.white) : HexColor('#A6A6A6'),
                        fontSize: isTablet(context) ? 20 : 15,
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
        (loginProvider.registerNationalIdController.text.length == 10 || loginProvider.flag == 1) &&
            loginProvider.civilIdNumberController.text.length == 8 &&
            loginProvider.relativeNatIdController.text.length == 10 &&
            loginProvider.thirdStepSelection[0] != 'choose'
      );
    }else{
      loginProvider.registerContinueEnabled =  (
          (loginProvider.registerNationalIdController.text.length == 10 || loginProvider.flag == 1) &&
          RegExp(r"^(?!^0+$)[a-zA-Z0-9]{3,20}$").hasMatch(loginProvider.passportNumberController.text) &&
          (loginProvider.insuranceNumberController.text.isEmpty ||
          loginProvider.insuranceNumberController.text.length == 10) &&
          DateFormat('dd/MM/yyyy').format(loginProvider.selectedDateOfBirth).isNotEmpty
      );
    }
    loginProvider.notifyMe();
  }
}
