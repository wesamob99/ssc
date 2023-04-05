// ignore_for_file: file_names

import 'package:drop_down_list/model/selected_list_item.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
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
import 'dart:ui' as ui;
import '../../../../viewModel/login/loginProvider.dart';
import '../../shared/firstStepScreen.dart';
import '../../shared/paymentScreen.dart';
import '../../shared/verifyMobileNumberScreen.dart';

class ApplicationForPensionersLoan extends StatefulWidget {
  const ApplicationForPensionersLoan({Key key}) : super(key: key);

  @override
  State<ApplicationForPensionersLoan> createState() => _ApplicationForPensionersLoanState();
}

class _ApplicationForPensionersLoanState extends State<ApplicationForPensionersLoan> {

  ServicesProvider servicesProvider;
  ThemeNotifier themeNotifier;
  bool termsChecked = false;
  String selectedLoanType;
  String selectedLoanCategory = '';
  List docs = [];

  Map loanResultInfo;

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
      return selectedLoanCategory != '';
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
    } else if(flag == 6){
      return termsChecked;
    }
  }

  @override
  void initState() {
    Provider.of<LoginProvider>(context, listen: false).readCountriesJson();
    servicesProvider = Provider.of<ServicesProvider>(context, listen: false);
    servicesProvider.mobileNumberController.text = UserSecuredStorage.instance.realMobileNumber;
    themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);
    servicesProvider.stepNumber = 1;
    servicesProvider.documentIndex = 0;
    servicesProvider.documentsScreensStepNumber = 1;
    servicesProvider.dependentsDocuments = [];
    servicesProvider.mandatoryDocuments = [];
    servicesProvider.optionalDocuments = [];
    servicesProvider.optionalDocumentsCheckBox = [];
    servicesProvider.selectedOptionalDocuments = [];
    servicesProvider.uploadedFiles = {
      "mandatory": [],
      "optional": [],
    };
    servicesProvider.activePayment = [];
    servicesProvider.getActivePayment("10", servicesProvider.result['p_per_info'][0][0]['NAT'] == "111" ? '1' : '2').whenComplete(() {}).then((value) {
      value['R_RESULT'][0].forEach((element){
        servicesProvider.activePayment.add(element);
      });
      servicesProvider.selectedActivePayment = servicesProvider.activePayment[0];
    });
    servicesProvider.currentLoanValue = 1;
    servicesProvider.currentNumberOfInstallments = 1;
    servicesProvider.currentFinancialCommitment = 0;
    servicesProvider.selectedPaymentCountry = SelectedListItem(
      name: UserConfig.instance.isLanguageEnglish() ? "Palestine" : "فلسطين",
      value: "970", natCode: 188,
      flag: countries.where((element) => element.dialCode == "970").first.flag,
    );
    selectedLoanType = servicesProvider.result['p_per_info'][0][0]['DUAL_FLG'] != 1
        ? 'heirLoan'
        : 'personalRetirementLoan';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: (servicesProvider.documentsScreensStepNumber == 1 || servicesProvider.documentsScreensStepNumber == 3) && servicesProvider.stepNumber == 5
          ? HexColor('#445740') : HexColor('#ffffff'),
      appBar: AppBar(
        centerTitle: false,
        title: Text(getTranslated('applicationForPensionersLoan', context)),
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: InkWell(
            onTap: (){
              if(servicesProvider.stepNumber == 5){
                switch(servicesProvider.documentsScreensStepNumber){
                  case 1: servicesProvider.stepNumber = 4; break;
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
                      if(servicesProvider.result['p_per_info'][0][0]['DUAL_FLG'] != 1){
                        servicesProvider.stepNumber = 2;
                      }else{
                        servicesProvider.stepNumber = 1;
                      }
                    }
                    break;
                  case 4:
                    {
                      servicesProvider.stepNumber = 3;
                    }
                    break;
                  case 6:
                    {
                      servicesProvider.stepNumber = 5;
                      servicesProvider.documentsScreensStepNumber = 5;
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
              servicesProvider.notifyMe();
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
                        const PaymentScreen(numberOfSteps: 6, nextStep: 'documents', stepText: 'forthStep', stepNumber: 4,),
                      if(Provider.of<ServicesProvider>(context).stepNumber == 5)
                        DocumentsScreen(nextStep: 'receiptOfAllowances', numberOfSteps: 6, data: {
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
                          "IFSC": "",
                          /// *****************************
                          "SECNO": servicesProvider.result['p_per_info'][0][0]['SECNO'],
                          "NAT_DESC": servicesProvider.result['p_per_info'][0][0]['NAT_DESC'],
                          "NAT": int.tryParse(servicesProvider.result['p_per_info'][0][0]['NAT'].toString()),
                          "NAT_NO": servicesProvider.result['p_per_info'][0][0]['NAT_NO'],
                          "PERS_NO": servicesProvider.result['p_per_info'][0][0]['PERS_NO'],
                          "LAST_EST_NAME": null,
                          "NAME1": servicesProvider.result['p_per_info'][0][0]['NAME1'],
                          "NAME2": servicesProvider.result['p_per_info'][0][0]['NAME2'],
                          "NAME3": servicesProvider.result['p_per_info'][0][0]['NAME3'],
                          "NAME4": servicesProvider.result['p_per_info'][0][0]['NAME4'],
                          "FULL_NAME_EN": servicesProvider.result['p_per_info'][0][0]['FULL_NAME_EN'],
                          "EMAIL": servicesProvider.result['p_per_info'][0][0]['EMAIL'],
                          "MOBILE": servicesProvider.result['p_per_info'][0][0]['MOBILE'],
                          "INTERNATIONAL_CODE": servicesProvider.result['p_per_info'][0][0]['INTERNATIONAL_CODE'],
                          "INSURED_ADDRESS": "",
                          "MARITAL_STATUS": null,
                          "REGDATE": null,
                          "REGRATE": null,
                          "LAST_SALARY": null,
                          "LAST_STODATE": null,
                          "GENDER": servicesProvider.result['p_per_info'][0][0]['GENDER'],
                          "PEN_START_DATE": null,
                          "GOVERNORATE": null,
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
                          "LAST_EST_NO": null,
                          "FAM_NO": null,
                          "nextVaild": null,
                          "wantAddFamily": null,
                          "GENDER_DESC": servicesProvider.result['p_per_info'][0][0]['GENDER_DESC'],
                          "PI_EPAY": null,
                          "INSURED": null,
                          "ID": null,
                          "DEP_FLAG": 0,
                          "SECNO_DEAD": servicesProvider.result['P_DEAD_LOAN'][0][0]['SECNO_DEAD'],
                          "CARDNO": servicesProvider.result['P_DEAD_LOAN'][0][0]['CARDNO'],
                          "NAT_NO_DEAD": servicesProvider.result['P_DEAD_LOAN'][0][0]['NAT_NO_DEAD'],
                          "FULL_NAME_DEAD": servicesProvider.result['P_DEAD_LOAN'][0][0]['FULL_NAME_DEAD'],
                          "NET_PAY": servicesProvider.result[selectedLoanType == 'heirLoan' ? 'P_DEAD_LOAN' : 'p_per_info'][0][0]['NET_PAY'],
                          "TYPE_OF_ADVANCE": (selectedLoanType == 'heirLoan' ? 2 : 1),
                          "OFFNO": servicesProvider.result['p_per_info'][0][0]['OFFNO'],
                          "DURATION": servicesProvider.currentNumberOfInstallments,
                          "TOT_PAY": servicesProvider.result[selectedLoanType == 'heirLoan' ? 'P_DEAD_LOAN' : 'p_per_info'][0][0]['TOT_PAY'],
                          "OUT_DEBT": servicesProvider.currentFinancialCommitment,
                          "LOAN_AMT": servicesProvider.currentLoanValue,
                          "LAON_TYPE": servicesProvider.result['P_LAON_TYPE'][0].where((element) => (UserConfig.instance.isLanguageEnglish()
                              ? element['DESC_EN'] : element['DESC_AR']) == selectedLoanCategory).first['COD'],
                          "STARTDT": loanResultInfo['PO_STARTDT'],
                          "MONTHLY_PAY_AMT": loanResultInfo['po_monthly_pay_amt'],
                          "LOAN_PAID_AMT": loanResultInfo['po_loan_paid_amt'],
                          "TOT_LOAN_AMT": loanResultInfo['po_loan_amt'],
                          "nextValid": true,
                          "DOC_FLG": servicesProvider.result[selectedLoanType == 'heirLoan' ? 'P_DEAD_LOAN' : 'p_per_info'][0][0]['DOC_FLG'],
                          "PENCODE": servicesProvider.result[selectedLoanType == 'heirLoan' ? 'P_DEAD_LOAN' : 'p_per_info'][0][0]['PENCODE'],
                          "PENSTART": servicesProvider.result[selectedLoanType == 'heirLoan' ? 'P_DEAD_LOAN' : 'p_per_info'][0][0]['PENSTART'],
                          "DUAL_FLG": servicesProvider.result['p_per_info'][0][0]['DUAL_FLG'],
                          "MAX_AMT": servicesProvider.result[selectedLoanType == 'heirLoan' ? 'P_DEAD_LOAN' : 'p_per_info'][0][0]['MAX_AMT'],
                          "MAX_DUR": servicesProvider.result[selectedLoanType == 'heirLoan' ? 'P_DEAD_LOAN' : 'p_per_info'][0][0]['MAX_DUR'],
                          "PREV_BAL": "",
                          "LAST_PDATE": "",
                          "RELAT": servicesProvider.result[selectedLoanType == 'heirLoan' ? 'P_DEAD_LOAN' : 'p_per_info'][0][0]['RELAT'],
                          "RELAT_DESC": servicesProvider.result[selectedLoanType == 'heirLoan' ? 'P_DEAD_LOAN' : 'p_per_info'][0][0]['RELAT_DESC'],
                          "BANK_DOC_FLG": loanResultInfo['po_bank_doc_flg'],
                        }, serviceType: 10, info: const {}, dependents: const [], relations: const [], nextStepNumber: 6,),
                      if(Provider.of<ServicesProvider>(context).stepNumber == 6)
                        fifthStep(context, themeNotifier),
                      if(!(Provider.of<ServicesProvider>(context).stepNumber == 5))
                        textButton(context,
                          themeNotifier,
                          Provider.of<ServicesProvider>(context).stepNumber != 6
                              ? (Provider.of<ServicesProvider>(context).stepNumber != 3 ? 'continue' : 'calculate')
                              : 'send',
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
                                          if(servicesProvider.result['p_per_info'][0][0]['DUAL_FLG'] != 1){
                                            servicesProvider.isMobileNumberUpdated = false;
                                            servicesProvider.stepNumber = 2;
                                          }else{
                                            servicesProvider.stepNumber = 3;
                                            servicesProvider.isMobileNumberUpdated = false;
                                          }
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
                                    if(servicesProvider.result['p_per_info'][0][0]['DUAL_FLG'] != 1){
                                      servicesProvider.isMobileNumberUpdated = false;
                                      servicesProvider.stepNumber = 2;
                                    }else{
                                      servicesProvider.stepNumber = 3;
                                      servicesProvider.isMobileNumberUpdated = false;
                                    }
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
                                  servicesProvider.isLoading = true;
                                  servicesProvider.notifyMe();
                                  loanResultInfo = null;
                                  String errorMessage = "";
                                  try{
                                    await servicesProvider.loanCalculation(servicesProvider.currentFinancialCommitment, servicesProvider.currentLoanValue, servicesProvider.currentNumberOfInstallments, selectedLoanCategory, selectedLoanType).whenComplete((){})
                                        .then((val) async {
                                      if(val['PO_status_no'] == 0){
                                        loanResultInfo = val;
                                        showCalculationResultBottomSheet(
                                          val['po_loan_paid_amt'],
                                          val['po_monthly_pay_amt'],
                                          val['PO_STARTDT'],
                                        );
                                      }else{
                                        servicesProvider.isMobileNumberUpdated = false;
                                        errorMessage = UserConfig.instance.isLanguageEnglish()
                                            ? val["PO_status_desc_EN"] : val["PO_status_desc_AR"];
                                        showMyDialog(context, 'failed', errorMessage, 'retryAgain', themeNotifier);
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
                                }
                              } break;
                              case 4: {
                                if(checkContinueEnabled(flag: 4)){
                                  servicesProvider.stepNumber = 5;
                                }
                              } break;
                              case 6: {
                                if(checkContinueEnabled(flag: 6)){
                                  // try{
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
                                    String loanType = servicesProvider.result['P_LAON_TYPE'][0].where((element) => selectedLoanCategory == ((UserConfig.instance.isLanguageEnglish() ? element['DESC_EN'] : element['DESC_AR']))).first['COD'];
                                    int typeOfAdvance = 1;
                                    if(servicesProvider.result['p_per_info'][0][0]['DUAL_FLG'] == 3){
                                      typeOfAdvance = (selectedLoanType == 'heirLoan' ? 2 : 1);
                                    } else if(servicesProvider.result['p_per_info'][0][0]['DUAL_FLG'] == 2){
                                      typeOfAdvance = 2;
                                    }
                                    await servicesProvider.setRetirementLoanApplication(docs, paymentInfo, typeOfAdvance, loanType, loanResultInfo, selectedLoanType).whenComplete(() {}).then((value) {
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
                                  // } catch(e){
                                  //   servicesProvider.isLoading = false;
                                  //   servicesProvider.notifyMe();
                                  //   if (kDebugMode) {
                                  //     print(e.toString());
                                  //   }
                                  // }
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
          if(Provider.of<ServicesProvider>(context).isLoading)
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
                  getTranslated('loanType', context),
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
                      '${getTranslated('next', context)}: ${getTranslated('loanDetails', context)}',
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
            buildFieldTitle(context, servicesProvider.result['p_per_info'][0][0]['DUAL_FLG'] == 3 ? 'loanType' : 'heirLoan', required: false),
            const SizedBox(height: 10.0,),
            if(servicesProvider.result['p_per_info'][0][0]['DUAL_FLG'] == 3)
            customTwoRadioButtons('heirLoan', 'personalRetirementLoan', setState),
            if(servicesProvider.result['p_per_info'][0][0]['DUAL_FLG'] == 3)
            const SizedBox(height: 20.0,),
            if(selectedLoanType == 'heirLoan')
            Card(
              elevation: 5.0,
              shadowColor: Colors.black45,
              color: getContainerColor(context),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Stack(
                children: [
                  Positioned(
                      top: 0,
                      left: 0,
                      child: SvgPicture.asset('assets/icons/deathLabel.svg', width: 50,)
                  ),
                  Container(
                    width: width(1, context),
                    padding: const EdgeInsets.all(25.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              servicesProvider.result['P_DEAD_LOAN'][0][0]['FULL_NAME_DEAD'],
                              style: TextStyle(
                                height: 1.4,
                                color: themeNotifier.isLight() ? HexColor('#363636') : Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            // if(nationality == 'jordanian')
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
                              decoration: BoxDecoration(
                                color: const Color.fromRGBO(0, 121, 5, 0.38),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: Text(
                                servicesProvider.result['P_DEAD_LOAN'][0][0]['RELAT_DESC'],
                                style: TextStyle(
                                  color: HexColor('#2D452E'),
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
                              servicesProvider.result['P_DEAD_LOAN'][0][0]['NAT_NO_DEAD'].toString(),
                              style: TextStyle(
                                color: themeNotifier.isLight() ? HexColor('#716F6F') : Colors.white70,
                              ),
                            ),
                            // Text(
                            //   ' / ',
                            //   style: TextStyle(
                            //     color: themeNotifier.isLight() ? HexColor('#716F6F') : Colors.white70,
                            //   ),
                            // ),
                            // Text(
                            //   servicesProvider.result['P_DEAD_LOAN'][0][0]['RELAT_DESC'],
                            //   style: TextStyle(
                            //     color: themeNotifier.isLight() ? HexColor('#716F6F') : Colors.white70,
                            //   ),
                            // ),
                          ],
                        ),
                        const SizedBox(height: 15.0,),
                        Row(
                          children: [
                            Text(
                              getTranslated('widowCardNumber', context) + ": ",
                              style: TextStyle(
                                color: themeNotifier.isLight() ? HexColor('#716F6F') : Colors.white70,
                              ),
                            ),
                            Text(
                              servicesProvider.result['P_DEAD_LOAN'][0][0]['CARDNO'].toString(),
                              style: TextStyle(
                                color: themeNotifier.isLight() ? HexColor('#716F6F') : Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      ],
                    )
                  ),
                ],
              )
            ),
          ],
        ),
      ),
    );
  }

  Widget thirdStep(context, themeNotifier){
    String selectedLoanCod = '';
    if(selectedLoanCategory != ''){
      selectedLoanCod = servicesProvider.result['P_LAON_TYPE'][0].where((element) => selectedLoanCategory == ((UserConfig.instance.isLanguageEnglish() ? element['DESC_EN'] : element['DESC_AR']))).first['COD'];
    }
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
                  getTranslated('thirdStep', context),
                  style: TextStyle(
                      color: HexColor('#979797'),
                      fontSize: width(0.03, context)
                  ),
                ),
                SizedBox(height: height(0.006, context),),
                Text(
                  getTranslated('loanDetails', context),
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
                      '3/5',
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
            buildFieldTitle(context, 'loanCategory', required: false),
            customRadioButtonGroup(servicesProvider.result['P_LAON_TYPE'][0], setState),
            if(selectedLoanCategory != '')
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4.0,),
                buildNoteField(
                  context,
                  selectedLoanCod == 'I'
                    ? 'islamicMurabahaLoanDesc' : selectedLoanCod == 'P'
                      ? 'personalLoanDesc' : 'developmentProjectsLoan', 70.0
                ),
                const SizedBox(height: 30.0,),
                buildFieldTitle(context, 'loanValue', required: false),
                const SizedBox(height: 20.0,),
                buildInputFieldsField(1),
                const SizedBox(height: 30.0,),
                buildFieldTitle(context, 'numberOfInstallments', required: false),
                const SizedBox(height: 20.0,),
                buildInputFieldsField(2),
                const SizedBox(height: 30.0,),
                buildFieldTitle(context, 'financialCommitment', required: false),
                const SizedBox(height: 20.0,),
                buildInputFieldsField(3, withSlider: false),
              ],
            ),
            const SizedBox(height: 30.0,),
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
                    '4/5',
                    style: TextStyle(
                        color: HexColor('#979797'),
                        fontSize: width(0.025, context)
                    ),
                  ),
                  Text(
                    '${getTranslated('finished', context)}',
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
                  getTranslated('retirementLoanTermsAndConditions', context),
                  style: TextStyle(
                    fontSize: height(0.015, context),
                    color: HexColor('#595959'),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget customTwoRadioButtons(String firstChoice, String secondChoice, setState){
    return Row(
      children: [
        InkWell(
          onTap: (){
            setState(() {
              selectedLoanType = firstChoice;
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
                  backgroundColor: (selectedLoanType == firstChoice)
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
              selectedLoanType = secondChoice;
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
                  backgroundColor: (selectedLoanType == secondChoice)
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

  Widget customRadioButtonGroup(List choices, setState){
    return SizedBox(
      width: width(0.9, context),
      height: 70,
      child: ListView.builder(
          shrinkWrap: true,
          itemCount: choices.length,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index){
            return Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                InkWell(
                  onTap: (){
                    setState(() {
                      selectedLoanCategory = UserConfig.instance.isLanguageEnglish()
                          ? choices[index]['DESC_EN'] : choices[index]['DESC_AR'];
                    });
                  },

                  child: Row(
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.0),
                          color:  (selectedLoanCategory == (UserConfig.instance.isLanguageEnglish() ? choices[index]['DESC_EN'] : choices[index]['DESC_AR']))
                              ? const Color.fromRGBO(153, 216, 140, 0.4) : HexColor('#E9E9E9')
                        ),
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          UserConfig.instance.isLanguageEnglish()
                              ? choices[index]['DESC_EN'] : choices[index]['DESC_AR'],
                          style: TextStyle(
                            color: HexColor('#363636'),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 4.0,)
              ],
            );
          }
      ),
    );
  }

  Widget buildInputFieldsField(int flag , {bool withSlider = true}){
    double minValue = 1;
    double maxValue = 1;

    if(flag == 1){
      minValue = 1.0;
      maxValue = double.tryParse(servicesProvider.result[selectedLoanType == 'heirLoan' ? 'P_DEAD_LOAN' : 'p_per_info'][0][0]['MAX_AMT'].toString());
    } else if(flag == 2){
      minValue = 1;
      maxValue = 60;
    } else if(flag == 3){
      minValue = 0;
      maxValue = 10000;
    }
    return Card(
      color: Colors.white,
      elevation: 0.8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 100,
                  child: TextFormField(
                    controller: TextEditingController(text: (flag == 1 ? servicesProvider.currentLoanValue : flag == 2 ? servicesProvider.currentNumberOfInstallments : servicesProvider.currentFinancialCommitment).toStringAsFixed(0)),
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[0-9]'))],
                    style: TextStyle(
                      fontSize: isTablet(context) ? 20 : 15,
                      color: themeNotifier.isLight() ? HexColor('#363636') : Colors.white,
                      fontWeight: FontWeight.bold
                    ),
                    cursorColor: themeNotifier.isLight() ? getPrimaryColor(context, themeNotifier) : Colors.white,
                    cursorWidth: 1,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: isTablet(context) ? 20 : 0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          color: themeNotifier.isLight()
                              ? getPrimaryColor(context, themeNotifier)
                              : Colors.white,
                          width: 0.5,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          color: themeNotifier.isLight()
                              ? getPrimaryColor(context, themeNotifier)
                              : Colors.white,
                          width: 0.8,
                        ),
                      )
                    ),
                    onChanged: (val){
                      if(double.tryParse(val) <= maxValue && double.tryParse(val) >= minValue) {
                        if(flag == 1){
                          servicesProvider.currentLoanValue = double.tryParse(val);
                        } else if(flag == 2){
                          servicesProvider.currentNumberOfInstallments = double.tryParse(val);
                        } else if(flag == 3){
                          servicesProvider.currentFinancialCommitment = double.tryParse(val);
                        }
                      } else if(double.tryParse(val) > maxValue){
                        if(flag == 1){
                          servicesProvider.currentLoanValue = maxValue;
                        } else if(flag == 2){
                          servicesProvider.currentNumberOfInstallments = maxValue;
                        } else if(flag == 3){
                          servicesProvider.currentFinancialCommitment = maxValue;
                        }
                      } else{
                        if(flag == 1){
                          servicesProvider.currentLoanValue = minValue;
                        } else if(flag == 2){
                          servicesProvider.currentNumberOfInstallments = minValue;
                        } else if(flag == 3){
                          servicesProvider.currentFinancialCommitment = minValue;
                        }
                      }
                    },
                    onEditingComplete: (){
                      servicesProvider.notifyMe();
                    },
                  ),
                ),
                const SizedBox(width: 10.0,),
                Text(getTranslated(flag == 2 ? 'month' : 'jd', context))
              ],
            ),
            SizedBox(height: withSlider ? 10.0 : 0.0,),
            if(withSlider)
            Column(
              children: [
                Slider(
                  activeColor: HexColor('#2D452E'),
                  inactiveColor: HexColor('#E0E0E0'),
                  value: flag == 1 ? servicesProvider.currentLoanValue : servicesProvider.currentNumberOfInstallments,
                  min: minValue,
                  max: maxValue,
                  divisions: minValue != maxValue ? (maxValue - minValue).floor() : 1,
                  label: '${(flag == 1 ? servicesProvider.currentLoanValue : servicesProvider.currentNumberOfInstallments).round()} ${getTranslated(flag == 2 ? 'month' : 'jd', context)}',
                  onChanged: (double value) {
                    servicesProvider.notifyMe();
                    setState(() {
                      if(flag == 1){
                        servicesProvider.currentLoanValue = value;
                      } else if(flag == 2){
                        servicesProvider.currentNumberOfInstallments = value;
                      }
                    });
                  },
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${minValue.toStringAsFixed(flag == 2 ? 0 : 1)} ${getTranslated(flag == 2 ? 'month' : 'jd', context)}',
                        style: const TextStyle(
                          fontSize: 13,
                        ),
                      ),
                      Text(
                        '${maxValue.toStringAsFixed(flag == 2 ? 0 : 1)} ${getTranslated(flag == 2 ? 'month' : 'jd', context)}',
                        style: const TextStyle(
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  showCalculationResultBottomSheet(loanPaidAmount, monthlyInstallment, startDate){
    return showModalBottomSheet(
        isScrollControlled: false,
        isDismissible: true,
        enableDrag: true,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(25.0))
        ),
        context: context,
        barrierColor: Colors.black26,
        builder: (context) {
          return GestureDetector(
            onTap: (){
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: BackdropFilter(
              filter: ui.ImageFilter.blur(
                sigmaX: 2.0,
                sigmaY: 2.0,
              ),
              child: Material(
                elevation: 100,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(25.0),
                  topRight: Radius.circular(25.0),
                ),
                color: Colors.white,
                shadowColor: Colors.black,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0).copyWith(top: 15.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(),
                          Container(
                            width: 45,
                            height: 6,
                            decoration: BoxDecoration(
                                color: HexColor('#000000'),
                                borderRadius: const BorderRadius.all(Radius.circular(25.0))),
                          ),
                          InkWell(
                            onTap: (){
                              Navigator.of(context).pop();
                            },
                            child: SvgPicture.asset('assets/icons/close.svg'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15.0,),
                      buildFieldTitle(context, 'theValueOfTheAdvanceAfterDeductingRiskInsurance', required: false),
                      const SizedBox(height: 15.0,),
                      Text(
                        loanPaidAmount.toStringAsFixed(3),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 30.0,),
                      buildFieldTitle(context, 'monthlyInstallment', required: false),
                      const SizedBox(height: 15.0,),
                      Row(
                        children: [
                          Text(
                            monthlyInstallment.toStringAsFixed(3),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            getTranslated('jd', context),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      // const SizedBox(height: 30.0,),
                      // buildFieldTitle(context, 'interestRate', required: false),
                      // const SizedBox(height: 15.0,),
                      // Row(
                      //   children: [
                      //     const Text(
                      //       '- ',
                      //       style: TextStyle(
                      //         fontWeight: FontWeight.bold,
                      //       ),
                      //     ),
                      //     Text(
                      //       getTranslated('approximately', context),
                      //       style: const TextStyle(
                      //         fontWeight: FontWeight.bold,
                      //       ),
                      //     ),
                      //     const Text(
                      //       ' -',
                      //       style: TextStyle(
                      //         fontWeight: FontWeight.bold,
                      //       ),
                      //     ),
                      //   ],
                      // ),
                      const SizedBox(height: 30.0,),
                      buildFieldTitle(context, 'theStartDateOfTheDeductionForPayment', required: false),
                      const SizedBox(height: 15.0,),
                      Text(
                       '$startDate',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Expanded(child: Container()),
                      Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.only(bottom: 30.0),
                        child: textButton(context, themeNotifier, 'submitApplication', primaryColor, Colors.white, (){
                          Navigator.of(context).pop();
                          servicesProvider.stepNumber = 4;
                          servicesProvider.notifyMe();
                        }),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }
    );
  }


}

enum ContextMenu { edit, delete }

