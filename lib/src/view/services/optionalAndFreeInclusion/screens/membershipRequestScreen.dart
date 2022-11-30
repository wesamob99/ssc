// ignore_for_file: file_names, use_build_context_synchronously

import 'package:drop_down_list/drop_down_list.dart';
import 'package:drop_down_list/model/selected_list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/svg.dart';
import 'package:group_radio_button/group_radio_button.dart';
import 'package:provider/provider.dart';
import 'package:ssc/src/view/services/shared/firstStepScreen.dart';
import 'package:ssc/src/viewModel/services/servicesProvider.dart';
import 'package:ssc/utilities/util.dart';
import 'dart:math' as math;
import '../../../../../infrastructure/userConfig.dart';
import '../../../../../utilities/hexColor.dart';
import '../../../../../utilities/theme/themes.dart';
import '../../../../viewModel/utilities/theme/themeProvider.dart';
import '../../shared/verifyMobileNumberScreen.dart';

class MembershipRequestScreen extends StatefulWidget {
  const MembershipRequestScreen({Key key}) : super(key: key);

  @override
  State<MembershipRequestScreen> createState() => _MembershipRequestScreenState();
}

class _MembershipRequestScreenState extends State<MembershipRequestScreen> {
  ServicesProvider servicesProvider;
  String selectedCalculateAccordingTo = 'lastSalary';
  List<String> calculateAccordingToList = [];
  List<SelectedListItem> listOfRates= [];
  SelectedListItem selectedRate= SelectedListItem(name: '1', natCode: null, flag: '');
  List<SelectedListItem> listOfYears= [];
  SelectedListItem selectedYear= SelectedListItem(name: '1', natCode: null, flag: '');
  double currentSliderValue = 0;
  double minSalary = 0;
  double maxSalary = 0;
  String confirmMonthlyValue = '';
  String confirmSalaryValue = '';

