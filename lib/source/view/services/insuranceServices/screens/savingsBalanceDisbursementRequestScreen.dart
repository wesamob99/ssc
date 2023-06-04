// ignore_for_file: file_names

import 'package:drop_down_list/model/selected_list_item.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
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

class SavingsBalanceDisbursementRequestScreen extends StatefulWidget {
  const SavingsBalanceDisbursementRequestScreen({Key key}) : super(key: key);

  @override
  State<SavingsBalanceDisbursementRequestScreen> createState() => _SavingsBalanceDisbursementRequestScreenState();
}

class _SavingsBalanceDisbursementRequestScreenState extends State<SavingsBalanceDisbursementRequestScreen> {

  ServicesProvider servicesProvider;
  ThemeNotifier themeNotifier;
  bool termsChecked = false;
  // ignore: prefer_typing_uninitialized_variables
  DateTime selectedDate;
  String areYouStillOnTopOfYourJob = 'yes';
  List docs = [];

  checkContinueEnabled({flag = 0}){
    if(flag == 1){
      return servicesProvider.disableMobileValidations ? servicesProvider.mobileNumberController.text.isNotEmpty : mobileNumberValidate(servicesProvider.mobileNumberController.text);
    } else if(flag == 2){
      if(servicesProvider.isMobileNumberUpdated){
        return Provider.of<ServicesProvider>(context, listen: false).pinPutFilled;
      } else{
        return true;
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
    servicesProvider.activePayment = [];
    servicesProvider.getActivePayment("2", servicesProvider.result['cur_getdata'][0][0]['NAT'] == "111" ? '1' : '2').whenComplete(() {}).then((value) {
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
                        const DocumentsScreen(nextStep: 'receiptOfAllowances', numberOfSteps: 5, data: {}, serviceType: 4, dependents: [], relations: [], nextStepNumber: 4, stepText: 'thirdStep',),
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
                                    // await servicesProvider.setMaternityAllowanceApplication(
                                    //     docs, paymentInfo,
                                    //     !(selectedNewbornNationality == 'nonJordanian' && selectedPlaceOfBirth == 'outsideJordan') ? newBornData : null,
                                    //     isTherePermitToExpectHisBirth == 'yes' ? 1 : 0,
                                    //     !(selectedNewbornNationality == 'nonJordanian' && selectedPlaceOfBirth == 'outsideJordan') ? newbornNationalNumberController.text : null,
                                    //     (selectedNewbornNationality == 'nonJordanian' && selectedPlaceOfBirth == 'outsideJordan') ? newbornNationalNumberController.text : null,
                                    //     selectedNewbornNationality == 'jordanian' ? 1 : 0,
                                    //     selectedPlaceOfBirth == 'insideJordan' ? 1 : 0,
                                    //     selectedMinDate, selectedMinDate.add(Duration(days: servicesProvider.result['p_per_info'][0][0]['MAT_VAC_PERIOD'] - 1)), selectedDateOfBirth
                                    // ).whenComplete(() {}).then((value) {
                                    //   if(value != null && value['P_Message'] != null && value['P_Message'][0][0]['PO_STATUS'] == 0){
                                    //     message = getTranslated('youCanCheckAndFollowItsStatusFromMyOrdersScreen', context);
                                    //     if(value['PO_TYPE'] == 2){
                                    //       message = UserConfig.instance.isLanguageEnglish()
                                    //           ? value['P_Message'][0][0]['PO_STATUS_DESC_EN'] : value['P_Message'][0][0]['PO_STATUS_DESC_AR'];
                                    //     }
                                    //     showMyDialog(context, 'yourRequestHasBeenSentSuccessfully',
                                    //         message, 'ok',
                                    //         themeNotifier,
                                    //         icon: 'assets/icons/serviceSuccess.svg', titleColor: '#2D452E').then((_){
                                    //       SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
                                    //         servicesProvider.selectedServiceRate = -1;
                                    //         servicesProvider.notifyMe();
                                    //         rateServiceBottomSheet(context, themeNotifier, servicesProvider);
                                    //       });
                                    //     });
                                    //   } else{
                                    //     message = UserConfig.instance.isLanguageEnglish()
                                    //         ? value['P_Message'][0][0]['PO_STATUS_DESC_EN'] : value['P_Message'][0][0]['PO_STATUS_DESC_AR'];
                                    //     showMyDialog(context, 'failed', message, 'cancel', themeNotifier);
                                    //   }
                                    // });
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
                  getTranslated('workingStatus', context),
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
                      '${getTranslated('next', context)}: ${getTranslated('exchangePurposes', context)}',
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
            buildNoteField(context, getTranslated('ifYouAreSuspendedFromYourWorkDesc', context), 50.0),
            const SizedBox(height: 30.0,),
            buildFieldTitle(context, 'areYouStillOnTopOfYourJob', required: false),
            const SizedBox(height: 10.0,),
            customTwoRadioButtons(1, 'yes', 'no', setState),
            const SizedBox(height: 20.0,),
            if(areYouStillOnTopOfYourJob == 'yes')
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
                          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                          decoration: BoxDecoration(
                            color: const Color.fromRGBO(0, 121, 5, 0.38),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Text(
                            getTranslated('onTopOfHisWork', context),
                            style: TextStyle(
                              color: HexColor('#2D452E'),
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5.0,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          servicesProvider.result['cur_getdata'][0][0]['LAST_EST_NAME'] ?? '',
                          style: TextStyle(
                            height: 1.4,
                            color: themeNotifier.isLight() ? HexColor('#363636') : Colors.white,
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10.0,),
                    Text(
                      '${servicesProvider.result['cur_getdata'][0][0]['LAST_EST_NO']}',
                      style: TextStyle(
                        color: themeNotifier.isLight() ? HexColor('#716F6F') : Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if(areYouStillOnTopOfYourJob == 'no')
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
                          onConfirm: (date) {
                            setState(() {
                              selectedDate = date;
                            });
                          },
                          currentTime: selectedDate,
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
                    itemCount: 10,
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index){
                      DateTime date = selectedDate.add(Duration(days: index));
                      String dayNameArabic = DateFormat.EEEE('ar').format(date); // Get the day name in Arabic
                      String dayNameEnglish = DateFormat.EEEE('en').format(date); // Get the day name in English
                      String dayNumber = DateFormat('d').format(date);
                      return Row(
                        children: [
                          InkWell(
                            onTap: (){
                              setState(() {
                                selectedDate = date;
                              });
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                  color: selectedDate == date ? primaryColor : Colors.transparent,
                                  borderRadius: BorderRadius.circular(8.0),
                                  border: Border.all(
                                    color: selectedDate == date ? Colors.transparent : HexColor('#979797'),
                                  )
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    dayNumber,
                                    style: TextStyle(
                                      color: selectedDate == date ? HexColor('#FFFFFF') : HexColor('#363636'),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 5.0,),
                                  Text(
                                    UserConfig.instance.isLanguageEnglish() ? dayNameEnglish : dayNameArabic,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: selectedDate == date ? HexColor('#FFFFFF') : HexColor('#363636'),
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
                ),
              ],
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
                areYouStillOnTopOfYourJob = firstChoice;
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
                  backgroundColor: (flag == 1 && areYouStillOnTopOfYourJob == firstChoice)
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
                areYouStillOnTopOfYourJob = secondChoice;
                selectedDate = DateTime.now();
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
                  backgroundColor: (flag == 1 && areYouStillOnTopOfYourJob == secondChoice)
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

