// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:ssc/source/view/services/shared/firstStepScreen.dart';
import 'package:ssc/source/view/services/shared/verifyMobileNumberScreen.dart';
import 'package:ssc/source/viewModel/services/servicesProvider.dart';
import 'package:ssc/utilities/util.dart';
import 'dart:math' as math;
import '../../../../../infrastructure/userConfig.dart';
import '../../../../../infrastructure/userSecuredStorage.dart';
import '../../../../../utilities/hexColor.dart';
import '../../../../../utilities/theme/themes.dart';
import '../../../../viewModel/utilities/theme/themeProvider.dart';

class WorkInjuryComplaintScreen extends StatefulWidget {
  const WorkInjuryComplaintScreen({Key key}) : super(key: key);

  @override
  State<WorkInjuryComplaintScreen> createState() => _WorkInjuryComplaintScreenState();
}

class _WorkInjuryComplaintScreenState extends State<WorkInjuryComplaintScreen> {
  ServicesProvider servicesProvider;
  DateTime selectedDateTime = DateTime.now();

  @override
  void initState() {
    servicesProvider = Provider.of<ServicesProvider>(context, listen: false);
    servicesProvider.mobileNumberController.text = UserSecuredStorage.instance.realMobileNumber;
    servicesProvider.stepNumber = 1;
    servicesProvider.selectedInjuredType = 'occupationalDisease';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ThemeNotifier themeNotifier = Provider.of<ThemeNotifier>(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(getTranslated('report_a_sickness/work_injury_complaint', context)),
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: InkWell(
            onTap: (){
              switch(servicesProvider.stepNumber){
                case 1: Navigator.of(context).pop(); break;
                case 2: servicesProvider.stepNumber = 1; break;
                case 3: servicesProvider.stepNumber = 2; break;
                case 4: servicesProvider.stepNumber = 3; break;
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
                      const FirstStepScreen(nextStep: 'orderDetails', numberOfSteps: 4,),
                    if(Provider.of<ServicesProvider>(context).stepNumber == 2 && Provider.of<ServicesProvider>(context).isMobileNumberUpdated)
                      VerifyMobileNumberScreen(nextStep: 'orderDetails', numberOfSteps: 4, mobileNo: servicesProvider.mobileNumberController.text ?? ''),
                    if(Provider.of<ServicesProvider>(context).stepNumber == 2 && !Provider.of<ServicesProvider>(context).isMobileNumberUpdated)
                      secondStep(context, themeNotifier),
                    if(Provider.of<ServicesProvider>(context).stepNumber == 3)
                      thirdStep(context, themeNotifier),
                    if(Provider.of<ServicesProvider>(context).stepNumber == 4)
                      forthStep(context, themeNotifier),
                    textButton(context,
                      themeNotifier,
                      Provider.of<ServicesProvider>(context).stepNumber != 4 ? 'continue' : 'send',
                      getPrimaryColor(context, themeNotifier),
                      HexColor('#ffffff'),
                          (){
                        switch(servicesProvider.stepNumber){
                          case 1: servicesProvider.stepNumber = 2; break;
                          case 2:
                            {
                              if(servicesProvider.isMobileNumberUpdated){
                                servicesProvider.stepNumber = 2;
                                servicesProvider.isMobileNumberUpdated = false;
                              } else{
                                servicesProvider.stepNumber = 3;
                              }
                            } break;
                          case 3: servicesProvider.stepNumber = 4; break;
                          case 4: {
                            SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
                              servicesProvider.selectedServiceRate = -1;
                              servicesProvider.notifyMe();
                              rateServiceBottomSheet(context, themeNotifier, servicesProvider);
                            });
                          } break; /// TODO: finish service
                        }
                        servicesProvider.notifyMe();
                      },
                    )
                    // SizedBox(height: height(0.01, context)),
                    // textButton(context,
                    //   themeNotifier,
                    //   'saveAsDraft',
                    //   MaterialStateProperty.all<Color>(Colors.transparent),
                    //   HexColor('#003C97'),
                    //       (){},
                    // ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget secondStep(context, themeNotifier){
    return SizedBox(
      height: isTablet(context) ? height(0.8, context) : isScreenHasSmallHeight(context) ? height(0.75, context) : height(0.77, context),
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
                      '2/4',
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
              getTranslated('injuryType', context),
              style: TextStyle(
                  color: HexColor('#363636'),
                  fontSize: width(0.032, context)
              ),
            ),
            SizedBox(height: height(0.015, context),),
            Row(
              children: [
                InkWell(
                  onTap: (){
                    servicesProvider.selectedInjuredType = 'occupationalDisease';
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
                          backgroundColor: servicesProvider.selectedInjuredType == 'occupationalDisease'
                              ? HexColor('#2D452E') : Colors.transparent,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          getTranslated('occupationalDisease', context),
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
                    servicesProvider.selectedInjuredType = 'workInjury';
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
                          backgroundColor: servicesProvider.selectedInjuredType == 'workInjury'
                              ? HexColor('#2D452E') : Colors.transparent,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          getTranslated('workInjury', context),
                          style: TextStyle(
                            color: HexColor('#666666'),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: height(0.015, context),),
            Text(
              getTranslated('accidentsDateAndTime', context),
              style: TextStyle(
                  color: HexColor('#363636'),
                  fontSize: width(0.032, context)
              ),
            ),
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
                    setState(() {
                      selectedDateTime = date;
                    });
                  },
                  currentTime: selectedDateTime,
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
                      DateFormat('dd/MM/yyyy').format(selectedDateTime),
                    ),
                    SvgPicture.asset('assets/icons/datePickerIcon.svg'),
                  ],
                ),
              ),
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
        child: Container(
          alignment: Alignment.center,
          height: isTablet(context) ? height(0.8, context) : isScreenHasSmallHeight(context) ? height(0.75, context) : height(0.77, context),
          child: Text(getTranslated('thirdStep', context)),
        ),
      ),
    );
  }

  Widget forthStep(context, themeNotifier){
    return SizedBox(
      height: isTablet(context) ? height(0.78, context) : isScreenHasSmallHeight(context) ? height(0.73, context) : height(0.75, context),
      child: SingleChildScrollView(
        child: Container(
          alignment: Alignment.center,
          height: isTablet(context) ? height(0.8, context) : isScreenHasSmallHeight(context) ? height(0.75, context) : height(0.77, context),
          child: Text(getTranslated('forthStep', context)),
        ),
      ),
    );
  }

}