  @override
  void initState() {
    servicesProvider = Provider.of<ServicesProvider>(context, listen: false);
    servicesProvider.stepNumber = 1;
    listOfYears = [];
    for(int i=1 ; i<=servicesProvider.result['cur_getdata'][0][0]['NOOFINCREMENTS']  ; i++){
      listOfYears.add(SelectedListItem(name: '$i', natCode: null, flag: ''));
    }
    listOfRates = [];
    for(int i=1 ; i<=servicesProvider.result['cur_getdata'][0][0]['MAX_PER_OF_INC']  ; i++){
      listOfRates.add(SelectedListItem(name: '$i', natCode: null, flag: ''));
    }
    if(servicesProvider.result['PO_is_it_firstOptionalSub'] == 0){
      calculateAccordingToList = ['lastSalary', 'increaseInAllowanceForDeductionYears'];
      if(servicesProvider.result['cur_getdata'][0][0]['HASBENEFITOFINC'] != 0) {
        calculateAccordingToList.add('discountNotMoreThan-20');
      }
      currentSliderValue = minSalary = double.tryParse(servicesProvider.result['cur_getdata'][0][0]['MINIMUMSALARYFORCHOOSE'].toString());
      servicesProvider.monthlyInstallmentController.text = currentSliderValue.toStringAsFixed(0);
      maxSalary = double.tryParse(servicesProvider.result['cur_getdata'][0][0]['MINIMUMSALARYFORDEC'].toString());
    } else{
      calculateAccordingToList = ['lastSalary', 'increaseInAllowanceForDeductionYears', 'discountNotMoreThan-20', 'lastSalaryAccordingToTheDefenseLaw'];
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ThemeNotifier themeNotifier = Provider.of<ThemeNotifier>(context);

    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(translate('membershipRequest', context)),
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: InkWell(
            onTap: (){
              switch(servicesProvider.stepNumber){
                case 1: Navigator.of(context).pop(); break;
                case 2:
                  {
                    if(servicesProvider.result['PO_is_it_firstOptionalSub'] == 0){
                      currentSliderValue = minSalary = double.tryParse(servicesProvider.result['cur_getdata'][0][0]['MINIMUMSALARYFORCHOOSE'].toString());
                      servicesProvider.monthlyInstallmentController.text = currentSliderValue.toStringAsFixed(0);
                      maxSalary = double.tryParse(servicesProvider.result['cur_getdata'][0][0]['MINIMUMSALARYFORDEC'].toString());
                    }
                    selectedCalculateAccordingTo = 'lastSalary';
                    confirmMonthlyValue = '';
                    confirmSalaryValue = '';
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
                      VerifyMobileNumberScreen(nextStep: 'payCalculation', numberOfSteps: 4, mobileNo: servicesProvider.mobileNumberController.text ?? ''),
                    if(Provider.of<ServicesProvider>(context).stepNumber == 2 && !Provider.of<ServicesProvider>(context).isMobileNumberUpdated)
                      secondStep(context, themeNotifier),
                    if(Provider.of<ServicesProvider>(context).stepNumber == 3)
                      thirdStep(context, themeNotifier),
                    textButton(context,
                      themeNotifier,
                      Provider.of<ServicesProvider>(context).stepNumber != 3 ? 'continue' : 'send',
                      MaterialStateProperty.all<Color>(
                          getPrimaryColor(context, themeNotifier)),
                      HexColor('#ffffff'),
                          () async {
                        switch(servicesProvider.stepNumber){
                          case 1: servicesProvider.stepNumber = 2; break;
                          case 2: {
                            if(servicesProvider.isMobileNumberUpdated){
                              servicesProvider.stepNumber = 2;
                              servicesProvider.isMobileNumberUpdated = false;
                            } else{
                              servicesProvider.stepNumber = 3;
                            }
                            confirmMonthlyValue = servicesProvider.monthlyInstallmentController.text;
                            confirmSalaryValue = (currentSliderValue * 0.175).toStringAsFixed(2);
                          } break;
                          case 3: {
                            String message = translate('somethingWrongHappened', context);
                            if(servicesProvider.result['PO_is_it_firstOptionalSub'] == 0 || servicesProvider.result['PO_is_it_firstOptionalSub'] == 1 || servicesProvider.result['PO_is_it_firstOptionalSub'] == 2) {
                              var value = await servicesProvider.optionalSubInsertNew().whenComplete((){});
                              if(servicesProvider.result['PO_is_it_firstOptionalSub'] == 1){
                                value = await servicesProvider.optionalSubFirstInsertNew().whenComplete((){});
                              }
                              if(value != '') {
                                message = UserConfig.instance.checkLanguage()
                                  ? value['PO_status_desc_en'] : value['PO_status_desc_ar'];
                              }
                              showMyDialog(context, (value != '' && value['PO_status'] == 1) ? 'doneSuccessfully' : 'failed', message, 'ok', themeNotifier).then((_){
                                SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
                                  servicesProvider.selectedServiceRate = -1;
                                  servicesProvider.notifyMe();
                                  rateServiceBottomSheet(context, themeNotifier, servicesProvider);
                                });
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
            Text(
              translate('CalculateAccordingTo', context),
              style: TextStyle(
                  color: HexColor('#363636'),
                  fontSize: width(0.032, context)
              ),
            ),
            SizedBox(height: height(0.015, context),),
            RadioGroup<String>.builder(
              activeColor: HexColor('#2D452E'),
              direction: Axis.vertical,
              horizontalAlignment: MainAxisAlignment.start,
              groupValue: selectedCalculateAccordingTo,
              spacebetween: 40,
              textStyle: isTablet(context)
                  ? TextStyle(
                  fontSize: width(0.025, context)
              ) : const TextStyle(),
              onChanged: (value) => setState(() {
                    selectedCalculateAccordingTo = value;
                  }),
              items: calculateAccordingToList,
              itemBuilder: (item) =>
                RadioButtonBuilder(
                  translate(item, context),
                ),
            ),
            SizedBox(height: height(0.02, context),),
            if(selectedCalculateAccordingTo == 'lastSalary')
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  translate('determineTheAffiliateWage', context),
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
                              activeColor: HexColor('#363636'),
                              inactiveColor: HexColor('#E0E0E0'),
                              value: currentSliderValue,
                              min: minSalary,
                              max: maxSalary,
                              divisions: minSalary != maxSalary ? (maxSalary - minSalary).floor() : 1,
                              label: currentSliderValue.round().toString(),
                              onChanged: (double value) {
                                servicesProvider.monthlyInstallmentController.text = value.toStringAsFixed(0);
                                servicesProvider.notifyMe();
                                setState(() {
                                  currentSliderValue = value;
                                });
                              },
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 15.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '$minSalary ${translate('jd', context)}',
                                    style: const TextStyle(
                                        fontSize: 13
                                    ),
                                  ),
                                  Text(
                                    '$maxSalary ${translate('jd', context)}',
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
                              translate('installmentValue', context),
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
                                  currentSliderValue = minSalary;
                                }
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
            if(selectedCalculateAccordingTo == 'increaseInAllowanceForDeductionYears')
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
                SizedBox(height: height(0.02, context),),
                Text(
                  translate('numberOfYears', context),
                  style: TextStyle(
                      color: HexColor('#363636'),
                      fontSize: width(0.032, context)
                  ),
                ),
                SizedBox(height: height(0.015, context),),
                buildDropDown(context, listOfYears, 2, servicesProvider)
              ],
            ),
            if(selectedCalculateAccordingTo == 'increaseInAllowanceForDeductionYears')
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
                          (minSalary * (double.tryParse(selectedRate.name) / 100) + minSalary).toStringAsFixed(2),
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
                          selectedCalculateAccordingTo == 'lastSalary' ? (currentSliderValue * 0.175).toStringAsFixed(3) : ((minSalary * (double.tryParse(selectedRate.name) / 100) + minSalary) * 0.175).toStringAsFixed(3),
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
            SizedBox(height: height(0.02, context),),
            Text(
              translate('CalculateAccordingTo', context),
              style: TextStyle(
                  color: HexColor('#363636'),
                  fontSize: width(0.036, context)
              ),
            ),
            SizedBox(height: height(0.015, context),),
            Text(translate(selectedCalculateAccordingTo, context)),
            SizedBox(height: height(0.035, context),),
            Text(
              translate('monthlyInstallment', context),
              style: TextStyle(
                  color: HexColor('#363636'),
                  fontSize: width(0.036, context)
              ),
            ),
            SizedBox(height: height(0.015, context),),
            Text('$confirmSalaryValue ${translate('jd', context)}'),
            SizedBox(height: height(0.035, context),),
            Text(
              translate('salary', context),
              style: TextStyle(
                  color: HexColor('#363636'),
                  fontSize: width(0.036, context)
              ),
            ),
            SizedBox(height: height(0.015, context),),
            Text('$confirmMonthlyValue ${translate('jd', context)}'),

          ],
        ),
      ),
    );
  }

  monthlyInstallmentTextFormField(controller, themeNotifier, onChanged){
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
        style: TextStyle(
          fontSize: isTablet(context) ? 20 : 15,
          color: minSalary != maxSalary ? HexColor('#363636') : Colors.grey,
        ),
        cursorColor: getPrimaryColor(context, themeNotifier),
        cursorWidth: 1,
        decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(horizontal: 5.0, vertical: isTablet(context) ? 20 : 0,),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: getPrimaryColor(context, themeNotifier),
                width: 0.5,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: getPrimaryColor(context, themeNotifier),
                width: 0.8,
              ),
            )
        ),
        onChanged: onChanged,
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
                flag == 1 ? selectedRate.name : selectedYear.name,
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