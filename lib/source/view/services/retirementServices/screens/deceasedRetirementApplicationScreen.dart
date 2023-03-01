// ignore_for_file: file_names

import 'package:drop_down_list/drop_down_list.dart';
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
import '../../shared/verifyMobileNumberScreen.dart';

class DeceasedRetirementApplicationScreen extends StatefulWidget {
  const DeceasedRetirementApplicationScreen({Key key}) : super(key: key);

  @override
  State<DeceasedRetirementApplicationScreen> createState() => _DeceasedRetirementApplicationScreenState();
}

class _DeceasedRetirementApplicationScreenState extends State<DeceasedRetirementApplicationScreen> {

  ServicesProvider servicesProvider;
  ThemeNotifier themeNotifier;
  SelectedListItem selectedDeadMobileCountry = SelectedListItem(
    name: UserConfig.instance.checkLanguage() ? "Jordan" : "الأردن",
    value: "962", natCode: 111,
    flag: countries[110].flag,
  );

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

  ///

  String nationality = 'jordanian';
  int deathType = 0;
  int deathPlace = 0;
  List<String> deathTypes = ['choose', 'aNaturalDeathWithinTheService', 'injuriesDeath'];
  List<String> deathPlaces = ['choose', 'insideJordan', 'outsideJordan'];
  DateTime selectedDateOfBirth = DateTime.now();
  DateTime selectedDeathDate = DateTime.now();

  checkContinueEnabled({flag = 0}){
    if(flag == 1){
      return true; /// TODO: add continue condition => mobileNumberValidate(servicesProvider.mobileNumberController.text);
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
      if(servicesProvider.isMobileNumberUpdated){
        return Provider.of<ServicesProvider>(context, listen: false).pinPutFilled;
      } else{
        return true;
      }
    }
  }

