// ignore_for_file: file_names

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
import '../../../../../utilities/hexColor.dart';
import '../../../../../utilities/theme/themes.dart';
import '../../../../../utilities/util.dart';
import 'dart:math' as math;
import '../../../../viewModel/login/loginProvider.dart';
import '../../shared/firstStepScreen.dart';
import '../../shared/paymentScreen.dart';
import '../../shared/verifyMobileNumberScreen.dart';

class MaternityAllowanceApplicationScreen extends StatefulWidget {
  const MaternityAllowanceApplicationScreen({Key key}) : super(key: key);

  @override
  State<MaternityAllowanceApplicationScreen> createState() => _MaternityAllowanceApplicationScreenState();
}

class _MaternityAllowanceApplicationScreenState extends State<MaternityAllowanceApplicationScreen> {

  ServicesProvider servicesProvider;
  ThemeNotifier themeNotifier;
  bool termsChecked = false;
  bool isNewBornValidID = false;
  // ignore: prefer_typing_uninitialized_variables
  var newBornData;
  DateTime minDate;
  DateTime maxDate;
  DateTime selectedMinDate;
  String selectedNewbornNationality = 'jordanian';
  String selectedPlaceOfBirth = 'insideJordan';
  String isTherePermitToExpectHisBirth = 'yes';
  TextEditingController newbornNationalNumberController = TextEditingController();

