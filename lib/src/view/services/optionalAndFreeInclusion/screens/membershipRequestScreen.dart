// ignore_for_file: file_names

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:ssc/src/view/services/shared/firstStepScreen.dart';
import 'package:ssc/src/viewModel/services/servicesProvider.dart';
import 'package:ssc/utilities/util.dart';
import 'dart:math' as math;
import 'dart:ui' as ui;
import '../../../../../infrastructure/userConfig.dart';
import '../../../../../utilities/hexColor.dart';
import '../../../../../utilities/theme/themes.dart';
import '../../../../viewModel/utilities/theme/themeProvider.dart';

class MembershipRequestScreen extends StatefulWidget {
  const MembershipRequestScreen({Key key}) : super(key: key);

  @override
  State<MembershipRequestScreen> createState() => _MembershipRequestScreenState();
}

class _MembershipRequestScreenState extends State<MembershipRequestScreen> {
  ServicesProvider servicesProvider;
  int selectedCalculateAccordingTo = 1;
  bool showPanel = false;
  double currentSliderValue = 200;
  TextEditingController confirmMonthlyController = TextEditingController();
  TextEditingController confirmSalaryController = TextEditingController();

  @override
  void initState() {
    servicesProvider = Provider.of<ServicesProvider>(context, listen: false);
    servicesProvider.stepNumber = 1;
    showPanel = false;
    servicesProvider.monthlyInstallmentController.text = currentSliderValue.toStringAsFixed(0);
    servicesProvider.readCountriesJson();
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
              if(!showPanel) {
                switch(servicesProvider.stepNumber){
                  case 1: Navigator.of(context).pop(); break;
                  case 2: servicesProvider.stepNumber = 1; break;
                  case 3: servicesProvider.stepNumber = 2; break;
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
              child: SingleChildScrollView(
                child: Container(
                  width: width(1, context),
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      if(Provider.of<ServicesProvider>(context).stepNumber == 1)
                        const FirstStepScreen(nextStep: 'payCalculation', numberOfSteps: 3),
                      if(Provider.of<ServicesProvider>(context).stepNumber == 2)
                        secondStep(context, themeNotifier),
                      if(Provider.of<ServicesProvider>(context).stepNumber == 3)
                        thirdStep(context, themeNotifier),
                      textButton(context,
                        themeNotifier,
                        Provider.of<ServicesProvider>(context).stepNumber != 3 ? 'continue' : 'send',
                        MaterialStateProperty.all<Color>(
                            getPrimaryColor(context, themeNotifier)),
                        HexColor('#ffffff'),
                            (){
                          switch(servicesProvider.stepNumber){
                            case 1: servicesProvider.stepNumber = 2; break;
                            case 2: {
                              servicesProvider.stepNumber = 3;
                              // confirmMonthlyController.text = selectedCalculateAccordingTo == 1 ? servicesProvider.monthlyInstallmentController.text : '1200';
                              confirmMonthlyController.text = servicesProvider.monthlyInstallmentController.text;
                              confirmSalaryController.text = '1200';
                            } break;
                            case 3: {
                              setState(() {
                                showPanel = true;
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
          ),
          if(showPanel)
          SlidingUpPanel(
            maxHeight: height(0.53, context),
            minHeight: height(0.53, context),
            parallaxEnabled: true,
            parallaxOffset: .5,
            color: HexColor('#FFFFFF'),
            defaultPanelState: PanelState.CLOSED,
            body: BackdropFilter(
              filter: ui.ImageFilter.blur(sigmaX: .8, sigmaY: .8),
              child: Container(
                color: const Color.fromRGBO(48, 48, 48, 0.51),
              ),
            ),
            panelBuilder: (sc) => _panel(sc, themeNotifier),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(25.0),
              topRight: Radius.circular(25.0),
            ),
          ),
        ],
      ),
    );
  }

  Widget secondStep(context, themeNotifier){
    return SingleChildScrollView(
      child: SizedBox(
        height: height(0.78, context),
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
            Container(
              padding: const EdgeInsets.all(5.0),
              decoration: BoxDecoration(
                color: HexColor('#F0F2F0'),
                borderRadius: BorderRadius.circular(50.0),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: (){
                        setState(() {
                          selectedCalculateAccordingTo = 1;
                        });
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(vertical: 6.0),
                        decoration: BoxDecoration(
                          color: selectedCalculateAccordingTo == 1
                              ? HexColor('#445740') : Colors.transparent,
                          borderRadius: BorderRadius.circular(50.0),
                        ),
                        child: Text(
                          translate('monthlyInstallment', context),
                          style: TextStyle(
                              color: selectedCalculateAccordingTo == 1
                                  ? Colors.white : HexColor('#A6A6A6')
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  Expanded(
                    child: InkWell(
                      onTap: (){
                        setState(() {
                          selectedCalculateAccordingTo = 2;
                        });
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 100),
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(vertical: 6.0),
                        decoration: BoxDecoration(
                          color: selectedCalculateAccordingTo == 2
                              ? HexColor('#445740') : Colors.transparent,
                          borderRadius: BorderRadius.circular(50.0),
                        ),
                        child: Text(
                          translate('salary', context),
                          style: TextStyle(
                              color: selectedCalculateAccordingTo == 2
                                  ? Colors.white : HexColor('#A6A6A6')
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: height(0.04, context),),
            Text(
              translate('selectMonthlyInstallment', context),
              style: TextStyle(
                  color: HexColor('#363636'),
                  fontSize: width(0.032, context)
              ),
            ),
            SizedBox(height: height(0.015, context),),
            Row(
              children: [
                Flexible(
                  flex: 5,
                  child: Slider(
                    activeColor: HexColor('#363636'),
                    inactiveColor: HexColor('#E0E0E0'),
                    value: currentSliderValue,
                    max: 800,
                    divisions: 800,
                    label: currentSliderValue.round().toString(),
                    onChanged: selectedCalculateAccordingTo == 1
                      ? (double value) {
                      servicesProvider.monthlyInstallmentController.text = value.toStringAsFixed(0);
                      servicesProvider.notifyMe();
                      setState(() {
                        currentSliderValue = value;
                      });
                    } : null,
                  ),
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
                          setState(() {
                            if(servicesProvider.monthlyInstallmentController.text.isNotEmpty) {
                              if(double.parse(servicesProvider.monthlyInstallmentController.text) <= 800){
                                currentSliderValue = double.parse(servicesProvider.monthlyInstallmentController.text);
                              } else{
                                currentSliderValue = 800;
                                servicesProvider.monthlyInstallmentController.text = "800";
                              }
                              currentSliderValue = double.parse(servicesProvider.monthlyInstallmentController.text);
                            } else{
                              currentSliderValue = 0;
                              servicesProvider.monthlyInstallmentController.text = "0";
                            }
                          });
                          servicesProvider.notifyMe();
                        },
                      ),
                    ],
                  )
                )
              ],
            ),
            SizedBox(height: height(0.04, context),),
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
                    '1200',
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
      ),
    );
  }

  Widget thirdStep(context, themeNotifier){
    return SingleChildScrollView(
      child: SizedBox(
        height: height(0.78, context),
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
              translate('monthlyInstallment', context),
              style: TextStyle(
                  color: HexColor('#363636'),
                  fontSize: width(0.032, context)
              ),
            ),
            SizedBox(height: height(0.015, context),),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  flex: 9,
                  child: buildTextFormField(context, themeNotifier, confirmMonthlyController, '', (value){}),
                ),
                Flexible(
                  flex: 1,
                  child: Text(
                    translate('jd', context),
                    style: TextStyle(
                        color: themeNotifier.isLight()
                            ? Colors.black
                            : Colors.white,
                        fontSize: width(isTablet(context) ? 0.028 : 0.031, context)),
                  ),
                ),
                const SizedBox.shrink()
              ],
            ),
            SizedBox(height: height(0.04, context),),
            Text(
              translate('salary', context),
              style: TextStyle(
                  color: HexColor('#363636'),
                  fontSize: width(0.032, context)
              ),
            ),
            SizedBox(height: height(0.015, context),),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  flex: 9,
                  child: buildTextFormField(context, themeNotifier, confirmSalaryController, '', (value){}),
                ),
                Flexible(
                  flex: 1,
                  child: Text(
                    translate('jd', context),
                    style: TextStyle(
                        color: themeNotifier.isLight()
                            ? Colors.black
                            : Colors.white,
                        fontSize: width(isTablet(context) ? 0.028 : 0.031, context)),
                  ),
                ),
                const SizedBox.shrink()
              ],
            ),
          ],
        ),
      ),
    );
  }

