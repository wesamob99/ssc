// ignore_for_file: file_names

import 'dart:convert';

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
import 'package:ssc/source/view/services/shared/paymentScreen.dart';
import 'package:ssc/source/viewModel/services/servicesProvider.dart';
import 'package:ssc/source/viewModel/utilities/theme/themeProvider.dart';

import '../../../../../infrastructure/userConfig.dart';
import '../../../../../infrastructure/userSecuredStorage.dart';
import '../../../../../utilities/countries.dart';
import '../../../../../utilities/hexColor.dart';
import '../../../../../utilities/theme/themes.dart';
import '../../../../../utilities/util.dart';
import 'dart:math' as math;
import 'dart:ui' as ui;

import '../../../../viewModel/accountSettings/accountSettingsProvider.dart';
import '../../../../viewModel/login/loginProvider.dart';
import '../../shared/firstStepScreen.dart';
import '../../shared/verifyMobileNumberScreen.dart';


/// used for both early retirement and old age retirement
/// if serviceType = 8 => early | else if serviceType = 1 => old age
class EarlyRetirementRequestScreen extends StatefulWidget {
  final int serviceType;
  const EarlyRetirementRequestScreen({Key key, @required this.serviceType}) : super(key: key);

  @override
  State<EarlyRetirementRequestScreen> createState() => _EarlyRetirementRequestScreenState();
}

class _EarlyRetirementRequestScreenState extends State<EarlyRetirementRequestScreen> {

  ServicesProvider servicesProvider;
  ThemeNotifier themeNotifier;

  String areYouAuthorizedToSignForCompany = 'no';
  String areYouPartnerInLimitedLiabilityCompany = 'no';
  bool nonJordanianSubmitEnabled = false;

  String selectedStatus;
  String selectedJobStatus;
  String selectedGetsSalary;
  String selectedHasDisability;
  String selectedMaritalStatus;
  String selectedGender;
  String selectedRelation;
  List<String> maritalList;
  bool termsChecked = false;
  int dependentIndex = 0;
  String nationality = 'jordanian';
  List docs = [];

  List pDependents = [];

  DateTime selectedDateOfBirth = DateTime.now();
  TextEditingController nationalIdController = TextEditingController();
  TextEditingController quatrainNounController = TextEditingController();


  checkContinueEnabled({flag = 0}){
    if(flag == 1){
      return mobileNumberValidate(servicesProvider.mobileNumberController.text);
    } else if(flag == 2){
      if(servicesProvider.isMobileNumberUpdated){
        return Provider.of<ServicesProvider>(context, listen: false).pinPutFilled;
      } else{
        return true;
      }
    } else if(flag == 3){
      if(servicesProvider.isMobileNumberUpdated){
        return Provider.of<ServicesProvider>(context, listen: false).pinPutFilled;
      } else{
        return true;
      }
    }else if(flag == 5){
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
    }else if(flag == 6){
      return termsChecked;
    } else{
      return true;
    }
  }