  @override
  void initState() {
    Provider.of<LoginProvider>(context, listen: false).readCountriesJson();
    servicesProvider = Provider.of<ServicesProvider>(context, listen: false);
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
    servicesProvider.penDeathLookup();
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
        title: Text(translate('deceasedRetirementApplication', context)),
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
                      const FirstStepScreen(nextStep: 'ensureFinancialSolvency', numberOfSteps: 4),
                    if(Provider.of<ServicesProvider>(context).stepNumber == 2 && Provider.of<ServicesProvider>(context).isMobileNumberUpdated)
                      VerifyMobileNumberScreen(nextStep: 'ensureFinancialSolvency', numberOfSteps: 4, mobileNo: servicesProvider.mobileNumberController.text ?? ''),
                    if(Provider.of<ServicesProvider>(context).stepNumber == 2 && !Provider.of<ServicesProvider>(context).isMobileNumberUpdated)
                      secondStep(context, themeNotifier),
                    if(Provider.of<ServicesProvider>(context).stepNumber == 3)
                      thirdStep(context, themeNotifier),
                    if(Provider.of<ServicesProvider>(context).stepNumber == 4)
                      const DocumentsScreen(nextStep: 'receiptOfAllowances', numberOfSteps: 4),
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
                                }else {
                                  servicesProvider.notifyMe();
                                  servicesProvider.stepNumber = 4;
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
                "DOCUMENT_DATE": DateFormat('MM/dd/yyyy, HH:mm').format(DateTime.now()).toString(),
                "required": type == 'mandatory' ? 0 : 1,
                "APP_ID": servicesProvider.result['P_Result'][0][0]['ID'],
                "ID": "",
                "STATUS": 1,
                "HIDE_ACTIONS": false
              };
              bool isDependentDoc = false;
              if(type == 'mandatory' && servicesProvider.result["P_Dep"].isNotEmpty){
                servicesProvider.deadPersonInfo['cur_getdata2'][0].forEach((element) {
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
                  translate('orderDetails', context),
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
                      '2/4',
                      style: TextStyle(
                          color: HexColor('#979797'),
                          fontSize: width(0.025, context)
                      ),
                    ),
                    Text(
                      '${translate('next', context)}: ${translate('heirsInformation', context)}',
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
                                    translate(nationality, context),
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
                                    translate('deathDate', context) + ": ",
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
    print(servicesProvider.deadPersonInfo['cur_getdata2'][0][dependentIndex]);
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
                    translate('heirsInformation', context),
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
                        '3/4',
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
                translate('numberOfHeirs', context) + ' ( ${(servicesProvider.deadPersonInfo['cur_getdata2'].length != 0  && servicesProvider.deadPersonInfo['cur_getdata2'][0].length != 0) ? dependentIndex + 1 : 0} / ${(servicesProvider.deadPersonInfo['cur_getdata2'].length != 0  && servicesProvider.deadPersonInfo['cur_getdata2'][0].length != 0) ? servicesProvider.deadPersonInfo['cur_getdata2'][0].length : 0} )',
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
                                            selectedJobStatus = servicesProvider.deadPersonInfo['cur_getdata2'][0][dependentIndex]['IS_WORK'] == 0
                                                ? 'unemployed' : 'employed';
                                            selectedGetsSalary = servicesProvider.deadPersonInfo['cur_getdata2'][0][dependentIndex]['IS_RETIRED'] == 0
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
                                            // dependentModalBottomSheet(dependentIndex);
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
                                  translate(
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
                                      translate('maritalStatus', context),
                                      style: TextStyle(
                                        color: themeNotifier.isLight() ? HexColor('#979797') : Colors.white70,
                                        fontSize: isScreenHasSmallWidth(context) ? 12 : 14,
                                      ),
                                    ),
                                    const SizedBox(height: 10.0,),
                                    Text(
                                      translate(
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
                                      translate('employmentStatus', context),
                                      style: TextStyle(
                                        color: themeNotifier.isLight() ? HexColor('#979797') : Colors.white70,
                                        fontSize: isScreenHasSmallWidth(context) ? 12 : 14,
                                      ),
                                    ),
                                    const SizedBox(height: 10.0,),
                                    Text(
                                      translate(
                                          servicesProvider.deadPersonInfo['cur_getdata2'][0][dependentIndex]['IS_WORK'] == 0
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
                                      translate('hasDisability', context),
                                      style: TextStyle(
                                        color: themeNotifier.isLight() ? HexColor('#979797') : Colors.white70,
                                        fontSize: isScreenHasSmallWidth(context) ? 12 : 14,
                                      ),
                                    ),
                                    const SizedBox(height: 10.0,),
                                    Text(
                                      translate(
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
                                      translate('getsSalary', context),
                                      style: TextStyle(
                                        color: themeNotifier.isLight() ? HexColor('#979797') : Colors.white70,
                                        fontSize: isScreenHasSmallWidth(context) ? 12 : 14,
                                      ),
                                    ),
                                    const SizedBox(height: 10.0,),
                                    Text(
                                      translate(
                                          servicesProvider.deadPersonInfo['cur_getdata2'][0][dependentIndex]['IS_RETIRED'] == 0
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
                  const SizedBox(height: 20.0,),
                  Text(
                    translate('mobileNumber', context),
                    style: TextStyle(
                        color: HexColor('#363636'),
                        fontSize: width(0.032, context)
                    ),
                  ),
                  SizedBox(height: height(0.015, context),),
                  Row(
                    children: [
                      Expanded(
                        child: buildTextFormField(context, themeNotifier, servicesProvider.mobileNumberController, '', (val){
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
                                '+${selectedMobileCountry.value}',
                                style: TextStyle(
                                  color: HexColor('#363636'),
                                ),
                              ),
                              Text(
                                selectedMobileCountry.flag,
                                style: TextStyle(
                                  color: HexColor('#363636'),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ],
          ),
          if(dependentIndex == ((servicesProvider.deadPersonInfo['cur_getdata2'].length != 0  && servicesProvider.deadPersonInfo['cur_getdata2'][0].length != 0) ? servicesProvider.deadPersonInfo['cur_getdata2'][0].length - 1 : 0))
            Padding(
              padding: const EdgeInsets.only(bottom: 5.0),
              child: textButtonWithIcon(
                  context, themeNotifier, 'addNewDependents', Colors.transparent, HexColor('#2D452E'),
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
                    // dependentModalBottomSheet(dependentIndex, isEdit: true);
                  },
                  borderColor: '#2D452E'
              ),
            )
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
                  nationality = firstChoice;
                  nationalIdController.clear();
                  servicesProvider.isNationalIdValid = false;
                  selectedDateOfBirth = DateTime.now();
                  selectedDeathDate = DateTime.now();
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
                  backgroundColor: (flag == 1 && nationality == firstChoice)
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
                  deathType = 0;
                  deathPlace = 0;
                  nationality = secondChoice;
                  nationalIdController.clear();
                  servicesProvider.isNationalIdValid = false;
                  selectedDateOfBirth = DateTime.now();
                  selectedDeathDate = DateTime.now();
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
                  backgroundColor: (flag == 1 && nationality == secondChoice)
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
              value: flag == 1 ? menuList[deathType] : menuList[deathPlace],
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
                });
              },
              items: menuList.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: SizedBox(
                    width: width(0.7, context),
                    child: Text(
                      translate(value, context),
                      style: TextStyle(
                        fontSize: isTablet(context) ? 20 : 15,
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

  /// TODO: add death person's documents to the documents when get his data

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
        Text(translate(key, context))
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
              servicesProvider.deadPersonInfo['cur_getdata2'][0].forEach((element){
                element = {
                  ...element,
                  "SOURCE_FLAG": 1,
                  "INHERITOR_DOCS": [],
                  "NATIONAL_NO": value['NATIONALNUMBER'],
                  "IS_ALIVE_A": value['IS_ALIVE'],
                  "MARITAL_STATUS_A": value['SOCIAL_STATUS'],
                  "WORK_STATUS": value['IS_WORK'],
                  "RELATION": value['RELATIVETYPE'],
                  "DISABILITY": 0,
                  "LAST_EVENT_DATE": value['LAST_SOC_STATUS_DATE'],
                  "SOCIAL_STATUS_A": value['SOCIAL_STATUS'],
                  "IS_WORK_A": value['IS_WORK'],
                  "IS_RETIRED_A": value['IS_RETIRED'],
                  "permanentDisability": 0,
                  "dateOfLastStatus": value['LAST_SOC_STATUS_DATE'],
                  "GUARDIANNAT": value['AGE'] < 18 ? 1 : null,
                  "validPhone": (value['MOBILE'] != null) ? true : false,
                  "DEP_CODE": "${DateTime.now().millisecondsSinceEpoch}${((math.Random().nextDouble() * 10000) + 1).floor()}",
                  "INTERNATIONAL_CODE": value['INTERNATIONAL_CODE'] ? value['INTERNATIONAL_CODE'] : 962
                };
              });
              servicesProvider.notifyMe();
            });
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
        showMyDialog(context, 'failed', translate('somethingWrongHappened', context), 'ok', themeNotifier);
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
}

enum ContextMenu { edit, delete }

