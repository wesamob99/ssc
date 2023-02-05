// ignore_for_file: file_names

import 'package:drop_down_list/drop_down_list.dart';
import 'package:drop_down_list/model/selected_list_item.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
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
  Future documentsFuture;
  ThemeNotifier themeNotifier;
  SelectedListItem selectedMobileCountry = SelectedListItem(
    name: UserConfig.instance.checkLanguage() ? "Jordan" : "الأردن",
    value: "962", natCode: 111,
    flag: countries[110].flag,
  );
  String areYouAuthorizedToSignForCompany = 'no';
  String areYouPartnerInLimitedLiabilityCompany = 'no';

  String selectedStatus;
  String selectedJobStatus;
  String selectedGetsSalary;
  String selectedHasDisability;
  String selectedMaritalStatus;
  String selectedMethodOfReceiving = 'insideJordan';
  List<String> maritalList;
  bool termsChecked = false;
  int dependentIndex = 0;

  TextEditingController nationalIdController = TextEditingController();
  String nationality = 'jordanian';

  checkContinueEnabled({flag = 0}){
    if(flag == 1){
      return ((servicesProvider.isMobileNumberUpdated == true && mobileNumberValidate(servicesProvider.mobileNumberController.text)) || servicesProvider.isMobileNumberUpdated == false);
    } else if(flag == 2){
      if(servicesProvider.isMobileNumberUpdated){
        return Provider.of<ServicesProvider>(context, listen: false).pinPutFilled;
      } else{
        // return ((selectedCalculateAccordingTo == 'increaseInAllowanceForDeductionYears' && selectedRate.name != '0' && selectedYear.name != '0') || selectedCalculateAccordingTo != 'increaseInAllowanceForDeductionYears');
        return true;
      }
    } else if(flag == 3){
      if(servicesProvider.isMobileNumberUpdated){
        return Provider.of<ServicesProvider>(context, listen: false).pinPutFilled;
      } else{
        // return ((selectedCalculateAccordingTo == 'increaseInAllowanceForDeductionYears' && selectedRate.name != '0' && selectedYear.name != '0') || selectedCalculateAccordingTo != 'increaseInAllowanceForDeductionYears');
        return true;
      }
    } else if(flag == 4){
      if(!servicesProvider.mandatoryDocumentsFinished){
        return servicesProvider.uploadedFiles['mandatory'].isNotEmpty && servicesProvider.uploadedFiles['mandatory'][servicesProvider.documentIndex].isNotEmpty;
      } else {
        return true;
      }
    } else{
      return true;
    }
  }

  @override
  void initState() {
    Provider.of<LoginProvider>(context, listen: false).readCountriesJson();
    servicesProvider = Provider.of<ServicesProvider>(context, listen: false);
    servicesProvider.showMandatoryDocumentsScreen = false;
    servicesProvider.showOptionalDocumentsScreen = false;
    servicesProvider.documentIndex = 0;
    servicesProvider.mandatoryDocumentsFinished = false;
    servicesProvider.mandatoryDocuments = [];
    servicesProvider.optionalDocuments = [];
    themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);
    documentsFuture = servicesProvider.getRequiredDocuments();
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
      backgroundColor: (servicesProvider.showMandatoryDocumentsScreen || servicesProvider.showOptionalDocumentsScreen)
          ? HexColor('#445740') : HexColor('#ffffff'),
      appBar: AppBar(
        centerTitle: false,
        title: Text(translate('earlyRetirementRequest', context)),
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: InkWell(
            onTap: (){
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
                case 4:
                  {
                    if(servicesProvider.showOptionalDocumentsScreen && servicesProvider.mandatoryDocuments.isEmpty){
                      servicesProvider.showMandatoryDocumentsScreen = false;
                      servicesProvider.showOptionalDocumentsScreen = false;
                      servicesProvider.stepNumber = 3;
                      setState(() {});
                      servicesProvider.notifyMe();
                    } else{
                      if(servicesProvider.documentIndex > 0){
                        servicesProvider.documentIndex--;
                      } else if(servicesProvider.documentIndex == 0 && servicesProvider.mandatoryDocumentsFinished){
                        servicesProvider.mandatoryDocumentsFinished = false;
                        if(servicesProvider.showOptionalDocumentsScreen){
                          servicesProvider.showOptionalDocumentsScreen = false;
                          servicesProvider.documentIndex = servicesProvider.mandatoryDocuments.length - 1;
                          servicesProvider.mandatoryDocumentsFinished = false;
                        } else {
                          servicesProvider.mandatoryDocumentsFinished = true;
                          servicesProvider.showOptionalDocumentsScreen = true;
                        }
                      } else if(servicesProvider.documentIndex == 0 && !servicesProvider.mandatoryDocumentsFinished && servicesProvider.showOptionalDocumentsScreen){
                        servicesProvider.mandatoryDocumentsFinished = true;
                        servicesProvider.documentIndex = servicesProvider.mandatoryDocuments.length - 1;
                        servicesProvider.showOptionalDocumentsScreen = false;
                      } else {
                        if(servicesProvider.showMandatoryDocumentsScreen){
                          servicesProvider.showMandatoryDocumentsScreen = false;
                          servicesProvider.stepNumber = 3;
                        } else {
                          servicesProvider.showMandatoryDocumentsScreen = true;
                        }
                      }
                    }
                    servicesProvider.notifyMe();
                  }
                  break;
                case 5:
                  {
                    if(servicesProvider.optionalDocuments.isEmpty){
                      if(servicesProvider.mandatoryDocuments.isNotEmpty){
                        servicesProvider.documentIndex = servicesProvider.mandatoryDocuments.length - 1;
                      }else {
                        servicesProvider.showMandatoryDocumentsScreen = true;
                      }
                      servicesProvider.mandatoryDocumentsFinished = false;
                      servicesProvider.stepNumber = 4;
                      setState(() {});
                      servicesProvider.notifyMe();
                    } else{
                      servicesProvider.mandatoryDocumentsFinished = servicesProvider.optionalDocuments.isNotEmpty ? true : false;
                      servicesProvider.documentIndex = servicesProvider.optionalDocuments.isNotEmpty ? servicesProvider.optionalDocuments.length - 1 : servicesProvider.mandatoryDocuments.length - 1;
                      servicesProvider.stepNumber = 4;
                    }
                  }
                  break;
                case 6: servicesProvider.stepNumber = 5; break;
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
                    if(!servicesProvider.showMandatoryDocumentsScreen && !servicesProvider.showOptionalDocumentsScreen)
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
                              if(dependentIndex < (servicesProvider.result['P_Dep'].length != 0 ? servicesProvider.result['P_Dep'][0].length - 1 : 0)){
                                dependentIndex++;
                              }else {
                                servicesProvider.showMandatoryDocumentsScreen = true;
                                servicesProvider.notifyMe();
                                servicesProvider.stepNumber = 4;
                              }
                            }
                          } break;
                          case 4: {
                            if(checkContinueEnabled(flag: 4)){
                              if(servicesProvider.documentIndex < servicesProvider.mandatoryDocuments.length-1 && !servicesProvider.mandatoryDocumentsFinished){
                                servicesProvider.documentIndex++;
                              } else if(servicesProvider.documentIndex < servicesProvider.optionalDocuments.length-1 && !servicesProvider.optionalDocumentsFinished){
                                servicesProvider.documentIndex++;
                              } else if(servicesProvider.documentIndex == servicesProvider.mandatoryDocuments.length-1 || servicesProvider.documentIndex == servicesProvider.optionalDocuments.length-1){
                                if(!servicesProvider.mandatoryDocumentsFinished){
                                  servicesProvider.mandatoryDocumentsFinished = true;
                                  servicesProvider.showOptionalDocumentsScreen = true;
                                  servicesProvider.documentIndex = 0;
                                } else{
                                  servicesProvider.showMandatoryDocumentsScreen = false;
                                  servicesProvider.showOptionalDocumentsScreen = false;
                                  servicesProvider.stepNumber = 5;
                                }
                              }
                              servicesProvider.notifyMe();
                            }
                          } break;
                          case 5: {
                            if(checkContinueEnabled(flag: 5)){
                              servicesProvider.stepNumber = 6;
                            }
                          } break;
                          case 6: {
                            showMyDialog(context, 'yourRequestHasBeenSentSuccessfully',
                                translate('youCanCheckAndFollowItsStatusFromMyOrdersScreen', context), 'ok',
                                themeNotifier,
                                icon: 'assets/icons/serviceSuccess.svg').then((_){
                              SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
                                servicesProvider.selectedServiceRate = -1;
                                servicesProvider.notifyMe();
                                rateServiceBottomSheet(context, themeNotifier, servicesProvider);
                              });
                            });
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
                translate('numberOfDependents', context) + ' ( ${servicesProvider.result['P_Dep'].length != 0 ? dependentIndex + 1 : 0} / ${servicesProvider.result['P_Dep'].length != 0 ? servicesProvider.result['P_Dep'][0].length : 0} )',
                style: TextStyle(
                  color: HexColor('#363636'),
                  fontWeight: FontWeight.w500,
                  fontSize: 17,
                ),
              ),
              SizedBox(height: height(0.02, context),),
              if(servicesProvider.result['P_Dep'].length != 0)
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
                              ),
                            ),
                            Row(
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
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 5.0,),
                                PopupMenuButton<ContextMenu>(
                                  onSelected: (ContextMenu result) async {
                                    switch (result.index) {
                                      case 0: {
                                        selectedStatus = servicesProvider.result['P_Dep'][0][dependentIndex]['IS_ALIVE'] == 1
                                            ? 'alive' : 'dead';
                                        selectedJobStatus = servicesProvider.result['P_Dep'][0][dependentIndex]['WORK_STATUS'] == 0
                                            ? 'unemployed' : 'employed';
                                        selectedGetsSalary = servicesProvider.result['P_Dep'][0][dependentIndex]['IS_RETIRED_A'] == 1
                                            ? 'no' : 'yes';
                                        selectedHasDisability = servicesProvider.result['P_Dep'][0][dependentIndex]['DISABILITY'] == 0
                                            ? 'no' : 'yes';
                                        selectedMaritalStatus = servicesProvider.result['P_Dep'][0][dependentIndex]['MARITAL_STATUS'] == 1
                                            ? UserConfig.instance.checkLanguage()
                                            ? 'single' : servicesProvider.result['P_Dep'][0][dependentIndex]['GENDER'] == 1 ? 'singleM' : 'singleF'
                                            : UserConfig.instance.checkLanguage()
                                            ? 'married' : servicesProvider.result['P_Dep'][0][dependentIndex]['GENDER'] == 1 ? 'marriedM' : 'marriedF';
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
                                                    servicesProvider.result['P_Dep'][0].removeAt(dependentIndex);
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
                                    size: 25,
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
                                  ),
                                ),
                                const SizedBox(height: 10.0,),
                                Text(
                                  translate(
                                      servicesProvider.result['P_Dep'][0][dependentIndex]['MARITAL_STATUS'] == 1
                                          ? UserConfig.instance.checkLanguage()
                                          ? 'single' : servicesProvider.result['P_Dep'][0][dependentIndex]['GENDER'] == 1 ? 'singleM' : 'singleF'
                                          : UserConfig.instance.checkLanguage()
                                          ? 'married' : servicesProvider.result['P_Dep'][0][dependentIndex]['GENDER'] == 1 ? 'marriedM' : 'marriedF',
                                      context),
                                  style: TextStyle(
                                    color: themeNotifier.isLight() ? HexColor('#363636') : Colors.white70,
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
                                  ),
                                ),
                                const SizedBox(height: 10.0,),
                                Text(
                                  translate(
                                      servicesProvider.result['P_Dep'][0][dependentIndex]['IS_RETIRED'] != 1
                                          ? 'no' : 'yes',
                                      context),
                                  style: TextStyle(
                                    color: themeNotifier.isLight() ? HexColor('#363636') : Colors.white70,
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
          if(dependentIndex == (servicesProvider.result['P_Dep'].length != 0 ? servicesProvider.result['P_Dep'][0].length - 1 : 0))
          Padding(
            padding: const EdgeInsets.only(bottom: 5.0),
            child: textButtonWithIcon(
                context, themeNotifier, 'addNewDependents', Colors.transparent, HexColor('#2D452E'),
                (){
                  nationalIdController = TextEditingController();
                  nationality = 'jordanian';
                  servicesProvider.isNationalIdValid = false;
                  servicesProvider.isLoading = false;
                  servicesProvider.notifyMe();
                  ///
                  selectedStatus = 'alive';
                  selectedJobStatus = 'employed';
                  selectedGetsSalary = 'yes';
                  selectedHasDisability = 'yes';
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
                  dependentModalBottomSheet(1, isEdit: true);
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
            SizedBox(height: height(0.02, context),),
            buildFieldTitle(context, 'methodOfReceivingSalary', required: false),
            const SizedBox(height: 10.0,),
            customTwoRadioButtons(5, 'insideJordan', 'outsideJordan', setState),
            const SizedBox(height: 30.0,),
            if(selectedMethodOfReceiving == 'insideJordan')
            Container(),
            if(selectedMethodOfReceiving == 'outsideJordan')
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildFieldTitle(context, 'country', required: false),
                const SizedBox(height: 10.0,),
                buildTextFormField(context, themeNotifier, TextEditingController(), '', (val){}),
                const SizedBox(height: 16,),
                buildFieldTitle(context, 'bankName', required: false),
                const SizedBox(height: 10.0,),
                buildTextFormField(context, themeNotifier, TextEditingController(), '', (val){}),
                const SizedBox(height: 16,),
                buildFieldTitle(context, 'bankBranch', required: false),
                const SizedBox(height: 10.0,),
                buildTextFormField(context, themeNotifier, TextEditingController(), '', (val){}),
                const SizedBox(height: 16,),
                buildFieldTitle(context, 'bankAddress', required: false),
                const SizedBox(height: 10.0,),
                buildTextFormField(context, themeNotifier, TextEditingController(), '', (val){}),
                const SizedBox(height: 16,),
                buildFieldTitle(context, 'accountNumber', required: false),
                const SizedBox(height: 10.0,),
                buildTextFormField(context, themeNotifier, TextEditingController(), '', (val){}, inputType: TextInputType.number),
                const SizedBox(height: 16,),
                buildFieldTitle(context, 'swiftCode', required: false),
                const SizedBox(height: 10.0,),
                buildTextFormField(context, themeNotifier, TextEditingController(), '', (val){}, inputType: TextInputType.text),
                const SizedBox(height: 16,),
                buildFieldTitle(context, 'mobileNumber', required: false),
                const SizedBox(height: 10.0,),
                Row(
                  children: [
                    Expanded(
                      flex: 4,
                      child: buildTextFormField(context, themeNotifier, TextEditingController(), '', (val){}, inputType: TextInputType.number),
                    ),
                    const SizedBox(width: 10.0,),
                    Expanded(
                      flex: 2,
                      child: buildCountriesDropDown(selectedMobileCountry),
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
                await servicesProvider.getInquiryInsuredInformation().then((value) async{
                  await servicesProvider.getInsuredInformationReport(value).then((value) async {
                    // downloadPDF(value, translate('detailedDisclosure', context)).whenComplete((){
                    //   if (kDebugMode) {
                    //     print('completed!');
                    //   }
                    // });
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

  Widget customTwoRadioButtons(int flag, String firstChoice, String secondChoice, setState){
    return Row(
      children: [
        InkWell(
          onTap: (){
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
                selectedMethodOfReceiving = firstChoice;
              }
              if(flag == 6) {
                nationality = firstChoice;
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
                  backgroundColor: (flag == 1 && selectedStatus == firstChoice) || (flag == 2 && selectedJobStatus == firstChoice) ||
                      (flag == 3 && selectedGetsSalary == firstChoice) || (flag == 4 && selectedHasDisability == firstChoice) || (flag == 5 && selectedMethodOfReceiving == firstChoice) || (flag == 6 && nationality == firstChoice)
                      ? HexColor('#2D452E') : Colors.transparent,
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
                selectedMethodOfReceiving = secondChoice;
              }
              if(flag == 6) {
                nationality = secondChoice;
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
                  backgroundColor: (flag == 1 && selectedStatus == secondChoice) || (flag == 2 && selectedJobStatus == secondChoice) ||
                      (flag == 3 && selectedGetsSalary == secondChoice) || (flag == 4 && selectedHasDisability == secondChoice) || (flag == 5 && selectedMethodOfReceiving == secondChoice) || (flag == 6 && nationality == secondChoice)
                      ? HexColor('#2D452E') : Colors.transparent,
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

  Widget customRadioButtonGroup(List choices, setState){
    return Expanded(
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 4,
        itemBuilder: (context, index){
          return Column(
            children: [
              InkWell(
                onTap: (){
                  setState(() {
                    selectedMaritalStatus = choices[index];
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
                        backgroundColor: selectedMaritalStatus == choices[index]
                            ? HexColor('#2D452E') : Colors.transparent,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        translate(choices[index], context),
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
                                customTwoRadioButtons(6, 'jordanian', 'nonJordanian', setState),
                                const SizedBox(height: 20.0,),
                                buildFieldTitle(context, 'nationalId', required: false),
                                const SizedBox(height: 10.0,),
                                buildTextFormField(context, themeNotifier, nationalIdController, '', (val){setState((){});}, inputType: TextInputType.number, enabled: !Provider.of<ServicesProvider>(context).isNationalIdValid),
                                const SizedBox(height: 15.0,),
                              ],
                            ),
                            Expanded(
                              child: ListView(
                                shrinkWrap: true,
                                children: [
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
                                                  !isEdit ? servicesProvider.result['P_Dep'][0][index]['NAME'] : 'NAME',
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
                                                        : const Color.fromRGBO(0, 121, 5, 0.38),
                                                    borderRadius: BorderRadius.circular(8.0),
                                                  ),
                                                  child: Text(
                                                    !isEdit ? getRelationType(servicesProvider.result['P_Dep'][0][index]['RELATION']) : 'RELATION',
                                                    style: TextStyle(
                                                      color: !isEdit
                                                          ? servicesProvider.result['P_Dep'][0][index]['RELATION'] == 11
                                                          ? HexColor('#003C97') : HexColor('#2D452E')
                                                          : HexColor('#2D452E'),
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
                                                  !isEdit ? servicesProvider.result['P_Dep'][0][index]['NATIONAL_NO'] : 'NATIONAL_NO',
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
                                                          : 'jordanian',
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
                                  customTwoRadioButtons((isEdit && !servicesProvider.isNationalIdValid) ? 69 : 2, 'unemployed', 'employed', setState),
                                  const SizedBox(height: 20.0,),
                                  buildFieldTitle(context, 'getsSalary', required: false),
                                  const SizedBox(height: 10.0,),
                                  customTwoRadioButtons((isEdit && !servicesProvider.isNationalIdValid) ? 69 : 3, 'yes', 'no', setState),
                                  const SizedBox(height: 20.0,),
                                  buildFieldTitle(context, 'hasDisability', required: false),
                                  const SizedBox(height: 10.0,),
                                  customTwoRadioButtons((isEdit && !servicesProvider.isNationalIdValid) ? 69 : 4, 'yes', 'no', setState),
                                  if(!isEdit)
                                  const SizedBox(height: 20.0,),
                                  if(!isEdit)
                                  buildFieldTitle(context, 'maritalStatus', required: false),
                                  if(!isEdit)
                                  const SizedBox(height: 10.0,),
                                  if(!isEdit)
                                  customRadioButtonGroup(maritalList, setState),
                                  // const SizedBox(height: 100.0,),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Positioned(
                          bottom: 15,
                          width: width(0.9, context),
                          child: Container(
                            color: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 5.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                textButton(context, themeNotifier, 'save', (!isEdit || ( isEdit && nationalIdController.text.length == 10)) ? HexColor('#445740') : HexColor('DADADA'),
                                    (!isEdit || ( isEdit && nationalIdController.text.length == 10)) ? Colors.white : HexColor('#363636'), () async {
                                  if(!isEdit) {
                                    Navigator.of(context).pop();
                                  } else{
                                    if(nationalIdController.text.length == 10){
                                      String message = '';
                                      servicesProvider.isLoading = true;
                                      servicesProvider.isModalLoading = true;
                                      servicesProvider.notifyMe();
                                      try{
                                        await servicesProvider.addNewDependent(nationalIdController.text).then((value) async {
                                          if(value['PO_status'] != 1){
                                            ///TODO : get dependent informations
                                            servicesProvider.isNationalIdValid = true;
                                            servicesProvider.notifyMe();
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

  Widget buildCountriesDropDown(SelectedListItem selectedCountry) {
    List<SelectedListItem> selectedListItem = [];
    for (var element in Provider.of<LoginProvider>(context, listen: false).countries) {
      int inx = countries.indexWhere((value) => value.dialCode == element.callingCode);
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
                    selectedMobileCountry = item;
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
                    selectedCountry?.value ?? "",
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


}

enum ContextMenu { edit, delete }

