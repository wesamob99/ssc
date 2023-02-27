// ignore_for_file: file_names

import 'dart:convert';

import 'package:drop_down_list/drop_down_list.dart';
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
import '../../shared/verifyMobileNumberScreen.dart';

class EarlyRetirementRequestScreen extends StatefulWidget {
  const EarlyRetirementRequestScreen({Key key}) : super(key: key);

  @override
  State<EarlyRetirementRequestScreen> createState() => _EarlyRetirementRequestScreenState();
}

class _EarlyRetirementRequestScreenState extends State<EarlyRetirementRequestScreen> {

  ServicesProvider servicesProvider;
  ThemeNotifier themeNotifier;
  SelectedListItem selectedMobileCountry = SelectedListItem(
    name: UserConfig.instance.checkLanguage() ? "Jordan" : "الأردن",
    value: "962", natCode: 111,
    flag: countries[110].flag,
  );

  SelectedListItem selectedPaymentCountry = SelectedListItem(
    name: UserConfig.instance.checkLanguage() ? "Iraq" : "عراق",
    value: "964", natCode: 112,
    flag: countries.where((element) => element.dialCode == "964").first.flag,
  );
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

  Map selectedActivePayment;
  List activePayment = [];
  DateTime selectedDateOfBirth = DateTime.now();
  TextEditingController nationalIdController = TextEditingController();
  TextEditingController quatrainNounController = TextEditingController();

  TextEditingController bankNameController = TextEditingController();
  TextEditingController bankBranchController = TextEditingController();
  TextEditingController bankAddressController = TextEditingController();
  TextEditingController accountNoController = TextEditingController();
  TextEditingController swiftCodeController = TextEditingController();
  TextEditingController mobileNumberController = TextEditingController();


