// ignore_for_file: file_names

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
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

class WorkInjuryComplaintScreen extends StatefulWidget {
  const WorkInjuryComplaintScreen({Key key}) : super(key: key);

  @override
  State<WorkInjuryComplaintScreen> createState() => _WorkInjuryComplaintScreenState();
}

class _WorkInjuryComplaintScreenState extends State<WorkInjuryComplaintScreen> {
  ServicesProvider servicesProvider;

  @override
  void initState() {
    servicesProvider = Provider.of<ServicesProvider>(context, listen: false);
    servicesProvider.stepNumber = 1;
    servicesProvider.readCountriesJson();
    servicesProvider.selectedInjuredType = 'occupationalDisease';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ThemeNotifier themeNotifier = Provider.of<ThemeNotifier>(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(translate('report_a_sickness/work_injury_complaint', context)),
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
        child: SingleChildScrollView(
          child: Container(
            width: width(1, context),
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if(Provider.of<ServicesProvider>(context).stepNumber == 1)
                  const FirstStepScreen(),
                if(Provider.of<ServicesProvider>(context).stepNumber == 2)
                  secondStep(context, themeNotifier, servicesProvider),
                if(Provider.of<ServicesProvider>(context).stepNumber == 3)
                  thirdStep(context, themeNotifier, servicesProvider),
                if(Provider.of<ServicesProvider>(context).stepNumber == 4)
                  forthStep(context, themeNotifier, servicesProvider),
                  textButton(context,
                  themeNotifier,
                  'continue',
                  MaterialStateProperty.all<Color>(
                      getPrimaryColor(context, themeNotifier)),
                  HexColor('#ffffff'),
                  (){
                    switch(servicesProvider.stepNumber){
                      case 1: servicesProvider.stepNumber = 2; break;
                      case 2: servicesProvider.stepNumber = 3; break;
                      case 3: servicesProvider.stepNumber = 4; break;
                      case 4: if (kDebugMode) {
                        print('finished!');
                      } break; /// TODO: finish service
                    }
                    servicesProvider.notifyMe();
                  },
                ),
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
    );
  }
}

Widget secondStep(context, themeNotifier, ServicesProvider servicesProvider){
  return SingleChildScrollView(
    child: SizedBox(
      height: height(0.7, context),
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
            translate('injuryType', context),
            style: TextStyle(
                color: HexColor('#363636'),
                fontSize: width(0.032, context)
            ),
          ),
          SizedBox(height: height(0.015, context),),
          RadioGroup<String>.builder(
            activeColor: HexColor('#2D452E'),
            direction: Axis.horizontal,
            horizontalAlignment: MainAxisAlignment.start,
            groupValue: servicesProvider.selectedInjuredType,
            spacebetween: 30,
            onChanged: (value){
              servicesProvider.selectedInjuredType = value;
              servicesProvider.notifyMe();
            },
            items: const ['occupationalDisease', 'workInjury'],
            itemBuilder: (item) => RadioButtonBuilder(
              translate(item, context),
            ),
          ),          SizedBox(height: height(0.015, context),),
          Text(
            translate('accidentsDateAndTime', context),
            style: TextStyle(
                color: HexColor('#363636'),
                fontSize: width(0.032, context)
            ),
          ),
          SizedBox(height: height(0.015, context),),
          buildTextFormField(context, themeNotifier, TextEditingController(), '', (val){}),
        ],
      ),
    ),
  );
}

Widget thirdStep(context, themeNotifier, ServicesProvider servicesProvider){
  return SingleChildScrollView(
    child: Container(
      alignment: Alignment.center,
      height: height(0.7, context),
      child: Text(translate('thirdStep', context)),
    ),
  );
}

Widget forthStep(context, themeNotifier, ServicesProvider servicesProvider){
  return SingleChildScrollView(
    child: Container(
      alignment: Alignment.center,
      height: height(0.7, context),
      child: Text(translate('forthStep', context)),
    ),
  );
}