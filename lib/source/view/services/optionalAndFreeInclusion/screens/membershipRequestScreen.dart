// ignore_for_file: file_names, use_build_context_synchronously

import 'package:drop_down_list/drop_down_list.dart';
import 'package:drop_down_list/model/selected_list_item.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:ssc/infrastructure/userSecuredStorage.dart';
import 'package:ssc/source/view/services/shared/firstStepScreen.dart';
import 'package:ssc/source/viewModel/services/servicesProvider.dart';
import 'package:ssc/utilities/util.dart';
import 'dart:math' as math;
import '../../../../../infrastructure/userConfig.dart';
import '../../../../../utilities/hexColor.dart';
import '../../../../../utilities/theme/themes.dart';
import '../../../../viewModel/accountSettings/accountSettingsProvider.dart';
import '../../../../viewModel/utilities/theme/themeProvider.dart';
import '../../shared/verifyMobileNumberScreen.dart';

class MembershipRequestScreen extends StatefulWidget {
  const MembershipRequestScreen({Key key}) : super(key: key);

  @override
  State<MembershipRequestScreen> createState() => _MembershipRequestScreenState();
}

class _MembershipRequestScreenState extends State<MembershipRequestScreen> {
  ServicesProvider servicesProvider;
  ThemeNotifier themeNotifier;
  String selectedCalculateAccordingTo = 'lastSalary';
  int submissionType = 1;
  List<String> calculateAccordingToList = [];
  List<SelectedListItem> listOfRates = [];
  SelectedListItem selectedRate = SelectedListItem(name: '0', natCode: null, flag: '');
  List<SelectedListItem> listOfYears = [];
  SelectedListItem selectedYear = SelectedListItem(name: '0', natCode: null, flag: '');
  List<SelectedListItem> listOfMonths = [];
  SelectedListItem selectedMonth;
  double currentSliderValue = 0;
  double minSalary = 0;
  double maxSalary = 0;
  String confirmSalaryValue = '';
  String confirmMonthlyValue = '';

  @override
  void initState() {
    servicesProvider = Provider.of<ServicesProvider>(context, listen: false);
    themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);
    servicesProvider.stepNumber = 1;
    servicesProvider.mobileNumberController.text = UserSecuredStorage.instance.realMobileNumber;

    listOfYears = [];
    for(int i=0 ; i<=servicesProvider.result['cur_getdata'][0][0]['NOOFINCREMENTS'] ; i++){
      listOfYears.add(SelectedListItem(name: '$i', natCode: null, flag: ''));
    }
    listOfRates = [];
    for(int i=0 ; i<=servicesProvider.result['cur_getdata'][0][0]['MAX_PER_OF_INC'] ; i++){
      listOfRates.add(SelectedListItem(name: '$i', natCode: null, flag: ''));
    }

    listOfMonths = [];
    if(servicesProvider.result['MONTHS'] != null){
      for(int i=0 ; i<servicesProvider.result['MONTHS'].length ; i++){
        selectedMonth = SelectedListItem(name: '${servicesProvider.result['MONTHS'][0]['SUB_DATE']}', value: '${servicesProvider.result['MONTHS'][0]['SALARY']}', natCode: null, flag: '');
        listOfMonths.add(SelectedListItem(name: '${servicesProvider.result['MONTHS'][i]['SUB_DATE']}', value: '${servicesProvider.result['MONTHS'][i]['SALARY']}', natCode: null, flag: ''));
      }
    }

    if(servicesProvider.result['PO_is_it_firstOptionalSub'] == 0){
      fillCalculateAccordingToList();
      currentSliderValue = minSalary = double.tryParse(servicesProvider.result['cur_getdata'][0][0]['MINIMUMSALARYFORDEC'].toString());
      maxSalary = double.tryParse(servicesProvider.result['cur_getdata'][0][0]['MAXIMUMSALARYFORDEC'].toString());
      if(selectedCalculateAccordingTo == 'lastSalary'){
        currentSliderValue = double.tryParse(
            (double.tryParse(servicesProvider.result['cur_getdata'][0][0]['LAST_SALARY'].toString()) > double.tryParse(servicesProvider.result['cur_getdata'][0][0]['MINIMUMSALARYFORCHOOSE'].toString())
                ? servicesProvider.result['cur_getdata'][0][0]['LAST_SALARY'] : servicesProvider.result['cur_getdata'][0][0]['MINIMUMSALARYFORCHOOSE']).toString());
      }
    } else{
      calculateAccordingToList = [];
      submissionType = null;
      currentSliderValue = minSalary = double.tryParse(servicesProvider.result['cur_getdata'][0][0]['MINIMUMSALARYFORCHOOSE'].toString());
      maxSalary = double.tryParse(servicesProvider.result['cur_getdata'][0][0]['MAXIMUMSALARYFORCHOOSE'].toString());
    }

