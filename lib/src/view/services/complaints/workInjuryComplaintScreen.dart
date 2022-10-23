import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:ssc/utilities/util.dart';
import 'dart:math' as math;
import '../../../../infrastructure/userConfig.dart';
import '../../../../utilities/hexColor.dart';
import '../../../../utilities/theme/themes.dart';
import '../../../viewModel/utilities/theme/themeProvider.dart';

class WorkInjuryComplaintScreen extends StatefulWidget {
  const WorkInjuryComplaintScreen({Key key}) : super(key: key);

  @override
  State<WorkInjuryComplaintScreen> createState() => _WorkInjuryComplaintScreenState();
}

class _WorkInjuryComplaintScreenState extends State<WorkInjuryComplaintScreen> {
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
              Navigator.of(context).pop();
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: height(0.7, context),
              child: firstStep(context, themeNotifier),
            ),
            textButton(context,
                themeNotifier,
                'continue',
                MaterialStateProperty.all<Color>(
                getPrimaryColor(context, themeNotifier)),
                HexColor('#ffffff'),
                (){},
            ),
            SizedBox(height: height(0.01, context)),
            textButton(context,
                themeNotifier,
                'saveAsDraft',
                MaterialStateProperty.all<Color>(Colors.transparent),
                HexColor('#003C97'),
                (){},
            ),
          ],
        ),
      ),
    );
  }
}

Widget firstStep(context, themeNotifier){
  return SingleChildScrollView(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: height(0.02, context),),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              translate('firstStep', context),
              style: TextStyle(
                  color: HexColor('#979797'),
                  fontSize: width(0.03, context)
              ),
            ),
            SizedBox(height: height(0.006, context),),
            Text(
            translate('confirmPersonalInformation', context),
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
                  '${translate('next', context)}: ${translate('orderDetails', context)}',
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
          translate('quatrainNoun', context),
          style: TextStyle(
              color: HexColor('#363636'),
              fontSize: width(0.032, context)
          ),
        ),
        SizedBox(height: height(0.015, context),),
        buildTextFormField(context, themeNotifier, TextEditingController(), '', (val){}, enabled: false),
        SizedBox(height: height(0.015, context),),
        Text(
          translate('nationalId', context),
          style: TextStyle(
              color: HexColor('#363636'),
              fontSize: width(0.032, context)
          ),
        ),
        SizedBox(height: height(0.015, context),),
        buildTextFormField(context, themeNotifier, TextEditingController(), '', (val){}, enabled: false),
        SizedBox(height: height(0.015, context),),
        Text(
          translate('securityNumber', context),
          style: TextStyle(
              color: HexColor('#363636'),
              fontSize: width(0.032, context)
          ),
        ),
        SizedBox(height: height(0.015, context),),
        buildTextFormField(context, themeNotifier, TextEditingController(), '', (val){}, enabled: false),
        SizedBox(height: height(0.015, context),),
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
              flex: 3,
              child: buildTextFormField(context, themeNotifier, TextEditingController(), '', (val){})
            ),
            SizedBox(width: width(0.015, context)),
            Expanded(
              flex: 1,
              child: buildTextFormField(context, themeNotifier, TextEditingController(), '', (val){})
            ),
          ],
        )
      ],
    ),
  );
}