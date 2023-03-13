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
import '../../shared/verifyMobileNumberScreen.dart';

class DeceasedRetirementApplicationScreen extends StatefulWidget {
  const DeceasedRetirementApplicationScreen({Key key}) : super(key: key);

  @override
  State<DeceasedRetirementApplicationScreen> createState() => _DeceasedRetirementApplicationScreenState();
}

class _DeceasedRetirementApplicationScreenState extends State<DeceasedRetirementApplicationScreen> {

  ServicesProvider servicesProvider;
  ThemeNotifier themeNotifier;
  int selectedInheritorMobileCountry = 962;

  SelectedListItem selectedMobileCountry = SelectedListItem(
    name: UserConfig.instance.checkLanguage() ? "Jordan" : "الأردن",
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
  TextEditingController quatrainNounController = TextEditingController();
  TextEditingController dependentMobileNumberController = TextEditingController();

  TextEditingController guardianNationalNumberController = TextEditingController();
  TextEditingController guardianSecondFieldController = TextEditingController(); // if the guardian is jordanian => the controller is for (guardian card number) else => the controller is for the (guardian name)

  ///

  String nationality = 'jordanian';
  String guardianshipNationality = 'jordanian';
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
        if(nationality == 'jordanian'){
          return nationalIdController.text.isNotEmpty && servicesProvider.isNationalIdValid && deathType != 0 && deathPlace != 0;
        }else{
          return nationalIdController.text.isNotEmpty && servicesProvider.isNationalIdValid && deathType != 0 && deathPlace != 0;
        }
      }
    } else if(flag == 3){
      if(servicesProvider.deadPersonInfo['cur_getdata2'].isNotEmpty && double.tryParse(servicesProvider.deadPersonInfo['cur_getdata2'][0][dependentIndex]['AGE'].toString()) >= 18){
        return servicesProvider.deadPersonInfo['cur_getdata2'][0][dependentIndex]['validPhone'];
      } else{
        return servicesProvider.deadPersonInfo['cur_getdata2'].isEmpty || servicesProvider.deadPersonInfo['cur_getdata2'][0][dependentIndex]['validPhone'] && (servicesProvider.deadPersonInfo['cur_getdata2'][0][dependentIndex]['GUARDIANNAME'] != "" && servicesProvider.deadPersonInfo['cur_getdata2'][0][dependentIndex]['GUARDIANNAME'] != null);
      }
    } else if(flag == 5){
      return termsChecked;
    }
  }

  @override
  void initState() {
    Provider.of<LoginProvider>(context, listen: false).readCountriesJson();
    servicesProvider = Provider.of<ServicesProvider>(context, listen: false);
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
    ///
    servicesProvider.penDeathLookup().whenComplete(() {}).then((value) {
      value['Relative_type_getdata'][0].forEach((element){
        if(!relationshipTypes.contains(UserConfig.instance.checkLanguage() ? element['REL_DESC_EN'] : element['REL_DESC_AR'])){
          relationshipTypes.add(UserConfig.instance.checkLanguage() ? element['REL_DESC_EN'] : element['REL_DESC_AR']);
        }
      });
      relationshipType = servicesProvider.deadPersonInfo['cur_getdata'][0][0]['RELATIVE_TYPE'];
    });
    servicesProvider.isNationalIdValid = false;
    selectedListItem = [];
    for (var element in servicesProvider.countries) {
      int inx = countries.indexWhere((value) => value.dialCode == element.callingCode);
      selectedListItem.add(
        SelectedListItem(
          name: UserConfig.instance.checkLanguage() ? countries[inx == -1 ? 0 : inx].name : element.country,
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
      backgroundColor: (servicesProvider.documentsScreensStepNumber == 1 || servicesProvider.documentsScreensStepNumber == 3) && servicesProvider.stepNumber == 4
          ? HexColor('#445740') : HexColor('#ffffff'),
      appBar: AppBar(
        centerTitle: false,
        title: Text(getTranslated('deceasedRetirementApplication', context)),
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
                        dependentMobileNumberController.text = servicesProvider.deadPersonInfo['cur_getdata2'][0][dependentIndex]['MOBILE'] ?? '';
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
                        const FirstStepScreen(nextStep: 'ensureFinancialSolvency', numberOfSteps: 5),
                      if(Provider.of<ServicesProvider>(context).stepNumber == 2 && Provider.of<ServicesProvider>(context).isMobileNumberUpdated)
                        VerifyMobileNumberScreen(nextStep: 'ensureFinancialSolvency', numberOfSteps: 5, mobileNo: servicesProvider.mobileNumberController.text ?? ''),
                      if(Provider.of<ServicesProvider>(context).stepNumber == 2 && !Provider.of<ServicesProvider>(context).isMobileNumberUpdated)
                        secondStep(context, themeNotifier),
                      if(Provider.of<ServicesProvider>(context).stepNumber == 3)
                        thirdStep(context, themeNotifier),
                      if(Provider.of<ServicesProvider>(context).stepNumber == 4)
                        DocumentsScreen(nextStep: 'receiptOfAllowances', numberOfSteps: 5, data: {
                          "DEATH_NAT": servicesProvider.deadPersonInfo['cur_getdata'][0][0]['NAT'],
                          "RELATION": servicesProvider.penDeath['Relative_type_getdata'][0].where((element) => (UserConfig.instance.checkLanguage() ? element['REL_DESC_EN'] : element['REL_DESC_AR']) == relationshipTypes[relationshipType]).first['REL_ID'],
                          "IS_INHERITOR": 0,
                          "INHERITORS_FLAG": 1,
                          "MILITARY_WORK_DOC": servicesProvider.deadPersonInfo['cur_getdata'][0][0]['MILITARY_WORK_DOC'],
                        }, serviceType: 11, info: servicesProvider.deadPersonInfo['cur_getdata'][0][0], dependents: servicesProvider.deadPersonInfo['cur_getdata2']),
                      if(Provider.of<ServicesProvider>(context).stepNumber == 5)
                        fifthStep(context, themeNotifier),
                      if(!(Provider.of<ServicesProvider>(context).stepNumber == 4))
                        textButton(context,
                          themeNotifier,
                          Provider.of<ServicesProvider>(context).stepNumber != 4 ? 'continue' : 'send',
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
                                  if(dependentIndex < ((servicesProvider.deadPersonInfo['cur_getdata2'].length != 0  && servicesProvider.deadPersonInfo['cur_getdata2'][0].length != 0) ? servicesProvider.deadPersonInfo['cur_getdata2'][0].length - 1 : 0)){
                                    dependentIndex++;
                                    dependentMobileNumberController.text = servicesProvider.deadPersonInfo['cur_getdata2'][0][dependentIndex]['MOBILE'] ?? '';
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
                                  /// TODO : complete set application
                                  List mandatoryDocs = await saveFiles('mandatory');
                                  List optionalDocs = await saveFiles('optional');
                                  docs.addAll(mandatoryDocs + optionalDocs);
                                  await servicesProvider.setDeceasedRetirementApplication(docs, deathPlace).whenComplete(() {}).then((value) {
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
                "APP_ID": '',
                "ID": "",
                "STATUS": 1,
                "HIDE_ACTIONS": false
              };
              bool isDependentDoc = false;
              if(type == 'mandatory' && servicesProvider.deadPersonInfo['cur_getdata2'].isNotEmpty){
                servicesProvider.deadPersonInfo['cur_getdata2'][0].forEach((element) {
                  if(element['NATIONALNUMBER'].toString() == servicesProvider.uploadedFiles[type][i][j]["document"]['CODE'].toString()){
                    if (kDebugMode) {
                      print('value: $value');
                    }
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
            buildFieldTitle(context, 'nationality', required: false),
            const SizedBox(height: 10.0,),
            customTwoRadioButtons(1, 'jordanian', 'nonJordanian', setState),
            const SizedBox(height: 20.0,),
            buildFieldTitle(context, nationality == 'jordanian' ? 'theNationalNumberOfTheDeceased' : 'thePersonalNumberOfTheDeceased', required: true, filled: nationalIdController.text.length == 10),
            const SizedBox(height: 10.0,),
            buildTextFormField(
                context, themeNotifier, nationalIdController, servicesProvider.isNationalIdValid ? 'val${nationalIdController.text}' : '9999999999', (val) async {
                setState(() {});
                deadPersonSubmitGetDetails();
              }, inputType: TextInputType.number,
            ),
            const SizedBox(height: 20.0,),
            if(servicesProvider.isNationalIdValid)
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
                                    '${servicesProvider.deadPersonInfo['cur_getdata'][0][0]['FULL_NAME_AR'] ?? servicesProvider.deadPersonInfo['cur_getdata'][0][0]['FULL_NAME_EN']}',
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
                                      color: servicesProvider.deadPersonInfo['cur_getdata'][0][0]['RELATIVE_TYPE'] == 11
                                          ? HexColor('#9EBDF8') : const Color.fromRGBO(0, 121, 5, 0.38),
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    child: Text(
                                      getRelationType(servicesProvider.deadPersonInfo['cur_getdata'][0][0]['RELATIVE_TYPE']),
                                      style: TextStyle(
                                        color: servicesProvider.deadPersonInfo['cur_getdata'][0][0]['RELATIVE_TYPE'] == 11
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
                                    servicesProvider.deadPersonInfo['cur_getdata'][0][0][(nationality == 'jordanian' ? 'NAT_NO' : 'PERS_NO')].toString(),
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
                                    getTranslated(nationality, context),
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
                                    getTranslated('deathDate', context) + ": ",
                                    style: TextStyle(
                                      color: themeNotifier.isLight() ? HexColor('#716F6F') : Colors.white70,
                                    ),
                                  ),
                                  Text(
                                    nationality == 'jordanian'
                                    ? servicesProvider.deadPersonInfo['cur_getdata'][0][0]['DEATH_DATE']
                                    : DateFormat('dd/MM/yyyy').format(selectedDeathDate),
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
            SizedBox(height: servicesProvider.isNationalIdValid ? 20.0 : 0,),
            if(nationality == 'nonJordanian')
            Column(
              children: [
                buildFieldTitle(context, 'relationshipWithTheDeceasedPerson', required: false),
                const SizedBox(height: 15.0,),
                dropDownList(relationshipTypes, themeNotifier, 3),
                const SizedBox(height: 20.0,),
              ],
            ),
            buildFieldTitle(context, 'deathType', required: true, filled: deathType != 0),
            const SizedBox(height: 15.0,),
            dropDownList(deathTypes, themeNotifier, 1),
            const SizedBox(height: 20.0,),
            buildFieldTitle(context, 'deathPlace', required: false),
            const SizedBox(height: 15.0,),
            dropDownList(deathPlaces, themeNotifier, 2),
            const SizedBox(height: 20.0,),
            if(nationality == 'nonJordanian')
              Column(
                children: [
                  buildFieldTitle(context, 'DateOfBirth', required: true, filled: selectedDateOfBirth != null),
                  const SizedBox(height: 15.0,),
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
                        onConfirm: (date) async{
                          setState((){
                            selectedDateOfBirth = date;
                          });
                          deadPersonSubmitGetDetails();
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
                  const SizedBox(height: 20.0,),
                  buildFieldTitle(context, 'deathDate', required: true, filled: selectedDateOfBirth != null),
                  const SizedBox(height: 15.0,),
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
                        onConfirm: (date) async{
                          setState((){
                            selectedDeathDate = date;
                          });
                          deadPersonSubmitGetDetails();
                        },
                        currentTime: selectedDeathDate,
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
                            DateFormat('dd/MM/yyyy').format(selectedDeathDate),
                          ),
                          SvgPicture.asset('assets/icons/datePickerIcon.svg'),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20.0,),
                ],
              ),
            const SizedBox(height: 15.0,),
          ],
        ),
      ),
    );
  }

  Widget thirdStep(context, themeNotifier){
    // print(servicesProvider.deadPersonInfo['cur_getdata2'][0][dependentIndex]);
    return SizedBox(
      height: isTablet(context) ? height(0.78, context) : isScreenHasSmallHeight(context) ? height(0.73, context) : height(0.75, context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
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
                        getTranslated('heirsInformation', context),
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
                  Text(
                    getTranslated('numberOfHeirs', context) + ' ( ${(servicesProvider.deadPersonInfo['cur_getdata2'].length != 0  && servicesProvider.deadPersonInfo['cur_getdata2'][0].length != 0) ? dependentIndex + 1 : 0} / ${(servicesProvider.deadPersonInfo['cur_getdata2'].length != 0  && servicesProvider.deadPersonInfo['cur_getdata2'][0].length != 0) ? servicesProvider.deadPersonInfo['cur_getdata2'][0].length : 0} )',
                    style: TextStyle(
                      color: HexColor('#363636'),
                      fontWeight: FontWeight.w500,
                      fontSize: 17,
                    ),
                  ),
                  SizedBox(height: height(0.02, context),),
                  if(servicesProvider.deadPersonInfo['cur_getdata2'].length != 0 && servicesProvider.deadPersonInfo['cur_getdata2'][0].length != 0)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if(double.tryParse(servicesProvider.deadPersonInfo['cur_getdata2'][0][dependentIndex]['AGE'].toString()) < 18)
                      Container(
                        width: width(1, context),
                        decoration: BoxDecoration(
                          color: HexColor('#FFF2CF'),
                          borderRadius: BorderRadius.circular(8.0)
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 10.0,
                              height: 50,
                              decoration: BoxDecoration(
                                  color: HexColor('#FFCA3A'),
                                  borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(UserConfig.instance.checkLanguage() ? 0.0 : 8.0),
                                    bottomRight: Radius.circular(UserConfig.instance.checkLanguage() ? 0.0 : 8.0),
                                    topLeft: Radius.circular(UserConfig.instance.checkLanguage() ? 8.0 : 0.0),
                                    bottomLeft: Radius.circular(UserConfig.instance.checkLanguage() ? 8.0 : 0.0),
                                  )
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10.0),
                              width: width(0.9, context),
                              child: Text(
                                getTranslated('guardianshipArgumentWillBeRequestedInTheCompulsoryDocumentsStep', context),
                                style: TextStyle(
                                  color: HexColor('##B48100'),
                                  fontSize: 12
                                ),
                              ),
                            ),
                          ],
                        )
                      ),
                      const SizedBox(height: 20.0,),
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
                                      servicesProvider.deadPersonInfo['cur_getdata2'][0][dependentIndex]['FULL_NAME'],
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
                                            color: servicesProvider.deadPersonInfo['cur_getdata2'][0][dependentIndex]['RELATIVETYPE'] == 11
                                                ? HexColor('#9EBDF8') : const Color.fromRGBO(0, 121, 5, 0.38),
                                            borderRadius: BorderRadius.circular(8.0),
                                          ),
                                          child: Text(
                                            getRelationType(servicesProvider.deadPersonInfo['cur_getdata2'][0][dependentIndex]['RELATIVETYPE']),
                                            style: TextStyle(
                                              color: servicesProvider.deadPersonInfo['cur_getdata2'][0][dependentIndex]['RELATIVETYPE'] == 11
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
                                                selectedStatus = servicesProvider.deadPersonInfo['cur_getdata2'][0][dependentIndex]['IS_ALIVE'] == 1
                                                    ? 'alive' : 'dead';
                                                selectedJobStatus = servicesProvider.deadPersonInfo['cur_getdata2'][0][dependentIndex]['IS_WORK_A'] == 0
                                                    ? 'unemployed' : 'employed';
                                                selectedGetsSalary = servicesProvider.deadPersonInfo['cur_getdata2'][0][dependentIndex]['IS_RETIRED_A'] == 0
                                                    ? 'no' : 'yes';
                                                selectedHasDisability = servicesProvider.deadPersonInfo['cur_getdata2'][0][dependentIndex]['DISABILITY'] == 0
                                                    ? 'no' : 'yes';
                                                selectedMaritalStatus = servicesProvider.deadPersonInfo['cur_getdata2'][0][dependentIndex]['SOCIAL_STATUS'] == 1
                                                    ? UserConfig.instance.checkLanguage()
                                                    ? 'single' : servicesProvider.deadPersonInfo['cur_getdata2'][0][dependentIndex]['GENDER'] == 1 ? 'singleM' : 'singleF'
                                                    : servicesProvider.deadPersonInfo['cur_getdata2'][0][dependentIndex]['SOCIAL_STATUS'] == 2
                                                    ? UserConfig.instance.checkLanguage()
                                                    ? 'married' : servicesProvider.deadPersonInfo['cur_getdata2'][0][dependentIndex]['GENDER'] == 1 ? 'marriedM' : 'marriedF'
                                                    : servicesProvider.deadPersonInfo['cur_getdata2'][0][dependentIndex]['SOCIAL_STATUS'] == 3
                                                    ? UserConfig.instance.checkLanguage()
                                                    ? 'divorced' : servicesProvider.deadPersonInfo['cur_getdata2'][0][dependentIndex]['GENDER'] == 1 ? 'divorcedM' : 'divorcedF'
                                                    : servicesProvider.deadPersonInfo['cur_getdata2'][0][dependentIndex]['SOCIAL_STATUS'] == 4
                                                    ? UserConfig.instance.checkLanguage()
                                                    ? 'widow' : servicesProvider.deadPersonInfo['cur_getdata2'][0][dependentIndex]['GENDER'] == 1 ? 'widowM' : 'widowF' : 'single';
                                                maritalList = [
                                                  UserConfig.instance.checkLanguage()
                                                      ? 'single'
                                                      : servicesProvider.deadPersonInfo['cur_getdata2'][0][dependentIndex]['GENDER'] == 1 ? 'singleM' : 'singleF',
                                                  UserConfig.instance.checkLanguage()
                                                      ? 'married'
                                                      : servicesProvider.deadPersonInfo['cur_getdata2'][0][dependentIndex]['GENDER'] == 1 ? 'marriedM' : 'marriedF',
                                                  UserConfig.instance.checkLanguage()
                                                      ? 'divorced'
                                                      : servicesProvider.deadPersonInfo['cur_getdata2'][0][dependentIndex]['GENDER'] == 1 ? 'divorcedM' : 'divorcedF',
                                                  UserConfig.instance.checkLanguage()
                                                      ? 'widow'
                                                      : servicesProvider.deadPersonInfo['cur_getdata2'][0][dependentIndex]['GENDER'] == 1 ? 'widowM' : 'widowF',
                                                ];
                                                inheritorModalBottomSheet(dependentIndex);
                                              } break;
                                              case 1: {
                                                showMyDialog(
                                                    context, 'wouldYouLikeToConfirmDeletionOfDependents',
                                                    servicesProvider.deadPersonInfo['cur_getdata2'][0][dependentIndex]['FULL_NAME'],
                                                    'yesContinue', themeNotifier, icon: 'assets/icons/dialogDeleteIcon.svg',
                                                    onPressed: () async{
                                                      String errorMessage = '';
                                                      servicesProvider.isLoading = true;
                                                      servicesProvider.notifyMe();
                                                      try{
                                                        await servicesProvider.deleteDependent(int.tryParse(servicesProvider.deadPersonInfo['cur_getdata2'][0][dependentIndex]["ID"].toString())).then((value){
                                                          Navigator.of(context).pop();
                                                          if(value['PO_RESULT'] == 1){
                                                            servicesProvider.dependentsDocuments.removeWhere((element) => element["CODE"] == servicesProvider.deadPersonInfo['cur_getdata2'][0][dependentIndex]["DEP_CODE"]);
                                                            servicesProvider.deadPersonInfo['cur_getdata2'][0].removeAt(dependentIndex);
                                                            if(dependentIndex == servicesProvider.deadPersonInfo['cur_getdata2'][0].length && dependentIndex != 0){
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
                                              enabled: servicesProvider.deadPersonInfo['cur_getdata2'][0][dependentIndex]['SOURCE_FLAG'] == 2,
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
                                      servicesProvider.deadPersonInfo['cur_getdata2'][0][dependentIndex]['NATIONALNUMBER'],
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
                                          servicesProvider.deadPersonInfo['cur_getdata2'][0][dependentIndex]['NATIONALITY'] == 1
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
                                          getTranslated('maritalStatus', context),
                                          style: TextStyle(
                                            color: themeNotifier.isLight() ? HexColor('#979797') : Colors.white70,
                                            fontSize: isScreenHasSmallWidth(context) ? 12 : 14,
                                          ),
                                        ),
                                        const SizedBox(height: 10.0,),
                                        Text(
                                          getTranslated(
                                              servicesProvider.deadPersonInfo['cur_getdata2'][0][dependentIndex]['SOCIAL_STATUS'] == 1
                                                  ? UserConfig.instance.checkLanguage()
                                                  ? 'single' : servicesProvider.deadPersonInfo['cur_getdata2'][0][dependentIndex]['GENDER'] == 1 ? 'singleM' : 'singleF'
                                                  : servicesProvider.deadPersonInfo['cur_getdata2'][0][dependentIndex]['SOCIAL_STATUS'] == 2
                                                  ? UserConfig.instance.checkLanguage()
                                                  ? 'married' : servicesProvider.deadPersonInfo['cur_getdata2'][0][dependentIndex]['GENDER'] == 1 ? 'marriedM' : 'marriedF'
                                                  : servicesProvider.deadPersonInfo['cur_getdata2'][0][dependentIndex]['SOCIAL_STATUS'] == 3
                                                  ? UserConfig.instance.checkLanguage()
                                                  ? 'divorced' : servicesProvider.deadPersonInfo['cur_getdata2'][0][dependentIndex]['GENDER'] == 1 ? 'divorcedM' : 'divorcedF'
                                                  : servicesProvider.deadPersonInfo['cur_getdata2'][0][dependentIndex]['SOCIAL_STATUS'] == 4
                                                  ? UserConfig.instance.checkLanguage()
                                                  ? 'widow' : servicesProvider.deadPersonInfo['cur_getdata2'][0][dependentIndex]['GENDER'] == 1 ? 'widowM' : 'widowF' : 'single',
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
                                          getTranslated('employmentStatus', context),
                                          style: TextStyle(
                                            color: themeNotifier.isLight() ? HexColor('#979797') : Colors.white70,
                                            fontSize: isScreenHasSmallWidth(context) ? 12 : 14,
                                          ),
                                        ),
                                        const SizedBox(height: 10.0,),
                                        Text(
                                          getTranslated(
                                              servicesProvider.deadPersonInfo['cur_getdata2'][0][dependentIndex]['IS_WORK_A'] == 0
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
                                          getTranslated('status', context),
                                          style: TextStyle(
                                            color: themeNotifier.isLight() ? HexColor('#979797') : Colors.white70,
                                            fontSize: isScreenHasSmallWidth(context) ? 12 : 14,
                                          ),
                                        ),
                                        const SizedBox(height: 10.0,),
                                        Text(
                                          getTranslated(
                                              servicesProvider.deadPersonInfo['cur_getdata2'][0][dependentIndex]['IS_ALIVE'] == 1
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
                                          getTranslated('hasDisability', context),
                                          style: TextStyle(
                                            color: themeNotifier.isLight() ? HexColor('#979797') : Colors.white70,
                                            fontSize: isScreenHasSmallWidth(context) ? 12 : 14,
                                          ),
                                        ),
                                        const SizedBox(height: 10.0,),
                                        Text(
                                          getTranslated(
                                              servicesProvider.deadPersonInfo['cur_getdata2'][0][dependentIndex]['DISABILITY'] == 0
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
                                          getTranslated('getsSalary', context),
                                          style: TextStyle(
                                            color: themeNotifier.isLight() ? HexColor('#979797') : Colors.white70,
                                            fontSize: isScreenHasSmallWidth(context) ? 12 : 14,
                                          ),
                                        ),
                                        const SizedBox(height: 10.0,),
                                        Text(
                                          getTranslated(
                                              servicesProvider.deadPersonInfo['cur_getdata2'][0][dependentIndex]['IS_RETIRED_A'] == 0
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
                                          getTranslated('getsSalary', context),
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
                      const SizedBox(height: 20.0,),
                      Text(
                        getTranslated('mobileNumber', context),
                        style: TextStyle(
                            color: HexColor('#363636'),
                            fontSize: width(0.032, context)
                        ),
                      ),
                      SizedBox(height: height(0.015, context),),
                      Row(
                        children: [
                          Expanded(
                            child: buildTextFormField(context, themeNotifier, dependentMobileNumberController, '', (val){
                              if(mobileNumberValidate(val)){
                                servicesProvider.deadPersonInfo['cur_getdata2'][0][dependentIndex]['validPhone'] = true;
                                servicesProvider.deadPersonInfo['cur_getdata2'][0][dependentIndex]['MOBILE'] = val;
                              } else{
                                servicesProvider.deadPersonInfo['cur_getdata2'][0][dependentIndex]['validPhone'] = false;
                                servicesProvider.deadPersonInfo['cur_getdata2'][0][dependentIndex]['MOBILE'] = null;
                              }
                              servicesProvider.notifyMe();
                            }, inputType: TextInputType.number),
                          ),
                          SizedBox(width: width(0.015, context)),
                          InkWell(
                            onTap: (){
                              DropDownState(
                                DropDown(
                                  isSearchVisible: true,
                                  data: selectedListItem ?? [],
                                  selectedItems: (List<dynamic> selectedList) {
                                    for(var item in selectedList) {
                                      if(item is SelectedListItem) {
                                        setState(() {
                                          selectedInheritorMobileCountry = int.tryParse(item.value);
                                          servicesProvider.deadPersonInfo['cur_getdata2'][0][dependentIndex]['INTERNATIONAL_CODE'] = selectedInheritorMobileCountry;
                                        });
                                      }
                                    }
                                  },
                                  enableMultipleSelection: false,
                                ),
                              ).showModal(context);
                            },
                            child: Container(
                              alignment: Alignment.center,
                              padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: isTablet(context) ? 15 : 13),
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
                                    '+$selectedInheritorMobileCountry',
                                    style: TextStyle(
                                      color: HexColor('#363636'),
                                    ),
                                  ),
                                  Text(
                                    selectedListItem.where((element) => element.value == selectedInheritorMobileCountry.toString()).first.flag,
                                    style: TextStyle(
                                      color: HexColor('#363636'),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      if(double.tryParse(servicesProvider.deadPersonInfo['cur_getdata2'][0][dependentIndex]['AGE'].toString()) < 18)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 20,),
                          buildFieldTitle(context, 'guardianNationality', required: false),
                          const SizedBox(height: 10.0,),
                          customTwoRadioButtons(9, 'jordanian', 'nonJordanian', setState),
                          SizedBox(height: (servicesProvider.deadPersonInfo['cur_getdata2'][0][dependentIndex]['GUARDIANNAME'] != "" && servicesProvider.deadPersonInfo['cur_getdata2'][0][dependentIndex]['GUARDIANNAME'] != null && guardianshipNationality == 'jordanian') ? 20.0 : 0,),
                          if(servicesProvider.deadPersonInfo['cur_getdata2'][0][dependentIndex]['GUARDIANNAME'] != "" && servicesProvider.deadPersonInfo['cur_getdata2'][0][dependentIndex]['GUARDIANNAME'] != null && guardianshipNationality == 'jordanian')
                          buildFieldTitle(context, 'guardianInformation', required: false),
                          SizedBox(height: (servicesProvider.deadPersonInfo['cur_getdata2'][0][dependentIndex]['GUARDIANNAME'] != "" && servicesProvider.deadPersonInfo['cur_getdata2'][0][dependentIndex]['GUARDIANNAME'] != null && guardianshipNationality == 'jordanian') ? 10.0 : 0,),
                          if(servicesProvider.deadPersonInfo['cur_getdata2'][0][dependentIndex]['GUARDIANNAME'] != "" && servicesProvider.deadPersonInfo['cur_getdata2'][0][dependentIndex]['GUARDIANNAME'] != null && guardianshipNationality == 'jordanian')
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
                                            servicesProvider.deadPersonInfo['cur_getdata2'][0][dependentIndex]['GUARDIANNAME'].toString(),
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
                                            guardianNationalNumberController.text,
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
                                            getTranslated(guardianshipNationality, context),
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
                          const SizedBox(height: 20,),
                          buildFieldTitle(context, guardianshipNationality == 'jordanian' ? 'guardianNationalNumber' : 'thePersonalNumberOfTheGuardian', required: false),
                          const SizedBox(height: 10.0,),
                          buildTextFormField(context, themeNotifier, guardianNationalNumberController, '', (val){
                            guardianSubmitGetDetails();
                          }, inputType: TextInputType.number),
                          const SizedBox(height: 20,),
                          buildFieldTitle(context, guardianshipNationality == 'jordanian' ? 'guardianCardNumber' : 'guardianName', required: false),
                          const SizedBox(height: 10.0,),
                          buildTextFormField(context, themeNotifier, guardianSecondFieldController, '', (val){
                            guardianSubmitGetDetails();
                          }, inputType: TextInputType.name),
                          // const SizedBox(height: 20.0,),
                          // Container(
                          //   alignment: Alignment.center,
                          //   child: textButton(context, themeNotifier, 'submitGuardian',
                          //       (guardianNationalNumberController.text.length == 10 && guardianSecondFieldController.text.isNotEmpty) ? primaryColor : HexColor('DADADA'),
                          //       (guardianNationalNumberController.text.length == 10 && guardianSecondFieldController.text.isNotEmpty) ? Colors.white : Colors.black87, (){
                          //     if(guardianNationalNumberController.text.length == 10 && guardianSecondFieldController.text.isNotEmpty){
                          //       guardianSubmitGetDetails();
                          //     }
                          //   }),
                          // ),
                          const SizedBox(height: 20.0,),
                        ],
                      ),
                    ],
                  ),
                  if(servicesProvider.deadPersonInfo['cur_getdata2'].length == 0 || servicesProvider.deadPersonInfo['cur_getdata2'][0].length == 0)
                  Padding(
                    padding: const EdgeInsets.only(top: 100.0),
                    child: Center(child: Text(getTranslated('emptyList', context))),
                  )
                ],
              ),
            ),
          ),
          if(dependentIndex == ((servicesProvider.deadPersonInfo['cur_getdata2'].length != 0  && servicesProvider.deadPersonInfo['cur_getdata2'][0].length != 0) ? servicesProvider.deadPersonInfo['cur_getdata2'][0].length - 1 : 0))
            Padding(
              padding: const EdgeInsets.only(bottom: 5.0),
              child: textButtonWithIcon(
                  context, themeNotifier, 'addNewHeir', Colors.transparent, HexColor('#2D452E'),
                    (){
                    // nonJordanianSubmitEnabled = false;
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
                    inheritorModalBottomSheet(dependentIndex, addingNew: true);
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

  Widget customTwoRadioButtons(int flag, String firstChoice, String secondChoice, setState, {bool disabled = false}){
    return Row(
      children: [
        InkWell(
          onTap: (){
            if(!disabled) {
              setState(() {
                if(flag == 1) {
                  deathType = 0;
                  deathPlace = 0;
                  relationshipType = 0;
                  nationality = firstChoice;
                  nationalIdController.clear();
                  servicesProvider.isNationalIdValid = false;
                  selectedDateOfBirth = DateTime.now();
                  selectedDeathDate = DateTime.now();
                }
                if(flag == 2) {
                  selectedStatus = firstChoice;
                }
                if(flag == 3) {
                  selectedJobStatus = firstChoice;
                }
                if(flag == 4) {
                  selectedGetsSalary = firstChoice;
                }
                if(flag == 5) {
                  selectedHasDisability = firstChoice;
                }
                if(flag == 6) {
                  // selectedMethodOfReceiving = firstChoice;
                }
                if(flag == 7) {
                  nationality = firstChoice;
                }
                if(flag == 8) {
                  selectedGender = firstChoice;
                }
                if(flag == 9) {
                  guardianNationalNumberController.text = '';
                  guardianSecondFieldController.text = '';
                  servicesProvider.deadPersonInfo['cur_getdata2'][0][dependentIndex]['GUARDIANNATNO'] = "";
                  servicesProvider.deadPersonInfo['cur_getdata2'][0][dependentIndex]['GUARDIANCARDNO'] = "";
                  servicesProvider.deadPersonInfo['cur_getdata2'][0][dependentIndex]['GUARDIANNAT'] = null;
                  servicesProvider.deadPersonInfo['cur_getdata2'][0][dependentIndex]['GUARDIANNAME'] = "";
                  guardianshipNationality = firstChoice;
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
                  backgroundColor: (flag == 1 && nationality == firstChoice) || (flag == 2 && selectedStatus == firstChoice) || (flag == 3 && selectedJobStatus == firstChoice) ||
                      (flag == 4 && selectedGetsSalary == firstChoice) || (flag == 5 && selectedHasDisability == firstChoice) ||
                      (flag == 7 && nationality == firstChoice) || (flag == 8 && selectedGender == firstChoice) || (flag == 9 && guardianshipNationality == firstChoice)
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
                  deathType = 0;
                  deathPlace = 0;
                  relationshipType = 0;
                  nationality = secondChoice;
                  nationalIdController.clear();
                  servicesProvider.isNationalIdValid = false;
                  selectedDateOfBirth = DateTime.now();
                  selectedDeathDate = DateTime.now();
                }
                if(flag == 2) {
                  selectedStatus = secondChoice;
                }
                if(flag == 3) {
                  selectedJobStatus = secondChoice;
                }
                if(flag == 4) {
                  selectedGetsSalary = secondChoice;
                }
                if(flag == 5) {
                  selectedHasDisability = secondChoice;
                }
                if(flag == 6) {
                  // selectedMethodOfReceiving = firstChoice;
                }
                if(flag == 7) {
                  nationality = secondChoice;
                }
                if(flag == 8) {
                  selectedGender = secondChoice;
                }
                if(flag == 9) {
                  guardianNationalNumberController.text = '';
                  guardianSecondFieldController.text = '';
                  servicesProvider.deadPersonInfo['cur_getdata2'][0][dependentIndex]['GUARDIANNATNO'] = "";
                  servicesProvider.deadPersonInfo['cur_getdata2'][0][dependentIndex]['GUARDIANCARDNO'] = "";
                  servicesProvider.deadPersonInfo['cur_getdata2'][0][dependentIndex]['GUARDIANNAT'] = null;
                  servicesProvider.deadPersonInfo['cur_getdata2'][0][dependentIndex]['GUARDIANNAME'] = "";
                  guardianshipNationality = secondChoice;
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
                  backgroundColor: (flag == 1 && nationality == secondChoice) || (flag == 2 && selectedStatus == secondChoice) || (flag == 3 && selectedJobStatus == secondChoice) ||
                      (flag == 4 && selectedGetsSalary == secondChoice) || (flag == 5 && selectedHasDisability == secondChoice) ||
                      (flag == 7 && nationality == secondChoice) || (flag == 8 && selectedGender == secondChoice) || (flag == 9 && guardianshipNationality == secondChoice)
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

  dropDownList(List<String> menuList, ThemeNotifier themeNotifier, int flag){
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: isTablet(context) ? 5 : 0.0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: HexColor('#979797'),
            )
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            DropdownButton<String>(
              value: flag == 1 ? menuList[deathType] : flag == 2 ? menuList[deathPlace] : menuList[relationshipType],
              icon: const Icon(
                Icons.arrow_drop_down_outlined,
                size: 0,
              ),
              elevation: 16,
              style: const TextStyle(color: Colors.black),
              underline: Container(
                height: 0,
                color: primaryColor,
              ),
              onChanged: (String value) async {
                setState(() {
                  if(flag == 1){
                    deathType = menuList.indexOf(value);
                    deadPersonSubmitGetDetails();
                  }
                  if(flag == 2){
                    deathPlace = menuList.indexOf(value);
                  }
                  if(flag == 3){
                    relationshipType = menuList.indexOf(value);
                    servicesProvider.deadPersonInfo['cur_getdata'][0][0]['RELATIVE_TYPE'] = servicesProvider.penDeath['Relative_type_getdata'][0].where((element) => (UserConfig.instance.checkLanguage() ? element['REL_DESC_EN'] : element['REL_DESC_AR']) == relationshipTypes[relationshipType]).first['REL_ID'];
                    deadPersonSubmitGetDetails();
                  }
                });
              },
              items: menuList.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: SizedBox(
                    width: width(0.7, context),
                    child: Text(
                        flag == 3 ? value : getTranslated(value, context),
                      style: TextStyle(
                        fontSize: isTablet(context) ? 20 : 15,
                        color: value != 'choose' ? Colors.black87 : Colors.grey,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const Icon(Icons.arrow_drop_down_outlined)
          ],
        )
    );
  }

  String getRelationType(int relation){
    String result = '';
    servicesProvider.penDeath['Relative_type_getdata'][0].forEach((element){
      if(element['REL_ID'].toString() == relation.toString()){
        result = UserConfig.instance.checkLanguage() ? element['REL_DESC_EN'] : element['REL_DESC_AR'];
      }
    });
    return result;
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

  deadPersonSubmitGetDetails() async {
    if(nationalIdController.text.length == 10 && deathType != 0){
      FocusScope.of(context).requestFocus(FocusNode());
      String message = '';
      servicesProvider.isLoading = true;
      servicesProvider.notifyMe();
      try{
        int penType = (deathType == 1) ? 4 : (deathType == 2) ? 5 : 1;
        Map<String, dynamic> data = {
          "natId": nationalIdController.text,
          "nationality": nationality == 'jordanian' ? 1 : 2,
          "penType": penType,
          "birthDate": nationality == 'jordanian' ? null : DateFormat('E%20MMM%20d%20y%20HH:mm:ss%20\'GMT\'', 'en_US').format(selectedDateOfBirth.toUtc()).toString(),
          "deathDate": nationality == 'jordanian' ? null : DateFormat('E%20MMM%20d%20y%20HH:mm:ss%20\'GMT\'', 'en_US').format(selectedDeathDate.toUtc()).toString()
        };
        await servicesProvider.deadPersonGetDetails(data).whenComplete((){}).then((value) {
          if(value['po_status'] == 0){
            servicesProvider.isNationalIdValid = true;
            setState((){
              servicesProvider.deadPersonInfo = value;
              servicesProvider.deadPersonInfo['cur_getdata'][0][0]['RELATIVE_TYPE'] = servicesProvider.penDeath['Relative_type_getdata'][0].where((element) => (UserConfig.instance.checkLanguage() ? element['REL_DESC_EN'] : element['REL_DESC_AR']) == relationshipTypes[relationshipType]).first['REL_ID'];
              if(servicesProvider.deadPersonInfo['cur_getdata2'].isNotEmpty){
                for(int i=0 ; i<servicesProvider.deadPersonInfo['cur_getdata2'][0].length ; i++){
                  servicesProvider.deadPersonInfo['cur_getdata2'][0][i] = {
                    ...servicesProvider.deadPersonInfo['cur_getdata2'][0][i],
                    "SOURCE_FLAG": 1,
                    "INHERITOR_DOCS": [],
                    "NATIONAL_NO": servicesProvider.deadPersonInfo['cur_getdata2'][0][i]['NATIONALNUMBER'],
                    "IS_ALIVE_A": servicesProvider.deadPersonInfo['cur_getdata2'][0][i]['IS_ALIVE'],
                    "MARITAL_STATUS_A": servicesProvider.deadPersonInfo['cur_getdata2'][0][i]['SOCIAL_STATUS'],
                    "WORK_STATUS": servicesProvider.deadPersonInfo['cur_getdata2'][0][i]['IS_WORK'],
                    "RELATION": servicesProvider.deadPersonInfo['cur_getdata2'][0][i]['RELATIVETYPE'],
                    "DISABILITY": 0,
                    "LAST_EVENT_DATE": servicesProvider.deadPersonInfo['cur_getdata2'][0][i]['LAST_SOC_STATUS_DATE'],
                    "SOCIAL_STATUS_A": servicesProvider.deadPersonInfo['cur_getdata2'][0][i]['SOCIAL_STATUS'],
                    "IS_WORK_A": servicesProvider.deadPersonInfo['cur_getdata2'][0][i]['IS_WORK'],
                    "IS_RETIRED_A": servicesProvider.deadPersonInfo['cur_getdata2'][0][i]['IS_RETIRED'],
                    "permanentDisability": 0,
                    "dateOfLastStatus": servicesProvider.deadPersonInfo['cur_getdata2'][0][i]['LAST_SOC_STATUS_DATE'],
                    "GUARDIANNAT": (double.tryParse(servicesProvider.deadPersonInfo['cur_getdata2'][0][i]['AGE'].toString()) < 18) ? 1 : null,
                    "validPhone": (servicesProvider.deadPersonInfo['cur_getdata2'][0][i]['MOBILE'] != null) ? true : false,
                    "DEP_CODE": "${DateTime.now().millisecondsSinceEpoch}${((math.Random().nextDouble() * 10000) + 1).floor()}",
                    "INTERNATIONAL_CODE": servicesProvider.deadPersonInfo['cur_getdata2'][0][i]['INTERNATIONAL_CODE'] ?? 962
                  };
                }
              }
            });
            servicesProvider.notifyMe();
          } else{
            servicesProvider.isNationalIdValid = false;
            servicesProvider.deadPersonInfo = null;
            message = UserConfig.instance.checkLanguage()
                ? value['PO_status_desc_EN'] : value['PO_status_desc_AR'];
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
    }else{
      servicesProvider.isNationalIdValid = false;
      servicesProvider.deadPersonInfo = null;
      servicesProvider.notifyMe();
    }
  }

  guardianSubmitGetDetails() async {
    if(guardianshipNationality == 'jordanian' && guardianNationalNumberController.text.length == 10 && guardianSecondFieldController.text.length == 8){
      FocusScope.of(context).requestFocus(FocusNode());
      String message = '';
      servicesProvider.isLoading = true;
      servicesProvider.notifyMe();
      try{
        await servicesProvider.guardianGetDetails(guardianNationalNumberController.text, guardianshipNationality == 'jordanian' ? 1 : 2, guardianSecondFieldController.text).whenComplete((){}).then((value) async {
          if(value['PO_status'] == null){
            servicesProvider.deadPersonInfo['cur_getdata2'][0][dependentIndex]['GUARDIANNATNO'] = guardianNationalNumberController.text;
            servicesProvider.deadPersonInfo['cur_getdata2'][0][dependentIndex]['GUARDIANCARDNO'] = guardianSecondFieldController.text;
            servicesProvider.deadPersonInfo['cur_getdata2'][0][dependentIndex]['GUARDIANNAT'] = 1;
            servicesProvider.deadPersonInfo['cur_getdata2'][0][dependentIndex]['GUARDIANNAME'] = value['cur_getdata'][0][0]['FULL_NAME'];
            await servicesProvider.getRequiredDocuments(
                jsonEncode({
                  "row": {
                    "IS_INHERITOR": 1,
                    "MILITARY_WORK_DOC": servicesProvider.deadPersonInfo['cur_getdata'][0][0]['MILITARY_WORK_DOC'],
                    "DEATH_NAT": servicesProvider.deadPersonInfo['cur_getdata'][0][0]['NAT'],
                    "INHERITORS_FLAG": 1
                  },
                  "dep": {
                    "dep": servicesProvider.deadPersonInfo['cur_getdata2'][0][dependentIndex]
                  }
                }), 11
            ).whenComplete((){}).then((value) {
              for(int i=0 ; i<value['R_RESULT'][0].length ; i++){
                value['R_RESULT'][0][i]['CODE'] = servicesProvider.deadPersonInfo['cur_getdata2'][0][dependentIndex]['NATIONALNUMBER'];
                value['R_RESULT'][0][i]['NAME'] = servicesProvider.deadPersonInfo['cur_getdata2'][0][dependentIndex]["FIRSTNAME"];
              }
              servicesProvider.dependentsDocuments.removeWhere((element) => element["CODE"] == servicesProvider.deadPersonInfo['cur_getdata2'][0][dependentIndex]['NATIONALNUMBER']);
              if(value['R_RESULT'].isNotEmpty){
                for(int i=0 ; i<value['R_RESULT'][0].length ; i++){
                  if(!servicesProvider.dependentsDocuments.contains(value['R_RESULT'][0][i])) {
                    servicesProvider.dependentsDocuments.add(value['R_RESULT'][0][i]);
                  }
                }
              }
            });
            servicesProvider.notifyMe();
          } else{
            servicesProvider.deadPersonInfo['cur_getdata2'][0][dependentIndex]['GUARDIANNATNO'] = "";
            servicesProvider.deadPersonInfo['cur_getdata2'][0][dependentIndex]['GUARDIANCARDNO'] = "";
            servicesProvider.deadPersonInfo['cur_getdata2'][0][dependentIndex]['GUARDIANNAT'] = null;
            servicesProvider.deadPersonInfo['cur_getdata2'][0][dependentIndex]['GUARDIANNAME'] = "";
            message = UserConfig.instance.checkLanguage()
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
    } else if(guardianshipNationality == 'nonJordanian' && guardianNationalNumberController.text.length == 10 && guardianSecondFieldController.text.length >= 3){
      servicesProvider.deadPersonInfo['cur_getdata2'][0][dependentIndex]['GUARDIANNATNO'] = guardianNationalNumberController.text;
      servicesProvider.deadPersonInfo['cur_getdata2'][0][dependentIndex]['GUARDIANCARDNO'] = "";
      servicesProvider.deadPersonInfo['cur_getdata2'][0][dependentIndex]['GUARDIANNAT'] = 2;
      servicesProvider.deadPersonInfo['cur_getdata2'][0][dependentIndex]['GUARDIANNAME'] = guardianSecondFieldController.text;
      try{
      await servicesProvider.getRequiredDocuments(
          jsonEncode({
            "row": {
              "IS_INHERITOR": 1,
              "MILITARY_WORK_DOC": servicesProvider.deadPersonInfo['cur_getdata'][0][0]['MILITARY_WORK_DOC'],
              "DEATH_NAT": servicesProvider.deadPersonInfo['cur_getdata'][0][0]['NAT'],
              "INHERITORS_FLAG": 1
            },
            "dep": {
              "dep": servicesProvider.deadPersonInfo['cur_getdata2'][0][dependentIndex]
            }
          }), 11
      ).whenComplete((){}).then((value) {
        for(int i=0 ; i<value['R_RESULT'][0].length ; i++){
          value['R_RESULT'][0][i]['CODE'] = servicesProvider.deadPersonInfo['cur_getdata2'][0][dependentIndex]['NATIONALNUMBER'];
          value['R_RESULT'][0][i]['NAME'] = servicesProvider.deadPersonInfo['cur_getdata2'][0][dependentIndex]["FIRSTNAME"];
        }
        servicesProvider.dependentsDocuments.removeWhere((element) => element["CODE"] == servicesProvider.deadPersonInfo['cur_getdata2'][0][dependentIndex]['NATIONALNUMBER']);
        if(value['R_RESULT'].isNotEmpty){
          for(int i=0 ; i<value['R_RESULT'][0].length ; i++){
            if(!servicesProvider.dependentsDocuments.contains(value['R_RESULT'][0][i])) {
              servicesProvider.dependentsDocuments.add(value['R_RESULT'][0][i]);
            }
          }
        }
      });
      servicesProvider.notifyMe();
      }catch(e){
        showMyDialog(context, 'failed', getTranslated('somethingWrongHappened', context), 'ok', themeNotifier);
        if (kDebugMode) {
          print(e.toString());
        }
      }
      servicesProvider.notifyMe();
    } else{
      servicesProvider.deadPersonInfo['cur_getdata2'][0][dependentIndex]['GUARDIANNATNO'] = "";
      servicesProvider.deadPersonInfo['cur_getdata2'][0][dependentIndex]['GUARDIANCARDNO'] = "";
      servicesProvider.deadPersonInfo['cur_getdata2'][0][dependentIndex]['GUARDIANNAT'] = null;
      servicesProvider.deadPersonInfo['cur_getdata2'][0][dependentIndex]['GUARDIANNAME'] = "";
      servicesProvider.notifyMe();
    }

  }

  inheritorModalBottomSheet(int index, {bool addingNew = false}){
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
                            if(addingNew)
                              Column(
                                children: [
                                  buildFieldTitle(context, 'nationality', required: false),
                                  const SizedBox(height: 10.0,),
                                  customTwoRadioButtons(7, 'jordanian', 'nonJordanian', setState, disabled: servicesProvider.isNationalIdValid),
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
                                      // checkNonJordanianInfo();
                                    });
                                  },
                                      inputType: TextInputType.number, enabled: !Provider.of<ServicesProvider>(context).isNationalIdValid
                                  ),
                                  const SizedBox(height: 15.0,),
                                ],
                              ),
                            if((nationality == 'jordanian' && servicesProvider.isNationalIdValid) || nationality == 'nonJordanian')
                              ListView(
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
                                                    !addingNew
                                                        ? servicesProvider.deadPersonInfo['cur_getdata2'][0][index]['FULL_NAME']
                                                        : '${servicesProvider.deadPersonInfo['cur_getdata2'][0][index]['FULL_NAME']}',
                                                    style: TextStyle(
                                                      height: 1.4,
                                                      color: themeNotifier.isLight() ? HexColor('#363636') : Colors.white,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                  Container(
                                                    padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
                                                    decoration: BoxDecoration(
                                                      color: !addingNew
                                                          ? servicesProvider.deadPersonInfo['cur_getdata2'][0][index]['RELATIVETYPE'] == 11
                                                          ? HexColor('#9EBDF8') : const Color.fromRGBO(0, 121, 5, 0.38)
                                                          : servicesProvider.deadPersonInfo['cur_getdata2'][0][index]['RELATIVETYPE'] == 11
                                                          ? HexColor('#9EBDF8') : const Color.fromRGBO(0, 121, 5, 0.38),
                                                      borderRadius: BorderRadius.circular(8.0),
                                                    ),
                                                    child: Text(
                                                      !addingNew
                                                          ? getRelationType(servicesProvider.deadPersonInfo['cur_getdata2'][0][index]['RELATIVETYPE'])
                                                          : getRelationType(servicesProvider.deadPersonInfo['cur_getdata2'][0][index]['RELATIVETYPE']),
                                                      style: TextStyle(
                                                        color: !addingNew
                                                            ? servicesProvider.deadPersonInfo['cur_getdata2'][0][index]['RELATIVETYPE'] == 11
                                                            ? HexColor('#003C97') : HexColor('#2D452E')
                                                            : servicesProvider.deadPersonInfo['cur_getdata2'][0][index]['RELATIVETYPE'] == 11
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
                                                    !addingNew
                                                        ? servicesProvider.deadPersonInfo['cur_getdata2'][0][index]['NATIONALNUMBER']
                                                        : servicesProvider.deadPersonInfo['cur_getdata2'][0][index]['NATIONALNUMBER'],
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
                                                        !addingNew
                                                            ? servicesProvider.deadPersonInfo['cur_getdata2'][0][index]['NATIONALITY'] == 1
                                                            ? 'jordanian' : 'nonJordanian'
                                                            : servicesProvider.deadPersonInfo['cur_getdata2'][0][index]['NATIONALITY'] == 1
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
                                        buildTextFormField(context, themeNotifier, quatrainNounController, '', (val){setState((){});}, enabled: !Provider.of<ServicesProvider>(context).isNationalIdValid),
                                        const SizedBox(height: 10.0,),
                                        buildFieldTitle(context, 'sex', required: false),
                                        const SizedBox(height: 10.0,),
                                        customTwoRadioButtons(8, 'male', 'female', setState),
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
                                                  // checkNonJordanianInfo();
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
                                  if(!addingNew)
                                    buildFieldTitle(context, 'status', required: false),
                                  if(!addingNew)
                                    const SizedBox(height: 10.0,),
                                  if(!addingNew)
                                    customTwoRadioButtons(2, 'alive', 'dead', setState),
                                  if(!addingNew)
                                    const SizedBox(height: 20.0,),
                                  buildFieldTitle(context, 'employmentStatus', required: false),
                                  const SizedBox(height: 10.0,),
                                  customTwoRadioButtons(3, 'unemployed', 'employed', setState),
                                  const SizedBox(height: 20.0,),
                                  buildFieldTitle(context, 'getsSalary', required: false),
                                  const SizedBox(height: 10.0,),
                                  customTwoRadioButtons(4, 'yes', 'no', setState),
                                  const SizedBox(height: 20.0,),
                                  buildFieldTitle(context, 'hasDisability', required: false),
                                  const SizedBox(height: 10.0,),
                                  customTwoRadioButtons(5, 'yes', 'no', setState),
                                  if(!addingNew)
                                    const SizedBox(height: 20.0,),
                                  if(!addingNew)
                                    buildFieldTitle(context, 'maritalStatus', required: false),
                                  if(!addingNew)
                                    const SizedBox(height: 10.0,),
                                  if(!addingNew)
                                    customRadioButtonGroup(1, maritalList, setState),
                                  if(nationality == 'nonJordanian')
                                    const SizedBox(height: 20.0,),
                                  if(nationality == 'nonJordanian')
                                    buildFieldTitle(context, 'relativeRelation', required: false),
                                  if(nationality == 'nonJordanian')
                                    const SizedBox(height: 10.0,),
                                  if(nationality == 'nonJordanian')
                                    customRadioButtonGroup(2, servicesProvider.result['P_RELATION'][0], setState),
                                  SizedBox(height: height(isScreenHasSmallHeight(context) ? 0.2 : 0.11, context),),
                                ],
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
                                textButton(context, themeNotifier, 'save', (!addingNew || (addingNew && nationality == 'jordanian' && servicesProvider.isNationalIdValid) || (addingNew && nationality == 'nonJordanian')) ? HexColor('#445740') : HexColor('DADADA'),
                                    (!addingNew || (addingNew && nationality == 'jordanian' && servicesProvider.isNationalIdValid) || (addingNew && nationality == 'nonJordanian')) ? Colors.white : HexColor('#363636'), () async {
                                      FocusScope.of(context).requestFocus(FocusNode());
                                      if(!addingNew) {
                                        // String message = '';
                                        servicesProvider.isLoading = true;
                                        servicesProvider.isModalLoading = true;
                                        servicesProvider.notifyMe();
                                        dynamic maritalStatus = selectedMaritalStatus == (UserConfig.instance.checkLanguage()
                                            ? 'single' : servicesProvider.deadPersonInfo['cur_getdata2'][0][index]["GENDER"] == 1 ? 'singleM' : 'singleF') ? 1
                                            : selectedMaritalStatus == (UserConfig.instance.checkLanguage()
                                            ? 'married' : servicesProvider.deadPersonInfo['cur_getdata2'][0][index]["GENDER"] == 1 ? 'marriedM' : 'marriedF') ? 2
                                            : selectedMaritalStatus == (UserConfig.instance.checkLanguage()
                                            ? 'divorced' : servicesProvider.deadPersonInfo['cur_getdata2'][0][index]["GENDER"] == 1 ? 'divorcedM' : 'divorcedF') ? 3
                                            : selectedMaritalStatus == (UserConfig.instance.checkLanguage()
                                            ? 'widow' : servicesProvider.deadPersonInfo['cur_getdata2'][0][index]["GENDER"] == 1 ? 'widowM' : 'widowF') ? 4 : 1;
                                        try{
                                          var dependent = {
                                            "NATIONALNUMBER": servicesProvider.deadPersonInfo['cur_getdata2'][0][index]["NATIONALNUMBER"],
                                            "FULL_NAME": servicesProvider.deadPersonInfo['cur_getdata2'][0][index]["FULL_NAME"],
                                            "FIRSTNAME": servicesProvider.deadPersonInfo['cur_getdata2'][0][index]["FIRSTNAME"],
                                            "SECONDNAME": servicesProvider.deadPersonInfo['cur_getdata2'][0][index]["SECONDNAME"],
                                            "THIRDNAME": servicesProvider.deadPersonInfo['cur_getdata2'][0][index]["THIRDNAME"],
                                            "LASTNAME": servicesProvider.deadPersonInfo['cur_getdata2'][0][index]["LASTNAME"],
                                            "NAME1": "",
                                            "NAME2": "",
                                            "NAME3": "",
                                            "NAME4": "",
                                            "NATIONALITY": servicesProvider.deadPersonInfo['cur_getdata2'][0][index]["NATIONALITY"],
                                            "RELATIVETYPE": servicesProvider.deadPersonInfo['cur_getdata2'][0][index]["RELATIVETYPE"],
                                            "GENDER": servicesProvider.deadPersonInfo['cur_getdata2'][0][index]["GENDER"],
                                            "AGE": servicesProvider.deadPersonInfo['cur_getdata2'][0][index]["AGE"],
                                            "SOCIAL_STATUS": maritalStatus,
                                            "SOCIAL_STATUS_A": servicesProvider.deadPersonInfo['cur_getdata2'][0][index]["SOCIAL_STATUS_A"],
                                            "IS_ALIVE": selectedStatus == 'alive' ? 1 : 0,
                                            "IS_ALIVE_A": servicesProvider.deadPersonInfo['cur_getdata2'][0][index]["IS_ALIVE_A"],
                                            "IS_WORK": servicesProvider.deadPersonInfo['cur_getdata2'][0][index]["IS_WORK"],
                                            "IS_WORK_A": selectedJobStatus == 'unemployed' ? 0 : 1,
                                            "IS_RETIRED": servicesProvider.deadPersonInfo['cur_getdata2'][0][index]["IS_RETIRED"],
                                            "IS_RETIRED_A": selectedGetsSalary == 'yes' ? 1 : 0,
                                            "dateOfLastStatus": servicesProvider.deadPersonInfo['cur_getdata2'][0][index]["dateOfLastStatus"],
                                            "GUARDIANNATNO": "",
                                            "GUARDIANCARDNO": "",
                                            "GUARDIANNAT": null,
                                            "GUARDIANNAME": "",
                                            "DISABILITY": selectedHasDisability == 'no' ? 0 : 1,
                                            "MOBILE": servicesProvider.deadPersonInfo['cur_getdata2'][0][index]["MOBILE"],
                                            "SOURCE_FLAG": servicesProvider.deadPersonInfo['cur_getdata2'][0][index]["SOURCE_FLAG"],
                                            "validPhone": servicesProvider.deadPersonInfo['cur_getdata2'][0][index]["validPhone"],
                                          };

                                          servicesProvider.deadPersonInfo['cur_getdata2'][0][index] = dependent;
                                          await servicesProvider.getRequiredDocuments(
                                              jsonEncode({
                                                "row": {
                                                  "IS_INHERITOR": 1,
                                                  "MILITARY_WORK_DOC": servicesProvider.deadPersonInfo['cur_getdata'][0][0]['MILITARY_WORK_DOC'],
                                                  "DEATH_NAT": servicesProvider.deadPersonInfo['cur_getdata'][0][0]['NAT'],
                                                  "INHERITORS_FLAG": 1
                                                },
                                                "dep": {
                                                  "dep": dependent
                                                }
                                              }), 11
                                          ).whenComplete((){}).then((value) {
                                            for(int i=0 ; i<value['R_RESULT'][0].length ; i++){
                                              value['R_RESULT'][0][i]['CODE'] = servicesProvider.deadPersonInfo['cur_getdata2'][0][dependentIndex]['NATIONALNUMBER'];
                                              value['R_RESULT'][0][i]['NAME'] = servicesProvider.deadPersonInfo['cur_getdata2'][0][dependentIndex]["FIRSTNAME"];
                                            }
                                            servicesProvider.dependentsDocuments.removeWhere((element) => element["CODE"] == servicesProvider.deadPersonInfo['cur_getdata2'][0][dependentIndex]["DEP_CODE"]);
                                            if(value['R_RESULT'].isNotEmpty){
                                              for(int i=0 ; i<value['R_RESULT'][0].length ; i++){
                                                value['R_RESULT'][0][i]["NAME"] = servicesProvider.deadPersonInfo['cur_getdata2'][0][dependentIndex]["FIRSTNAME"];
                                                if(!servicesProvider.dependentsDocuments.contains(value['R_RESULT'][0][i])) {
                                                  servicesProvider.dependentsDocuments.add(value['R_RESULT'][0][i]);
                                                }
                                              }
                                            }
                                          });
                                          // ignore: use_build_context_synchronously
                                          Navigator.pop(context);
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
                                        if((nationality == 'jordanian' && servicesProvider.isNationalIdValid) || (nationality == 'nonJordanian')){
                                          String message = '';
                                          servicesProvider.isLoading = true;
                                          servicesProvider.isModalLoading = true;
                                          servicesProvider.notifyMe();
                                          dynamic maritalStatus = selectedMaritalStatus == (UserConfig.instance.checkLanguage()
                                              ? 'single' : servicesProvider.deadPersonInfo['cur_getdata2'][0][index]["GENDER"] == 1 ? 'singleM' : 'singleF') ? 1
                                              : selectedMaritalStatus == (UserConfig.instance.checkLanguage()
                                              ? 'married' : servicesProvider.deadPersonInfo['cur_getdata2'][0][index]["GENDER"] == 1 ? 'marriedM' : 'marriedF') ? 2
                                              : selectedMaritalStatus == (UserConfig.instance.checkLanguage()
                                              ? 'divorced' : servicesProvider.deadPersonInfo['cur_getdata2'][0][index]["GENDER"] == 1 ? 'divorcedM' : 'divorcedF') ? 3
                                              : selectedMaritalStatus == (UserConfig.instance.checkLanguage()
                                              ? 'widow' : servicesProvider.deadPersonInfo['cur_getdata2'][0][index]["GENDER"] == 1 ? 'widowM' : 'widowF') ? 4 : 1;
                                          try{
                                            await servicesProvider.checkDocumentDependent((servicesProvider.deadPersonInfo['cur_getdata2'].isNotEmpty && servicesProvider.deadPersonInfo['cur_getdata2'][0].length != 0) ? servicesProvider.deadPersonInfo['cur_getdata2'][0] : []).then((value) async {
                                              if(value['P_RESULT'].isEmpty){
                                                Map<String, dynamic> dependent;
                                                String id = "${DateTime.now().millisecondsSinceEpoch}${((math.Random().nextDouble() * 10000) + 1).floor()}";
                                                if(nationality == 'jordanian'){
                                                  dependent = {
                                                    "NAME": servicesProvider.deadPersonInfo['cur_getdata2'][0][index]["FULL_NAME"],
                                                    "GENDER": servicesProvider.deadPersonInfo['cur_getdata2'][0][index]["GENDER"],
                                                    "FIRSTNAME": servicesProvider.deadPersonInfo['cur_getdata2'][0][index]["FIRSTNAME"],
                                                    "SECONDNAME": servicesProvider.deadPersonInfo['cur_getdata2'][0][index]["SECONDNAME"],
                                                    "THIRDNAME": servicesProvider.deadPersonInfo['cur_getdata2'][0][index]["THIRDNAME"],
                                                    "LASTNAME": servicesProvider.deadPersonInfo['cur_getdata2'][0][index]["LASTNAME"],
                                                    "BIRTHDATE": servicesProvider.deadPersonInfo['cur_getdata2'][0][index]["BIRTHDATE"],
                                                    "AGE": servicesProvider.deadPersonInfo['cur_getdata2'][0][index]["AGE"],
                                                    "MARITAL_STATUS_A": servicesProvider.deadPersonInfo['cur_getdata2'][0][index]["SOCIAL_STATUS"],
                                                    "MARITAL_STATUS": servicesProvider.deadPersonInfo['cur_getdata2'][0][index]["SOCIAL_STATUS"],
                                                    "WORK_STATUS_A": servicesProvider.deadPersonInfo['cur_getdata2'][0][index]["IS_WORK"],
                                                    "IS_ALIVE_A": servicesProvider.deadPersonInfo['cur_getdata2'][0][index]["IS_ALIVE"],
                                                    "IS_ALIVE": servicesProvider.deadPersonInfo['cur_getdata2'][0][index]["IS_ALIVE"],
                                                    "IS_RETIRED_A": selectedGetsSalary == 'yes' ? 1 : 0,
                                                    "LAST_EVENT_DATE": servicesProvider.deadPersonInfo['cur_getdata2'][0][index]["LAST_SOC_STATUS_DATE"],
                                                    "WANT_HEALTH_INSURANCE": "",
                                                    "PreLoad": null,
                                                    "Added": null,
                                                    "doc_dep": "",
                                                    "RELATION": servicesProvider.deadPersonInfo['cur_getdata2'][0][index]["RELATIVETYPE"],
                                                    "WORK_STATUS": selectedJobStatus == 'unemployed' ? 0 : 1,
                                                    "IS_RETIRED": servicesProvider.deadPersonInfo['cur_getdata2'][0][index]["IS_RETIRED"],
                                                    "DISABILITY": selectedHasDisability == 'no' ? 0 : 1,
                                                    "ID": id,
                                                    "DEP_CODE": id,
                                                    "SOURCE_FLAG": 2,
                                                    "NATIONAL_NO": servicesProvider.deadPersonInfo['cur_getdata2'][0][index]["NATIONALNUMBER"],
                                                    "NATIONALITY": servicesProvider.deadPersonInfo['cur_getdata2'][0][index]["NATIONALITY"],
                                                  };
                                                } else{
                                                  dependent = {
                                                    "NAME": quatrainNounController.text,
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
                                                if(servicesProvider.deadPersonInfo['cur_getdata2'].length != 0) {
                                                  servicesProvider.deadPersonInfo['cur_getdata2'][0].add(dependent);
                                                } else{
                                                  servicesProvider.deadPersonInfo['cur_getdata2'].add([dependent]);
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

  /// TODO: complete inheritor's EDIT and ADD NEW
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
              const SizedBox(height: 10.0,)
            ],
          );
        }
    );
  }

}

enum ContextMenu { edit, delete }

