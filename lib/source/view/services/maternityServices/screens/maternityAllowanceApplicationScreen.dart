// ignore_for_file: file_names

import 'package:drop_down_list/model/selected_list_item.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as path;
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:ssc/source/view/services/shared/documentsScreen.dart';
import 'package:ssc/source/viewModel/accountSettings/accountSettingsProvider.dart';
import 'package:ssc/source/viewModel/services/servicesProvider.dart';
import 'package:ssc/source/viewModel/utilities/theme/themeProvider.dart';

import '../../../../../infrastructure/userConfig.dart';
import '../../../../../infrastructure/userSecuredStorage.dart';
import '../../../../../utilities/countries.dart';
import '../../../../../utilities/hexColor.dart';
import '../../../../../utilities/theme/themes.dart';
import '../../../../../utilities/util.dart';
import 'dart:math' as math;
import '../../../../viewModel/login/loginProvider.dart';
import '../../shared/firstStepScreen.dart';
import '../../shared/paymentScreen.dart';
import '../../shared/verifyMobileNumberScreen.dart';

class MaternityAllowanceApplicationScreen extends StatefulWidget {
  const MaternityAllowanceApplicationScreen({Key key}) : super(key: key);

  @override
  State<MaternityAllowanceApplicationScreen> createState() => _MaternityAllowanceApplicationScreenState();
}

class _MaternityAllowanceApplicationScreenState extends State<MaternityAllowanceApplicationScreen> {

  ServicesProvider servicesProvider;
  ThemeNotifier themeNotifier;
  bool termsChecked = false;
  bool isNewBornValidID = false;
  // ignore: prefer_typing_uninitialized_variables
  var newBornData;
  DateTime minDate;
  DateTime maxDate;
  DateTime selectedMinDate;
  DateTime selectedDateOfBirth = DateTime.now();
  String selectedNewbornNationality = 'jordanian';
  String selectedPlaceOfBirth = 'insideJordan';
  String isTherePermitToExpectHisBirth = 'yes';
  TextEditingController newbornNationalNumberController = TextEditingController();
  List docs = [];

  checkContinueEnabled({flag = 0}){
    if(flag == 1){
      return servicesProvider.disableMobileValidations ? servicesProvider.mobileNumberController.text.isNotEmpty : mobileNumberValidate(servicesProvider.mobileNumberController.text);
    } else if(flag == 2){
      if(servicesProvider.isMobileNumberUpdated){
        return Provider.of<ServicesProvider>(context, listen: false).pinPutFilled;
      } else{
        return newBornData != null || (selectedNewbornNationality == 'nonJordanian' && selectedPlaceOfBirth == 'outsideJordan');
      }
    } else if(flag == 4){
      if(servicesProvider.selectedActivePayment['ID'] == 5){
        return servicesProvider.bankNameController.text.isNotEmpty &&
            servicesProvider.bankBranchController.text.isNotEmpty &&
            servicesProvider.bankAddressController.text.isNotEmpty &&
            servicesProvider.accountNoController.text.isNotEmpty &&
            servicesProvider.swiftCodeController.text.isNotEmpty &&
            servicesProvider.paymentMobileNumberController.text.isNotEmpty;
      } else{
        return true;
      }
    } else if(flag == 5){
      return termsChecked;
    }
    return true;
  }