  monthlyInstallmentTextFormField(controller, themeNotifier, onChanged){
    return Opacity(
      opacity: selectedCalculateAccordingTo == 2 ? 0.5 : 1,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: TextFormField(
          readOnly: selectedCalculateAccordingTo == 2,
          textAlignVertical: TextAlignVertical.center,
          textAlign: TextAlign.center,
          controller: controller,
          keyboardType: TextInputType.number,
          style: TextStyle(
            fontSize: isTablet(context) ? 20 : 15,
            color: HexColor('#363636'),
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
      ),
    );
  }

  Widget _panel(ScrollController sc, themeNotifier) {
    return MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          child: ListView(
            controller: sc,
            children: <Widget>[
              const SizedBox(
                height: 12.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: 40,
                    height: 5,
                    decoration: BoxDecoration(
                        color: HexColor('#000000'),
                        borderRadius: const BorderRadius.all(Radius.circular(25.0))),
                  ),
                ],
              ),
              const SizedBox(
                height: 18.0,
              ),
              Text(
                translate('serviceEvaluation', context),
                style: const TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 20.0,
                ),
              ),
              const SizedBox(
                height: 18.0,
              ),
              Text(
                translate('howEasyToApply', context),
                style: const TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 16.0,
                ),
              ),
              const SizedBox(
                height: 12.0,
              ),
              Text(
                translate('howEasyToApplyDesc', context),
                style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 12.0,
                  color: HexColor('#979797')
                ),
              ),
              const SizedBox(
                height: 12.0,
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                width: width(1, context),
                height: height(0.1, context),
                child: ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: 5,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index){
                    return Row(
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: HexColor('#2D452E'),
                          child: Text(
                            '${index + 1}',
                            style: const TextStyle(
                              color: Colors.white
                            ),
                          ),
                        ),
                        const SizedBox(width: 10.0)
                      ],
                    );
                  }
                ),
              ),
              const SizedBox(
                height: 20.0,
              ),
              Text(
                translate('shareYourOpinion', context),
                style: const TextStyle(
                    fontSize: 16.0,
                ),
              ),
              const SizedBox(
                height: 12.0,
              ),
              buildTextFormField(context, themeNotifier, TextEditingController(), '', (value){}, minLines: 5),
              const SizedBox(
                height: 25.0,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: textButton(context, themeNotifier, 'done', MaterialStateProperty.all<Color>(
                    primaryColor
                ), Colors.white, (){
                  setState(() {
                    showPanel = false;
                  });
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                }),
              )
            ],
          ),
        )
    );
  }

}