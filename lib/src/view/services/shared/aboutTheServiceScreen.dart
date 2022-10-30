// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:readmore/readmore.dart';
import 'package:ssc/src/viewModel/services/servicesProvider.dart';
import 'package:ssc/utilities/hexColor.dart';
import 'package:ssc/utilities/util.dart';
import 'dart:math' as math;
import '../../../../../infrastructure/userConfig.dart';
import '../../../../../utilities/theme/themes.dart';
import '../../../viewModel/utilities/theme/themeProvider.dart';

class AboutTheServiceScreen extends StatefulWidget {
  final String serviceTitle;
  final String aboutServiceDescription;
  final List<String> termsOfTheService;
  final List<String> stepsOfTheService;
  const AboutTheServiceScreen({
    Key key,
    @required this.serviceTitle,
    @required this.aboutServiceDescription,
    @required this.termsOfTheService,
    @required this.stepsOfTheService
  }) : super(key: key);

  @override
  State<AboutTheServiceScreen> createState() => _AboutTheServiceScreenState();
}

class _AboutTheServiceScreenState extends State<AboutTheServiceScreen> {
  ServicesProvider servicesProvider;
  bool termsChecked = false;

  getTextStyle(context, isColored){
    return TextStyle(
        color: isColored ? HexColor('#003C97') : HexColor('#595959'),
        fontSize: height(0.014, context)
    );
  }

  @override
  void initState() {
    servicesProvider = Provider.of<ServicesProvider>(context, listen: false);
    servicesProvider.stepNumber = 1;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ThemeNotifier themeNotifier = Provider.of<ThemeNotifier>(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(translate(widget.serviceTitle, context)),
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
      body: GestureDetector(
        onTap: (){
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Container(
          width: width(1, context),
          height: height(0.85, context),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Text(
                        translate('aboutTheService', context),
                        style: const TextStyle(
                            fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                    ReadMoreText(
                      widget.aboutServiceDescription,
                      trimLines: 5,
                      colorClickableText: HexColor('#003C97'),
                      trimMode: TrimMode.Line,
                      trimCollapsedText: translate('readMore', context),
                      trimExpandedText: translate('readLess', context),
                      style: TextStyle(
                        fontWeight: FontWeight.w100,
                        height: 1.3,
                        color: HexColor('#363636'),
                      ),
                    ),
                    // Text(
                    //   widget.aboutServiceDescription,
                    //   style: const TextStyle(
                    //       fontWeight: FontWeight.w100,
                    //       height: 1.3
                    //   ),
                    // ),
                    Divider(
                      indent: width(0.09, context),
                      endIndent: width(0.09, context),
                      color: HexColor('#DADADA'),
                      thickness: 1,
                      height: height(0.04, context),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 15),
                      child: Text(
                        translate('termsOfTheService', context),
                        style: const TextStyle(
                            fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                    SizedBox(
                      height: height(0.06, context) * widget.termsOfTheService.length,
                      child: ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                          itemCount: widget.termsOfTheService.length,
                          itemBuilder: (context, index){
                            return Row(
                              children: [
                                Card(
                                  elevation: 5.0,
                                  margin: const EdgeInsets.all(3.0),
                                  shadowColor: const Color.fromRGBO(45, 69, 46, 0.28),
                                  color: HexColor('#FFFFFF'),
                                  child: Padding(
                                    padding: EdgeInsets.all(width(0.025, context)),
                                    child: SvgPicture.asset('assets/icons/quickAccessIcons/reportAnAccidentIcon.svg'),
                                  ),
                                ),
                                SizedBox(width: width(0.03, context),),
                                SizedBox(
                                  width: width(0.74, context),
                                  child: Text(widget.termsOfTheService[index]),
                                )
                              ],
                            );
                          }
                      ),
                    ),
                    Divider(
                      indent: width(0.09, context),
                      endIndent: width(0.09, context),
                      color: HexColor('#DADADA'),
                      thickness: 1,
                      height: height(0.04, context),
                    ),
                    Padding(
                        padding: const EdgeInsets.only(bottom: 15),
                        child: Row(
                          children: [
                            Text(
                              '${translate('stepsOfTheService', context)} ',
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                            Text(
                              '( ${widget.stepsOfTheService.length} ${translate('steps', context)} )',
                              style: TextStyle(
                                  fontWeight: FontWeight.w100,
                                  color: HexColor('#666666')
                              ),
                            ),
                          ],
                        )
                    ),
                    SizedBox(
                      height: (height(0.02, context) + 10.0) * widget.stepsOfTheService.length,
                      child: ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: widget.stepsOfTheService.length,
                          itemBuilder: (context, index){
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 15.0),
                              child: Text(
                                '${index + 1}- ${widget.stepsOfTheService[index]}',
                              ),
                            );
                          }
                      ),
                    ),
                    SizedBox(
                      height: height(0.02, context),
                    ),
                  ],
                ),
              ),
              Column(
                children: [
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
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(translate('termsAndConditionsAndPoliciesAgreement11', context), style: getTextStyle(context, false),),
                              Text(translate('termsAndConditionsAndPoliciesAgreement2', context), style: getTextStyle(context, true)),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(translate('termsAndConditionsAndPoliciesAgreement3', context), style: getTextStyle(context, true)),
                              Text(translate('termsAndConditionsAndPoliciesAgreement4', context), style: getTextStyle(context, false))
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: height(0.025, context),),
                  textButton(
                    context, themeNotifier, 'startNow', MaterialStateProperty.all<Color>(
                    termsChecked ? getPrimaryColor(context, themeNotifier) : HexColor('#DADADA')),
                    termsChecked ? HexColor('#ffffff') : HexColor('#363636'),
                    () async {
                      if(termsChecked){}
                    }
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}