// ignore_for_file: file_names

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:ssc/src/viewModel/services/servicesProvider.dart';
import 'package:ssc/src/viewModel/utilities/theme/themeProvider.dart';

import '../../../../../infrastructure/userConfig.dart';
import '../../../../../infrastructure/userSecuredStorage.dart';
import '../../../../../utilities/hexColor.dart';
import '../../../../../utilities/theme/themes.dart';
import '../../../../../utilities/util.dart';
import 'dart:math' as math;
import 'dart:ui' as ui;

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
  String firstSelectedItem = 'no';
  String secondSelectedItem = 'no';

  String selectedStatus;
  String selectedJobStatus;
  String selectedGetsSalary;
  String selectedHasDisability;
  String selectedMaritalStatus;
  List<String> maritalList;

  checkContinueEnabled({flag = 0}){
    if(flag == 1){
      return ((servicesProvider.isMobileNumberUpdated == true && servicesProvider.mobileNumberController.text.length == 9) || servicesProvider.isMobileNumberUpdated == false);
    } else if(flag == 2){
      if(servicesProvider.isMobileNumberUpdated){
        return Provider.of<ServicesProvider>(context, listen: false).pinPutFilled;
      } else{
        // return ((selectedCalculateAccordingTo == 'increaseInAllowanceForDeductionYears' && selectedRate.name != '0' && selectedYear.name != '0') || selectedCalculateAccordingTo != 'increaseInAllowanceForDeductionYears');
        return true;
      }
    } else{
      return true;
    }
  }

  @override
  void initState() {
    servicesProvider = Provider.of<ServicesProvider>(context, listen: false);
    themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);
    servicesProvider.stepNumber = 1;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                case 3: servicesProvider.stepNumber = 2; break;
                case 4: servicesProvider.stepNumber = 3; break;
                case 5: servicesProvider.stepNumber = 4; break;
                case 6: servicesProvider.stepNumber = 6; break;
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
                      forthStep(context, themeNotifier),
                    if(Provider.of<ServicesProvider>(context).stepNumber == 5)
                      fifthStep(context, themeNotifier),
                    if(Provider.of<ServicesProvider>(context).stepNumber == 6)
                      sixthStep(context, themeNotifier),
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
                              servicesProvider.stepNumber = 4;
                            }
                          } break;
                          case 4: {
                            if(checkContinueEnabled(flag: 4)){
                              servicesProvider.stepNumber = 5;
                            }
                          } break;
                          case 5: {
                            if(checkContinueEnabled(flag: 5)){
                              servicesProvider.stepNumber = 6;
                            }
                          } break;
                          case 6: {
                            while(Navigator.canPop(context)){ // Navigator.canPop return true if can pop
                              Navigator.pop(context);
                            }
                          } break;
                        }
                        servicesProvider.notifyMe();
                      },
                    )
                  ],
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  translate('numberOfDependents', context) + ' ( ${servicesProvider.result['P_Dep'][0].length} )',
                  style: TextStyle(
                    color: HexColor('#363636'),
                    fontWeight: FontWeight.w500,
                    fontSize: 17,
                  ),
                ),
              ),
              Expanded(
                child: textButtonWithIcon(
                  context, themeNotifier, 'addNewDependents', Colors.transparent, HexColor('#2D452E'),
                  (){},
                  borderColor: '#2D452E'
                )
              )
            ],
          ),
          SizedBox(height: height(0.02, context),),
          Expanded(
            child: ListView.builder(
              itemCount: servicesProvider.result['P_Dep'][0].length,
              itemBuilder: (context, index){
                return Card(
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
                                servicesProvider.result['P_Dep'][0][index]['NAME'],
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
                                      color: servicesProvider.result['P_Dep'][0][index]['RELATION'] == 11
                                          ? HexColor('#9EBDF8') : const Color.fromRGBO(0, 121, 5, 0.38),
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    child: Text(
                                      getRelationType(servicesProvider.result['P_Dep'][0][index]['RELATION']),
                                      style: TextStyle(
                                        color: servicesProvider.result['P_Dep'][0][index]['RELATION'] == 11
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
                                          selectedStatus = servicesProvider.result['P_Dep'][0][index]['IS_ALIVE'] == 1
                                              ? 'alive' : 'dead';
                                          selectedJobStatus = servicesProvider.result['P_Dep'][0][index]['WORK_STATUS'] == 0
                                              ? 'unemployed' : 'employed';
                                          selectedGetsSalary = servicesProvider.result['P_Dep'][0][index]['IS_RETIRED'] == 0
                                              ? 'no' : 'yes';
                                          selectedHasDisability = servicesProvider.result['P_Dep'][0][index]['DISABILITY'] == 0
                                              ? 'no' : 'yes';
                                          selectedMaritalStatus = servicesProvider.result['P_Dep'][0][index]['MARITAL_STATUS'] == 1
                                              ? UserConfig.instance.checkLanguage()
                                              ? 'single' : servicesProvider.result['P_Dep'][0][index]['GENDER'] == 1 ? 'singleM' : 'singleF'
                                              : UserConfig.instance.checkLanguage()
                                              ? 'married' : servicesProvider.result['P_Dep'][0][index]['GENDER'] == 1 ? 'marriedM' : 'marriedF';
                                          maritalList = [
                                            UserConfig.instance.checkLanguage()
                                                ? 'single'
                                                : servicesProvider.result['P_Dep'][0][index]['GENDER'] == 1 ? 'singleM' : 'singleF',
                                            UserConfig.instance.checkLanguage()
                                                ? 'married'
                                                : servicesProvider.result['P_Dep'][0][index]['GENDER'] == 1 ? 'marriedM' : 'marriedF',
                                            UserConfig.instance.checkLanguage()
                                                ? 'divorced'
                                                : servicesProvider.result['P_Dep'][0][index]['GENDER'] == 1 ? 'divorcedM' : 'divorcedF',
                                            UserConfig.instance.checkLanguage()
                                                ? 'widow'
                                                : servicesProvider.result['P_Dep'][0][index]['GENDER'] == 1 ? 'widowM' : 'widowF',
                                          ];
                                          editDependentModalBottomSheet(index);
                                        } break;
                                        case 1: {
                                          showMyDialog(
                                            context, 'wouldYouLikeToConfirmDeletionOfDependents',
                                            servicesProvider.result['P_Dep'][0][index]['NAME'],
                                            'yesContinue', themeNotifier, icon: 'assets/icons/dialogDeleteIcon.svg',
                                            onPressed: (){}, withCancelButton: true);
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
                                servicesProvider.result['P_Dep'][0][index]['NATIONAL_NO'],
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
                                  servicesProvider.result['P_Dep'][0][index]['NATIONALITY'] == 1
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
                                    servicesProvider.result['P_Dep'][0][index]['MARITAL_STATUS'] == 1
                                        ? UserConfig.instance.checkLanguage()
                                        ? 'single' : servicesProvider.result['P_Dep'][0][index]['GENDER'] == 1 ? 'singleM' : 'singleF'
                                        : UserConfig.instance.checkLanguage()
                                        ? 'married' : servicesProvider.result['P_Dep'][0][index]['GENDER'] == 1 ? 'marriedM' : 'marriedF',
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
                                    servicesProvider.result['P_Dep'][0][index]['WORK_STATUS'] == 0
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
                                    servicesProvider.result['P_Dep'][0][index]['IS_ALIVE'] == 1
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
                                    servicesProvider.result['P_Dep'][0][index]['DISABILITY'] == 0
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
                                    servicesProvider.result['P_Dep'][0][index]['IS_RETIRED'] == 0
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
                );
              },
            ),
          )
        ],
      ),
    );
  }

  Widget forthStep(context, themeNotifier){
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
                  translate('forthStep', context),
                  style: TextStyle(
                      color: HexColor('#979797'),
                      fontSize: width(0.03, context)
                  ),
                ),
                SizedBox(height: height(0.006, context),),
                Text(
                  translate('documents', context),
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
                      '4/6',
                      style: TextStyle(
                          color: HexColor('#979797'),
                          fontSize: width(0.025, context)
                      ),
                    ),
                    Text(
                      '${translate('next', context)}: ${translate('receiptOfAllowances', context)}',
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
          ],
        ),
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
          ],
        ),
      ),
    );
  }

  Widget sixthStep(context, themeNotifier){
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
          ],
        ),
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
                firstSelectedItem = 'yes';
              }
              if(flag == 2) {
                secondSelectedItem = 'yes';
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
                  backgroundColor: (flag == 1 && firstSelectedItem == 'yes') || (flag == 2 && secondSelectedItem == 'yes')
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
                firstSelectedItem = 'no';
              }
              if(flag == 2) {
                secondSelectedItem = 'no';
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
                  backgroundColor: (flag == 1 && firstSelectedItem == 'no') || (flag == 2 && secondSelectedItem == 'no')
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
                      (flag == 3 && selectedGetsSalary == firstChoice) || (flag == 4 && selectedHasDisability == firstChoice)
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
                      (flag == 3 && selectedGetsSalary == secondChoice) || (flag == 4 && selectedHasDisability == secondChoice)
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

  editDependentModalBottomSheet(index){
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
            child: Material(
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
                        Card(
                            elevation: 2.0,
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
                                        servicesProvider.result['P_Dep'][0][index]['NAME'],
                                        style: TextStyle(
                                          height: 1.4,
                                          color: themeNotifier.isLight() ? HexColor('#363636') : Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
                                        decoration: BoxDecoration(
                                          color: servicesProvider.result['P_Dep'][0][index]['RELATION'] == 11
                                              ? HexColor('#9EBDF8') : const Color.fromRGBO(0, 121, 5, 0.38),
                                          borderRadius: BorderRadius.circular(8.0),
                                        ),
                                        child: Text(
                                          getRelationType(servicesProvider.result['P_Dep'][0][index]['RELATION']),
                                          style: TextStyle(
                                            color: servicesProvider.result['P_Dep'][0][index]['RELATION'] == 11
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
                                        servicesProvider.result['P_Dep'][0][index]['NATIONAL_NO'],
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
                                            servicesProvider.result['P_Dep'][0][index]['NATIONALITY'] == 1
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
                        const SizedBox(height: 20.0,),
                        Expanded(
                          child: ListView(
                            shrinkWrap: true,
                            children: [
                              buildFieldTitle(context, 'status', required: false),
                              const SizedBox(height: 10.0,),
                              customTwoRadioButtons(1, 'alive', 'dead', setState),
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
                              const SizedBox(height: 20.0,),
                              buildFieldTitle(context, 'maritalStatus', required: false),
                              const SizedBox(height: 10.0,),
                              customRadioButtonGroup(maritalList, setState),
                              const SizedBox(height: 100.0,),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Positioned(
                      bottom: 5,
                      width: width(0.9, context),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          textButton(context, themeNotifier, 'save', HexColor('#445740'), Colors.white, (){
                            Navigator.of(context).pop();
                          }),
                          const SizedBox(height: 4.0,),
                          textButton(context, themeNotifier, 'cancel', HexColor('#DADADA'), HexColor('#363636'), (){
                            Navigator.of(context).pop();
                          }),
                        ],
                      ),
                    )
                  ],
                ),
              ),
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

}

enum ContextMenu { edit, delete }

