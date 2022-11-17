// ignore_for_file: file_names

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:ssc/src/view/services/shared/firstStepScreen.dart';
import 'package:ssc/src/viewModel/services/servicesProvider.dart';
import 'package:ssc/utilities/util.dart';
import 'dart:math' as math;
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

  @override
  void initState() {
    servicesProvider = Provider.of<ServicesProvider>(context, listen: false);
    servicesProvider.stepNumber = 1;
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
      body: GestureDetector(
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
                    const FirstStepScreen(nextStep: 'payCalculation'),
                  if(Provider.of<ServicesProvider>(context).stepNumber == 2)
                    secondStep(context, themeNotifier),
                  if(Provider.of<ServicesProvider>(context).stepNumber == 3)
                    thirdStep(context, themeNotifier),
                  if(Provider.of<ServicesProvider>(context).stepNumber == 4)
                    forthStep(context, themeNotifier),
                  textButton(context,
                    themeNotifier,
                    Provider.of<ServicesProvider>(context).stepNumber != 4 ? 'continue' : 'finish',
                    MaterialStateProperty.all<Color>(
                        getPrimaryColor(context, themeNotifier)),
                    HexColor('#ffffff'),
                        (){
                      switch(servicesProvider.stepNumber){
                        case 1: servicesProvider.stepNumber = 2; break;
                        case 2: servicesProvider.stepNumber = 3; break;
                        case 3: servicesProvider.stepNumber = 4; break;
                        case 4: if (kDebugMode) {
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
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
                      '2/4',
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
            SizedBox(height: height(0.02, context),),
            Text(
              translate('CalculateAccordingTo', context),
              style: TextStyle(
                  color: HexColor('#363636'),
                  fontSize: width(0.032, context)
              ),
            ),
            SizedBox(height: height(0.015, context),),
          ],
        ),
      ),
    );
  }

  Widget thirdStep(context, themeNotifier){
    return SingleChildScrollView(
      child: Container(
        alignment: Alignment.center,
        height: height(0.78, context),
        child: Text(translate('thirdStep', context)),
      ),
    );
  }

  Widget forthStep(context, themeNotifier){
    return SingleChildScrollView(
      child: Container(
        alignment: Alignment.center,
        height: height(0.78, context),
        child: Text(translate('forthStep', context)),
      ),
    );
  }

}