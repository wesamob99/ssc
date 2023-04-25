// ignore_for_file: file_names

import 'package:drop_down_list/model/selected_list_item.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
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

class OneTimeCompensationRequestScreen extends StatefulWidget {
  const OneTimeCompensationRequestScreen({Key key}) : super(key: key);

  @override
  State<OneTimeCompensationRequestScreen> createState() => _OneTimeCompensationRequestScreenState();
}

class _OneTimeCompensationRequestScreenState extends State<OneTimeCompensationRequestScreen> {

  ServicesProvider servicesProvider;
  ThemeNotifier themeNotifier;
  int selectedInheritorMobileCountry = 962;

  SelectedListItem selectedMobileCountry = SelectedListItem(
    name: UserConfig.instance.isLanguageEnglish() ? "Jordan" : "الأردن",
    value: "962", natCode: 111,
    flag: countries[110].flag,
  );
  List<SelectedListItem> selectedListItem = [];


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
  List docs = [];

  Map selectedActivePayment;
  List activePayment = [];
  TextEditingController nationalIdController = TextEditingController();
  TextEditingController deceasedNationalIdController = TextEditingController();
  TextEditingController quatrainNounController = TextEditingController();
  TextEditingController dependentMobileNumberController = TextEditingController();

  TextEditingController guardianNationalNumberController = TextEditingController();
  TextEditingController guardianSecondFieldController = TextEditingController(); // if the guardian is jordanian => the controller is for (guardian card number) else => the controller is for the (guardian name)
  TextEditingController ageController = TextEditingController();

  ///