  @override
  void initState() {
    Provider.of<LoginProvider>(context, listen: false).readCountriesJson();
    servicesProvider = Provider.of<ServicesProvider>(context, listen: false);
    if(servicesProvider.result['P_DEP_INFO'].length != 0){
      pDependents = servicesProvider.result['P_DEP_INFO'];
    }
    if(servicesProvider.result['P_Dep'].length != 0){
      pDependents = servicesProvider.result['P_Dep'];
    }
    servicesProvider.getActivePayment("${widget.serviceType}", servicesProvider.result['p_per_info'][0][0]['NAT'] == "111" ? '1' : '2').whenComplete(() {}).then((value) {
      value['R_RESULT'][0].forEach((element){
        servicesProvider.activePayment.add(element);
      });
      servicesProvider.selectedActivePayment = servicesProvider.activePayment[0];
    });
    servicesProvider.mobileNumberController.text = UserSecuredStorage.instance.realMobileNumber;
    servicesProvider.documentIndex = 0;
    servicesProvider.dependentsDocuments = [];
    servicesProvider.mandatoryDocuments = [];
    servicesProvider.optionalDocuments = [];
    servicesProvider.optionalDocumentsCheckBox = [];
    servicesProvider.selectedOptionalDocuments = [];
    themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);
    servicesProvider.stepNumber = 1;
    servicesProvider.uploadedFiles = {
      "mandatory": [],
      "optional": [],
    };
    servicesProvider.selectedMobileCountry = SelectedListItem(
      name: UserConfig.instance.checkLanguage() ? "Jordan" : "الأردن",
      value: "962", natCode: 111,
      flag: countries[110].flag,
    );
    servicesProvider.selectedPaymentCountry = SelectedListItem(
      name: UserConfig.instance.checkLanguage() ? "Iraq" : "عراق",
      value: "964", natCode: 112,
      flag: countries.where((element) => element.dialCode == "964").first.flag,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: (servicesProvider.documentsScreensStepNumber == 1 || servicesProvider.documentsScreensStepNumber == 3) && servicesProvider.stepNumber == 4
      ? HexColor('#445740') : HexColor('#ffffff'),
      appBar: AppBar(
        centerTitle: false,
        title: Text(getTranslated('earlyRetirementRequest', context)),
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: InkWell(
            onTap: (){
              if(servicesProvider.stepNumber == 4){
                switch(servicesProvider.documentsScreensStepNumber){
                  case 1: servicesProvider.stepNumber = 3; break;
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
                  case 3:
                    {
                      if(dependentIndex > 0){
                        dependentIndex--;
                      } else{
                        servicesProvider.stepNumber = 2;
                      }
                    } break;
                  case 5:
                    {
                      servicesProvider.stepNumber = 4;
                      servicesProvider.documentsScreensStepNumber = 5;
                    }
                    break;
                  case 6: servicesProvider.stepNumber = 5; break;
                }
              }
              servicesProvider.notifyMe();
            },
            child: Transform.rotate(
              angle: UserConfig.instance.checkLanguage()
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
                        const FirstStepScreen(nextStep: 'ensureFinancialSolvency', numberOfSteps: 6),
                      if(Provider.of<ServicesProvider>(context).stepNumber == 2 && Provider.of<ServicesProvider>(context).isMobileNumberUpdated)
                        VerifyMobileNumberScreen(nextStep: 'ensureFinancialSolvency', numberOfSteps: 6, mobileNo: servicesProvider.mobileNumberController.text ?? ''),
                      if(Provider.of<ServicesProvider>(context).stepNumber == 2 && !Provider.of<ServicesProvider>(context).isMobileNumberUpdated)
                        secondStep(context, themeNotifier),
                      if(Provider.of<ServicesProvider>(context).stepNumber == 3)
                        thirdStep(context, themeNotifier),
                      if(Provider.of<ServicesProvider>(context).stepNumber == 4)
                        DocumentsScreen(nextStep: 'receiptOfAllowances', numberOfSteps: 6, data: {
                        "PAYMENT_METHOD": servicesProvider.result['p_per_info'][0][0]['PAYMENT_METHOD'],
                        "BANK_LOCATION": servicesProvider.result['p_per_info'][0][0]['BANK_LOCATION'], /// update
                        "BRANCH_ID": servicesProvider.result['p_per_info'][0][0]['BRANCH_ID'],
                        "BRANCH_NAME": servicesProvider.result['p_per_info'][0][0]['BRANCH_NAME'],
                        "BANK_ID": servicesProvider.result['p_per_info'][0][0]['BANK_ID'],
                        "BANK_NAME": servicesProvider.result['p_per_info'][0][0]['BANK_NAME'],
                        "ACCOUNT_NAME": servicesProvider.result['p_per_info'][0][0]['ACCOUNT_NAME'],
                        "PAYMENT_COUNTRY": servicesProvider.result['p_per_info'][0][0]['PAYMENT_COUNTRY'],
                        "PAYMENT_COUNTRY_CODE": servicesProvider.result['p_per_info'][0][0]['PAYMENT_COUNTRY_CODE'],
                        "PAYMENT_PHONE": servicesProvider.result['p_per_info'][0][0]['PAYMENT_PHONE'],
                        "IFSC": servicesProvider.result['p_per_info'][0][0]['IFSC'],
                        "SWIFT_CODE": servicesProvider.result['p_per_info'][0][0]['SWIFT_CODE'], /// update
                        "BANK_DETAILS": servicesProvider.result['p_per_info'][0][0]['BANK_DETAILS'], /// update
                        "IBAN": servicesProvider.result['p_per_info'][0][0]['IBAN'],
                        "CASH_BANK_ID": servicesProvider.result['p_per_info'][0][0]['CASH_BANK_ID'],
                        "REP_NATIONALITY": servicesProvider.result['p_per_info'][0][0]['REP_NATIONALITY'], /// update
                        "REP_NATIONAL_NO": servicesProvider.result['p_per_info'][0][0]['REP_NATIONAL_NO'], /// update
                        "REP_NAME": servicesProvider.result['p_per_info'][0][0]['REP_NAME'], /// update
                        "WALLET_TYPE": servicesProvider.result['p_per_info'][0][0]['WALLET_TYPE'],
                        "WALLET_OTP_VERIVIED": null,
                        "WALLET_OTP": null,
                        "WALLET_PHONE": servicesProvider.result['p_per_info'][0][0]['WALLET_PHONE'],
                        "WALLET_PHONE_VERIVIED": servicesProvider.result['p_per_info'][0][0]['WALLET_PHONE_VERIVIED'],
                        "WALLET_PASSPORT_NUMBER": servicesProvider.result['p_per_info'][0][0]['WALLET_PASSPORT_NUMBER'],
                        "PEN_IBAN": servicesProvider.result['p_per_info'][0][0]['PEN_IBAN'],
                        "SECNO": servicesProvider.result['p_per_info'][0][0]['SECNO'],
                        "NAT_DESC": servicesProvider.result['p_per_info'][0][0]['NAT_DESC'],
                        "NAT": servicesProvider.result['p_per_info'][0][0]['NAT'],
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
                        "INSURED_ADDRESS": servicesProvider.result['p_per_info'][0][0]['INSURED_ADDRESS'],
                        "MARITAL_STATUS": servicesProvider.result['p_per_info'][0][0]['MARITAL_STATUS'] ?? servicesProvider.result['p_per_info'][0][0]['SOCIAL_STATUS'],
                        "REGDATE": null,
                        "REGRATE": null,
                        "LAST_SALARY": null,
                        "LAST_STODATE": servicesProvider.result['p_per_info'][0][0]['LAST_STODATE'],
                        "ACTUAL_STODATE": servicesProvider.result['p_per_info'][0][0]['ACTUAL_STODATE'],
                        "GENDER": servicesProvider.result['p_per_info'][0][0]['GENDER'],
                        "CIVIL_WORK_DOC": servicesProvider.result['p_per_info'][0][0]['CIVIL_WORK_DOC'],
                        "MILITARY_WORK_DOC": servicesProvider.result['p_per_info'][0][0]['MILITARY_WORK_DOC'],
                        "CIV_MIL_RETIRED_DOC": servicesProvider.result['p_per_info'][0][0]['CIV_MIL_RETIRED_DOC'],
                        "PEN_START_DATE": servicesProvider.result['p_per_info'][0][0]['PEN_START_DATE'],
                        "GOVERNORATE": servicesProvider.result['p_per_info'][0][0]['GOVERNORATE'],
                        "DETAILED_ADDRESS": null,
                        "PASS_NO": null,
                        "RESIDENCY_NO": null,
                        "DOB": servicesProvider.result['p_per_info'][0][0]['DOB'],
                        "JOB_NO": null,
                        "JOB_DESC": servicesProvider.result['p_per_info'][0][0]['JOB_DESC'],
                        "ENAME1": null,
                        "ENAME2": null,
                        "ENAME3": null,
                        "ENAME4": null,
                        "LAST_EST_NO": servicesProvider.result['p_per_info'][0][0]['LAST_EST_NO'], /// update
                        "FAM_NO": null,
                        "nextVaild": null,
                        "wantAddFamily": null,
                        "GENDER_DESC": servicesProvider.result['p_per_info'][0][0]['GENDER_DESC'],
                        "PI_EPAY": null,
                        "INSURED": null,
                        "ID": servicesProvider.result['p_per_info'][0][0]['ID'], /// update
                        "DEP_FLAG": 0
                      }, serviceType: widget.serviceType, dependents: pDependents, relations: servicesProvider.result['P_RELATION'][0],),
                      if(Provider.of<ServicesProvider>(context).stepNumber == 5)
                        const PaymentScreen(numberOfSteps: 6, nextStep: 'confirmRequest',),
                      if(Provider.of<ServicesProvider>(context).stepNumber == 6)
                        sixthStep(context, themeNotifier),
                      if(!(Provider.of<ServicesProvider>(context).stepNumber == 4))
                      textButton(context,
                        themeNotifier,
                        Provider.of<ServicesProvider>(context).stepNumber != 6 ? 'continue' : 'send',
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
                                        errorMessage = UserConfig.instance.checkLanguage()
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
                                    await servicesProvider.updateUserMobileNumberCheckOTP(servicesProvider.pinPutCodeController.text).whenComplete((){})
                                        .then((val) async {
                                      if(val['PO_STATUS'] == 1){
                                        Provider.of<AccountSettingsProvider>(context, listen: false).updateUserInfo(2, servicesProvider.mobileNumberController.text).whenComplete((){}).then((value){
                                          if(value["PO_STATUS"] == 0){
                                            servicesProvider.stepNumber = 2;
                                            servicesProvider.isMobileNumberUpdated = false;
                                            UserSecuredStorage.instance.realMobileNumber = servicesProvider.mobileNumberController.text;
                                          }else{
                                            showMyDialog(context, 'updateMobileNumberFailed', UserConfig.instance.checkLanguage()
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
                                        errorMessage = UserConfig.instance.checkLanguage()
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
                                  servicesProvider.isLoading = false;
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
                            case 3: {
                              if(checkContinueEnabled(flag: 3)){
                                servicesProvider.documentsScreensStepNumber = 1;
                                if(dependentIndex < ((pDependents.isNotEmpty  && pDependents[0].length != 0) ? pDependents[0].length - 1 : 0)){
                                  dependentIndex++;
                                }else {
                                  servicesProvider.notifyMe();
                                  servicesProvider.stepNumber = 4;
                                }
                              }
                            } break;
                            case 5: {
                              if(checkContinueEnabled(flag: 5)){
                                servicesProvider.stepNumber = 6;
                              }
                            } break;
                            case 6: {
                              if(checkContinueEnabled(flag: 6)){
                                try{
                                  String message = '';
                                  servicesProvider.isLoading = true;
                                  servicesProvider.isModalLoading = false;
                                  servicesProvider.notifyMe();
                                  List mandatoryDocs = await saveFiles('mandatory');
                                  List optionalDocs = await saveFiles('optional');
                                  docs.addAll(mandatoryDocs + optionalDocs);
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
                                  int wantInsurance = areYouPartnerInLimitedLiabilityCompany == 'yes' ? 1 : 0;
                                  int authorizedToSign = areYouAuthorizedToSignForCompany == 'yes' ? 1 : 0;
                                  await servicesProvider.setEarlyRetirementApplication(docs, paymentInfo, authorizedToSign, wantInsurance).whenComplete(() {}).then((value) {
                                    if(value != null && value['P_Message'] != null && value['P_Message'][0][0]['PO_STATUS'] == 0){
                                      message = getTranslated('youCanCheckAndFollowItsStatusFromMyOrdersScreen', context);
                                      if(value['PO_TYPE'] == 2){
                                        message = UserConfig.instance.checkLanguage()
                                            ? value['P_Message'][0][0]['PO_STATUS_DESC_EN'] : value['P_Message'][0][0]['PO_STATUS_DESC_AR'];
                                      }
                                      showMyDialog(context, 'yourRequestHasBeenSentSuccessfully',
                                          message, 'ok',
                                          themeNotifier,
                                          icon: 'assets/icons/serviceSuccess.svg').then((_){
                                        SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
                                          servicesProvider.selectedServiceRate = -1;
                                          servicesProvider.notifyMe();
                                          rateServiceBottomSheet(context, themeNotifier, servicesProvider);
                                        });
                                      });
                                    } else{
                                      message = UserConfig.instance.checkLanguage()
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
                "DOCUMENT_DATE": DateFormat('MM/dd/yyyy, HH:mm').format(DateTime.now()).toString(),
                "required": type == 'mandatory' ? 0 : 1,
                "APP_ID": servicesProvider.result['p_per_info'][0][0]['ID'],
                "ID": "",
                "STATUS": 1,
                "HIDE_ACTIONS": false
              };
              bool isDependentDoc = false;
              if(type == 'mandatory' && servicesProvider.result["P_DEP_INFO"].isNotEmpty){
                pDependents[0].forEach((element) {
                  if(element['DEP_CODE'].toString() == servicesProvider.uploadedFiles[type][i][j]["document"]['CODE'].toString()){
                    if (kDebugMode) {
                      print('value: $value');
                    }
                    isDependentDoc = true;
                    if(element['doc_dep'] is String){
                      element['doc_dep'] = [document];
                    }else{
                      element['doc_dep'].add(document);
                    }
                  }
                });
              }
              if(!isDependentDoc) {
                docs.add(document);
              }
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
                  getTranslated('ensureFinancialSolvency', context),
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
                      '2/6',
                      style: TextStyle(
                          color: HexColor('#979797'),
                          fontSize: width(0.025, context)
                      ),
                    ),
                    Text(
                      '${getTranslated('next', context)}: ${getTranslated('confirmationOfDependentInformation', context)}',
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
            buildFieldTitle(context, 'areYouAuthorizedToSignForCompany', required: false),
            SizedBox(height: height(0.01, context),),
            yesNoTwoRadioButtons(1),
            const SizedBox(height: 30,),
            buildFieldTitle(context, 'areYouPartnerInLimitedLiabilityCompany', required: false),
            SizedBox(height: height(0.01, context),),
            yesNoTwoRadioButtons(2),
          ],
        ),
      ),
    );
  }

  Widget thirdStep(context, themeNotifier){
    // if(pDependents.isNotEmpty && pDependents[0].length != 0){
    //   servicesProvider.checkDocumentDependent(pDependents[0]);
    // }
    return SizedBox(
      height: isTablet(context) ? height(0.78, context) : isScreenHasSmallHeight(context) ? height(0.73, context) : height(0.75, context),
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
                    getTranslated('thirdStep', context),
                    style: TextStyle(
                        color: HexColor('#979797'),
                        fontSize: width(0.03, context)
                    ),
                  ),
                  SizedBox(height: height(0.006, context),),
                  Text(
                    getTranslated('confirmationOfDependentInformation', context),
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
                        '3/6',
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
              SizedBox(height: height(0.02, context),),
              Text(
                getTranslated('numberOfDependents', context) + ' ( ${(pDependents.isNotEmpty  && pDependents[0].length != 0) ? dependentIndex + 1 : 0} / ${(pDependents.isNotEmpty  && pDependents[0].length != 0) ? pDependents[0].length : 0} )',
                style: TextStyle(
                  color: HexColor('#363636'),
                  fontWeight: FontWeight.w500,
                  fontSize: 17,
                ),
              ),
              SizedBox(height: height(0.02, context),),
              if(pDependents.isNotEmpty && pDependents[0].length != 0)
              Card(
                  elevation: 6.0,
                  shadowColor: Colors.black45,
                  color: getContainerColor(context),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: Container(
                    width: width(1, context),
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8.0),
                              decoration: BoxDecoration(
                                color: (pDependents[0][dependentIndex]['RELATION'] ?? pDependents[0][dependentIndex]['RELATIVETYPE']) == 11
                                    ? HexColor('#9EBDF8') : const Color.fromRGBO(0, 121, 5, 0.38),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: Text(
                                getRelationType(pDependents[0][dependentIndex]['RELATION'] ?? pDependents[0][dependentIndex]['RELATIVETYPE']),
                                style: TextStyle(
                                  color: (pDependents[0][dependentIndex]['RELATION'] ?? pDependents[0][dependentIndex]['RELATIVETYPE']) == 11
                                      ? HexColor('#003C97') : HexColor('#2D452E'),
                                  fontWeight: FontWeight.w400,
                                  fontSize: isScreenHasSmallWidth(context) ? 13 : 15,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10,),
                            PopupMenuButton<ContextMenu>(
                              onSelected: (ContextMenu result) async {
                                switch (result.index) {
                                  case 0: {
                                    nationality = pDependents[0][dependentIndex]['NATIONALITY'] == 1 ? 'jordanian' : 'nonJordanian';
                                    selectedStatus = pDependents[0][dependentIndex]['IS_ALIVE'] == 1
                                        ? 'alive' : 'dead';
                                    selectedJobStatus = (pDependents[0][dependentIndex]['WORK_STATUS'] ?? pDependents[0][dependentIndex]['IS_WORK']) == 0
                                        ? 'unemployed' : 'employed';
                                    selectedGetsSalary = (pDependents[0][dependentIndex]['IS_RETIRED_A'] ?? pDependents[0][dependentIndex]['IS_WORK']) == 0
                                        ? 'no' : 'yes';
                                    selectedHasDisability = (pDependents[0][dependentIndex]['DISABILITY'] ?? pDependents[0][dependentIndex]['IS_SUPPORT_TO_OTHER_PEN']) == 0
                                        ? 'no' : 'yes';
                                    selectedMaritalStatus = (
                                        pDependents[0][dependentIndex]['MARITAL_STATUS'] ?? pDependents[0][dependentIndex]['SOCIAL_STATUS']) == 1
                                        ? 'single'
                                        : (pDependents[0][dependentIndex]['MARITAL_STATUS'] ?? pDependents[0][dependentIndex]['SOCIAL_STATUS']) == 2
                                        ? 'married'
                                        : (pDependents[0][dependentIndex]['MARITAL_STATUS'] ?? pDependents[0][dependentIndex]['SOCIAL_STATUS']) == 3
                                        ? 'divorced'
                                        : (pDependents[0][dependentIndex]['MARITAL_STATUS'] ?? pDependents[0][dependentIndex]['SOCIAL_STATUS']) == 4
                                        ? 'widow' : 'single';
                                    maritalList = [
                                      'single',
                                      'married',
                                      'divorced',
                                      'widow'
                                    ];

                                    if((pDependents[0][dependentIndex]['RELATION'] ?? pDependents[0][dependentIndex]['RELATIVETYPE']) == 11){
                                      maritalList.remove('widow');
                                      maritalList.remove('single');
                                    }

                                    if((pDependents[0][dependentIndex]['RELATION'] ?? pDependents[0][dependentIndex]['RELATIVETYPE']) == 6){
                                      maritalList.remove('single');
                                    }

                                    dependentModalBottomSheet(dependentIndex);
                                  } break;
                                  case 1: {
                                    showMyDialog(
                                        context, 'wouldYouLikeToConfirmDeletionOfDependents',
                                        pDependents[0][dependentIndex]['NAME'] ?? pDependents[0][dependentIndex]['FULL_NAME'],
                                        'yesContinue', themeNotifier, icon: 'assets/icons/dialogDeleteIcon.svg',
                                        onPressed: () async{
                                          String errorMessage = '';
                                          servicesProvider.isLoading = true;
                                          servicesProvider.notifyMe();
                                          try{
                                            await servicesProvider.deleteDependent(int.tryParse(pDependents[0][dependentIndex]["ID"].toString())).then((value){
                                              Navigator.of(context).pop();
                                              if(value['PO_RESULT'] == 1){
                                                servicesProvider.dependentsDocuments.removeWhere((element) => element["CODE"] == pDependents[0][dependentIndex]["DEP_CODE"]);
                                                pDependents[0].removeAt(dependentIndex);
                                                if(dependentIndex == pDependents[0].length && dependentIndex != 0){
                                                  setState(() {
                                                    dependentIndex--;
                                                  });
                                                }
                                                showMyDialog(context, 'dependentWereDeleted', '', 'ok', themeNotifier, titleColor: '#2D452E', icon: 'assets/icons/serviceSuccess.svg');
                                              } else{
                                                errorMessage = UserConfig.instance.checkLanguage()
                                                    ? value["pO_status_desc_en"] : value["pO_status_desc_ar"];
                                                showMyDialog(context, 'failed', errorMessage, 'ok', themeNotifier);
                                              }
                                            });
                                            servicesProvider.isLoading = false;
                                            servicesProvider.notifyMe();
                                          }catch(e){
                                            servicesProvider.isLoading = false;
                                            servicesProvider.notifyMe();
                                            if (kDebugMode) {
                                              print(e.toString());
                                            }
                                          }
                                        }, withCancelButton: true);
                                  } break;
                                  default: {} break;
                                }
                              },
                              icon: Icon(
                                Icons.more_vert,
                                color: HexColor('#51504E'),
                                size: 33,
                              ),
                              itemBuilder: (BuildContext context) =>
                              <PopupMenuEntry<ContextMenu>>[
                                PopupMenuItem<ContextMenu>(
                                  value: ContextMenu.edit,
                                  child: contextMenuItem(
                                      "edit",
                                      'assets/icons/edit.svg',
                                      '#363636'
                                  ),
                                ),
                                PopupMenuItem<ContextMenu>(
                                  value: ContextMenu.delete,
                                  enabled: pDependents[0][dependentIndex]['SOURCE_FLAG'] == 2,
                                  child: contextMenuItem(
                                      "delete",
                                      'assets/icons/delete.svg',
                                      '#ED3124'
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              pDependents[0][dependentIndex]['NAME'] ?? pDependents[0][dependentIndex]['FULL_NAME'],
                              style: TextStyle(
                                height: 1.4,
                                color: themeNotifier.isLight() ? HexColor('#363636') : Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: isScreenHasSmallWidth(context) ? 13 : 15,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 15.0,),
                        Row(
                          children: [
                            Text(
                              pDependents[0][dependentIndex]['NATIONAL_NO'],
                              style: TextStyle(
                                color: themeNotifier.isLight() ? HexColor('#716F6F') : Colors.white70,
                              ),
                            ),
                            Text(
                              ' / ',
                              style: TextStyle(
                                color: themeNotifier.isLight() ? HexColor('#716F6F') : Colors.white70,
                              ),
                            ),
                            Text(
                              getTranslated(
                                  pDependents[0][dependentIndex]['NATIONALITY'] == 1
                                      ? 'jordanian' : 'nonJordanian',
                                  context),
                              style: TextStyle(
                                color: themeNotifier.isLight() ? HexColor('#716F6F') : Colors.white70,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 40.0,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    getTranslated('maritalStatus', context),
                                    style: TextStyle(
                                      color: themeNotifier.isLight() ? HexColor('#979797') : Colors.white70,
                                      fontSize: isScreenHasSmallWidth(context) ? 12 : 14,
                                    ),
                                  ),
                                  const SizedBox(height: 10.0,),
                                  Text(
                                    getTranslated(
                                        (pDependents[0][dependentIndex]['MARITAL_STATUS'] ?? pDependents[0][dependentIndex]['SOCIAL_STATUS']) == 1
                                            ? UserConfig.instance.checkLanguage()
                                            ? 'single' : int.parse(pDependents[0][dependentIndex]['GENDER'].toString()) == 1 ? 'singleM' : 'singleF'
                                            : (pDependents[0][dependentIndex]['MARITAL_STATUS'] ?? pDependents[0][dependentIndex]['SOCIAL_STATUS']) == 2
                                            ? UserConfig.instance.checkLanguage()
                                            ? 'married' : int.parse(pDependents[0][dependentIndex]['GENDER'].toString()) == 1 ? 'marriedM' : 'marriedF'
                                            : (pDependents[0][dependentIndex]['MARITAL_STATUS'] ?? pDependents[0][dependentIndex]['SOCIAL_STATUS']) == 3
                                            ? UserConfig.instance.checkLanguage()
                                            ? 'divorced' : int.parse(pDependents[0][dependentIndex]['GENDER'].toString()) == 1 ? 'divorcedM' : 'divorcedF'
                                            : (pDependents[0][dependentIndex]['MARITAL_STATUS'] ?? pDependents[0][dependentIndex]['SOCIAL_STATUS']) == 4
                                            ? UserConfig.instance.checkLanguage()
                                            ? 'widow' : int.parse(pDependents[0][dependentIndex]['GENDER'].toString()) == 1 ? 'widowM' : 'widowF' : 'single',
                                        context),
                                    style: TextStyle(
                                      color: themeNotifier.isLight() ? HexColor('#363636') : Colors.white70,
                                      fontSize: isScreenHasSmallWidth(context) ? 12 : 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    getTranslated('employmentStatus', context),
                                    style: TextStyle(
                                      color: themeNotifier.isLight() ? HexColor('#979797') : Colors.white70,
                                      fontSize: isScreenHasSmallWidth(context) ? 12 : 14,
                                    ),
                                  ),
                                  const SizedBox(height: 10.0,),
                                  Text(
                                    getTranslated(
                                        (pDependents[0][dependentIndex]['WORK_STATUS'] ?? pDependents[0][dependentIndex]['IS_WORK']) == 0
                                            ? 'unemployed' : 'employed',
                                        context),
                                    style: TextStyle(
                                      color: themeNotifier.isLight() ? HexColor('#363636') : Colors.white70,
                                      fontSize: isScreenHasSmallWidth(context) ? 12 : 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    getTranslated('status', context),
                                    style: TextStyle(
                                      color: themeNotifier.isLight() ? HexColor('#979797') : Colors.white70,
                                      fontSize: isScreenHasSmallWidth(context) ? 12 : 14,
                                    ),
                                  ),
                                  const SizedBox(height: 10.0,),
                                  Text(
                                    getTranslated(
                                        pDependents[0][dependentIndex]['IS_ALIVE'] == 1
                                            ? 'alive' : 'dead',
                                        context),
                                    style: TextStyle(
                                      color: themeNotifier.isLight() ? HexColor('#363636') : Colors.white70,
                                      fontSize: isScreenHasSmallWidth(context) ? 12 : 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 40.0,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  getTranslated('hasDisability', context),
                                  style: TextStyle(
                                    color: themeNotifier.isLight() ? HexColor('#979797') : Colors.white70,
                                    fontSize: isScreenHasSmallWidth(context) ? 12 : 14,
                                  ),
                                ),
                                const SizedBox(height: 10.0,),
                                Text(
                                  getTranslated(
                                      (pDependents[0][dependentIndex]['DISABILITY'] ?? pDependents[0][dependentIndex]['IS_SUPPORT_TO_OTHER_PEN']) == 0
                                          ? 'no' : 'yes',
                                      context),
                                  style: TextStyle(
                                    color: themeNotifier.isLight() ? HexColor('#363636') : Colors.white70,
                                    fontSize: isScreenHasSmallWidth(context) ? 12 : 14,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(width: 20.0,),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  getTranslated('getsSalary', context),
                                  style: TextStyle(
                                    color: themeNotifier.isLight() ? HexColor('#979797') : Colors.white70,
                                    fontSize: isScreenHasSmallWidth(context) ? 12 : 14,
                                  ),
                                ),
                                const SizedBox(height: 10.0,),
                                Text(
                                  getTranslated(
                                      (pDependents[0][dependentIndex]['IS_RETIRED_A'] ?? pDependents[0][dependentIndex]['IS_WORK']) == 0
                                          ? 'no' : 'yes',
                                      context),
                                  style: TextStyle(
                                    color: themeNotifier.isLight() ? HexColor('#363636') : Colors.white70,
                                    fontSize: isScreenHasSmallWidth(context) ? 12 : 14,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
              ),
            ],
          ),
          if(dependentIndex == ((pDependents.isNotEmpty  && pDependents[0].length != 0) ? pDependents[0].length - 1 : 0))
          Padding(
            padding: const EdgeInsets.only(bottom: 5.0),
            child: textButtonWithIcon(
                context, themeNotifier, 'addNewDependents', Colors.transparent, HexColor('#2D452E'),
                (){
                  nonJordanianSubmitEnabled = false;
                  servicesProvider.dependentInfo = null;
                  nationalIdController = TextEditingController();
                  quatrainNounController = TextEditingController();
                  selectedDateOfBirth = DateTime.now();
                  nationality = 'jordanian';
                  servicesProvider.isNationalIdValid = false;
                  servicesProvider.isLoading = false;
                  servicesProvider.notifyMe();
                  ///
                  selectedStatus = 'alive';
                  selectedJobStatus = 'employed';
                  selectedGetsSalary = 'yes';
                  selectedHasDisability = 'no';
                  selectedGender = 'male';
                  selectedRelation = getRelationType(1);
                  selectedMaritalStatus = 'single';
                  maritalList = [
                    'single',
                    'married',
                    'divorced',
                    'widow',
                  ];
                  ///
                  dependentModalBottomSheet(dependentIndex, isEdit: true);
                },
                borderColor: '#2D452E'
            ),
          )
        ],
      ),
    );
  }

  Widget sixthStep(context, themeNotifier){
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
                getTranslated('sixthStep', context),
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
                    '6/6',
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
                    await downloadPDF(val2, getTranslated('detailedDisclosure', context)).whenComplete(() {
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
                  getTranslated('earlyRetirementTermsAndConditions', context),
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

  Widget yesNoTwoRadioButtons(int flag){
    return Row(
      children: [
        InkWell(
          onTap: (){
            setState(() {
              if(flag == 1) {
                areYouAuthorizedToSignForCompany = 'yes';
              }
              if(flag == 2) {
                areYouPartnerInLimitedLiabilityCompany = 'yes';
              }
            });
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
                  backgroundColor: (flag == 1 && areYouAuthorizedToSignForCompany == 'yes') || (flag == 2 && areYouPartnerInLimitedLiabilityCompany == 'yes')
                    ? HexColor('#2D452E') : Colors.transparent,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0).copyWith(
                  left: UserConfig.instance.checkLanguage()
                      ? 10 : width(isTablet(context) ? 0.1 : 0.2, context),
                  right: UserConfig.instance.checkLanguage()
                      ? width(isTablet(context) ? 0.1 : 0.2, context) : 10,
                ),
                child: Text(
                  getTranslated('yes', context),
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
              if(flag == 1) {
                areYouAuthorizedToSignForCompany = 'no';
              }
              if(flag == 2) {
                areYouPartnerInLimitedLiabilityCompany = 'no';
              }
            });
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
                  backgroundColor: (flag == 1 && areYouAuthorizedToSignForCompany == 'no') || (flag == 2 && areYouPartnerInLimitedLiabilityCompany == 'no')
                      ? HexColor('#2D452E') : Colors.transparent,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0).copyWith(
                  left: UserConfig.instance.checkLanguage()
                      ? 10
                      : width(isTablet(context) ? 0.1 : 0.2, context),
                  right: UserConfig.instance.checkLanguage()
                      ? width(isTablet(context) ? 0.1 : 0.2, context)
                      : 10,
                ),
                child: Text(
                  getTranslated('no', context),
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

  Widget customTwoRadioButtons(int flag, String firstChoice, String secondChoice, setState, {bool disabled = false}){
    return Row(
      children: [
        InkWell(
          onTap: (){
            if(!disabled) {
              setState(() {
                if(flag == 1) {
                  selectedStatus = firstChoice;
                }
                if(flag == 2) {
                  selectedJobStatus = firstChoice;
                }
                if(flag == 3) {
                  selectedGetsSalary = firstChoice;
                }
                if(flag == 4) {
                  selectedHasDisability = firstChoice;
                }
                if(flag == 5) {
                  // selectedMethodOfReceiving = firstChoice;
                }
                if(flag == 6) {
                  nationality = firstChoice;
                }
                if(flag == 7) {
                  selectedGender = firstChoice;
                }
            });
            }
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
                  backgroundColor: (flag == 1 && selectedStatus == firstChoice) || (flag == 2 && selectedJobStatus == firstChoice) ||
                      (flag == 3 && selectedGetsSalary == firstChoice) || (flag == 4 && selectedHasDisability == firstChoice) ||
                      (flag == 6 && nationality == firstChoice) || (flag == 7 && selectedGender == firstChoice)
                      // || (flag == 5 && selectedMethodOfReceiving == firstChoice)
                      ? disabled ? Colors.grey : HexColor('#2D452E')
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
            if(!disabled) {
              setState(() {
                if(flag == 1) {
                  selectedStatus = secondChoice;
                }
                if(flag == 2) {
                  selectedJobStatus = secondChoice;
                }
                if(flag == 3) {
                  selectedGetsSalary = secondChoice;
                }
                if(flag == 4) {
                  selectedHasDisability = secondChoice;
                }
                if(flag == 5) {
                  // selectedMethodOfReceiving = secondChoice;
                }
                if(flag == 6) {
                  nationality = secondChoice;
                }
                if(flag == 7) {
                  selectedGender = secondChoice;
                }
            });
            }
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
                  backgroundColor: (flag == 1 && selectedStatus == secondChoice) || (flag == 2 && selectedJobStatus == secondChoice) ||
                      (flag == 3 && selectedGetsSalary == secondChoice) || (flag == 4 && selectedHasDisability == secondChoice) ||
                      (flag == 6 && nationality == secondChoice) || (flag == 7 && selectedGender == secondChoice)
                      // || (flag == 5 && selectedMethodOfReceiving == secondChoice)
                      ? disabled ? Colors.grey : HexColor('#2D452E') : Colors.transparent,
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

  Widget customRadioButtonGroup(int flag, List choices, setState){
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: choices.length,
      itemBuilder: (context, index){
        return Column(
          children: [
            InkWell(
              onTap: (){
                setState(() {
                  if(flag == 1) {
                    selectedMaritalStatus = choices[index];
                  }
                  if(flag == 2) {
                    selectedRelation = UserConfig.instance.checkLanguage()
                        ? choices[index]['REL_DESC_EN'] : choices[index]['REL_DESC_AR'];
                  }
                  if(flag == 3) {
                    servicesProvider.selectedActivePayment = choices[index];
                  }
                });
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
                      backgroundColor: (flag == 1 && selectedMaritalStatus == choices[index]) || (flag == 2 && selectedRelation == (UserConfig.instance.checkLanguage()
                          ? choices[index]['REL_DESC_EN'] : choices[index]['REL_DESC_AR']))  || (flag == 3 && servicesProvider.selectedActivePayment == choices[index])
                          ? HexColor('#2D452E') : Colors.transparent,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      flag == 1
                      ? getTranslated(choices[index], context)
                      : UserConfig.instance.checkLanguage()
                      ? choices[index][flag == 2 ? 'REL_DESC_EN' : 'NAME_EN'] : choices[index][flag == 2 ? 'REL_DESC_AR' : 'NAME_AR'],
                      style: TextStyle(
                        color: HexColor('#666666'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: index == choices.length -1 ? 10.0 : 0.0,)
          ],
        );
      }
    );
  }

  dependentModalBottomSheet(int index, {bool isEdit = false}){
    return showModalBottomSheet(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25.0))
      ),
      context: context,
      barrierColor: Colors.black26,
      backgroundColor: const Color.fromRGBO(250, 250, 250, 1.0),
      isScrollControlled: true,
      constraints: BoxConstraints(
          maxHeight: height(0.9, context),
      ),
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, setState) => BackdropFilter(
            filter: ui.ImageFilter.blur(
              sigmaX: 1.0,
              sigmaY: 1.0,
            ),
            child: Stack(
              children: [
                Material(
                  elevation: 100,
                  borderRadius: BorderRadius.circular(25.0),
                  color: getContainerColor(context),
                  shadowColor: Colors.black,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0).copyWith(top: 15.0),
                    child: Stack(
                      children: [
                        SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Container(
                                    width: 45,
                                    height: 6,
                                    decoration: BoxDecoration(
                                        color: !themeNotifier.isLight() ? Colors.white : HexColor('#000000'),
                                        borderRadius: const BorderRadius.all(Radius.circular(25.0))),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 25.0,),
                              if(isEdit)
                              Column(
                                children: [
                                  if(!servicesProvider.isNationalIdValid)
                                  buildFieldTitle(context, 'nationality', required: false),
                                  if(!servicesProvider.isNationalIdValid)
                                  const SizedBox(height: 10.0,),
                                  if(!servicesProvider.isNationalIdValid)
                                  customTwoRadioButtons(6, 'jordanian', 'nonJordanian', setState, disabled: servicesProvider.isNationalIdValid),
                                  if(!servicesProvider.isNationalIdValid)
                                  const SizedBox(height: 20.0,),
                                  buildFieldTitle(context, nationality == 'jordanian' ? 'nationalId' : 'personalId', required: !servicesProvider.isNationalIdValid, filled: nationalIdController.text.length == 10),
                                  const SizedBox(height: 10.0,),
                                  buildTextFormField(
                                      context, themeNotifier, nationalIdController, servicesProvider.isNationalIdValid ? 'val${nationalIdController.text}' : '9999999999', (val) async {
                                        if(val.length == 10 && nationality == 'jordanian' && pDependents[0].where((element) => element['NATIONAL_NO'].toString() == val).isEmpty){
                                          FocusScope.of(context).requestFocus(FocusNode());
                                          String message = '';
                                          servicesProvider.isLoading = true;
                                          servicesProvider.isModalLoading = true;
                                          servicesProvider.notifyMe();
                                          try{
                                            await servicesProvider.getDependentInfo(val).whenComplete((){}).then((value) {
                                              if(value['PO_status'] == 0){
                                                servicesProvider.isNationalIdValid = true;
                                                setState((){
                                                  servicesProvider.dependentInfo = value;
                                                  ///
                                                  selectedStatus = value['cur_getdata'][0][0]['IS_ALIVE'] == 1
                                                      ? 'alive' : 'dead';
                                                  selectedJobStatus = (value['cur_getdata'][0][0]['WORK_STATUS'] ?? value['cur_getdata'][0][0]['IS_WORK']) == 0
                                                      ? 'unemployed' : 'employed';
                                                  selectedGetsSalary = (value['cur_getdata'][0][0]['IS_RETIRED_A'] ?? value['cur_getdata'][0][0]['IS_WORK']) == 0
                                                      ? 'no' : 'yes';
                                                  selectedHasDisability = (value['cur_getdata'][0][0]['DISABILITY'] ?? value['cur_getdata'][0][0]['IS_SUPPORT_TO_OTHER_PEN']) != 0
                                                      ? 'yes' : 'no';
                                                  selectedMaritalStatus = (value['cur_getdata'][0][0]['SOCIAL_STATUS'] ?? value['cur_getdata'][0][0]['MARITAL_STATUS_A']) == 1
                                                      ? 'single'
                                                      : (value['cur_getdata'][0][0]['SOCIAL_STATUS'] ?? value['cur_getdata'][0][0]['MARITAL_STATUS_A']) == 2
                                                      ? 'married'
                                                      : (value['cur_getdata'][0][0]['SOCIAL_STATUS'] ?? value['cur_getdata'][0][0]['MARITAL_STATUS_A']) == 3
                                                      ? 'divorced'
                                                      : (value['cur_getdata'][0][0]['SOCIAL_STATUS'] ?? value['cur_getdata'][0][0]['MARITAL_STATUS_A']) == 4
                                                      ? 'widow' : 'single';
                                                  maritalList = [
                                                    'single',
                                                    'married',
                                                    'divorced',
                                                    'widow'
                                                  ];
                                                  if((value['cur_getdata'][0][0]['RELATION'] ?? value['cur_getdata'][0][0]['RELATIVETYPE']) == 11){
                                                    maritalList.remove('widow');
                                                    maritalList.remove('single');
                                                  }

                                                  if((value['cur_getdata'][0][0]['RELATION'] ?? value['cur_getdata'][0][0]['RELATIVETYPE']) == 6){
                                                    maritalList.remove('single');
                                                  }
                                                  ///
                                                  servicesProvider.notifyMe();
                                                });
                                              } else{
                                                message = UserConfig.instance.checkLanguage()
                                                    ? value['PO_status_desc_EN'] : value['PO_status_desc_AR'];
                                                showMyDialog(context, 'failed', message, 'ok', themeNotifier);
                                              }
                                            });
                                            servicesProvider.isLoading = false;
                                            servicesProvider.isModalLoading = false;
                                            servicesProvider.notifyMe();
                                          }catch(e){
                                            servicesProvider.isLoading = false;
                                            servicesProvider.isModalLoading = false;
                                            servicesProvider.notifyMe();
                                            if (kDebugMode) {
                                              print(e.toString());
                                            }
                                          }
                                        } else if(pDependents[0].where((element) => element['NATIONAL_NO'].toString() == val).isNotEmpty){
                                          showMyDialog(context, 'failed', getTranslated('theNationalPersonalNumberAddedToTheDependents', context), 'ok', themeNotifier);
                                        }
                                        setState((){
                                          checkNonJordanianInfo();
                                        });
                                      },
                                      inputType: TextInputType.number, enabled: !Provider.of<ServicesProvider>(context).isNationalIdValid
                                  ),
                                  const SizedBox(height: 15.0,),
                                  if(nationality == 'jordanian' && !servicesProvider.isNationalIdValid)
                                  SizedBox(height: height(1, context),),
                                ],
                              ),
                              if((nationality == 'jordanian' && (servicesProvider.isNationalIdValid) || !isEdit) || nationality == 'nonJordanian')
                              Column(
                                // shrinkWrap: true,
                                children: [
                                  if(nationality == 'jordanian')
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
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                SizedBox(
                                                  width: width(0.6, context),
                                                  child: Text(
                                                    !isEdit
                                                        ? pDependents[0][index]['NAME'] ?? pDependents[0][index]['FULL_NAME']
                                                        : '${servicesProvider.dependentInfo['cur_getdata'][0][0]['FULL_NAME'] ?? servicesProvider.dependentInfo['cur_getdata'][0][0]['NAME']}',
                                                    style: TextStyle(
                                                      height: 1.4,
                                                      color: themeNotifier.isLight() ? HexColor('#363636') : Colors.white,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
                                                  decoration: BoxDecoration(
                                                    color: !isEdit
                                                        ? (pDependents[0][index]['RELATION'] ?? pDependents[0][index]['RELATIVETYPE']) == 11
                                                        ? HexColor('#9EBDF8') : const Color.fromRGBO(0, 121, 5, 0.38)
                                                        : servicesProvider.dependentInfo['cur_getdata'][0][0]['RELATIVETYPE'] == 11
                                                        ? HexColor('#9EBDF8') : const Color.fromRGBO(0, 121, 5, 0.38),
                                                    borderRadius: BorderRadius.circular(8.0),
                                                  ),
                                                  child: Text(
                                                    !isEdit
                                                        ? getRelationType(pDependents[0][index]['RELATION'] ?? pDependents[0][index]['RELATIVETYPE'])
                                                        : getRelationType(servicesProvider.dependentInfo['cur_getdata'][0][0]['RELATIVETYPE']),
                                                    style: TextStyle(
                                                      color: !isEdit
                                                          ? (pDependents[0][index]['RELATION'] ?? pDependents[0][index]['RELATIVETYPE']) == 11
                                                          ? HexColor('#003C97') : HexColor('#2D452E')
                                                          : servicesProvider.dependentInfo['cur_getdata'][0][0]['RELATIVETYPE'] == 11
                                                          ? HexColor('#003C97') : HexColor('#2D452E'),
                                                      fontWeight: FontWeight.w400,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 15.0,),
                                            Row(
                                              children: [
                                                Text(
                                                  !isEdit
                                                      ? pDependents[0][index]['NATIONAL_NO']
                                                      : servicesProvider.dependentInfo['cur_getdata'][0][0]['NATIONALNUMBER'],
                                                  style: TextStyle(
                                                    color: themeNotifier.isLight() ? HexColor('#716F6F') : Colors.white70,
                                                  ),
                                                ),
                                                Text(
                                                  ' / ',
                                                  style: TextStyle(
                                                    color: themeNotifier.isLight() ? HexColor('#716F6F') : Colors.white70,
                                                  ),
                                                ),
                                                Text(
                                                  getTranslated(
                                                      !isEdit
                                                          ? pDependents[0][index]['NATIONALITY'] == 1
                                                          ? 'jordanian' : 'nonJordanian'
                                                          : servicesProvider.dependentInfo['cur_getdata'][0][0]['NATIONALITY'] == 1
                                                          ? 'jordanian' : 'nonJordanian',
                                                      context),
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
                                  if(nationality == 'nonJordanian')
                                  Column(
                                    children: [
                                      buildFieldTitle(context, 'quatrainNoun', required: false),
                                      const SizedBox(height: 10.0,),
                                      buildTextFormField(context, themeNotifier, quatrainNounController, '', (val){setState((){checkNonJordanianInfo();});}, enabled: !Provider.of<ServicesProvider>(context).isNationalIdValid),
                                      const SizedBox(height: 10.0,),
                                      buildFieldTitle(context, 'sex', required: false),
                                      const SizedBox(height: 10.0,),
                                      customTwoRadioButtons(7, 'male', 'female', setState),
                                      const SizedBox(height: 20.0,),
                                      buildFieldTitle(context, 'DateOfBirth', required: false),
                                      SizedBox(height: height(0.015, context),),
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
                                              setState((){
                                                selectedDateOfBirth = date;
                                                checkNonJordanianInfo();
                                              });
                                            },
                                            currentTime: selectedDateOfBirth,
                                            locale: LocaleType.en,
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
                                  const SizedBox(height: 20.0,),
                                  buildFieldTitle(context, 'status', required: false),
                                  const SizedBox(height: 10.0,),
                                  customTwoRadioButtons(1, 'alive', 'dead', setState),
                                  const SizedBox(height: 30.0,),
                                  buildFieldTitle(context, 'employmentStatus', required: false),
                                  const SizedBox(height: 10.0,),
                                  customTwoRadioButtons(2, 'unemployed', 'employed', setState),
                                  const SizedBox(height: 30.0,),
                                  buildFieldTitle(context, 'getsSalary', required: false),
                                  const SizedBox(height: 10.0,),
                                  customTwoRadioButtons(3, 'yes', 'no', setState),
                                  const SizedBox(height: 30.0,),
                                  buildFieldTitle(context, 'hasDisability', required: false),
                                  const SizedBox(height: 10.0,),
                                  customTwoRadioButtons(4, 'yes', 'no', setState),
                                  const SizedBox(height: 30.0,),
                                  buildFieldTitle(context, 'maritalStatus', required: false),
                                  const SizedBox(height: 10.0,),
                                  customRadioButtonGroup(1, maritalList, setState),
                                  if(nationality == 'nonJordanian')
                                  const SizedBox(height: 10.0,),
                                  if(nationality == 'nonJordanian')
                                  buildFieldTitle(context, 'relativeRelation', required: false),
                                  if(nationality == 'nonJordanian')
                                  const SizedBox(height: 10.0,),
                                  if(nationality == 'nonJordanian')
                                  customRadioButtonGroup(2, servicesProvider.result['P_RELATION'][0], setState),
                                  SizedBox(height: height(isScreenHasSmallHeight(context) ? 0.25 : 0.15, context),),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          width: width(0.9, context),
                          child: Container(
                            color: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 5.0).copyWith(bottom: 15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                textButton(context, themeNotifier, 'save', (!isEdit || (isEdit && nationality == 'jordanian' && servicesProvider.isNationalIdValid) || (isEdit && nationality == 'nonJordanian' && nonJordanianSubmitEnabled)) ? HexColor('#445740') : HexColor('DADADA'),
                                    (!isEdit || (isEdit && nationality == 'jordanian' && servicesProvider.isNationalIdValid) || (isEdit && nationality == 'nonJordanian' && nonJordanianSubmitEnabled)) ? Colors.white : HexColor('#363636'), () async {
                                  FocusScope.of(context).requestFocus(FocusNode());
                                  if(!isEdit) {
                                    String message = '';
                                    servicesProvider.isLoading = true;
                                    servicesProvider.isModalLoading = true;
                                    servicesProvider.notifyMe();
                                    dynamic maritalStatus = selectedMaritalStatus == 'single' ? 1
                                        : selectedMaritalStatus == 'married' ? 2
                                        : selectedMaritalStatus == 'divorced' ? 3
                                        : selectedMaritalStatus == 'widow' ? 4 : 1;
                                    try{
                                      /// TODO: complete checkDocumentDependent!
                                      await servicesProvider.checkDocumentDependent((pDependents.isNotEmpty && pDependents[0].length != 0) ? pDependents[0] : []).then((value) async {
                                        if(value['P_RESULT'].isEmpty){
                                          var dependent = {
                                            "FULL_NAME": pDependents[0][index]["FULL_NAME"] ?? pDependents[0][index]['NAME'],
                                            "RELATION": pDependents[0][index]["RELATION"] ?? pDependents[0][index]["RELATIVETYPE"],
                                            "IS_ALIVE": selectedStatus == 'alive' ? 1 : 0,
                                            "WORK_STATUS": selectedJobStatus == 'unemployed' ? 0 : 1,
                                            "IS_RETIRED": pDependents[0][index]["IS_RETIRED"],
                                            "DISABILITY": selectedHasDisability == 'no' ? 0 : 1,
                                            "MARITAL_STATUS": maritalStatus,
                                            "GENDER": pDependents[0][index]["GENDER"],
                                            "ID": pDependents[0][index]["ID"],
                                            "SOURCE_FLAG": pDependents[0][index]["SOURCE_FLAG"],
                                            "NATIONAL_NO": pDependents[0][index]["NATIONAL_NO"],
                                            "NATIONALITY": pDependents[0][index]["NATIONALITY"],
                                            "BIRTHDATE": pDependents[0][index]["BIRTHDATE"],
                                            "AGE": pDependents[0][index]["AGE"],
                                            "MARITAL_STATUS_A": pDependents[0][index]["MARITAL_STATUS_A"] ?? pDependents[0][index]["SOCIAL_STATUS"],
                                            "WORK_STATUS_A": pDependents[0][index]["WORK_STATUS_A"] ?? pDependents[0][index]["IS_WORK"],
                                            "IS_ALIVE_A": pDependents[0][index]["IS_ALIVE_A"],
                                            "IS_RETIRED_A": selectedGetsSalary == 'yes' ? 1 : 0,
                                            "LAST_EVENT_DATE": pDependents[0][index]["LAST_EVENT_DATE"],
                                            "WANT_HEALTH_INSURANCE": "",
                                            "PreLoad": 0,
                                            "Added": 1,
                                            "doc_dep": [],
                                            "DEP_CODE": pDependents[0][index]["DEP_CODE"],
                                            "IS_STOP": ""
                                          };
                                          pDependents[0][index] = dependent;
                                          await servicesProvider.getRequiredDocuments(
                                              jsonEncode({
                                                "row": {
                                                  "NAT": "111",
                                                  "GENDER": "1"
                                                },
                                                "dep": {
                                                  "dep": dependent
                                                }
                                              }), widget.serviceType
                                          ).whenComplete((){}).then((value) {
                                            servicesProvider.dependentsDocuments.removeWhere((element) => element["CODE"] == pDependents[0][dependentIndex]["DEP_CODE"]);
                                            if(value['R_RESULT'].isNotEmpty){
                                              for(int i=0 ; i<value['R_RESULT'][0].length ; i++){
                                                if(!servicesProvider.dependentsDocuments.contains(value['R_RESULT'][0][i])) {
                                                  servicesProvider.dependentsDocuments.add(value['R_RESULT'][0][i]);
                                                }
                                              }
                                            }
                                          });
                                          // ignore: use_build_context_synchronously
                                          Navigator.pop(context);
                                        } else{
                                          message = UserConfig.instance.checkLanguage()
                                              ? value['PO_status_desc_EN'] : value['PO_status_desc_AR'];
                                          showMyDialog(context, 'failed', message, 'ok', themeNotifier);
                                        }
                                      });
                                      servicesProvider.isLoading = false;
                                      servicesProvider.isModalLoading = false;
                                      servicesProvider.notifyMe();
                                    } catch(e){
                                      servicesProvider.isLoading = false;
                                      servicesProvider.isModalLoading = false;
                                      servicesProvider.notifyMe();
                                      if (kDebugMode) {
                                        print(e.toString());
                                      }
                                    }
                                  } else{
                                    if((nationality == 'jordanian' && servicesProvider.isNationalIdValid) || (nationality == 'nonJordanian' && nonJordanianSubmitEnabled)){
                                      String message = '';
                                      servicesProvider.isLoading = true;
                                      servicesProvider.isModalLoading = true;
                                      servicesProvider.notifyMe();
                                      try{
                                        await servicesProvider.checkDocumentDependent((pDependents.isNotEmpty && pDependents[0].length != 0) ? pDependents[0] : []).then((value) async {
                                          if(value['P_RESULT'].isEmpty){
                                            dynamic maritalStatus = selectedMaritalStatus == 'single' ? 1
                                                : selectedMaritalStatus == 'married' ? 2
                                                : selectedMaritalStatus == 'divorced' ? 3
                                                : selectedMaritalStatus == 'widow' ? 4 : 1;
                                            Map<String, dynamic> dependent;
                                            String id = "${DateTime.now().millisecondsSinceEpoch}${((math.Random().nextDouble() * 10000) + 1).floor()}";
                                            if(nationality == 'jordanian'){
                                              dependent = {
                                                "NAME": servicesProvider.dependentInfo['cur_getdata'][0][0]["FULL_NAME"] ?? servicesProvider.dependentInfo['cur_getdata'][0][0]["NAME"],
                                                "GENDER": servicesProvider.dependentInfo['cur_getdata'][0][0]["GENDER"],
                                                "FIRSTNAME": servicesProvider.dependentInfo['cur_getdata'][0][0]["FIRSTNAME"],
                                                "SECONDNAME": servicesProvider.dependentInfo['cur_getdata'][0][0]["SECONDNAME"],
                                                "THIRDNAME": servicesProvider.dependentInfo['cur_getdata'][0][0]["THIRDNAME"],
                                                "LASTNAME": servicesProvider.dependentInfo['cur_getdata'][0][0]["LASTNAME"],
                                                "BIRTHDATE": servicesProvider.dependentInfo['cur_getdata'][0][0]["BIRTHDATE"],
                                                "AGE": servicesProvider.dependentInfo['cur_getdata'][0][0]["AGE"],
                                                "MARITAL_STATUS_A": servicesProvider.dependentInfo['cur_getdata'][0][0]["MARITAL_STATUS_A"] ?? servicesProvider.dependentInfo['cur_getdata'][0][0]["SOCIAL_STATUS"],
                                                "MARITAL_STATUS": servicesProvider.dependentInfo['cur_getdata'][0][0]["MARITAL_STATUS"] ?? servicesProvider.dependentInfo['cur_getdata'][0][0]["SOCIAL_STATUS"],
                                                "WORK_STATUS_A": servicesProvider.dependentInfo['cur_getdata'][0][0]["WORK_STATUS_A"] ?? servicesProvider.dependentInfo['cur_getdata'][0][0]["IS_WORK"],
                                                "IS_ALIVE_A": servicesProvider.dependentInfo['cur_getdata'][0][0]["IS_ALIVE"],
                                                "IS_ALIVE": selectedStatus == 'alive' ? 1 : 0,
                                                "IS_RETIRED_A": selectedGetsSalary == 'yes' ? 1 : 0,
                                                "LAST_EVENT_DATE": servicesProvider.dependentInfo['cur_getdata'][0][0]["LAST_SOC_STATUS_DATE"],
                                                "WANT_HEALTH_INSURANCE": "",
                                                "PreLoad": null,
                                                "Added": null,
                                                "doc_dep": "",
                                                "RELATION": servicesProvider.dependentInfo['cur_getdata'][0][0]["RELATION"] ?? servicesProvider.dependentInfo['cur_getdata'][0][0]["RELATIVETYPE"],
                                                "WORK_STATUS": selectedJobStatus == 'unemployed' ? 0 : 1,
                                                "IS_RETIRED": servicesProvider.dependentInfo['cur_getdata'][0][0]["IS_RETIRED"],
                                                "DISABILITY": selectedHasDisability == 'no' ? 0 : 1,
                                                "ID": id,
                                                "DEP_CODE": id,
                                                "SOURCE_FLAG": 2,
                                                "NATIONAL_NO": servicesProvider.dependentInfo['cur_getdata'][0][0]["NATIONALNUMBER"],
                                                "NATIONALITY": servicesProvider.dependentInfo['cur_getdata'][0][0]["NATIONALITY"],
                                              };
                                            } else{
                                              dependent = {
                                                "NAME": quatrainNounController.text,
                                                "RELATION": getRelationNumber(selectedRelation),
                                                "IS_ALIVE": selectedStatus == 'alive' ? 1 : 0,
                                                "WORK_STATUS": selectedJobStatus == 'unemployed' ? 0 : 1,
                                                "IS_RETIRED": selectedGetsSalary == 'yes' ? 1 : 0,
                                                "DISABILITY": selectedHasDisability == 'no' ? 0 : 1,
                                                "MARITAL_STATUS": maritalStatus,
                                                "MARITAL_STATUS_A": maritalStatus,
                                                "GENDER": selectedGender == 'male' ? 1 : 2,
                                                "ID": id,
                                                "SOURCE_FLAG": 2,
                                                "NATIONAL_NO": nationalIdController.text,
                                                "NATIONALITY": 2,
                                                "BIRTHDATE": DateFormat('dd/MM/yyyy').format(selectedDateOfBirth),
                                                "AGE": 0,
                                                ///
                                                "WORK_STATUS_A": selectedJobStatus == 'unemployed' ? 0 : 1,
                                                "IS_ALIVE_A": 1,
                                                "IS_RETIRED_A": selectedGetsSalary == 'yes' ? 1 : 0,
                                                "LAST_EVENT_DATE": "",
                                                "WANT_HEALTH_INSURANCE": "",
                                                "PreLoad": null,
                                                "Added": null,
                                                "doc_dep": "",
                                                "DEP_CODE": id,
                                              };
                                            }
                                            await servicesProvider.getRequiredDocuments(
                                                jsonEncode({
                                                  "row": {
                                                    "NAT": "111",
                                                    "GENDER": "1"
                                                  },
                                                  "dep": {
                                                    "dep": dependent
                                                  }
                                                }), widget.serviceType
                                            ).whenComplete((){}).then((value) {
                                              servicesProvider.dependentsDocuments.removeWhere((element) => element["CODE"] == pDependents[0][dependentIndex]["DEP_CODE"]);
                                              if(value['R_RESULT'].isNotEmpty){
                                                for(int i=0 ; i<value['R_RESULT'][0].length ; i++){
                                                  if(!servicesProvider.dependentsDocuments.contains(value['R_RESULT'][0][i])) {
                                                    servicesProvider.dependentsDocuments.add(value['R_RESULT'][0][i]);
                                                  }
                                                }
                                              }
                                            });
                                            if(pDependents.isNotEmpty) {
                                              pDependents[0].add(dependent);
                                            } else{
                                              pDependents.add([dependent]);
                                            }
                                            // ignore: use_build_context_synchronously
                                            Navigator.pop(context);
                                          } else{
                                            message = UserConfig.instance.checkLanguage()
                                                ? value['PO_status_desc_EN'] : value['PO_status_desc_AR'];
                                            showMyDialog(context, 'failed', message, 'ok', themeNotifier);
                                          }
                                        });
                                        servicesProvider.isLoading = false;
                                        servicesProvider.isModalLoading = false;
                                        servicesProvider.notifyMe();
                                      } catch(e){
                                        servicesProvider.isLoading = false;
                                        servicesProvider.isModalLoading = false;
                                        servicesProvider.notifyMe();
                                        if (kDebugMode) {
                                          print(e.toString());
                                        }
                                      }
                                    }
                                  }
                                }),
                                const SizedBox(height: 4.0,),
                                textButton(context, themeNotifier, 'cancel', HexColor('#DADADA'), HexColor('#363636'), (){
                                  Navigator.of(context).pop();
                                }),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                if(Provider.of<ServicesProvider>(context).isLoading && Provider.of<ServicesProvider>(context).isModalLoading)
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: width(1, context),
                    color: themeNotifier.isLight() ? Colors.white70 : Colors.black45,
                    child: Center(
                      child: animatedLoader(context),
                    ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget contextMenuItem(String key, String icon, String iconColor) {
    return Row(
      children: <Widget>[
        SvgPicture.asset(icon, color: HexColor(iconColor),),
        const SizedBox(width: 10),
        Text(getTranslated(key, context))
      ],
    );
  }

  String getRelationType(int relation){
    String result = '';
    servicesProvider.result['P_RELATION'][0].forEach((element){
      if(element['REL_ID'].toString() == relation.toString()){
        result = UserConfig.instance.checkLanguage() ? element['REL_DESC_EN'] : element['REL_DESC_AR'];
      }
    });
    return result;
  }

  int getRelationNumber(String relation){
    int result = 0;
    servicesProvider.result['P_RELATION'][0].forEach((element){
      if((UserConfig.instance.checkLanguage() ? element['REL_DESC_EN'] : element['REL_DESC_AR']) == relation){
        result = element['REL_ID'];
      }
    });
    return result;
  }

  checkNonJordanianInfo() {
    if (nationalIdController.text.length == 10 &&
        quatrainNounController.text.isNotEmpty &&
        DateFormat('dd/MM/yyyy').format(selectedDateOfBirth).isNotEmpty) {
      setState(() {
        nonJordanianSubmitEnabled = true;
      });
    } else {
      setState(() {
        nonJordanianSubmitEnabled = false;
      });
    }
  }
}

enum ContextMenu { edit, delete }