  checkContinueEnabled({flag = 0}){
    if(flag == 1){
      return mobileNumberValidate(servicesProvider.mobileNumberController.text);
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
                        const DocumentsScreen(nextStep: 'receiptOfAllowances', numberOfSteps: 5, data: {}, serviceType: 4, dependents: [], relations: [], nextStepNumber: 4,),
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
                                      await servicesProvider.updateUserMobileNumberCheckOTP(servicesProvider.pinPutCodeController.text).whenComplete((){})
                                          .then((val) async {
                                        if(val['PO_STATUS'] == 1){
                                          Provider.of<AccountSettingsProvider>(context, listen: false).updateUserInfo(4, servicesProvider.mobileNumberController.text).whenComplete((){}).then((value){
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

                                }
                              } break;
                              case 5: {

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
            const SizedBox(height: 10.0,),
            buildFieldTitle(context, 'newbornNationality', required: false),
            const SizedBox(height: 10.0,),
            customTwoRadioButtons(1, 'jordanian', 'nonJordanian', setState),
            const SizedBox(height: 15.0,),
            buildFieldTitle(context, 'placeOfBirth', required: false),
            const SizedBox(height: 10.0,),
            customTwoRadioButtons(2, 'insideJordan', 'outsideJordan', setState),
            const SizedBox(height: 15.0,),
            buildFieldTitle(context, selectedNewbornNationality == 'jordanian' ? 'newbornNationalNumber' : 'newbornNationalID', required: false),
            const SizedBox(height: 10.0,),
            buildTextFormField(context, themeNotifier, newbornNationalNumberController, '9999999999', (value) async {
              if((selectedNewbornNationality == 'jordanian' && value.length == 10) || selectedNewbornNationality != 'jordanian'){
                FocusScope.of(context).requestFocus(FocusNode());
                String message = '';
                servicesProvider.isLoading = true;
                servicesProvider.notifyMe();
                try{
                  await servicesProvider.getMaternityChildService(value).whenComplete((){}).then((value) async {
                    if(value['PO_status'] == 0){
                      setState(() {
                        isNewBornValidID = true;
                        newBornData = value;
                        minDate = DateFormat('dd/MM/yyyy').parse(value['cur_getdata'][0][0]['CHILD_BIRTHDATE']);
                        selectedMinDate = minDate;
                        maxDate = DateFormat('dd/MM/yyyy').parse(value['cur_getdata'][0][0]['CHILD_BIRTHDATE']).add(
                            Duration(days: servicesProvider.result['p_per_info'][0][0]['MAT_VAC_PERIOD'] - 1)
                        );
                      });
                      servicesProvider.notifyMe();
                    } else{
                      setState(() {
                        isNewBornValidID = false;
                        newBornData = null;
                        minDate = null;
                        selectedMinDate = minDate;
                        maxDate = null;
                      });
                      servicesProvider.notifyMe();
                      message = UserConfig.instance.isLanguageEnglish()
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
              } else{
                setState(() {
                  isNewBornValidID = false;
                  newBornData = null;
                  minDate = null;
                  selectedMinDate = minDate;
                  maxDate = null;
                });
                servicesProvider.notifyMe();
              }
            }),
            const SizedBox(height: 15.0,),
            if(isNewBornValidID)
            Column(
              children: [
                buildFieldTitle(context, 'isTherePermitToExpectHisBirth', required: false),
                const SizedBox(height: 10.0,),
                customTwoRadioButtons(3, 'yes', 'no', setState),
                const SizedBox(height: 15.0,),
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
                              isTherePermitToExpectHisBirth == 'yes'
                              ? '${getTranslated('choose', context)} ${getTranslated('theStartDateOfTheLeave', context)}'
                              : DateFormat('dd/MM/yyyy').format(minDate),
                              style: TextStyle(
                                color: HexColor('#A6A6A6'),
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        if(isTherePermitToExpectHisBirth == 'yes')
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
                              minTime: minDate,
                              maxTime: maxDate,
                              onConfirm: (date) {
                                setState(() {
                                  selectedMinDate = date;
                                });
                              },
                              currentTime: selectedMinDate,
                              locale: LocaleType.en,
                            );
                          },
                          child: SvgPicture.asset('assets/icons/calenderBox.svg'),
                        )
                      ],
                    ),
                    SizedBox(height: isTherePermitToExpectHisBirth == 'yes' ? 10.0 : 0,),
                    if(isTherePermitToExpectHisBirth == 'yes')
                    SizedBox(
                      height: 82.0,
                      child: ListView.builder(
                        itemCount: maxDate.difference(minDate).inDays + 1,
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index){
                          DateTime date = minDate.add(Duration(days: index));
                          String dayName = DateFormat('EEEE').format(date);
                          String dayNumber = DateFormat('d').format(date);
                          return Row(
                            children: [
                              InkWell(
                                onTap: (){
                                  setState(() {
                                    selectedMinDate = date;
                                  });
                                },
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 300),
                                  width: 80,
                                  height: 80,
                                  decoration: BoxDecoration(
                                    color: selectedMinDate == date ? primaryColor : Colors.transparent,
                                    borderRadius: BorderRadius.circular(8.0),
                                    border: Border.all(
                                      color: selectedMinDate == date ? Colors.transparent : HexColor('#979797'),
                                    )
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        dayNumber,
                                        style: TextStyle(
                                          color: selectedMinDate == date ? HexColor('#FFFFFF') : HexColor('#363636'),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 5.0,),
                                      Text(
                                        dayName,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: selectedMinDate == date ? HexColor('#FFFFFF') : HexColor('#363636'),
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
                    )
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20.0,),
            if(isNewBornValidID && newBornData != null)
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
                          SizedBox(
                            width: width(0.6, context),
                            child: Text(
                              '${newBornData['cur_getdata'][0][0]['C_M_NAME1']??''} ${newBornData['cur_getdata'][0][0]['C_M_NAME2']??''} ${newBornData['cur_getdata'][0][0]['C_M_NAME3']??''} ${newBornData['cur_getdata'][0][0]['C_M_NAME4']??''}',
                              style: TextStyle(
                                height: 1.4,
                                color: themeNotifier.isLight() ? HexColor('#363636') : Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15.0,),
                      Row(
                        children: [
                          Text(
                            newbornNationalNumberController.text,
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
                            getTranslated(selectedNewbornNationality, context),
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
                            getTranslated('theDateTheLeaveEnds', context),
                            style: TextStyle(
                              color: themeNotifier.isLight() ? HexColor('#716F6F') : Colors.white70,
                            ),
                          ),
                          Text(
                            ' : ',
                            style: TextStyle(
                              color: themeNotifier.isLight() ? HexColor('#716F6F') : Colors.white70,
                            ),
                          ),
                          Text(
                            DateFormat('dd/MM/yyyy').format(selectedMinDate.add(Duration(days: servicesProvider.result['p_per_info'][0][0]['MAT_VAC_PERIOD'] - 1))),
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

            const SizedBox(height: 15.0,),
          ],
        ),
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
                selectedNewbornNationality = firstChoice;
                isNewBornValidID = false;
                newBornData = null;
                minDate = null;
                selectedMinDate = minDate;
                maxDate = null;
              }else if(flag == 2){
                selectedPlaceOfBirth = firstChoice;
                isNewBornValidID = false;
                newBornData = null;
                minDate = null;
                selectedMinDate = minDate;
                maxDate = null;
              }else if(flag == 3){
                isTherePermitToExpectHisBirth = firstChoice;
                minDate = DateFormat('dd/MM/yyyy').parse(newBornData['cur_getdata'][0][0]['CHILD_BIRTHDATE']).subtract(
                  Duration(days: servicesProvider.result['p_per_info'][0][0]['MAX_EXP_VAC']),
                );
                selectedMinDate = minDate;
                maxDate = DateFormat('dd/MM/yyyy').parse(newBornData['cur_getdata'][0][0]['CHILD_BIRTHDATE']);
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
                  backgroundColor: (flag == 1 && selectedNewbornNationality == firstChoice) || (flag == 2 && selectedPlaceOfBirth == firstChoice) || (flag == 3 && isTherePermitToExpectHisBirth == firstChoice)
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
                selectedNewbornNationality = secondChoice;
                isNewBornValidID = false;
                newBornData = null;
                minDate = null;
                selectedMinDate = minDate;
                maxDate = null;
              }else if(flag == 2){
                selectedPlaceOfBirth = secondChoice;
                isNewBornValidID = false;
                newBornData = null;
                minDate = null;
                selectedMinDate = minDate;
                maxDate = null;
              }else if(flag == 3){
                isTherePermitToExpectHisBirth = secondChoice;
                minDate = DateFormat('dd/MM/yyyy').parse(newBornData['cur_getdata'][0][0]['CHILD_BIRTHDATE']);
                selectedMinDate = minDate;
                maxDate = DateFormat('dd/MM/yyyy').parse(newBornData['cur_getdata'][0][0]['CHILD_BIRTHDATE']).add(
                  Duration(days: servicesProvider.result['p_per_info'][0][0]['MAT_VAC_PERIOD'] - 1),
                );
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
                  backgroundColor: (flag == 1 && selectedNewbornNationality == secondChoice) || (flag == 2 && selectedPlaceOfBirth == secondChoice) || (flag == 3 && isTherePermitToExpectHisBirth == secondChoice)
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

