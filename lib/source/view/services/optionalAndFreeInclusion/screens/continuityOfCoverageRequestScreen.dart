// ignore_for_file: file_names, use_build_context_synchronously

import 'package:drop_down_list/drop_down_list.dart';
import 'package:drop_down_list/model/selected_list_item.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
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

class ContinuityOfCoverageRequestScreen extends StatefulWidget {
  const ContinuityOfCoverageRequestScreen({Key key}) : super(key: key);

  @override
  State<ContinuityOfCoverageRequestScreen> createState() => _ContinuityOfCoverageRequestScreenState();
}

class _ContinuityOfCoverageRequestScreenState extends State<ContinuityOfCoverageRequestScreen> {
  ServicesProvider servicesProvider;
  String confirmSalaryValue = '';
  String confirmMonthlyValue = '';
  double salary;
  List<SelectedListItem> listOfRates = [];
  SelectedListItem selectedRate = SelectedListItem(name: '0', natCode: null, flag: '');

  @override
  void initState() {
    servicesProvider = Provider.of<ServicesProvider>(context, listen: false);
    servicesProvider.mobileNumberController.text = UserSecuredStorage.instance.realMobileNumber;
    servicesProvider.stepNumber = 1;
    listOfRates = [];
    for(int i=0 ; i<=servicesProvider.result['cur_getdata'][0][0]['MAX_PER_OF_INC'] ; i++){
      listOfRates.add(SelectedListItem(name: '$i', natCode: null, flag: ''));
    }

    salary = double.parse(servicesProvider.result['cur_getdata'][0][0]['SALARY'].toString());
    confirmSalaryValue = double.tryParse(servicesProvider.result['cur_getdata'][0][0]['SALARY']).toStringAsFixed(3);
    confirmMonthlyValue = (double.tryParse(servicesProvider.result['cur_getdata'][0][0]['SALARY']) * (double.tryParse(servicesProvider.result['cur_getdata'][0][0]['REG_PER'].toString())) / 100).toStringAsFixed(3);
    super.initState();
  }

  checkContinueEnabled({flag = 0}){
    if(flag == 1){
      return mobileNumberValidate(servicesProvider.mobileNumberController.text);
    } else if(flag == 2){
      if(servicesProvider.isMobileNumberUpdated){
        return Provider.of<ServicesProvider>(context, listen: false).pinPutFilled;
      } else{
        return true;
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
        title: Text(translate('requestToAmendTheAnnualIncreasePercentage', context)),
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: InkWell(
            onTap: (){
              switch(servicesProvider.stepNumber){
                case 1: Navigator.of(context).pop(); break;
                case 2:
                  {

                    servicesProvider.stepNumber = 1;
                  } break;
                case 3: servicesProvider.stepNumber = 2; break;
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
                            String message = translate('somethingWrongHappened', context);
                            servicesProvider.isLoading = true;
                            servicesProvider.notifyMe();
                            var value = await servicesProvider.submitOptionSubIncrement(int.tryParse(selectedRate.name.toString()), double.tryParse(confirmSalaryValue));
                            servicesProvider.isLoading = false;
                            servicesProvider.notifyMe();
                            if(value != '') {
                              message = UserConfig.instance.checkLanguage()
                                  ? value['PO_status_desc_en'] : value['PO_status_desc_ar'];
                            }
                            showMyDialog(context, (value != '' && value['PO_status'] == 0) ? 'currentRateOfIncreaseDoneSuccessfully' : 'failed',
                                message, (value != '' && value['PO_status'] == 0) ? '#ok' : 'cancel',
                                themeNotifier,
                                titleColor: (value != '' && value['PO_status'] == 0) ? '#2D452E' : '#ED3124',
                                icon: (value != '' && value['PO_status'] == 0) ? 'assets/icons/serviceSuccess.svg' : 'assets/icons/loginError.svg').then((_){
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
                  translate('payCalculation', context),
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
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  translate('currentRateOfIncrease', context),
                  style: TextStyle(
                      color: HexColor('#363636'),
                      fontSize: width(0.032, context)
                  ),
                ),
                const SizedBox(width: 10.0),
                Text(
                  '${servicesProvider.result['cur_getdata'][0][0]['INCR_TYPE']} %',
                  style: TextStyle(
                    color: HexColor('#2D452E'),
                    fontSize: width(0.032, context),
                    fontWeight: FontWeight.bold
                  ),
                ),
              ],
            ),
            SizedBox(height: height(0.03, context),),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  translate('rateOfIncrease', context),
                  style: TextStyle(
                      color: HexColor('#363636'),
                      fontSize: width(0.032, context)
                  ),
                ),
                SizedBox(height: height(0.015, context),),
                buildDropDown(context, listOfRates, 1, servicesProvider),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: height(0.02, context),),
                Text(
                  translate('monthlyInstallment', context) + (UserConfig.instance.checkLanguage() ? ' is :' : ' هو :'),
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
                          translate('jd', context),
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
                  translate('salary', context) + (UserConfig.instance.checkLanguage() ? ' is :' : ' هو :'),
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
                          translate('jd', context),
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
                  translate('thirdStep', context),
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
                      '3/3',
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
            SizedBox(height: height(0.035, context),),
            Text(
              translate('rateOfIncrease', context),
              style: TextStyle(
                  color: HexColor('#363636'),
                  fontSize: width(0.036, context)
              ),
            ),
            SizedBox(height: height(0.015, context),),
            Text('${selectedRate.name} %'),
            SizedBox(height: height(0.035, context),),
            Text(
              translate('monthlyInstallment', context),
              style: TextStyle(
                  color: HexColor('#363636'),
                  fontSize: width(0.036, context)
              ),
            ),
            SizedBox(height: height(0.015, context),),
            Text('$confirmMonthlyValue ${translate('jd', context)}'),
            SizedBox(height: height(0.035, context),),
            Text(
              translate('salary', context),
              style: TextStyle(
                  color: HexColor('#363636'),
                  fontSize: width(0.036, context)
              ),
            ),
            SizedBox(height: height(0.015, context),),
            Text('$confirmSalaryValue ${translate('jd', context)}'),

          ],
        ),
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
                  selectedRate = item;
                });
              }
              double temp = (salary) * (double.tryParse(selectedRate.name) / 100);
              String tempSalVal = (salary + temp).toStringAsFixed(3);
              String tempMonVal = ((salary + temp) * ((double.tryParse(servicesProvider.result['cur_getdata'][0][0]['REG_PER'].toString())) / 100)).toStringAsFixed(3);
              if(double.tryParse(servicesProvider.result['cur_getdata'][0][0]['MINIMUMSALARYFORCHOOSE'].toString()) < double.tryParse(tempSalVal) && double.tryParse(servicesProvider.result['cur_getdata'][0][0]['MAXIMUMSALARYFORCHOOSE'].toString()) > double.tryParse(tempSalVal)){
                confirmSalaryValue = tempSalVal;
                confirmMonthlyValue = tempMonVal;
              }else{
                // Navigator.of(context).pop();
                setState((){
                  selectedRate = SelectedListItem(name: '0', natCode: null, flag: '');
                });
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
              Text(
                '${selectedRate.name} %',
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
}