  checkContinueEnabled({flag = 0}){
    if(flag == 1){
      return ((servicesProvider.isMobileNumberUpdated == true && mobileNumberValidate(servicesProvider.mobileNumberController.text)) || servicesProvider.isMobileNumberUpdated == false);
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
      if(selectedActivePayment['ID'] == 5){
        return bankNameController.text.isNotEmpty &&
            bankBranchController.text.isNotEmpty &&
            bankAddressController.text.isNotEmpty &&
            accountNoController.text.isNotEmpty &&
            swiftCodeController.text.isNotEmpty &&
            mobileNumberController.text.isNotEmpty;
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
    servicesProvider.getActivePayment(servicesProvider.result['P_Result'][0][0]['SERVICE_TYPE'].toString(), servicesProvider.result['P_Result'][0][0]['NAT'] == "111" ? '1' : '2').whenComplete(() {}).then((value) {
      value['R_RESULT'][0].forEach((element){
        activePayment.add(element);
      });
      selectedActivePayment = activePayment[0];
    });
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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: (servicesProvider.documentsScreensStepNumber == 1 || servicesProvider.documentsScreensStepNumber == 3) && servicesProvider.stepNumber == 4
      ? HexColor('#445740') : HexColor('#ffffff'),
      appBar: AppBar(
        centerTitle: false,
        title: Text(translate('earlyRetirementRequest', context)),
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
                    const DocumentsScreen(nextStep: 'receiptOfAllowances', numberOfSteps: 6),
                    if(Provider.of<ServicesProvider>(context).stepNumber == 5)
                      fifthStep(context, themeNotifier),
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
                                      servicesProvider.stepNumber = 2;
                                      servicesProvider.isMobileNumberUpdated = false;
                                      UserSecuredStorage.instance.realMobileNumber = servicesProvider.mobileNumberController.text;
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
                              if(dependentIndex < ((servicesProvider.result['P_Dep'].length != 0  && servicesProvider.result['P_Dep'][0].length != 0) ? servicesProvider.result['P_Dep'][0].length - 1 : 0)){
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
                            try{
                              String message = '';
                              servicesProvider.isLoading = true;
                              servicesProvider.isModalLoading = false;
                              servicesProvider.notifyMe();
                              List mandatoryDocs = await saveFiles('mandatory');
                              List optionalDocs = await saveFiles('optional');
                              docs.addAll(mandatoryDocs + optionalDocs);
                              Map<String, dynamic> paymentInfo = {
                                'PAYMENT_METHOD': selectedActivePayment['ID'],
                                'BANK_LOCATION': selectedActivePayment['ID'] == 5 ? bankAddressController.text : 0,
                                'BRANCH_ID': selectedActivePayment['ID'] == 5 ? '' : '',
                                'BRANCH_NAME': selectedActivePayment['ID'] == 5 ? bankBranchController.text : '',
                                'BANK_ID': selectedActivePayment['ID'] == 5 ? '' : '',
                                'BANK_NAME': selectedActivePayment['ID'] == 5 ? bankNameController.text : '',
                                'ACCOUNT_NAME': selectedActivePayment['ID'] == 5 ? accountNoController.text : '',
                                'PAYMENT_COUNTRY': selectedActivePayment['ID'] == 5 ? selectedPaymentCountry.name : '',
                                'PAYMENT_COUNTRY_CODE': selectedActivePayment['ID'] == 5 ? selectedPaymentCountry.value : '',
                                'PAYMENT_PHONE': selectedActivePayment['ID'] == 5 ? mobileNumberController.text : '',
                                'SWIFT_CODE': selectedActivePayment['ID'] == 5 ? swiftCodeController.text : '',
                                'BANK_DETAILS': selectedActivePayment['ID'] == 5 ? '' : '',
                                'IBAN': selectedActivePayment['ID'] == 3 ? servicesProvider.result['P_Result'][0][0]['IBAN'] : '',
                                'CASH_BANK_ID': selectedActivePayment['ID'] == 5 ? '' : '',
                                // معلومات الوكيل (REP)
                                'REP_NATIONALITY': selectedActivePayment['ID'] == 5 ? '' : '',
                                'REP_NATIONAL_NO': selectedActivePayment['ID'] == 5 ? '' : '',
                                'REP_NAME': selectedActivePayment['ID'] == 5 ? '' : '',
                                // معلومات المحفظه (WALLET)
                                'WALLET_TYPE': selectedActivePayment['ID'] == 5 ? '' : '',
                                'WALLET_OTP_VERIVIED': selectedActivePayment['ID'] == 5 ? '' : null,
                                'WALLET_OTP': selectedActivePayment['ID'] == 5 ? '' : null,
                                'WALLET_PHONE': selectedActivePayment['ID'] == 5 ? '' : '',
                                'WALLET_PHONE_VERIVIED': selectedActivePayment['ID'] == 5 ? '' : '',
                                'WALLET_PASSPORT_NUMBER': selectedActivePayment['ID'] == 5 ? '' : '',
                                'PEN_IBAN': selectedActivePayment['ID'] == 5 ? '' : null,
                              };
                              int wantInsurance = areYouPartnerInLimitedLiabilityCompany == 'yes' ? 1 : 0;
                              int authorizedToSign = areYouAuthorizedToSignForCompany == 'yes' ? 1 : 0;
                              await servicesProvider.setEarlyRetirementApplication(docs, paymentInfo, authorizedToSign, wantInsurance).whenComplete(() {}).then((value) {
                                if(value != null && value['P_Message'] != null && value['P_Message'][0][0]['PO_STATUS'] == 0){
                                  message = translate('youCanCheckAndFollowItsStatusFromMyOrdersScreen', context);
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
                "APP_ID": servicesProvider.result['P_Result'][0][0]['ID'],
                "ID": "",
                "STATUS": 1,
                "HIDE_ACTIONS": false
              };
              bool isDependentDoc = false;
              if(type == 'mandatory' && servicesProvider.result["P_Dep"].isNotEmpty){
                servicesProvider.result['P_Dep'][0].forEach((element) {
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
                  translate('secondStep', context),
                  style: TextStyle(
                      color: HexColor('#979797'),
                      fontSize: width(0.03, context)
                  ),
                ),
                SizedBox(height: height(0.006, context),),
                Text(
                  translate('ensureFinancialSolvency', context),
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
                      '${translate('next', context)}: ${translate('confirmationOfDependentInformation', context)}',
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
                    translate('thirdStep', context),
                    style: TextStyle(
                        color: HexColor('#979797'),
                        fontSize: width(0.03, context)
                    ),
                  ),
                  SizedBox(height: height(0.006, context),),
                  Text(
                    translate('confirmationOfDependentInformation', context),
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
                        '${translate('next', context)}: ${translate('documents', context)}',
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
                translate('numberOfDependents', context) + ' ( ${(servicesProvider.result['P_Dep'].length != 0  && servicesProvider.result['P_Dep'][0].length != 0) ? dependentIndex + 1 : 0} / ${(servicesProvider.result['P_Dep'].length != 0  && servicesProvider.result['P_Dep'][0].length != 0) ? servicesProvider.result['P_Dep'][0].length : 0} )',
                style: TextStyle(
                  color: HexColor('#363636'),
                  fontWeight: FontWeight.w500,
                  fontSize: 17,
                ),
              ),
              SizedBox(height: height(0.02, context),),
              if(servicesProvider.result['P_Dep'].length != 0 && servicesProvider.result['P_Dep'][0].length != 0)
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              servicesProvider.result['P_Dep'][0][dependentIndex]['NAME'],
                              style: TextStyle(
                                height: 1.4,
                                color: themeNotifier.isLight() ? HexColor('#363636') : Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: isScreenHasSmallWidth(context) ? 13 : 15,
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
                                  decoration: BoxDecoration(
                                    color: servicesProvider.result['P_Dep'][0][dependentIndex]['RELATION'] == 11
                                        ? HexColor('#9EBDF8') : const Color.fromRGBO(0, 121, 5, 0.38),
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  child: Text(
                                    getRelationType(servicesProvider.result['P_Dep'][0][dependentIndex]['RELATION']),
                                    style: TextStyle(
                                      color: servicesProvider.result['P_Dep'][0][dependentIndex]['RELATION'] == 11
                                          ? HexColor('#003C97') : HexColor('#2D452E'),
                                      fontWeight: FontWeight.w400,
                                      fontSize: isScreenHasSmallWidth(context) ? 13 : 15,
                                    ),
                                  ),
                                ),
                                PopupMenuButton<ContextMenu>(
                                  onSelected: (ContextMenu result) async {
                                    switch (result.index) {
                                      case 0: {
                                        selectedStatus = servicesProvider.result['P_Dep'][0][dependentIndex]['IS_ALIVE'] == 1
                                            ? 'alive' : 'dead';
                                        selectedJobStatus = servicesProvider.result['P_Dep'][0][dependentIndex]['WORK_STATUS'] == 0
                                            ? 'unemployed' : 'employed';
                                        selectedGetsSalary = servicesProvider.result['P_Dep'][0][dependentIndex]['IS_RETIRED_A'] == 0
                                            ? 'no' : 'yes';
                                        selectedHasDisability = servicesProvider.result['P_Dep'][0][dependentIndex]['DISABILITY'] == 0
                                            ? 'no' : 'yes';
                                        selectedMaritalStatus = servicesProvider.result['P_Dep'][0][dependentIndex]['MARITAL_STATUS'] == 1
                                            ? UserConfig.instance.checkLanguage()
                                            ? 'single' : servicesProvider.result['P_Dep'][0][dependentIndex]['GENDER'] == 1 ? 'singleM' : 'singleF'
                                            : servicesProvider.result['P_Dep'][0][dependentIndex]['MARITAL_STATUS'] == 2
                                            ? UserConfig.instance.checkLanguage()
                                            ? 'married' : servicesProvider.result['P_Dep'][0][dependentIndex]['GENDER'] == 1 ? 'marriedM' : 'marriedF'
                                            : servicesProvider.result['P_Dep'][0][dependentIndex]['MARITAL_STATUS'] == 3
                                            ? UserConfig.instance.checkLanguage()
                                            ? 'divorced' : servicesProvider.result['P_Dep'][0][dependentIndex]['GENDER'] == 1 ? 'divorcedM' : 'divorcedF'
                                            : servicesProvider.result['P_Dep'][0][dependentIndex]['MARITAL_STATUS'] == 4
                                            ? UserConfig.instance.checkLanguage()
                                            ? 'widow' : servicesProvider.result['P_Dep'][0][dependentIndex]['GENDER'] == 1 ? 'widowM' : 'widowF' : 'single';
                                        maritalList = [
                                          UserConfig.instance.checkLanguage()
                                              ? 'single'
                                              : servicesProvider.result['P_Dep'][0][dependentIndex]['GENDER'] == 1 ? 'singleM' : 'singleF',
                                          UserConfig.instance.checkLanguage()
                                              ? 'married'
                                              : servicesProvider.result['P_Dep'][0][dependentIndex]['GENDER'] == 1 ? 'marriedM' : 'marriedF',
                                          UserConfig.instance.checkLanguage()
                                              ? 'divorced'
                                              : servicesProvider.result['P_Dep'][0][dependentIndex]['GENDER'] == 1 ? 'divorcedM' : 'divorcedF',
                                          UserConfig.instance.checkLanguage()
                                              ? 'widow'
                                              : servicesProvider.result['P_Dep'][0][dependentIndex]['GENDER'] == 1 ? 'widowM' : 'widowF',
                                        ];
                                        dependentModalBottomSheet(dependentIndex);
                                      } break;
                                      case 1: {
                                        showMyDialog(
                                            context, 'wouldYouLikeToConfirmDeletionOfDependents',
                                            servicesProvider.result['P_Dep'][0][dependentIndex]['NAME'],
                                            'yesContinue', themeNotifier, icon: 'assets/icons/dialogDeleteIcon.svg',
                                            onPressed: () async{
                                              String errorMessage = '';
                                              servicesProvider.isLoading = true;
                                              servicesProvider.notifyMe();
                                              try{
                                                await servicesProvider.deleteDependent(int.tryParse(servicesProvider.result['P_Dep'][0][dependentIndex]["ID"].toString())).then((value){
                                                  Navigator.of(context).pop();
                                                  if(value['PO_RESULT'] == 1){
                                                    servicesProvider.dependentsDocuments.removeWhere((element) => element["CODE"] == servicesProvider.result['P_Dep'][0][dependentIndex]["DEP_CODE"]);
                                                    servicesProvider.result['P_Dep'][0].removeAt(dependentIndex);
                                                    if(dependentIndex == servicesProvider.result['P_Dep'][0].length && dependentIndex != 0){
                                                      setState(() {
                                                        dependentIndex--;
                                                      });
                                                    }
                                                    showMyDialog(context, 'dependentWereDeleted', '', 'ok', themeNotifier, titleColor: '#2D452E');
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
                                    size: 22,
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
                                      enabled: servicesProvider.result['P_Dep'][0][dependentIndex]['SOURCE_FLAG'] == 2,
                                      child: contextMenuItem(
                                          "delete",
                                          'assets/icons/delete.svg',
                                          '#ED3124'
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            )
                          ],
                        ),
                        const SizedBox(height: 15.0,),
                        Row(
                          children: [
                            Text(
                              servicesProvider.result['P_Dep'][0][dependentIndex]['NATIONAL_NO'],
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
                              translate(
                                  servicesProvider.result['P_Dep'][0][dependentIndex]['NATIONALITY'] == 1
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
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  translate('maritalStatus', context),
                                  style: TextStyle(
                                    color: themeNotifier.isLight() ? HexColor('#979797') : Colors.white70,
                                    fontSize: isScreenHasSmallWidth(context) ? 12 : 14,
                                  ),
                                ),
                                const SizedBox(height: 10.0,),
                                Text(
                                  translate(
                                      servicesProvider.result['P_Dep'][0][dependentIndex]['MARITAL_STATUS'] == 1
                                          ? UserConfig.instance.checkLanguage()
                                          ? 'single' : servicesProvider.result['P_Dep'][0][dependentIndex]['GENDER'] == 1 ? 'singleM' : 'singleF'
                                          : servicesProvider.result['P_Dep'][0][dependentIndex]['MARITAL_STATUS'] == 2
                                          ? UserConfig.instance.checkLanguage()
                                          ? 'married' : servicesProvider.result['P_Dep'][0][dependentIndex]['GENDER'] == 1 ? 'marriedM' : 'marriedF'
                                          : servicesProvider.result['P_Dep'][0][dependentIndex]['MARITAL_STATUS'] == 3
                                          ? UserConfig.instance.checkLanguage()
                                          ? 'divorced' : servicesProvider.result['P_Dep'][0][dependentIndex]['GENDER'] == 1 ? 'divorcedM' : 'divorcedF'
                                          : servicesProvider.result['P_Dep'][0][dependentIndex]['MARITAL_STATUS'] == 4
                                          ? UserConfig.instance.checkLanguage()
                                          ? 'widow' : servicesProvider.result['P_Dep'][0][dependentIndex]['GENDER'] == 1 ? 'widowM' : 'widowF' : 'single',
                                      context),
                                  style: TextStyle(
                                    color: themeNotifier.isLight() ? HexColor('#363636') : Colors.white70,
                                    fontSize: isScreenHasSmallWidth(context) ? 12 : 14,
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  translate('employmentStatus', context),
                                  style: TextStyle(
                                    color: themeNotifier.isLight() ? HexColor('#979797') : Colors.white70,
                                    fontSize: isScreenHasSmallWidth(context) ? 12 : 14,
                                  ),
                                ),
                                const SizedBox(height: 10.0,),
                                Text(
                                  translate(
                                      servicesProvider.result['P_Dep'][0][dependentIndex]['WORK_STATUS'] == 0
                                          ? 'unemployed' : 'employed',
                                      context),
                                  style: TextStyle(
                                    color: themeNotifier.isLight() ? HexColor('#363636') : Colors.white70,
                                    fontSize: isScreenHasSmallWidth(context) ? 12 : 14,
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  translate('status', context),
                                  style: TextStyle(
                                    color: themeNotifier.isLight() ? HexColor('#979797') : Colors.white70,
                                    fontSize: isScreenHasSmallWidth(context) ? 12 : 14,
                                  ),
                                ),
                                const SizedBox(height: 10.0,),
                                Text(
                                  translate(
                                      servicesProvider.result['P_Dep'][0][dependentIndex]['IS_ALIVE'] == 1
                                          ? 'alive' : 'dead',
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
                        const SizedBox(height: 40.0,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  translate('hasDisability', context),
                                  style: TextStyle(
                                    color: themeNotifier.isLight() ? HexColor('#979797') : Colors.white70,
                                    fontSize: isScreenHasSmallWidth(context) ? 12 : 14,
                                  ),
                                ),
                                const SizedBox(height: 10.0,),
                                Text(
                                  translate(
                                      servicesProvider.result['P_Dep'][0][dependentIndex]['DISABILITY'] == 0
                                          ? 'no' : 'yes',
                                      context),
                                  style: TextStyle(
                                    color: themeNotifier.isLight() ? HexColor('#363636') : Colors.white70,
                                    fontSize: isScreenHasSmallWidth(context) ? 12 : 14,
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  translate('getsSalary', context),
                                  style: TextStyle(
                                    color: themeNotifier.isLight() ? HexColor('#979797') : Colors.white70,
                                    fontSize: isScreenHasSmallWidth(context) ? 12 : 14,
                                  ),
                                ),
                                const SizedBox(height: 10.0,),
                                Text(
                                  translate(
                                      servicesProvider.result['P_Dep'][0][dependentIndex]['IS_RETIRED_A'] == 0
                                          ? 'no' : 'yes',
                                      context),
                                  style: TextStyle(
                                    color: themeNotifier.isLight() ? HexColor('#363636') : Colors.white70,
                                    fontSize: isScreenHasSmallWidth(context) ? 12 : 14,
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  translate('getsSalary', context),
                                  style: const TextStyle(
                                    color: Colors.transparent,
                                  ),
                                ),
                                const SizedBox(height: 10.0,),
                                const Text(
                                  'على قيد الحياة',
                                  style: TextStyle(
                                    color: Colors.white,
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
          if(dependentIndex == ((servicesProvider.result['P_Dep'].length != 0  && servicesProvider.result['P_Dep'][0].length != 0) ? servicesProvider.result['P_Dep'][0].length - 1 : 0))
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
                  selectedMaritalStatus = UserConfig.instance.checkLanguage()
                  ? 'single' : 'singleM';
                  maritalList = [
                    UserConfig.instance.checkLanguage()
                    ? 'single' : 'singleM',
                    UserConfig.instance.checkLanguage()
                    ? 'married' : 'marriedM',
                    UserConfig.instance.checkLanguage()
                    ? 'divorced' : 'divorcedM',
                    UserConfig.instance.checkLanguage()
                    ? 'widow' : 'widowM',
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

  Widget fifthStep(context, themeNotifier){
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
                  translate('fifthStep', context),
                  style: TextStyle(
                      color: HexColor('#979797'),
                      fontSize: width(0.03, context)
                  ),
                ),
                SizedBox(height: height(0.006, context),),
                Text(
                  translate('receiptOfAllowances', context),
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
                      '5/6',
                      style: TextStyle(
                          color: HexColor('#979797'),
                          fontSize: width(0.025, context)
                      ),
                    ),
                    Text(
                      '${translate('next', context)}: ${translate('confirmRequest', context)}',
                      style: TextStyle(
                          color: HexColor('#979797'),
                          fontSize: width(0.032, context)
                      ),
                    ),
                  ],
                ),
              ],
            ),
            //activePayment
            SizedBox(height: height(0.02, context),),
            buildFieldTitle(context, 'methodOfReceivingSalary', required: false),
            const SizedBox(height: 10.0,),
            // customTwoRadioButtons(5, 'insideJordan', 'outsideJordan', setState),
            SizedBox(
              height: activePayment.length * 50.0,
              child: customRadioButtonGroup(3, activePayment, setState),
            ),
            if(selectedActivePayment['ID'] == 3) // inside jordan
            Text(
              servicesProvider.result["p_per_info"][0][0]["IBAN"].length == 30
              ? '${translate('iban', context)}: ${servicesProvider.result["p_per_info"][0][0]["IBAN"]}'
              : translate('goToYourBanksApplicationAndSendYourIBANToTheEscrow', context),
            ),
            if(selectedActivePayment['ID'] == 5) // outside jordan
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildFieldTitle(context, 'country', required: false),
                const SizedBox(height: 10.0,),
                // buildTextFormField(context, themeNotifier, countryController, '', (val){
                //   servicesProvider.notifyMe();
                // }),
                buildCountriesDropDown(selectedPaymentCountry, 1),
                const SizedBox(height: 16,),
                buildFieldTitle(context, 'bankName', required: false),
                const SizedBox(height: 10.0,),
                buildTextFormField(context, themeNotifier, bankNameController, '', (val){
                  servicesProvider.notifyMe();
                }),
                const SizedBox(height: 16,),
                buildFieldTitle(context, 'bankBranch', required: false),
                const SizedBox(height: 10.0,),
                buildTextFormField(context, themeNotifier, bankBranchController, '', (val){
                  servicesProvider.notifyMe();
                }),
                const SizedBox(height: 16,),
                buildFieldTitle(context, 'bankAddress', required: false),
                const SizedBox(height: 10.0,),
                buildTextFormField(context, themeNotifier, bankAddressController, '', (val){
                  servicesProvider.notifyMe();
                }),
                const SizedBox(height: 16,),
                buildFieldTitle(context, 'accountNumber', required: false),
                const SizedBox(height: 10.0,),
                buildTextFormField(context, themeNotifier, accountNoController, '', (val){
                  servicesProvider.notifyMe();
                }, inputType: TextInputType.number),
                const SizedBox(height: 16,),
                buildFieldTitle(context, 'swiftCode', required: false),
                const SizedBox(height: 10.0,),
                buildTextFormField(context, themeNotifier, swiftCodeController, '', (val){
                  servicesProvider.notifyMe();
                }, inputType: TextInputType.text),
                const SizedBox(height: 16,),
                buildFieldTitle(context, 'mobileNumber', required: false),
                const SizedBox(height: 10.0,),
                Row(
                  children: [
                    Expanded(
                      flex: 4,
                      child: buildTextFormField(context, themeNotifier, mobileNumberController, '', (val){
                        servicesProvider.notifyMe();
                      }, inputType: TextInputType.number),
                    ),
                    const SizedBox(width: 10.0,),
                    Expanded(
                      flex: 2,
                      child: buildCountriesDropDown(selectedMobileCountry, 2),
                    ),
                  ],
                ),
                const SizedBox(height: 20,),
              ],
            ),
          ],
        ),
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
                translate('fifthStep', context),
                style: TextStyle(
                    color: HexColor('#979797'),
                    fontSize: width(0.03, context)
                ),
              ),
              SizedBox(height: height(0.006, context),),
              Text(
                translate('confirmRequest', context),
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
                    translate('finished', context),
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
            translate('reviewYourDetailedStatement', context),
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
                    await downloadPDF(val2, translate('detailedDisclosure', context)).whenComplete(() {
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
                translate('detailedDisclosure', context),
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
                  translate('earlyRetirementTermsAndConditions', context),
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
                  translate('yes', context),
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
                  translate('no', context),
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
                  translate(firstChoice, context),
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
                  translate(secondChoice, context),
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
    return Expanded(
      child: ListView.builder(
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
                      selectedActivePayment = choices[index];
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
                            ? choices[index]['REL_DESC_EN'] : choices[index]['REL_DESC_AR']))  || (flag == 3 && selectedActivePayment == choices[index])
                            ? HexColor('#2D452E') : Colors.transparent,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        flag == 1
                        ? translate(choices[index], context)
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
              const SizedBox(height: 10.0,)
            ],
          );
        }
      ),
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
          maxHeight: height(0.9, context)
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
                        Column(
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
                                buildFieldTitle(context, 'nationality', required: false),
                                const SizedBox(height: 10.0,),
                                customTwoRadioButtons(6, 'jordanian', 'nonJordanian', setState, disabled: servicesProvider.isNationalIdValid),
                                const SizedBox(height: 20.0,),
                                buildFieldTitle(context, nationality == 'jordanian' ? 'nationalId' : 'personalId', required: false),
                                const SizedBox(height: 10.0,),
                                buildTextFormField(
                                    context, themeNotifier, nationalIdController, servicesProvider.isNationalIdValid ? 'val${nationalIdController.text}' : '9999999999', (val) async {
                                      if((val.length == 10 && nationality == 'jordanian')){
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
                                      }
                                      setState((){
                                        checkNonJordanianInfo();
                                      });
                                    },
                                    inputType: TextInputType.number, enabled: !Provider.of<ServicesProvider>(context).isNationalIdValid
                                ),
                                const SizedBox(height: 15.0,),
                              ],
                            ),
                            if((nationality == 'jordanian' && servicesProvider.isNationalIdValid) || nationality == 'nonJordanian')
                            Expanded(
                              child: ListView(
                                shrinkWrap: true,
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
                                                Text(
                                                  !isEdit
                                                      ? servicesProvider.result['P_Dep'][0][index]['NAME']
                                                      : '${servicesProvider.dependentInfo['cur_getdata'][0][0]['FULL_NAME']}',
                                                  style: TextStyle(
                                                    height: 1.4,
                                                    color: themeNotifier.isLight() ? HexColor('#363636') : Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                Container(
                                                  padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
                                                  decoration: BoxDecoration(
                                                    color: !isEdit
                                                        ? servicesProvider.result['P_Dep'][0][index]['RELATION'] == 11
                                                        ? HexColor('#9EBDF8') : const Color.fromRGBO(0, 121, 5, 0.38)
                                                        : servicesProvider.dependentInfo['cur_getdata'][0][0]['RELATIVETYPE'] == 11
                                                        ? HexColor('#9EBDF8') : const Color.fromRGBO(0, 121, 5, 0.38),
                                                    borderRadius: BorderRadius.circular(8.0),
                                                  ),
                                                  child: Text(
                                                    !isEdit
                                                        ? getRelationType(servicesProvider.result['P_Dep'][0][index]['RELATION'])
                                                        : getRelationType(servicesProvider.dependentInfo['cur_getdata'][0][0]['RELATIVETYPE']),
                                                    style: TextStyle(
                                                      color: !isEdit
                                                          ? servicesProvider.result['P_Dep'][0][index]['RELATION'] == 11
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
                                                      ? servicesProvider.result['P_Dep'][0][index]['NATIONAL_NO']
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
                                                  translate(
                                                      !isEdit
                                                          ? servicesProvider.result['P_Dep'][0][index]['NATIONALITY'] == 1
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
                                  if(!isEdit)
                                  buildFieldTitle(context, 'status', required: false),
                                  if(!isEdit)
                                  const SizedBox(height: 10.0,),
                                  if(!isEdit)
                                  customTwoRadioButtons(1, 'alive', 'dead', setState),
                                  if(!isEdit)
                                  const SizedBox(height: 20.0,),
                                  buildFieldTitle(context, 'employmentStatus', required: false),
                                  const SizedBox(height: 10.0,),
                                  customTwoRadioButtons(2, 'unemployed', 'employed', setState),
                                  const SizedBox(height: 20.0,),
                                  buildFieldTitle(context, 'getsSalary', required: false),
                                  const SizedBox(height: 10.0,),
                                  customTwoRadioButtons(3, 'yes', 'no', setState),
                                  const SizedBox(height: 20.0,),
                                  buildFieldTitle(context, 'hasDisability', required: false),
                                  const SizedBox(height: 10.0,),
                                  customTwoRadioButtons(4, 'yes', 'no', setState),
                                  if(!isEdit)
                                  const SizedBox(height: 20.0,),
                                  if(!isEdit)
                                  buildFieldTitle(context, 'maritalStatus', required: false),
                                  if(!isEdit)
                                  const SizedBox(height: 10.0,),
                                  if(!isEdit)
                                  customRadioButtonGroup(1, maritalList, setState),
                                  if(nationality == 'nonJordanian')
                                  const SizedBox(height: 20.0,),
                                  if(nationality == 'nonJordanian')
                                  buildFieldTitle(context, 'relativeRelation', required: false),
                                  if(nationality == 'nonJordanian')
                                  const SizedBox(height: 10.0,),
                                  if(nationality == 'nonJordanian')
                                  customRadioButtonGroup(2, UserConfig.instance.checkLanguage() ? servicesProvider.result['P_RELATION'][0]: servicesProvider.result['P_RELATION'][0], setState),
                                  SizedBox(height: height(isScreenHasSmallHeight(context) ? 0.2 : 0.11, context),),
                                ],
                              ),
                            ),
                          ],
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
                                    dynamic maritalStatus = selectedMaritalStatus == (UserConfig.instance.checkLanguage()
                                        ? 'single' : servicesProvider.result['P_Dep'][0][index]["GENDER"] == 1 ? 'singleM' : 'singleF') ? 1
                                        : selectedMaritalStatus == (UserConfig.instance.checkLanguage()
                                        ? 'married' : servicesProvider.result['P_Dep'][0][index]["GENDER"] == 1 ? 'marriedM' : 'marriedF') ? 2
                                        : selectedMaritalStatus == (UserConfig.instance.checkLanguage()
                                        ? 'divorced' : servicesProvider.result['P_Dep'][0][index]["GENDER"] == 1 ? 'divorcedM' : 'divorcedF') ? 3
                                        : selectedMaritalStatus == (UserConfig.instance.checkLanguage()
                                        ? 'widow' : servicesProvider.result['P_Dep'][0][index]["GENDER"] == 1 ? 'widowM' : 'widowF') ? 4 : 1;
                                    try{
                                      /// TODO: complete checkDocumentDependent!
                                      await servicesProvider.checkDocumentDependent((selectedGender == "male") ? "1" : "2").then((value) async {
                                        if(value['P_RESULT'].isEmpty){
                                          var dependent = {
                                            "NAME": servicesProvider.result['P_Dep'][0][index]["NAME"],
                                            "RELATION": servicesProvider.result['P_Dep'][0][index]["RELATION"],
                                            "IS_ALIVE": selectedStatus == 'alive' ? 1 : 0,
                                            "WORK_STATUS": selectedJobStatus == 'unemployed' ? 0 : 1,
                                            "IS_RETIRED": servicesProvider.result['P_Dep'][0][index]["IS_RETIRED"],
                                            "DISABILITY": selectedHasDisability == 'no' ? 0 : 1,
                                            "MARITAL_STATUS": maritalStatus,
                                            "GENDER": servicesProvider.result['P_Dep'][0][index]["GENDER"],
                                            "ID": servicesProvider.result['P_Dep'][0][index]["ID"],
                                            "SOURCE_FLAG": servicesProvider.result['P_Dep'][0][index]["SOURCE_FLAG"],
                                            "NATIONAL_NO": servicesProvider.result['P_Dep'][0][index]["NATIONAL_NO"],
                                            "NATIONALITY": servicesProvider.result['P_Dep'][0][index]["NATIONALITY"],
                                            "BIRTHDATE": servicesProvider.result['P_Dep'][0][index]["BIRTHDATE"],
                                            "AGE": servicesProvider.result['P_Dep'][0][index]["AGE"],
                                            "MARITAL_STATUS_A": servicesProvider.result['P_Dep'][0][index]["MARITAL_STATUS_A"],
                                            "WORK_STATUS_A": servicesProvider.result['P_Dep'][0][index]["WORK_STATUS_A"],
                                            "IS_ALIVE_A": servicesProvider.result['P_Dep'][0][index]["IS_ALIVE_A"],
                                            "IS_RETIRED_A": selectedGetsSalary == 'yes' ? 1 : 0,
                                            "LAST_EVENT_DATE": servicesProvider.result['P_Dep'][0][index]["LAST_EVENT_DATE"],
                                            "WANT_HEALTH_INSURANCE": "",
                                            "PreLoad": 0,
                                            "Added": 1,
                                            "doc_dep": [],
                                            "DEP_CODE": servicesProvider.result['P_Dep'][0][index]["DEP_CODE"],
                                            "IS_STOP": ""
                                          };
                                          servicesProvider.result['P_Dep'][0][index] = dependent;
                                          await servicesProvider.getRequiredDocuments(
                                              jsonEncode({
                                                "row": {
                                                  "NAT": "111",
                                                  "GENDER": "1"
                                                },
                                                "dep": {
                                                  "dep": dependent
                                                }
                                              }), 8
                                          ).whenComplete((){}).then((value) {
                                            servicesProvider.dependentsDocuments.removeWhere((element) => element["CODE"] == servicesProvider.result['P_Dep'][0][dependentIndex]["DEP_CODE"]);
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
                                      dynamic maritalStatus = selectedMaritalStatus == (UserConfig.instance.checkLanguage()
                                          ? 'single' : servicesProvider.dependentInfo['cur_getdata'][0][0]["GENDER"] == 1 ? 'singleM' : 'singleF') ? 1
                                          : selectedMaritalStatus == (UserConfig.instance.checkLanguage()
                                          ? 'married' : servicesProvider.dependentInfo['cur_getdata'][0][0]["GENDER"] == 1 ? 'marriedM' : 'marriedF') ? 2
                                          : selectedMaritalStatus == (UserConfig.instance.checkLanguage()
                                          ? 'divorced' : servicesProvider.dependentInfo['cur_getdata'][0][0]["GENDER"] == 1 ? 'divorcedM' : 'divorcedF') ? 3
                                          : selectedMaritalStatus == (UserConfig.instance.checkLanguage()
                                          ? 'widow' : servicesProvider.dependentInfo['cur_getdata'][0][0]["GENDER"] == 1 ? 'widowM' : 'widowF') ? 4 : 1;
                                      try{
                                        await servicesProvider.checkDocumentDependent((selectedGender == "male") ? "1" : "2").then((value) async {
                                          if(value['P_RESULT'].isEmpty){
                                            Map<String, dynamic> dependent;
                                            String id = "${DateTime.now().millisecondsSinceEpoch}${((math.Random().nextDouble() * 10000) + 1).floor()}";
                                            if(nationality == 'jordanian'){
                                              dependent = {
                                                "NAME": servicesProvider.dependentInfo['cur_getdata'][0][0]["FULL_NAME"],
                                                "GENDER": servicesProvider.dependentInfo['cur_getdata'][0][0]["GENDER"],
                                                "FIRSTNAME": servicesProvider.dependentInfo['cur_getdata'][0][0]["FIRSTNAME"],
                                                "SECONDNAME": servicesProvider.dependentInfo['cur_getdata'][0][0]["SECONDNAME"],
                                                "THIRDNAME": servicesProvider.dependentInfo['cur_getdata'][0][0]["THIRDNAME"],
                                                "LASTNAME": servicesProvider.dependentInfo['cur_getdata'][0][0]["LASTNAME"],
                                                "BIRTHDATE": servicesProvider.dependentInfo['cur_getdata'][0][0]["BIRTHDATE"],
                                                "AGE": servicesProvider.dependentInfo['cur_getdata'][0][0]["AGE"],
                                                "MARITAL_STATUS_A": servicesProvider.dependentInfo['cur_getdata'][0][0]["SOCIAL_STATUS"],
                                                "MARITAL_STATUS": servicesProvider.dependentInfo['cur_getdata'][0][0]["SOCIAL_STATUS"],
                                                "WORK_STATUS_A": servicesProvider.dependentInfo['cur_getdata'][0][0]["IS_WORK"],
                                                "IS_ALIVE_A": servicesProvider.dependentInfo['cur_getdata'][0][0]["IS_ALIVE"],
                                                "IS_ALIVE": servicesProvider.dependentInfo['cur_getdata'][0][0]["IS_ALIVE"],
                                                "IS_RETIRED_A": selectedGetsSalary == 'yes' ? 1 : 0,
                                                "LAST_EVENT_DATE": servicesProvider.dependentInfo['cur_getdata'][0][0]["LAST_SOC_STATUS_DATE"],
                                                "WANT_HEALTH_INSURANCE": "",
                                                "PreLoad": null,
                                                "Added": null,
                                                "doc_dep": "",
                                                "RELATION": servicesProvider.dependentInfo['cur_getdata'][0][0]["RELATIVETYPE"],
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
                                                "IS_ALIVE": 1,
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
                                                    "GENDER": "2"
                                                  },
                                                  "dep": {
                                                    "dep": dependent
                                                  }
                                                }),
                                                8
                                            ).whenComplete((){}).then((value) {
                                              if(value['R_RESULT'].isNotEmpty){
                                                for(int i=0 ; i<value['R_RESULT'][0].length ; i++){
                                                  if(!servicesProvider.dependentsDocuments.contains(value['R_RESULT'][0][i])) {
                                                    servicesProvider.dependentsDocuments.add(value['R_RESULT'][0][i]);
                                                  }
                                                }
                                              }
                                            });
                                            if(servicesProvider.result['P_Dep'].length != 0) {
                                              servicesProvider.result['P_Dep'][0].add(dependent);
                                            } else{
                                              servicesProvider.result['P_Dep'].add([dependent]);
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
        Text(translate(key, context))
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

  Widget buildCountriesDropDown(SelectedListItem selectedCountry, int flag) {
    List<SelectedListItem> selectedListItem = [];
    for (var element in Provider.of<LoginProvider>(context, listen: false).countries) {
      int inx = countries.indexWhere((value) => value.dialCode == element.callingCode);
      if((flag == 1 && element.natcode != 111) || flag == 2) {
        selectedListItem.add(
        SelectedListItem(
          name: UserConfig.instance.checkLanguage() ? countries[inx == -1
              ? 0
              : inx].name : element.country,
          natCode: element.natcode,
          value: countries[inx == -1 ? 0 : inx].dialCode,
          isSelected: false,
          flag: countries[inx == -1 ? 0 : inx].flag,
        ),
      );
      }
    }
    return InkWell(
      onTap: () {
        DropDownState(
          DropDown(
            isSearchVisible: true,
            data: selectedListItem ?? [],
            selectedItems: (List<dynamic> selectedList) {
              for (var item in selectedList) {
                if (item is SelectedListItem) {
                  setState(() {
                    if(flag == 1){
                      selectedPaymentCountry = item;
                    }else if(flag == 2){
                      selectedMobileCountry = item;
                    }
                  });
                }
              }
            },
            enableMultipleSelection: false,
          ),
        ).showModal(context);
      },
      child: Container(
          alignment: UserConfig.instance.checkLanguage()
              ? Alignment.centerLeft
              : Alignment.centerRight,
          padding: const EdgeInsets.symmetric(
              horizontal: 16.0, vertical: 9.3),
          decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(8.0),
              border: Border.all(
                  color: HexColor('#979797')
              )
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    selectedCountry?.flag ?? "",
                    style: const TextStyle(
                      fontSize: 25,
                    ),
                  ),
                  SizedBox(width: width(0.01, context),),
                  Text(
                    flag == 1 ? selectedCountry.name : selectedCountry?.value ?? "",
                    style: TextStyle(
                        color: HexColor('#363636'),
                        fontSize: 15
                    ),
                  ),
                ],
              ),
              Icon(
                Icons.arrow_drop_down_outlined,
                color: HexColor('#363636'),
              )
            ],
          )
      ),
    );
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