  bool nonJordanianSaveEnabled = false;
  String nationality = 'jordanian';
  String guardianshipNationality = 'jordanian';
  String heirNationality = 'jordanian';
  int deathType = 0;
  int deathPlace = 0;
  int relationshipType = 0;
  List<String> deathTypes = ['choose', 'aNaturalDeathWithinTheService', 'injuriesDeath'];
  List<String> deathPlaces = ['choose', 'insideJordan', 'outsideJordan'];
  List<String> relationshipTypes = [];
  DateTime selectedDateOfBirth = DateTime.now();
  DateTime selectedDeathDate = DateTime.now();

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
      return true;
    } else if(flag == 5){
      return termsChecked;
    }
    return true;
  }

  @override
  void initState() {
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
    themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);
    servicesProvider.stepNumber = 1;
    servicesProvider.uploadedFiles = {
      "mandatory": [],
      "optional": [],
    };
    ///
    servicesProvider.penDeathLookup().whenComplete(() {}).then((value) {
      value['Relative_type_getdata'][0].forEach((element){
        if(!relationshipTypes.contains(UserConfig.instance.isLanguageEnglish() ? element['REL_DESC_EN'] : element['REL_DESC_AR'])){
          relationshipTypes.add(UserConfig.instance.isLanguageEnglish() ? element['REL_DESC_EN'] : element['REL_DESC_AR']);
        }
      });
    });
    servicesProvider.isNationalIdValid = false;
    selectedListItem = [];
    for (var element in servicesProvider.countries) {
      int inx = countries.indexWhere((value) => value.dialCode == element.callingCode);
      selectedListItem.add(
        SelectedListItem(
          name: UserConfig.instance.isLanguageEnglish() ? countries[inx == -1 ? 0 : inx].name : element.country,
          natCode: element.natcode,
          value: countries[inx == -1 ? 0 : inx].dialCode,
          isSelected: false,
          flag: countries[inx == -1 ? 0 : inx].flag,
        ),
      );
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: (servicesProvider.documentsScreensStepNumber == 1 || servicesProvider.documentsScreensStepNumber == 3) && servicesProvider.stepNumber == 3
          ? HexColor('#445740') : HexColor('#ffffff'),
      appBar: AppBar(
        centerTitle: false,
        title: Text(getTranslated('oneTimeCompensationRequest', context)),
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
                  case 3:
                    {
                      if(dependentIndex > 0){
                        dependentIndex--;
                        dependentMobileNumberController.text = servicesProvider.deadPersonInfo['cur_getdata2'][0][dependentIndex]['MOBILE'].toString() ?? '';
                        selectedInheritorMobileCountry = servicesProvider.deadPersonInfo['cur_getdata2'][0][dependentIndex]['INTERNATIONAL_CODE'] ?? 962;
                        guardianshipNationality = (servicesProvider.deadPersonInfo['cur_getdata2'][0][dependentIndex]['GUARDIANNAT'] == 1 ? 'jordanian' : 'nonJordanian') ?? "jordanian";
                        guardianNationalNumberController.text = servicesProvider.deadPersonInfo['cur_getdata2'][0][dependentIndex]['GUARDIANNATNO'] ?? "";
                        guardianSecondFieldController.text = (guardianshipNationality == 'jordanian'
                            ? servicesProvider.deadPersonInfo['cur_getdata2'][0][dependentIndex]['GUARDIANCARDNO']
                            : servicesProvider.deadPersonInfo['cur_getdata2'][0][dependentIndex]['GUARDIANNAME']
                        ) ?? "";
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
                        const DocumentsScreen(nextStep: 'receiptOfAllowances', numberOfSteps: 5, data: {
                          "PAYMENT_METHOD": 3,
                          "BANK_LOCATION": 1,
                          "BRANCH_ID": 1002,
                          "BRANCH_NAME": "",
                          "BANK_ID": 1000,
                          "BANK_NAME": "",
                          "ACCOUNT_NAME": "",
                          "PAYMENT_COUNTRY": "",
                          "PAYMENT_COUNTRY_CODE": "",
                          "PAYMENT_PHONE": "",
                          "IFSC": "",
                          "SWIFT_CODE": "",
                          "BANK_DETAILS": "",
                          "IBAN": null,
                          "CASH_BANK_ID": "",
                          "REP_NATIONALITY": "",
                          "REP_NATIONAL_NO": "",
                          "REP_NAME": "",
                          "WALLET_TYPE": "",
                          "WALLET_OTP_VERIVIED": null,
                          "WALLET_OTP": null,
                          "WALLET_PHONE": "",
                          "WALLET_PHONE_VERIVIED": "",
                          "WALLET_PASSPORT_NUMBER": "",
                          "PEN_IBAN": null,
                          "SECNO": 9762053076,
                          "NAT_DESC": "الاردن",
                          "NAT": 111,
                          "NAT_NO": 9762053076,
                          "PERS_NO": null,
                          "LAST_EST_NAME": "شركةالأزياء التقليديه لصناعة الألبسه ذ.م.م",
                          "NAME1": "عنده",
                          "NAME2": "عناد",
                          "NAME3": "ذياب",
                          "NAME4": "الدياب",
                          "FULL_NAME_EN": "",
                          "EMAIL": null,
                          "MOBILE": 789992354,
                          "INTERNATIONAL_CODE": 962,
                          "INSURED_ADDRESS": "s",
                          "MARITAL_STATUS": null,
                          "REGDATE": null,
                          "REGRATE": null,
                          "LAST_SALARY": null,
                          "LAST_STODATE": "01/01/2022",
                          "GENDER": "2",
                          "PEN_START_DATE": null,
                          "DETAILED_ADDRESS": null,
                          "PASS_NO": null,
                          "RESIDENCY_NO": null,
                          "DOB": "22/08/1976",
                          "JOB_NO": null,
                          "JOB_DESC": null,
                          "ENAME1": null,
                          "ENAME2": null,
                          "ENAME3": null,
                          "ENAME4": null,
                          "LAST_EST_NO": 1621500,
                          "FAM_NO": null,
                          "nextVaild": null,
                          "wantAddFamily": null,
                          "GENDER_DESC": "غير معرف",
                          "PI_EPAY": null,
                          "INSURED": null,
                          "COMPENSATION_REASON": 5,
                          "CLEARANCE_NO": null,
                          "OFFNO": 60,
                          "CLEARANCE_FLAG": 1,
                          "IS_ARMY": 0,
                          "Marriage_contract": 0,
                          "ID": null,
                          "DEP_FLAG": 0
                        }, serviceType: 11, dependents: [], relations: [], nextStepNumber: 4,),
                      if(Provider.of<ServicesProvider>(context).stepNumber == 4)
                        const PaymentScreen(numberOfSteps: 5, nextStep: 'confirmRequest', stepText: 'forthStep', stepNumber: 4,),
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
                                  servicesProvider.documentsScreensStepNumber = 1;
                                  if(dependentIndex < ((servicesProvider.deadPersonInfo['cur_getdata2'].length != 0  && servicesProvider.deadPersonInfo['cur_getdata2'][0].length != 0) ? servicesProvider.deadPersonInfo['cur_getdata2'][0].length - 1 : 0)){
                                    dependentIndex++;
                                    dependentMobileNumberController.text = (servicesProvider.deadPersonInfo['cur_getdata2'][0][dependentIndex]['MOBILE'] ?? '').toString() ?? '';
                                    selectedInheritorMobileCountry = servicesProvider.deadPersonInfo['cur_getdata2'][0][dependentIndex]['INTERNATIONAL_CODE'] ?? 962;
                                    guardianNationalNumberController.text = servicesProvider.deadPersonInfo['cur_getdata2'][0][dependentIndex]['GUARDIANNATNO'] ?? "";
                                    guardianshipNationality = (servicesProvider.deadPersonInfo['cur_getdata2'][0][dependentIndex]['GUARDIANNAT'] == 1 ? 'jordanian' : 'nonJordanian') ?? "jordanian";
                                    guardianSecondFieldController.text = (guardianshipNationality == 'jordanian'
                                        ? servicesProvider.deadPersonInfo['cur_getdata2'][0][dependentIndex]['GUARDIANCARDNO']
                                        : servicesProvider.deadPersonInfo['cur_getdata2'][0][dependentIndex]['GUARDIANNAME']
                                    ) ?? "";
                                  }else {
                                    servicesProvider.notifyMe();
                                    servicesProvider.stepNumber = 4;
                                  }
                                }
                              } break;
                              case 5: {
                                try{
                                  String message = '';
                                  servicesProvider.isLoading = true;
                                  servicesProvider.isModalLoading = false;
                                  servicesProvider.notifyMe();
                                  List mandatoryDocs = await saveFiles('mandatory');
                                  List optionalDocs = await saveFiles('optional');
                                  docs.addAll(mandatoryDocs + optionalDocs);
                                  await servicesProvider.setDeceasedRetirementApplication(docs, deathPlace).whenComplete(() {}).then((value) {
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
              bool isDependentDoc = false;
              if(type == 'mandatory' && servicesProvider.deadPersonInfo['cur_getdata2'].isNotEmpty){
                servicesProvider.deadPersonInfo['cur_getdata2'][0].forEach((element) {
                  element['INHERITOR_DOCS'] = [];
                  if(element['NATIONALNUMBER'].toString() == servicesProvider.uploadedFiles[type][i][j]["document"]['CODE'].toString()){
                    document = {
                      "PATH": value['path'],
                      "DOC_TYPE": servicesProvider.uploadedFiles[type][i][j]["document"]["ID"],
                      "FILE": {},
                      "DIRTY": false,
                      "DEP_ID": "${DateTime.now().millisecondsSinceEpoch}${((math.Random().nextDouble() * 10000) + 1).floor()}",
                      "FILE_NAME": path.basename(value['path'].toString()),
                      "DOCUMENT_DATE": DateFormat("dd/MM/yyyy", 'en').format(DateTime.now()),
                      "required": type == 'mandatory' ? 0 : 1,
                      "ID": "",
                      "STATUS": 1,
                    };
                    isDependentDoc = true;
                    if(element['INHERITOR_DOCS'] is String){
                      element['INHERITOR_DOCS'] = [document];
                    }else{
                      element['INHERITOR_DOCS'].add(document);
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
                      '${getTranslated('next', context)}: ${getTranslated('heirsInformation', context)}',
                      style: TextStyle(
                          color: HexColor('#979797'),
                          fontSize: width(0.032, context)
                      ),
                    ),
                  ],
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
                  getTranslated('deceasedTermsAndConditions', context),
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
                      selectedRelation = UserConfig.instance.isLanguageEnglish()
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
                        backgroundColor: (flag == 1 && selectedMaritalStatus == choices[index]) || (flag == 2 && (selectedRelation == (UserConfig.instance.isLanguageEnglish()
                            ? choices[index]['REL_DESC_EN'] : choices[index]['REL_DESC_AR'])))  || (flag == 3 && selectedActivePayment == choices[index])
                            ? HexColor('#2D452E') : Colors.transparent,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        flag == 1
                            ? getTranslated(choices[index], context)
                            : UserConfig.instance.isLanguageEnglish()
                            ? choices[index][flag == 3 ? 'NAME_EN' : 'REL_DESC_EN'] : choices[index][flag == 3 ? 'NAME_AR' : 'REL_DESC_AR'],
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

enum ContextMenu { edit, delete }