    confirmSalaryValue = currentSliderValue.toStringAsFixed(3);
    confirmMonthlyValue = (currentSliderValue * (double.tryParse(servicesProvider.result['cur_getdata'][0][0]['REG_PER'].toString())) / 100).toStringAsFixed(3);

    if(selectedCalculateAccordingTo == 'lastSalaryAccordingToTheDefenseLaw'){
      confirmSalaryValue = double.parse(selectedMonth.value).toStringAsFixed(3);
      confirmMonthlyValue = (servicesProvider.result['cur_getdata'][0][0]['LAST_SALARY'] * ((double.tryParse(servicesProvider.result['cur_getdata'][0][0]['REG_PER'].toString())) / 100)).toStringAsFixed(3);
    }

    servicesProvider.monthlyInstallmentController.text = currentSliderValue.toStringAsFixed(3);
    super.initState();
  }

  fillCalculateAccordingToList(){
    if(servicesProvider.result['cur_getdata'][0][0]['LAST_SAL_OPT_ENABLED'] == 1) {
      calculateAccordingToList = ['lastSalary'];
    }
    if(servicesProvider.result['cur_getdata'][0][0]['HASBENEFITOFINC'] == 0) {
      calculateAccordingToList.add('increaseInAllowanceForDeductionYears');
      selectedCalculateAccordingTo = (servicesProvider.result['cur_getdata'][0][0]['LAST_SAL_OPT_ENABLED'] == 1) ? 'lastSalary' : 'increaseInAllowanceForDeductionYears';
      submissionType = (servicesProvider.result['cur_getdata'][0][0]['LAST_SAL_OPT_ENABLED'] == 1) ? 1 : 2;
    }
    if(servicesProvider.result['cur_getdata'][0][0]['HASBENEFITOFDEC'] == 0) {
      calculateAccordingToList.add('discountNotMoreThan-20');
      selectedCalculateAccordingTo = (servicesProvider.result['cur_getdata'][0][0]['LAST_SAL_OPT_ENABLED'] == 1) ? 'lastSalary' : 'discountNotMoreThan-20';
      submissionType = (servicesProvider.result['cur_getdata'][0][0]['LAST_SAL_OPT_ENABLED'] == 1) ? 1 : 3;
    }
    if(servicesProvider.result['cur_getdata'][0][0]['COMPLEMENTARY_SUBSC'] == 1) {
      calculateAccordingToList.add('lastSalaryAccordingToTheDefenseLaw');
      selectedCalculateAccordingTo = (servicesProvider.result['cur_getdata'][0][0]['LAST_SAL_OPT_ENABLED'] == 1) ? 'lastSalary' : 'lastSalaryAccordingToTheDefenseLaw';
      submissionType = (servicesProvider.result['cur_getdata'][0][0]['LAST_SAL_OPT_ENABLED'] == 1) ? 1 : 5;
    }
  }

  checkContinueEnabled({flag = 0}){
    if(flag == 1){
      return servicesProvider.disableMobileValidations ? servicesProvider.mobileNumberController.text.isNotEmpty : mobileNumberValidate(servicesProvider.mobileNumberController.text);
    } else if(flag == 2){
      if(servicesProvider.isMobileNumberUpdated){
        return Provider.of<ServicesProvider>(context, listen: false).pinPutFilled;
      } else{
        return ((selectedCalculateAccordingTo == 'increaseInAllowanceForDeductionYears' && selectedRate.name != '0' && selectedYear.name != '0') || selectedCalculateAccordingTo != 'increaseInAllowanceForDeductionYears');
      }
    } else{
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    ThemeNotifier themeNotifier = Provider.of<ThemeNotifier>(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(getTranslated('membershipRequest', context)),
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: InkWell(
            onTap: (){
              switch(servicesProvider.stepNumber){
                case 1: Navigator.of(context).pop(); break;
                case 2: servicesProvider.stepNumber = 1; break;
                case 3: servicesProvider.stepNumber = 2; break;
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
                        const FirstStepScreen(nextStep: 'payCalculation', numberOfSteps: 3),
                      if(Provider.of<ServicesProvider>(context).stepNumber == 2 && Provider.of<ServicesProvider>(context).isMobileNumberUpdated)
                        VerifyMobileNumberScreen(nextStep: 'payCalculation', numberOfSteps: 3, mobileNo: servicesProvider.mobileNumberController.text ?? ''),
                      if(Provider.of<ServicesProvider>(context).stepNumber == 2 && !Provider.of<ServicesProvider>(context).isMobileNumberUpdated)
                        secondStep(context, themeNotifier),
                      if(Provider.of<ServicesProvider>(context).stepNumber == 3)
                        thirdStep(context, themeNotifier),
                      textButton(context,
                        themeNotifier,
                        Provider.of<ServicesProvider>(context).stepNumber != 3 ? 'continue' : 'send',
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
                            case 3: {
                              String message = getTranslated('somethingWrongHappened', context);
                              if(servicesProvider.result['PO_is_it_firstOptionalSub'] == 0 || servicesProvider.result['PO_is_it_firstOptionalSub'] == 1 || servicesProvider.result['PO_is_it_firstOptionalSub'] == 2) {
                                double appliedSalary = double.tryParse(confirmSalaryValue);
                                String percentDecreaseVal = 'null';
                                int sYear;
                                int sRate;
                                String sMonth = selectedCalculateAccordingTo == 'lastSalaryAccordingToTheDefenseLaw' ? selectedMonth.name : null;
                                if(selectedCalculateAccordingTo == 'discountNotMoreThan-20'){
                                  percentDecreaseVal = confirmSalaryValue;
                                  appliedSalary = double.parse(servicesProvider.result['cur_getdata'][0][0]['LAST_SALARY'].toString());
                                  sYear = int.tryParse(selectedYear.name);
                                  sRate = int.tryParse(selectedRate.name);
                                }
                                servicesProvider.isLoading = true;
                                servicesProvider.notifyMe();
                                var value = await servicesProvider.optionalSubInsertNew(double.tryParse(confirmMonthlyValue), servicesProvider.result['PO_is_it_firstOptionalSub'], appliedSalary, submissionType, sYear, sRate, percentDecreaseVal, sMonth).whenComplete((){});
                                if(servicesProvider.result['PO_is_it_firstOptionalSub'] == 1){
                                  value = await servicesProvider.optionalSubFirstInsertNew(double.tryParse(confirmMonthlyValue), double.tryParse(confirmSalaryValue), submissionType).whenComplete((){});
                                }
                                servicesProvider.isLoading = false;
                                servicesProvider.notifyMe();
                                if(value != '') {
                                  message = UserConfig.instance.isLanguageEnglish()
                                    ? value['PO_status_desc_en'] : value['PO_status_desc_ar'];
                                }
                                showMyDialog(context, (value != '' && value['PO_status'] == 1) ? 'youAreIncludedOptional' : 'failed',
                                    message, 'cancel',
                                    themeNotifier, withPayButton: (value != '' && value['PO_status'] == 1) ? true : false,
                                    icon: (value != '' && value['PO_status'] == 1) ? 'assets/icons/serviceSuccess.svg' : 'assets/icons/loginError.svg', titleColor: (value != '' && value['PO_status'] == 1) ? '#000000' : '#ED3124').then((_){
                                  if(value['PO_status'] == 1){
                                    UserSecuredStorage.instance.token = value['TOKEN'].toString();
                                    UserSecuredStorage.instance.insuranceNumber = value['PO_SSC_ID'].toString();
                                    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
                                      servicesProvider.selectedServiceRate = -1;
                                      servicesProvider.notifyMe();
                                      rateServiceBottomSheet(context, themeNotifier, servicesProvider);
                                    });
                                  }else{
                                    Navigator.of(context).pop();
                                  }
                                });
                              }else{
                                showMyDialog(context, 'failed', message, 'ok', themeNotifier).then((_){
                                  SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
                                    servicesProvider.selectedServiceRate = -1;
                                    servicesProvider.notifyMe();
                                    rateServiceBottomSheet(context, themeNotifier, servicesProvider);
                                  });
                                });
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
                  getTranslated('secondStep', context),
                  style: TextStyle(
                      color: HexColor('#979797'),
                      fontSize: width(0.03, context)
                  ),
                ),
                SizedBox(height: height(0.006, context),),
                Text(
                  getTranslated('payCalculation', context),
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
                      '2/3',
                      style: TextStyle(
                          color: HexColor('#979797'),
                          fontSize: width(0.025, context)
                      ),
                    ),
                    Text(
                      '${getTranslated('next', context)}: ${getTranslated('confirmRequest', context)}',
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
            if(servicesProvider.result['PO_is_it_firstOptionalSub'] == 0)
            Text(
              getTranslated('CalculateAccordingTo', context),
              style: TextStyle(
                  color: HexColor('#363636'),
                  fontSize: width(0.032, context)
              ),
            ),
            if(servicesProvider.result['PO_is_it_firstOptionalSub'] == 0)
            SizedBox(height: height(0.015, context),),
            if(servicesProvider.result['PO_is_it_firstOptionalSub'] == 0)
            // RadioGroup<String>.builder(
            //   activeColor: HexColor('#2D452E'),
            //   direction: Axis.vertical,
            //   horizontalAlignment: MainAxisAlignment.start,
            //   groupValue: selectedCalculateAccordingTo,
            //   // spacebetween: 40,
            //   textStyle: isTablet(context)
            //   ? TextStyle(
            //     fontSize: width(0.025, context)
            //   ) : const TextStyle(),
            //   onChanged: (value) => setState(() {
            //         selectedCalculateAccordingTo = value;
            //         if(selectedCalculateAccordingTo == 'lastSalary'){
            //           submissionType = 1;
            //           currentSliderValue = double.tryParse(
            //               (double.tryParse(servicesProvider.result['cur_getdata'][0][0]['LAST_SALARY'].toString()) > double.tryParse(servicesProvider.result['cur_getdata'][0][0]['MINIMUMSALARYFORCHOOSE'].toString())
            //                       ? servicesProvider.result['cur_getdata'][0][0]['LAST_SALARY'] : servicesProvider.result['cur_getdata'][0][0]['MINIMUMSALARYFORCHOOSE']).toString());
            //           confirmSalaryValue = currentSliderValue.toStringAsFixed(2);
            //           confirmMonthlyValue = (currentSliderValue * ((double.tryParse(servicesProvider.result['cur_getdata'][0][0]['REG_PER'].toString())) / 100)).toStringAsFixed(3);
            //         }else if(selectedCalculateAccordingTo == 'increaseInAllowanceForDeductionYears'){
            //           submissionType = 2;
            //           currentSliderValue = double.tryParse(
            //               (double.tryParse(servicesProvider.result['cur_getdata'][0][0]['LAST_SALARY'].toString()) > double.tryParse(servicesProvider.result['cur_getdata'][0][0]['MINIMUMSALARYFORCHOOSE'].toString())
            //                       ? servicesProvider.result['cur_getdata'][0][0]['LAST_SALARY'] : servicesProvider.result['cur_getdata'][0][0]['MINIMUMSALARYFORCHOOSE']).toString());
            //           selectedRate = selectedYear = SelectedListItem(name: '0', natCode: null, flag: '');
            //           confirmSalaryValue = ((currentSliderValue * (double.tryParse(selectedRate.name) / 100) + currentSliderValue)).toStringAsFixed(3);
            //           confirmMonthlyValue = ((currentSliderValue * (double.tryParse(selectedRate.name) / 100) + currentSliderValue) * ((double.tryParse(servicesProvider.result['cur_getdata'][0][0]['REG_PER'].toString())) / 100)).toStringAsFixed(3);
            //         } else if(selectedCalculateAccordingTo == 'discountNotMoreThan-20'){
            //           submissionType = 3;
            //           currentSliderValue = maxSalary;
            //           servicesProvider.monthlyInstallmentController.text = currentSliderValue.toStringAsFixed(3);
            //           confirmSalaryValue = currentSliderValue.toStringAsFixed(2);
            //           confirmMonthlyValue = (currentSliderValue * ((double.tryParse(servicesProvider.result['cur_getdata'][0][0]['REG_PER'].toString())) / 100)).toStringAsFixed(3);
            //         } else if(selectedCalculateAccordingTo == 'lastSalaryAccordingToTheDefenseLaw'){
            //           submissionType = 5;
            //         }
            //   }),
            //   items: calculateAccordingToList,
            //   itemBuilder: (item) =>
            //     RadioButtonBuilder(
            //       getTranslated(item, context),
            //     ),
            // ),
            customRadioButtonGroup(calculateAccordingToList, setState),
            if(servicesProvider.result['PO_is_it_firstOptionalSub'] == 0)
            SizedBox(height: height(0.02, context),),
            if(servicesProvider.result['PO_is_it_firstOptionalSub'] != 0 || selectedCalculateAccordingTo == 'discountNotMoreThan-20')
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  getTranslated('determineTheAffiliateWage', context),
                  style: TextStyle(
                      color: HexColor('#363636'),
                      fontSize: width(0.032, context)
                  ),
                ),
                SizedBox(height: height(0.015, context),),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Flexible(
                        flex: 5,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Slider(
                              activeColor: HexColor('#2D452E'),
                              inactiveColor: HexColor('#E0E0E0'),
                              value: currentSliderValue,
                              min: minSalary,
                              max: maxSalary,
                              divisions: minSalary != maxSalary ? (maxSalary - minSalary).floor() : 1,
                              label: currentSliderValue.round().toString(),
                              onChanged: (double value) {
                                servicesProvider.monthlyInstallmentController.text = value.toStringAsFixed(3);
                                servicesProvider.notifyMe();
                                setState(() {
                                  currentSliderValue = value;
                                  confirmSalaryValue = currentSliderValue.toStringAsFixed(2);
                                  confirmMonthlyValue = (currentSliderValue * ((double.tryParse(servicesProvider.result['cur_getdata'][0][0]['REG_PER'].toString())) / 100)).toStringAsFixed(3);
                                });
                              },
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 15.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '$minSalary ${getTranslated('jd', context)}',
                                    style: const TextStyle(
                                        fontSize: 13
                                    ),
                                  ),
                                  Text(
                                    '$maxSalary ${getTranslated('jd', context)}',
                                    style: const TextStyle(
                                        fontSize: 13
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        )
                    ),
                    Flexible(
                        flex: 1,
                        child: Column(
                          children: [
                            Text(
                              getTranslated('sal', context),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: HexColor('#363636'),
                                fontSize: width(0.022, context),
                              ),
                            ),
                            const SizedBox(height: 5.0),
                            monthlyInstallmentTextFormField(
                              servicesProvider.monthlyInstallmentController, themeNotifier,
                                  (value){
                                if((int.tryParse(value.isEmpty ? '0' : value) <= maxSalary) && (int.tryParse(value.isEmpty ? '0' : value) >= minSalary)) {
                                  setState(() {
                                    currentSliderValue = double.parse(servicesProvider.monthlyInstallmentController.text);
                                  });
                                }else{
                                  setState((){
                                    if(int.tryParse(value.isEmpty ? '0' : value) > maxSalary) {
                                      currentSliderValue = maxSalary;
                                    } else if(int.tryParse(value.isEmpty ? '0' : value) < minSalary) {
                                      currentSliderValue = minSalary;
                                    }
                                  });
                                }
                                setState(() {
                                  confirmSalaryValue = currentSliderValue.toStringAsFixed(2);
                                  confirmMonthlyValue = (currentSliderValue * ((double.tryParse(servicesProvider.result['cur_getdata'][0][0]['REG_PER'].toString())) / 100)).toStringAsFixed(3);
                                });
                                servicesProvider.notifyMe();
                              },
                            ),
                          ],
                        )
                    )
                  ],
                ),
              ],
            ),
            if(selectedCalculateAccordingTo == 'lastSalaryAccordingToTheDefenseLaw')
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  getTranslated('theMonthFromWhichTheSubscriptionIsToStart', context),
                  style: TextStyle(
                      color: HexColor('#363636'),
                      fontSize: width(0.032, context)
                  ),
                ),
                SizedBox(height: height(0.015, context),),
                buildDropDown(context, listOfMonths, 3, servicesProvider),
                SizedBox(height: height(0.02, context),),
              ],
            ),
            if(selectedCalculateAccordingTo == 'increaseInAllowanceForDeductionYears')
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  getTranslated('rateOfIncrease', context),
                  style: TextStyle(
                      color: HexColor('#363636'),
                      fontSize: width(0.032, context)
                  ),
                ),
                SizedBox(height: height(0.015, context),),
                buildDropDown(context, listOfRates, 1, servicesProvider),
                SizedBox(height: height(0.02, context),),
                Text(
                  getTranslated('numberOfYears', context),
                  style: TextStyle(
                      color: HexColor('#363636'),
                      fontSize: width(0.032, context)
                  ),
                ),
                SizedBox(height: height(0.015, context),),
                buildDropDown(context, listOfYears, 2, servicesProvider)
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: height(0.02, context),),
                Text(
                  getTranslated('monthlyInstallment', context) + (UserConfig.instance.isLanguageEnglish() ? ' is :' : ' هو :'),
                  style: TextStyle(
                      color: HexColor('#363636'),
                      fontSize: width(0.032, context)
                  ),
                ),
                SizedBox(height: height(0.02, context),),
                Container(
                    width: width(1, context),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: HexColor('#F0F2F0'),
                        borderRadius: BorderRadius.circular(12.0)
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          confirmMonthlyValue,
                          style: TextStyle(
                            color: HexColor('#666666'),
                            fontWeight: FontWeight.w500,
                            fontSize: 20,
                          ),
                        ),
                        Text(
                          getTranslated('jd', context),
                          style: TextStyle(
                            color: HexColor('#716F6F'),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    )
                )
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: height(0.03, context),),
                Text(
                  getTranslated('salary', context) + (UserConfig.instance.isLanguageEnglish() ? ' is :' : ' هو :'),
                  style: TextStyle(
                      color: HexColor('#363636'),
                      fontSize: width(0.032, context)
                  ),
                ),
                SizedBox(height: height(0.02, context),),
                Container(
                    width: width(1, context),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: HexColor('#F0F2F0'),
                        borderRadius: BorderRadius.circular(12.0)
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          confirmSalaryValue,
                          style: TextStyle(
                            color: HexColor('#666666'),
                            fontWeight: FontWeight.w500,
                            fontSize: 20,
                          ),
                        ),
                        Text(
                          getTranslated('jd', context),
                          style: TextStyle(
                            color: HexColor('#716F6F'),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    )
                ),
                SizedBox(height: height(0.02, context),),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget thirdStep(context, themeNotifier){
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
                      '3/3',
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
            if(servicesProvider.result['PO_is_it_firstOptionalSub'] == 0)
            SizedBox(height: height(0.02, context),),
            if(servicesProvider.result['PO_is_it_firstOptionalSub'] == 0)
            Text(
              getTranslated('CalculateAccordingTo', context),
              style: TextStyle(
                  color: HexColor('#363636'),
                  fontSize: width(0.036, context)
              ),
            ),
            if(servicesProvider.result['PO_is_it_firstOptionalSub'] == 0)
            SizedBox(height: height(0.015, context),),
            if(servicesProvider.result['PO_is_it_firstOptionalSub'] == 0)
            Text(getTranslated(selectedCalculateAccordingTo, context)),
            SizedBox(height: height(0.035, context),),
            Text(
              getTranslated('monthlyInstallment', context),
              style: TextStyle(
                  color: HexColor('#363636'),
                  fontSize: width(0.036, context)
              ),
            ),
            SizedBox(height: height(0.015, context),),
            Text('$confirmMonthlyValue ${getTranslated('jd', context)}'),
            SizedBox(height: height(0.035, context),),
            Text(
              getTranslated('salary', context),
              style: TextStyle(
                  color: HexColor('#363636'),
                  fontSize: width(0.036, context)
              ),
            ),
            SizedBox(height: height(0.015, context),),
            Text('$confirmSalaryValue ${getTranslated('jd', context)}'),

          ],
        ),
      ),
    );
  }

  monthlyInstallmentTextFormField(controller, themeNotifier, onChanged){
    ServicesProvider servicesProvider = Provider.of<ServicesProvider>(context);
    bool rightInput = (servicesProvider.monthlyInstallmentController.text.isNotEmpty &&
        double.tryParse(servicesProvider.monthlyInstallmentController.text) >= minSalary &&
        double.tryParse(servicesProvider.monthlyInstallmentController.text) <= maxSalary);
    return Container(
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextFormField(
        enabled: minSalary != maxSalary,
        textAlignVertical: TextAlignVertical.center,
        textAlign: TextAlign.center,
        controller: controller,
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[0-9]'))],
        style: TextStyle(
          fontSize: isTablet(context) ? 20 : 15,
          color: minSalary != maxSalary ? HexColor('#363636') : Colors.grey,
        ),
        cursorColor: themeNotifier.isLight()
            ? getPrimaryColor(context, themeNotifier)
            : Colors.white,
        cursorWidth: 1,
        decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(horizontal: 5.0, vertical: isTablet(context) ? 20 : 0,),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: rightInput
                  ? getPrimaryColor(context, themeNotifier) : HexColor('#BC0D0D'),
                width: 0.5,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: rightInput
                  ? getPrimaryColor(context, themeNotifier) : HexColor('#BC0D0D'),
                width: 0.8,
              ),
            )
        ),
        onChanged: onChanged,
        onTapOutside: (_){
          if(!rightInput){
            if(servicesProvider.monthlyInstallmentController.text.isEmpty ||
                double.tryParse(servicesProvider.monthlyInstallmentController.text) < minSalary){
              servicesProvider.monthlyInstallmentController.text = minSalary.toString();
            } else if(double.tryParse(servicesProvider.monthlyInstallmentController.text) > maxSalary){
              servicesProvider.monthlyInstallmentController.text = maxSalary.toString();
            }
            setState(() {});
          }
        },
      ),
    );
  }

  Widget buildDropDown(context, List listOfItems, flag, provider) {
    return InkWell(
      onTap: () {
        DropDownState(
          DropDown(
            isSearchVisible: true,
            data: listOfItems ?? [],
            selectedItems: (List selectedList) {
              for (var item in selectedList) {
                setState((){
                  if(flag == 1) {
                    selectedRate = item;
                  }
                  if(flag == 2) {
                    selectedYear = item;
                  }
                  if(flag == 3) {
                    selectedMonth = item;
                  }
                });
              }
              if(flag == 1 || flag == 2){
                double temp = 0;
                for(int i=1 ; i<=int.tryParse(selectedYear.name) ; i++){
                  temp += (currentSliderValue + temp) * (double.tryParse(selectedRate.name) / 100);
                }
                // ** each user has a maximum salary **
                // ** check if the new salary is less than the maximum salary before update [ confirmSalaryValue && confirmMonthlyValue ] **
                if((currentSliderValue + temp) < double.tryParse(servicesProvider.result['cur_getdata'][0][0]['MAXIMUMSALARYFORCHOOSE'].toString())) {
                  confirmSalaryValue = (currentSliderValue + temp).toStringAsFixed(3);
                  confirmMonthlyValue = ((currentSliderValue + temp) * ((double.tryParse(servicesProvider.result['cur_getdata'][0][0]['REG_PER'].toString())) / 100)).toStringAsFixed(3);
                } else{
                  flag == 1 ? selectedRate = SelectedListItem(name: '0', natCode: null, flag: '') : selectedYear = SelectedListItem(name: '0', natCode: null, flag: '');
                  /// TODO: check with the back-end if the problem solved
                  // setState(() {
                  //   showMyDialog(context, 'failed', getTranslated('yourMaximumSalaryLimitIs', context) + ' ' + servicesProvider.result['cur_getdata'][0][0]['MAXIMUMSALARYFORCHOOSE'].toString(), 'ok', themeNotifier);
                  // });
                }
              } else{
                confirmSalaryValue = double.parse(selectedMonth.value).toStringAsFixed(3);
                confirmMonthlyValue = (servicesProvider.result['cur_getdata'][0][0]['LAST_SALARY'] * ((double.tryParse(servicesProvider.result['cur_getdata'][0][0]['REG_PER'].toString())) / 100)).toStringAsFixed(3);
              }
            },
            enableMultipleSelection: false,
          ),
        ).showModal(context);
      },
      child: Container(
          alignment: UserConfig.instance.isLanguageEnglish()
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
              Text(
                flag == 1 ? '${selectedRate.name} %' : flag == 2 ? selectedYear.name : selectedMonth.name,
                style: TextStyle(
                    color: HexColor('#363636'),
                    fontSize: 15
                ),
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

  Widget customRadioButtonGroup(List choices, setState){
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
                    selectedCalculateAccordingTo = choices[index];
                    if(selectedCalculateAccordingTo == 'lastSalary'){
                      submissionType = 1;
                      currentSliderValue = double.tryParse(
                          (double.tryParse(servicesProvider.result['cur_getdata'][0][0]['LAST_SALARY'].toString()) > double.tryParse(servicesProvider.result['cur_getdata'][0][0]['MINIMUMSALARYFORCHOOSE'].toString())
                              ? servicesProvider.result['cur_getdata'][0][0]['LAST_SALARY'] : servicesProvider.result['cur_getdata'][0][0]['MINIMUMSALARYFORCHOOSE']).toString());
                      confirmSalaryValue = currentSliderValue.toStringAsFixed(2);
                      confirmMonthlyValue = (currentSliderValue * ((double.tryParse(servicesProvider.result['cur_getdata'][0][0]['REG_PER'].toString())) / 100)).toStringAsFixed(3);
                    }else if(selectedCalculateAccordingTo == 'increaseInAllowanceForDeductionYears'){
                      submissionType = 2;
                      currentSliderValue = double.tryParse(
                          (double.tryParse(servicesProvider.result['cur_getdata'][0][0]['LAST_SALARY'].toString()) > double.tryParse(servicesProvider.result['cur_getdata'][0][0]['MINIMUMSALARYFORCHOOSE'].toString())
                              ? servicesProvider.result['cur_getdata'][0][0]['LAST_SALARY'] : servicesProvider.result['cur_getdata'][0][0]['MINIMUMSALARYFORCHOOSE']).toString());
                      selectedRate = selectedYear = SelectedListItem(name: '0', natCode: null, flag: '');
                      confirmSalaryValue = ((currentSliderValue * (double.tryParse(selectedRate.name) / 100) + currentSliderValue)).toStringAsFixed(3);
                      confirmMonthlyValue = ((currentSliderValue * (double.tryParse(selectedRate.name) / 100) + currentSliderValue) * ((double.tryParse(servicesProvider.result['cur_getdata'][0][0]['REG_PER'].toString())) / 100)).toStringAsFixed(3);
                    } else if(selectedCalculateAccordingTo == 'discountNotMoreThan-20'){
                      submissionType = 3;
                      currentSliderValue = maxSalary;
                      servicesProvider.monthlyInstallmentController.text = currentSliderValue.toStringAsFixed(3);
                      confirmSalaryValue = currentSliderValue.toStringAsFixed(2);
                      confirmMonthlyValue = (currentSliderValue * ((double.tryParse(servicesProvider.result['cur_getdata'][0][0]['REG_PER'].toString())) / 100)).toStringAsFixed(3);
                    } else if(selectedCalculateAccordingTo == 'lastSalaryAccordingToTheDefenseLaw'){
                      submissionType = 5;
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
                        backgroundColor: choices[index] == selectedCalculateAccordingTo
                            ? HexColor('#2D452E') : Colors.transparent,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        getTranslated(choices[index], context),
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
    );
  }

}