  @override
  void initState() {
    themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);
    Provider.of<LoginProvider>(context, listen: false).readCountriesJson();
    servicesProvider = Provider.of<ServicesProvider>(context, listen: false);
    servicesProvider.mobileNumberController.text = UserSecuredStorage.instance.realMobileNumber;
    servicesProvider.documentIndex = 0;
    servicesProvider.documentsScreensStepNumber = 1;
    servicesProvider.dependentsDocuments = [];
    servicesProvider.mandatoryDocuments = [];
    servicesProvider.optionalDocuments = [];
    servicesProvider.optionalDocumentsCheckBox = [];
    servicesProvider.selectedOptionalDocuments = [];
    servicesProvider.activePayment = [];
    servicesProvider.getActivePayment("2", servicesProvider.result['p_per_info'][0][0]['NAT'] == "111" ? '1' : '2').whenComplete(() {}).then((value) {
      value['R_RESULT'][0].forEach((element){
        servicesProvider.activePayment.add(element);
      });
      servicesProvider.selectedActivePayment = servicesProvider.activePayment[0];
    });
    servicesProvider.selectedPaymentCountry = SelectedListItem(
      name: UserConfig.instance.isLanguageEnglish() ? "Palestine" : "فلسطين",
      value: "970", natCode: 188,
      flag: countries.where((element) => element.dialCode == "970").first.flag,
    );
    servicesProvider.stepNumber = 1;
    servicesProvider.uploadedFiles = {
      "mandatory": [],
      "optional": [],
    };
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: (servicesProvider.documentsScreensStepNumber == 1 || servicesProvider.documentsScreensStepNumber == 3) && servicesProvider.stepNumber == 3
          ? HexColor('#445740') : HexColor('#ffffff'),
      appBar: AppBar(
        centerTitle: false,
        title: Text(getTranslated('maternityAllowanceApplication', context)),
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: InkWell(
            onTap: (){
              if(servicesProvider.stepNumber == 3){
                switch(servicesProvider.documentsScreensStepNumber){
                  case 1: servicesProvider.stepNumber = 2; break;
                  case 2: {
                    if(servicesProvider.documentIndex > 0){
                      servicesProvider.documentIndex--;
                    } else{
                      servicesProvider.documentsScreensStepNumber = 1;
                    }
                  } break;
                  case 3: {
                    if(servicesProvider.mandatoryDocuments.isNotEmpty){
                      servicesProvider.documentIndex = servicesProvider.mandatoryDocuments.length - 1;
                      servicesProvider.documentsScreensStepNumber = 2;
                    } else{
                      servicesProvider.documentsScreensStepNumber = 1;
                    }
                  } break;
                  case 4: {
                    if(servicesProvider.documentIndex > 0){
                      servicesProvider.documentIndex--;
                    } else{
                      servicesProvider.documentsScreensStepNumber = 3;
                    }
                  } break;
                  case 5: {
                    if(servicesProvider.selectedOptionalDocuments.isNotEmpty){
                      servicesProvider.documentIndex = servicesProvider.selectedOptionalDocuments.length - 1;
                      servicesProvider.documentsScreensStepNumber = 4;
                    } else{
                      servicesProvider.documentsScreensStepNumber = 3;
                    }
                  } break;
                }
              } else{
                switch(servicesProvider.stepNumber){
                  case 1: Navigator.of(context).pop(); break;
                  case 2: servicesProvider.stepNumber = 1; break;
                  case 4:
                    {
                      servicesProvider.stepNumber = 3;
                      servicesProvider.documentsScreensStepNumber = 5;
                    } break;
                  case 5:
                    {
                      servicesProvider.stepNumber = 4;
                    }
                    break;
                }
              }
              servicesProvider.notifyMe();
            },
            child: Transform.rotate(
              angle: UserConfig.instance.isLanguageEnglish()
                  ? -math.pi / 1.0 : 0,
              child: SvgPicture.asset(
                  'assets/icons/backWhite.svg'
              ),
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          GestureDetector(
            onTap: (){
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: WillPopScope(
              onWillPop: () async => false,
              child: Container(
                width: width(1, context),
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      if(Provider.of<ServicesProvider>(context).stepNumber == 1)
                        const FirstStepScreen(nextStep: 'ensureFinancialSolvency', numberOfSteps: 5),
                      if(Provider.of<ServicesProvider>(context).stepNumber == 2 && Provider.of<ServicesProvider>(context).isMobileNumberUpdated)
                        VerifyMobileNumberScreen(nextStep: 'ensureFinancialSolvency', numberOfSteps: 5, mobileNo: servicesProvider.mobileNumberController.text ?? ''),
                      if(Provider.of<ServicesProvider>(context).stepNumber == 2 && !Provider.of<ServicesProvider>(context).isMobileNumberUpdated)
                        secondStep(context, themeNotifier),
                      if(Provider.of<ServicesProvider>(context).stepNumber == 3)
                        DocumentsScreen(nextStep: 'receiptOfAllowances', numberOfSteps: 5, data: {
                          'PAYMENT_METHOD': "",
                          'BANK_LOCATION': "",
                          'BRANCH_ID': '',
                          'BRANCH_NAME': '',
                          'BANK_ID': '',
                          'BANK_NAME': '',
                          'ACCOUNT_NAME': '',
                          'PAYMENT_COUNTRY': '',
                          'PAYMENT_COUNTRY_CODE': '',
                          'PAYMENT_PHONE': '',
                          'SWIFT_CODE': '',
                          'BANK_DETAILS': '',
                          'IBAN': '',
                          'CASH_BANK_ID': '',
                          // معلومات الوكيل (REP)
                          'REP_NATIONALITY': '',
                          'REP_NATIONAL_NO': '',
                          'REP_NAME': '',
                          // معلومات المحفظه (WALLET)
                          'WALLET_TYPE': '',
                          'WALLET_OTP_VERIVIED': null,
                          'WALLET_OTP': null,
                          'WALLET_PHONE': '',
                          'WALLET_PHONE_VERIVIED': '',
                          'WALLET_PASSPORT_NUMBER': '',
                          'PEN_IBAN': null,
                          "IFSC": "",
                          "SECNO": servicesProvider.result['p_per_info'][0][0]['SECNO'],
                          "NAT_DESC": servicesProvider.result['p_per_info'][0][0]['NAT_DESC'],
                          "NAT": int.tryParse(servicesProvider.result['p_per_info'][0][0]['NAT'].toString()),
                          "NAT_NO": servicesProvider.result['p_per_info'][0][0]['NAT_NO'],
                          "PERS_NO": servicesProvider.result['p_per_info'][0][0]['PERS_NO'],
                          "LAST_EST_NAME": servicesProvider.result['p_per_info'][0][0]['LAST_EST_NAME'],
                          "NAME1": servicesProvider.result['p_per_info'][0][0]['NAME1'],
                          "NAME2": servicesProvider.result['p_per_info'][0][0]['NAME2'],
                          "NAME3": servicesProvider.result['p_per_info'][0][0]['NAME3'],
                          "NAME4": servicesProvider.result['p_per_info'][0][0]['NAME4'],
                          "FULL_NAME_EN": servicesProvider.result['p_per_info'][0][0]['FULL_NAME_EN'],
                          "EMAIL": servicesProvider.result['p_per_info'][0][0]['EMAIL'],
                          "MOBILE": servicesProvider.result['p_per_info'][0][0]['MOBILE'],
                          "INTERNATIONAL_CODE": servicesProvider.result['p_per_info'][0][0]['INTERNATIONAL_CODE'],
                          "MARITAL_STATUS": null,
                          "REGDATE": null,
                          "REGRATE": null,
                          "LAST_SALARY": null,
                          "LAST_STODATE": null,
                          "GENDER": servicesProvider.result['p_per_info'][0][0]['GENDER'],
                          "PEN_START_DATE": null,
                          "DETAILED_ADDRESS": null,
                          "PASS_NO": null,
                          "RESIDENCY_NO": null,
                          "DOB": servicesProvider.result['p_per_info'][0][0]['DOB'],
                          "JOB_NO": null,
                          "JOB_DESC": null,
                          "ENAME1": null,
                          "ENAME2": null,
                          "ENAME3": null,
                          "ENAME4": null,
                          "LAST_EST_NO": servicesProvider.result['p_per_info'][0][0]['LAST_EST_NO'],
                          "FAM_NO": null,
                          "nextVaild": null,
                          "wantAddFamily": null,
                          "GENDER_DESC": servicesProvider.result['p_per_info'][0][0]['GENDER_DESC'],
                          "PI_EPAY": null,
                          "INSURED": null,
                          "ID": null,
                          "DEP_FLAG": 0,
                          "OFFNO": servicesProvider.result['p_per_info'][0][0]['OFFNO'],
                          "BIRTH_PLACE": selectedPlaceOfBirth == 'insideJordan' ? 1 : 0,
                          "CHILD_NATIONALITY": selectedNewbornNationality == 'jordanian' ? 1 : 0,
                          "CHILD_NAT_NO": (selectedNewbornNationality == 'nonJordanian' && selectedPlaceOfBirth == 'outsideJordan') ? newbornNationalNumberController.text : null,
                          "CHILD_SERIAL_NO": !(selectedNewbornNationality == 'nonJordanian' && selectedPlaceOfBirth == 'outsideJordan') ? newbornNationalNumberController.text : null,
                          "BIRTH_DATE": !(selectedNewbornNationality == 'nonJordanian' && selectedPlaceOfBirth == 'outsideJordan')
                          ? DateFormat('dd/MM/yyyy').parse(newBornData['cur_getdata'][0][0]['CHILD_BIRTHDATE']).toString()
                          : selectedDateOfBirth.toString(),
                          "BIRTH_EXPECTATION": isTherePermitToExpectHisBirth == 'yes' ? 1 : 0,
                          "LEAVE_START_DATE": selectedMinDate.toIso8601String(),
                          "LEAVE_END_DATE": selectedMinDate.add(Duration(days: servicesProvider.result['p_per_info'][0][0]['MAT_VAC_PERIOD'] - 1)).toIso8601String(),
                          "MOTHER_NAME": null,
                          "C_M_NAME1": !(selectedNewbornNationality == 'nonJordanian' && selectedPlaceOfBirth == 'outsideJordan') ? newBornData['cur_getdata'][0][0]['C_M_NAME1'] : null,
                          "C_M_NAME2": !(selectedNewbornNationality == 'nonJordanian' && selectedPlaceOfBirth == 'outsideJordan') ? newBornData['cur_getdata'][0][0]['C_M_NAME2'] : null,
                          "C_M_NAME3": !(selectedNewbornNationality == 'nonJordanian' && selectedPlaceOfBirth == 'outsideJordan') ? newBornData['cur_getdata'][0][0]['C_M_NAME3'] : null,
                          "C_M_NAME4": !(selectedNewbornNationality == 'nonJordanian' && selectedPlaceOfBirth == 'outsideJordan') ? newBornData['cur_getdata'][0][0]['C_M_NAME4'] : null,
                        }, serviceType: 4, dependents: const [], relations: const [], nextStepNumber: 4, stepText: 'thirdStep',),
                      if(Provider.of<ServicesProvider>(context).stepNumber == 4)
                        const PaymentScreen(numberOfSteps: 5, nextStep: 'confirmRequest', stepText: 'forthStep', stepNumber: 4,),
                      if(Provider.of<ServicesProvider>(context).stepNumber == 5)
                        fifthStep(context, themeNotifier),
                      if(!(Provider.of<ServicesProvider>(context).stepNumber == 3))
                        textButton(context,
                          themeNotifier,
                          Provider.of<ServicesProvider>(context).stepNumber != 5 ? 'continue' : 'send',
                          checkContinueEnabled(flag: Provider.of<ServicesProvider>(context).stepNumber)
                              ? getPrimaryColor(context, themeNotifier) : HexColor('#DADADA'),
                          checkContinueEnabled(flag: Provider.of<ServicesProvider>(context).stepNumber)
                              ? HexColor('#ffffff') : HexColor('#363636'),
                              () async {
                            switch(servicesProvider.stepNumber){
                              case 1: {
                                if(checkContinueEnabled(flag: 1)){
                                  if(servicesProvider.isMobileNumberUpdated){
                                    servicesProvider.isLoading = true;
                                    servicesProvider.notifyMe();
                                    String errorMessage = "";
                                    try{
                                      await servicesProvider.updateUserMobileNumberSendOTP(servicesProvider.mobileNumberController.text).whenComplete((){})
                                          .then((val) async {
                                        if(val['PO_STATUS'] == '1'){
                                          servicesProvider.isMobileNumberUpdated = true;
                                          servicesProvider.stepNumber = 2;
                                        }else{
                                          servicesProvider.isMobileNumberUpdated = false;
                                          errorMessage = UserConfig.instance.isLanguageEnglish()
                                              ? val["PO_STATUS_DESC_EN"] : val["PO_STATUS_DESC_AR"];
                                          showMyDialog(context, 'updateMobileNumberFailed', errorMessage, 'retryAgain', themeNotifier);
                                        }
                                        servicesProvider.notifyMe();
                                      });
                                      servicesProvider.isLoading = false;
                                      servicesProvider.notifyMe();
                                    }catch(e){
                                      servicesProvider.isMobileNumberUpdated = false;
                                      servicesProvider.isLoading = false;
                                      servicesProvider.notifyMe();
                                      if (kDebugMode) {
                                        print(e.toString());
                                      }
                                    }
                                  } else{
                                    servicesProvider.stepNumber = 2;
                                    servicesProvider.isMobileNumberUpdated = false;
                                    servicesProvider.notifyMe();
                                  }
                                }
                              } break;
                              case 2: {
                                if(checkContinueEnabled(flag: 2)){
                                  if(servicesProvider.isMobileNumberUpdated){
                                    servicesProvider.isLoading = true;
                                    servicesProvider.notifyMe();
                                    String errorMessage = "";
                                    try{
                                      await servicesProvider.updateUserMobileNumberCheckOTP(servicesProvider.pinPutCodeController.text).whenComplete((){}).then((val) async {
                                        if(val['PO_STATUS'] == 1){
                                          await Provider.of<AccountSettingsProvider>(context, listen: false).updateUserInfo(2, servicesProvider.mobileNumberController.text).whenComplete((){}).then((value){
                                            if(value["PO_STATUS"] == 0){
                                              servicesProvider.stepNumber = 2;
                                              servicesProvider.isMobileNumberUpdated = false;
                                              UserSecuredStorage.instance.realMobileNumber = servicesProvider.mobileNumberController.text;
                                              setState(() {});
                                            }else{
                                              showMyDialog(context, 'updateMobileNumberFailed', UserConfig.instance.isLanguageEnglish()
                                                  ? value["PO_STATUS_DESC_EN"] : value["PO_STATUS_DESC_AR"], 'retryAgain', themeNotifier).then((value) {
                                                servicesProvider.mobileNumberController.text = '';
                                                servicesProvider.stepNumber = 1;
                                                servicesProvider.notifyMe();
                                              });
                                            }
                                          });
                                        }else{
                                          servicesProvider.stepNumber = 2;
                                          servicesProvider.isMobileNumberUpdated = true;
                                          errorMessage = UserConfig.instance.isLanguageEnglish()
                                              ? val["PO_STATUS_DESC_EN"] : val["PO_STATUS_DESC_AR"];
                                          showMyDialog(context, 'updateMobileNumberFailed', errorMessage, 'retryAgain', themeNotifier);
                                        }
                                        servicesProvider.notifyMe();
                                      });
                                      servicesProvider.isLoading = false;
                                      servicesProvider.notifyMe();
                                    }catch(e){
                                      servicesProvider.stepNumber = 2;
                                      servicesProvider.isMobileNumberUpdated = true;
                                      servicesProvider.isLoading = false;
                                      servicesProvider.notifyMe();
                                      if (kDebugMode) {
                                        print(e.toString());
                                      }
                                    }
                                    servicesProvider.pinPutCodeController.text = "";
                                    servicesProvider.pinPutFilled = false;
                                    servicesProvider.notifyMe();
                                  } else{
                                    if(checkContinueEnabled(flag: 2)) {
                                      servicesProvider.stepNumber = 3;
                                      servicesProvider.isMobileNumberUpdated = false;
                                    }
                                  }
                                }
                              } break;
                              case 4: {
                                if(checkContinueEnabled(flag: 4)){
                                  servicesProvider.stepNumber = 5;
                                }
                              } break;
                              case 5: {
                                /// TODO: create maternity set application and finish the service
                                if(checkContinueEnabled(flag: 5)){
                                  try{
                                    String message = '';
                                    servicesProvider.isLoading = true;
                                    servicesProvider.isModalLoading = false;
                                    servicesProvider.notifyMe();
                                    Map<String, dynamic> paymentInfo = {
                                      'PAYMENT_METHOD': servicesProvider.selectedActivePayment['ID'],
                                      'BANK_LOCATION': servicesProvider.selectedActivePayment['ID'] == 5 ? servicesProvider.bankAddressController.text : 0,
                                      'BRANCH_ID': servicesProvider.selectedActivePayment['ID'] == 5 ? '' : '',
                                      'BRANCH_NAME': servicesProvider.selectedActivePayment['ID'] == 5 ? servicesProvider.bankBranchController.text : '',
                                      'BANK_ID': servicesProvider.selectedActivePayment['ID'] == 5 ? '' : '',
                                      'BANK_NAME': servicesProvider.selectedActivePayment['ID'] == 5 ? servicesProvider.bankNameController.text : '',
                                      'ACCOUNT_NAME': servicesProvider.selectedActivePayment['ID'] == 5 ? servicesProvider.accountNoController.text : '',
                                      'PAYMENT_COUNTRY': servicesProvider.selectedActivePayment['ID'] == 5 ? servicesProvider.selectedPaymentCountry.name : '',
                                      'PAYMENT_COUNTRY_CODE': servicesProvider.selectedActivePayment['ID'] == 5 ? servicesProvider.selectedPaymentCountry.value : '',
                                      'PAYMENT_PHONE': servicesProvider.selectedActivePayment['ID'] == 5 ? servicesProvider.paymentMobileNumberController.text : '',
                                      'SWIFT_CODE': servicesProvider.selectedActivePayment['ID'] == 5 ? servicesProvider.swiftCodeController.text : '',
                                      'BANK_DETAILS': servicesProvider.selectedActivePayment['ID'] == 5 ? '' : '',
                                      'IBAN': servicesProvider.selectedActivePayment['ID'] == 3 ? servicesProvider.result["p_per_info"][0][0]["IBAN"] : '',
                                      'CASH_BANK_ID': servicesProvider.selectedActivePayment['ID'] == 5 ? '' : '',
                                      // معلومات الوكيل (REP)
                                      'REP_NATIONALITY': servicesProvider.selectedActivePayment['ID'] == 5 ? '' : '',
                                      'REP_NATIONAL_NO': servicesProvider.selectedActivePayment['ID'] == 5 ? '' : '',
                                      'REP_NAME': servicesProvider.selectedActivePayment['ID'] == 5 ? '' : '',
                                      // معلومات المحفظه (WALLET)
                                      'WALLET_TYPE': servicesProvider.selectedActivePayment['ID'] == 5 ? '' : '',
                                      'WALLET_OTP_VERIVIED': servicesProvider.selectedActivePayment['ID'] == 5 ? '' : null,
                                      'WALLET_OTP': servicesProvider.selectedActivePayment['ID'] == 5 ? '' : null,
                                      'WALLET_PHONE': servicesProvider.selectedActivePayment['ID'] == 5 ? '' : '',
                                      'WALLET_PHONE_VERIVIED': servicesProvider.selectedActivePayment['ID'] == 5 ? '' : '',
                                      'WALLET_PASSPORT_NUMBER': servicesProvider.selectedActivePayment['ID'] == 5 ? '' : '',
                                      'PEN_IBAN': servicesProvider.selectedActivePayment['ID'] == 5 ? '' : null,
                                    };
                                    List mandatoryDocs = await saveFiles('mandatory');
                                    List optionalDocs = await saveFiles('optional');
                                    docs.addAll(mandatoryDocs + optionalDocs);
                                    await servicesProvider.setMaternityAllowanceApplication(
                                      docs, paymentInfo,
                                      !(selectedNewbornNationality == 'nonJordanian' && selectedPlaceOfBirth == 'outsideJordan') ? newBornData : null,
                                      isTherePermitToExpectHisBirth == 'yes' ? 1 : 0,
                                      !(selectedNewbornNationality == 'nonJordanian' && selectedPlaceOfBirth == 'outsideJordan') ? newbornNationalNumberController.text : null,
                                      (selectedNewbornNationality == 'nonJordanian' && selectedPlaceOfBirth == 'outsideJordan') ? newbornNationalNumberController.text : null,
                                      selectedNewbornNationality == 'jordanian' ? 1 : 0,
                                      selectedPlaceOfBirth == 'insideJordan' ? 1 : 0,
                                      selectedMinDate, selectedMinDate.add(Duration(days: servicesProvider.result['p_per_info'][0][0]['MAT_VAC_PERIOD'] - 1)), selectedDateOfBirth
                                    ).whenComplete(() {}).then((value) {
                                      if(value != null && value['P_Message'] != null && value['P_Message'][0][0]['PO_STATUS'] == 0){
                                        message = getTranslated('youCanCheckAndFollowItsStatusFromMyOrdersScreen', context);
                                        if(value['PO_TYPE'] == 2){
                                          message = UserConfig.instance.isLanguageEnglish()
                                              ? value['P_Message'][0][0]['PO_STATUS_DESC_EN'] : value['P_Message'][0][0]['PO_STATUS_DESC_AR'];
                                        }
                                        showMyDialog(context, 'yourRequestHasBeenSentSuccessfully',
                                            message, 'ok',
                                            themeNotifier,
                                            icon: 'assets/icons/serviceSuccess.svg', titleColor: '#2D452E').then((_){
                                          SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
                                            servicesProvider.selectedServiceRate = -1;
                                            servicesProvider.notifyMe();
                                            rateServiceBottomSheet(context, themeNotifier, servicesProvider);
                                          });
                                        });
                                      } else{
                                        message = UserConfig.instance.isLanguageEnglish()
                                            ? value['P_Message'][0][0]['PO_STATUS_DESC_EN'] : value['P_Message'][0][0]['PO_STATUS_DESC_AR'];
                                        showMyDialog(context, 'failed', message, 'cancel', themeNotifier);
                                      }
                                    });
                                    servicesProvider.isLoading = false;
                                    servicesProvider.notifyMe();
                                  } catch(e){
                                    servicesProvider.isLoading = false;
                                    servicesProvider.notifyMe();
                                    if (kDebugMode) {
                                      print(e.toString());
                                    }
                                  }
                                }
                              } break;
                            }
                            servicesProvider.notifyMe();
                          },
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          if(Provider.of<ServicesProvider>(context).isLoading && !Provider.of<ServicesProvider>(context).isModalLoading)
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

  saveFiles(String type) async{
    List docs = [];
    for(int i=0 ; i<servicesProvider.uploadedFiles[type].length ; i++){
      if(servicesProvider.uploadedFiles[type][i] != null){
        int j=0;
        while(j<servicesProvider.uploadedFiles[type][i].length){
          try{
            await servicesProvider.saveFile(servicesProvider.uploadedFiles[type][i][j]["file"]).whenComplete(() {}).then((value) {
              if (kDebugMode) {
                print('value: $value');
              }
              Map document = {
                "PATH": value['path'],
                "DOC_TYPE": servicesProvider.uploadedFiles[type][i][j]["document"]["ID"],
                "FILE": {},
                "FILE_NAME": path.basename(value['path'].toString()),
                "DOC_TYPE_DESC_AR": servicesProvider.uploadedFiles[type][i][j]["document"]["NAME_AR"],
                "DOC_TYPE_DESC_EN": servicesProvider.uploadedFiles[type][i][j]["document"]["NAME_EN"],
                "DOCUMENT_DATE": DateFormat("dd/MM/yyyy", 'en').format(DateTime.now()),
                "required": type == 'mandatory' ? 0 : 1,
                "APP_ID": '',
                "ID": "",
                "STATUS": 1,
                "HIDE_ACTIONS": false
              };
              docs.add(document);
            });
            j++;
          }catch(e){
            j++;
            if (kDebugMode) {
              print(e.toString());
            }
          }
        }
      }
    }
    return docs;
  }

  Widget secondStep(context, themeNotifier){
    return SizedBox(
      height: isTablet(context) ? height(0.78, context) : isScreenHasSmallHeight(context) ? height(0.73, context) : height(0.75, context),
      child: SingleChildScrollView(
        child: Column(
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
                      fontSize: width(0.03, context)
                  ),
                ),
                SizedBox(height: height(0.006, context),),
                Text(
                  getTranslated('orderDetails', context),
                  style: TextStyle(
                      color: HexColor('#5F5F5F'),
                      fontSize: width(0.035, context)
                  ),
                )
              ],
            ),
            SizedBox(height: height(0.01, context),),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox.shrink(),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '2/5',
                      style: TextStyle(
                          color: HexColor('#979797'),
                          fontSize: width(0.025, context)
                      ),
                    ),
                    Text(
                      '${getTranslated('next', context)}: ${getTranslated('documents', context)}',
                      style: TextStyle(
                          color: HexColor('#979797'),
                          fontSize: width(0.032, context)
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10.0,),
            buildFieldTitle(context, 'newbornNationality', required: false),
            const SizedBox(height: 10.0,),
            customTwoRadioButtons(1, 'jordanian', 'nonJordanian', setState),
            const SizedBox(height: 15.0,),
            buildFieldTitle(context, 'placeOfBirth', required: false),
            const SizedBox(height: 10.0,),
            customTwoRadioButtons(2, 'insideJordan', 'outsideJordan', setState),
            const SizedBox(height: 15.0,),
            if(!(selectedNewbornNationality == 'nonJordanian' && selectedPlaceOfBirth == 'outsideJordan'))
            Column(
              children: [
                buildFieldTitle(context, selectedNewbornNationality == 'jordanian' ? 'newbornNationalNumber' : 'newbornNationalID', required: false),
                const SizedBox(height: 10.0,),
                buildTextFormField(context, themeNotifier, newbornNationalNumberController, '9999999999', (value) async {
                  if((selectedNewbornNationality == 'jordanian' && value.length == 10) || (selectedNewbornNationality == 'nonJordanian' && selectedPlaceOfBirth == 'outsideJordan')){
                    FocusScope.of(context).requestFocus(FocusNode());
                    String message = '';
                    servicesProvider.isLoading = true;
                    servicesProvider.notifyMe();
                    try{
                      await servicesProvider.getMaternityChildService(value).whenComplete((){}).then((value) async {
                        if(value['PO_status'] == 0){
                          setState(() {
                            isNewBornValidID = true;
                            newBornData = value;
                            minDate = DateFormat('dd/MM/yyyy').parse(value['cur_getdata'][0][0]['CHILD_BIRTHDATE']);
                            selectedMinDate = minDate;
                            maxDate = DateFormat('dd/MM/yyyy').parse(value['cur_getdata'][0][0]['CHILD_BIRTHDATE']).add(
                                Duration(days: servicesProvider.result['p_per_info'][0][0]['MAT_VAC_PERIOD'] - 1)
                            );
                          });
                          servicesProvider.notifyMe();
                        } else{
                          setState(() {
                            isNewBornValidID = false;
                            newBornData = null;
                            minDate = null;
                            selectedMinDate = minDate;
                            maxDate = null;
                          });
                          servicesProvider.notifyMe();
                          message = UserConfig.instance.isLanguageEnglish()
                              ? value['pO_status_desc_EN'] : value['pO_status_desc_AR'];
                          showMyDialog(context, 'failed', message, 'ok', themeNotifier);
                        }
                      });
                      servicesProvider.isLoading = false;
                      servicesProvider.notifyMe();
                    }catch(e){
                      servicesProvider.isLoading = false;
                      servicesProvider.notifyMe();
                      showMyDialog(context, 'failed', getTranslated('somethingWrongHappened', context), 'ok', themeNotifier);
                      if (kDebugMode) {
                        print(e.toString());
                      }
                    }
                  } else{
                    setState(() {
                      isNewBornValidID = false;
                      newBornData = null;
                      minDate = null;
                      selectedMinDate = minDate;
                      maxDate = null;
                    });
                    servicesProvider.notifyMe();
                  }
                }, inputType: TextInputType.number),
              ],
            ),
            if(selectedNewbornNationality == 'nonJordanian' && selectedPlaceOfBirth == 'outsideJordan')
            Column(
              children: [
                buildFieldTitle(context, 'DateOfBirth', required: false),
                const SizedBox(height: 10.0,),
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
                        setState(() {
                          selectedDateOfBirth = date;
                          if(isTherePermitToExpectHisBirth == 'yes'){
                            minDate = date.subtract(
                              Duration(days: servicesProvider.result['p_per_info'][0][0]['MAX_EXP_VAC']),
                            );
                            selectedMinDate = minDate;
                            maxDate = date;
                          }else {
                            minDate = date;
                            selectedMinDate = minDate;
                            maxDate = date.add(
                              Duration(days: servicesProvider.result['p_per_info'][0][0]['MAT_VAC_PERIOD'] - 1),
                            );
                          }
                        });
                      },
                      currentTime: DateTime.now(),
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
                          DateFormat('dd/MM/yyyy').format(selectedDateOfBirth),
                        ),
                        SvgPicture.asset('assets/icons/datePickerIcon.svg'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15.0,),
            if(isNewBornValidID || (selectedNewbornNationality == 'nonJordanian' && selectedPlaceOfBirth == 'outsideJordan'))
            Column(
              children: [
                buildFieldTitle(context, 'isTherePermitToExpectHisBirth', required: false),
                const SizedBox(height: 10.0,),
                customTwoRadioButtons(3, 'yes', 'no', setState),
                SizedBox(height: isTherePermitToExpectHisBirth == 'yes' ? 15.0 : 0.0,),
                if(isTherePermitToExpectHisBirth == 'yes')
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(getTranslated('theStartDateOfTheLeave', context)),
                            const SizedBox(height: 10.0,),
                            Text(
                              '${getTranslated('choose', context)} ${getTranslated('theStartDateOfTheLeave', context)}',
                              style: TextStyle(
                                color: HexColor('#A6A6A6'),
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        InkWell(
                          onTap: (){
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
                              minTime: minDate,
                              maxTime: maxDate,
                              onConfirm: (date) {
                                setState(() {
                                  selectedMinDate = date;
                                });
                              },
                              currentTime: selectedMinDate,
                              locale: UserConfig.instance.isLanguageEnglish() ? LocaleType.en : LocaleType.ar,
                            );
                          },
                          child: SvgPicture.asset('assets/icons/calenderBox.svg'),
                        )
                      ],
                    ),
                    const SizedBox(height: 10.0),
                    SizedBox(
                      height: 82.0,
                      child: ListView.builder(
                        itemCount: maxDate.difference(minDate).inDays + 1,
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index){
                          DateTime date = minDate.add(Duration(days: index));
                          String dayNameArabic = DateFormat.EEEE('ar').format(date); // Get the day name in Arabic
                          String dayNameEnglish = DateFormat.EEEE('en').format(date); // Get the day name in English
                          String dayNumber = DateFormat('d').format(date);
                          return Row(
                            children: [
                              InkWell(
                                onTap: (){
                                  setState(() {
                                    selectedMinDate = date;
                                  });
                                },
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 300),
                                  width: 80,
                                  height: 80,
                                  decoration: BoxDecoration(
                                    color: selectedMinDate == date ? primaryColor : Colors.transparent,
                                    borderRadius: BorderRadius.circular(8.0),
                                    border: Border.all(
                                      color: selectedMinDate == date ? Colors.transparent : HexColor('#979797'),
                                    )
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        dayNumber,
                                        style: TextStyle(
                                          color: selectedMinDate == date ? HexColor('#FFFFFF') : HexColor('#363636'),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 5.0,),
                                      Text(
                                        UserConfig.instance.isLanguageEnglish() ? dayNameEnglish : dayNameArabic,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: selectedMinDate == date ? HexColor('#FFFFFF') : HexColor('#363636'),
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10.0,),
                            ],
                          );
                        },
                      ),
                    )
                  ],
                ),
              ],
            ),
            SizedBox(height: isTherePermitToExpectHisBirth == 'yes' ? 20.0 : 10.0,),
            if(isNewBornValidID && newBornData != null  || (selectedNewbornNationality == 'nonJordanian' && selectedPlaceOfBirth == 'outsideJordan'))
            Card(
                elevation: 5.0,
                shadowColor: Colors.black45,
                color: getContainerColor(context),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: Container(
                  width: width(1, context),
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if(!(selectedNewbornNationality == 'nonJordanian' && selectedPlaceOfBirth == 'outsideJordan'))
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: width(0.6, context),
                            child: Text(
                              '${newBornData['cur_getdata'][0][0]['C_M_NAME1']??''} ${newBornData['cur_getdata'][0][0]['C_M_NAME2']??''} ${newBornData['cur_getdata'][0][0]['C_M_NAME3']??''} ${newBornData['cur_getdata'][0][0]['C_M_NAME4']??''}',
                              style: TextStyle(
                                height: 1.4,
                                color: themeNotifier.isLight() ? HexColor('#363636') : Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15.0,),
                      Row(
                        children: [
                          if(!(selectedNewbornNationality == 'nonJordanian' && selectedPlaceOfBirth == 'outsideJordan'))
                          Text(
                            newbornNationalNumberController.text,
                            style: TextStyle(
                              color: themeNotifier.isLight() ? HexColor('#716F6F') : Colors.white70,
                            ),
                          ),
                          if(!(selectedNewbornNationality == 'nonJordanian' && selectedPlaceOfBirth == 'outsideJordan'))
                          Text(
                            ' / ',
                            style: TextStyle(
                              color: themeNotifier.isLight() ? HexColor('#716F6F') : Colors.white70,
                            ),
                          ),
                          Text(
                            getTranslated(selectedNewbornNationality, context),
                            style: TextStyle(
                              color: themeNotifier.isLight() ? HexColor('#716F6F') : Colors.white70,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15.0,),
                      Row(
                        children: [
                          Text(
                            getTranslated('theStartDateOfTheLeave', context),
                            style: TextStyle(
                              color: themeNotifier.isLight() ? HexColor('#716F6F') : Colors.white70,
                            ),
                          ),
                          Text(
                            ' : ',
                            style: TextStyle(
                              color: themeNotifier.isLight() ? HexColor('#716F6F') : Colors.white70,
                            ),
                          ),
                          Text(
                            DateFormat('dd/MM/yyyy').format(selectedMinDate),
                            style: TextStyle(
                              color: themeNotifier.isLight() ? HexColor('#716F6F') : Colors.white70,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15.0,),
                      Row(
                        children: [
                          Text(
                            getTranslated('theDateTheLeaveEnds', context),
                            style: TextStyle(
                              color: themeNotifier.isLight() ? HexColor('#716F6F') : Colors.white70,
                            ),
                          ),
                          Text(
                            ' : ',
                            style: TextStyle(
                              color: themeNotifier.isLight() ? HexColor('#716F6F') : Colors.white70,
                            ),
                          ),
                          Text(
                            DateFormat('dd/MM/yyyy').format(selectedMinDate.add(Duration(days: servicesProvider.result['p_per_info'][0][0]['MAT_VAC_PERIOD'] - 1))),
                            style: TextStyle(
                              color: themeNotifier.isLight() ? HexColor('#716F6F') : Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                )
            ),
            const SizedBox(height: 20.0,),
          ],
        ),
      ),
    );
  }

  Widget fifthStep(context, themeNotifier){
    return SizedBox(
      height: isTablet(context) ? height(0.78, context) : isScreenHasSmallHeight(context) ? height(0.73, context) : height(0.75, context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: height(0.02, context),),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                getTranslated('fifthStep', context),
                style: TextStyle(
                    color: HexColor('#979797'),
                    fontSize: width(0.03, context)
                ),
              ),
              SizedBox(height: height(0.006, context),),
              Text(
                getTranslated('confirmRequest', context),
                style: TextStyle(
                    color: HexColor('#5F5F5F'),
                    fontSize: width(0.035, context)
                ),
              )
            ],
          ),
          SizedBox(height: height(0.01, context),),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox.shrink(),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '5/5',
                    style: TextStyle(
                        color: HexColor('#979797'),
                        fontSize: width(0.025, context)
                    ),
                  ),
                  Text(
                    getTranslated('finished', context),
                    style: TextStyle(
                        color: HexColor('#979797'),
                        fontSize: width(0.032, context)
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: height(0.02, context),),
          Text(
            getTranslated('reviewYourDetailedStatement', context),
            style: TextStyle(
              color: HexColor('#363636'),
            ),
          ),
          const SizedBox(height: 20.0,),
          InkWell(
            onTap: () async{
              servicesProvider.isLoading = true;
              servicesProvider.notifyMe();
              try{
                await servicesProvider.getInquiryInsuredInformation().then((val1) async{
                  await servicesProvider.getInsuredInformationReport(val1).then((val2) async {
                    await downloadAndOpenPDF(val2.data, getTranslated('detailedDisclosure', context)).whenComplete(() {
                      if (kDebugMode) {
                        print('completed');
                      }
                    });
                  });
                });
                servicesProvider.isLoading = false;
                servicesProvider.notifyMe();
              } catch(e){
                servicesProvider.isLoading = false;
                servicesProvider.notifyMe();
                if (kDebugMode) {
                  print(e.toString());
                }
              }
            },
            child: Container(
              width: width(1, context),
              padding: const EdgeInsets.all(14.0),
              decoration: BoxDecoration(
                  color: const Color.fromRGBO(208, 208, 208, 0.26),
                  borderRadius: BorderRadius.circular(10.0),
                  border: Border.all(
                      color: HexColor('#979797')
                  )
              ),
              child: Text(
                getTranslated('detailedDisclosure', context),
                style: TextStyle(
                  color: HexColor('#003C97'),
                ),
              ),
            ),
          ),
          Expanded(child: Container()),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: (){
                  setState(() {
                    termsChecked = !termsChecked;
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
                        color: termsChecked ? HexColor('#2D452E') : HexColor('#DADADA'),
                        borderRadius: BorderRadius.circular(4.0)
                    ),
                  ),
                ),
              ),
              SizedBox(width: width(0.05, context),),
              Expanded(
                child: Text(
                  getTranslated('maternityTermsAndConditions', context),
                  style: TextStyle(
                    fontSize: height(0.015, context),
                    color: HexColor('#595959'),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 30.0,)
        ],
      ),
    );
  }

  Widget customTwoRadioButtons(int flag, String firstChoice, String secondChoice, setState){
    return Row(
      children: [
        InkWell(
          onTap: (){
            setState(() {
              if(flag == 1){
                selectedNewbornNationality = firstChoice;
                isNewBornValidID = false;
                newBornData = null;
                minDate = null;
                selectedMinDate = minDate;
                maxDate = null;
              }else if(flag == 2){
                selectedPlaceOfBirth = firstChoice;
                isNewBornValidID = false;
                newBornData = null;
                minDate = null;
                selectedMinDate = minDate;
                maxDate = null;
              }else if(flag == 3){
                isTherePermitToExpectHisBirth = firstChoice;
                if(selectedPlaceOfBirth == 'outsideJordan' && selectedNewbornNationality == 'nonJordanian'){
                  minDate = selectedDateOfBirth.subtract(
                    Duration(days: servicesProvider.result['p_per_info'][0][0]['MAX_EXP_VAC']),
                  );
                  selectedMinDate = minDate;
                  maxDate = selectedDateOfBirth;
                }else {
                  minDate = DateFormat('dd/MM/yyyy').parse(newBornData['cur_getdata'][0][0]['CHILD_BIRTHDATE']).subtract(
                    Duration(days: servicesProvider.result['p_per_info'][0][0]['MAX_EXP_VAC']),
                  );
                  selectedMinDate = minDate;
                  maxDate = DateFormat('dd/MM/yyyy').parse(newBornData['cur_getdata'][0][0]['CHILD_BIRTHDATE']);
                }
              }
            });
            servicesProvider.notifyMe();
          },
          child: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(500.0),
                  border: Border.all(
                    color: HexColor('#2D452E'),
                  ),
                ),
                padding: const EdgeInsets.all(2.0),
                child: CircleAvatar(
                  radius: isTablet(context) ? 10 : 5,
                  backgroundColor: (flag == 1 && selectedNewbornNationality == firstChoice) || (flag == 2 && selectedPlaceOfBirth == firstChoice) || (flag == 3 && isTherePermitToExpectHisBirth == firstChoice)
                      ? HexColor('#2D452E')
                      : Colors.transparent,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  getTranslated(firstChoice, context),
                  style: TextStyle(
                    color: HexColor('#666666'),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 10.0,),
        InkWell(
          onTap: (){
            setState(() {
              if(flag == 1){
                selectedNewbornNationality = secondChoice;
                isNewBornValidID = false;
                newBornData = null;
                minDate = null;
                selectedMinDate = minDate;
                maxDate = null;
                if(selectedPlaceOfBirth == 'outsideJordan' && isTherePermitToExpectHisBirth == 'yes'){
                  minDate = selectedDateOfBirth.subtract(
                    Duration(days: servicesProvider.result['p_per_info'][0][0]['MAX_EXP_VAC']),
                  );
                  selectedMinDate = minDate;
                  maxDate = selectedDateOfBirth;
                }else {
                  minDate = null;
                  selectedMinDate = minDate;
                  maxDate = null;
                }
              }else if(flag == 2){
                selectedPlaceOfBirth = secondChoice;
                isNewBornValidID = false;
                newBornData = null;
                if(selectedNewbornNationality == 'nonJordanian' && isTherePermitToExpectHisBirth == 'yes'){
                  minDate = selectedDateOfBirth.subtract(
                    Duration(days: servicesProvider.result['p_per_info'][0][0]['MAX_EXP_VAC']),
                  );
                  selectedMinDate = minDate;
                  maxDate = selectedDateOfBirth;
                }else {
                  minDate = null;
                  selectedMinDate = minDate;
                  maxDate = null;
                }
              }else if(flag == 3){
                isTherePermitToExpectHisBirth = secondChoice;
                if(selectedPlaceOfBirth == 'outsideJordan' && selectedNewbornNationality == 'nonJordanian'){
                  minDate = selectedDateOfBirth;
                  selectedMinDate = minDate;
                  maxDate = selectedDateOfBirth.add(
                    Duration(days: servicesProvider.result['p_per_info'][0][0]['MAT_VAC_PERIOD'] - 1),
                  );
                }else {
                  minDate = DateFormat('dd/MM/yyyy').parse(newBornData['cur_getdata'][0][0]['CHILD_BIRTHDATE']);
                  selectedMinDate = minDate;
                  maxDate = DateFormat('dd/MM/yyyy').parse(newBornData['cur_getdata'][0][0]['CHILD_BIRTHDATE']).add(
                    Duration(days: servicesProvider.result['p_per_info'][0][0]['MAT_VAC_PERIOD'] - 1),
                  );
                }
              }
            });
            servicesProvider.notifyMe();
          },
          child: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(500.0),
                  border: Border.all(
                    color: HexColor('#2D452E'),
                  ),
                ),
                padding: const EdgeInsets.all(2.0),
                child: CircleAvatar(
                  radius: isTablet(context) ? 10 : 5,
                  backgroundColor: (flag == 1 && selectedNewbornNationality == secondChoice) || (flag == 2 && selectedPlaceOfBirth == secondChoice) || (flag == 3 && isTherePermitToExpectHisBirth == secondChoice)
                      ? HexColor('#2D452E')
                      : Colors.transparent,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  getTranslated(secondChoice, context),
                  style: TextStyle(
                    color: HexColor('#666666'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

}

enum ContextMenu { edit, delete }

