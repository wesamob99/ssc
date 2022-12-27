// ignore_for_file: file_names, use_build_context_synchronously

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:readmore/readmore.dart';
import 'package:ssc/src/viewModel/services/servicesProvider.dart';
import 'package:ssc/utilities/hexColor.dart';
import 'package:ssc/utilities/util.dart';
import '../../../../../utilities/theme/themes.dart';
import '../../../../infrastructure/userConfig.dart';
import '../../../viewModel/utilities/theme/themeProvider.dart';

class AboutTheServiceScreen extends StatefulWidget {
  final String serviceTitle;
  final String aboutServiceDescription;
  final List<String> termsOfTheService;
  final List<String> stepsOfTheService;
  final Widget serviceScreen;
  final Future<dynamic> Function() serviceApiCall;
  const AboutTheServiceScreen({
    Key key,
    @required this.serviceTitle,
    @required this.aboutServiceDescription,
    @required this.termsOfTheService,
    @required this.stepsOfTheService,
    @required this.serviceScreen,
    @required this.serviceApiCall
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
        fontSize: width(0.03, context)
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
        leading: leadingBackIcon(context),
      ),
      body: Stack(
        children: [
          GestureDetector(
            onTap: (){
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: Container(
              height: height(1, context),
              width: width(1, context),
              padding: const EdgeInsets.all(16.0),
              child: Stack(
                children: [
                  SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 5),
                          child: Text(
                            translate('aboutTheService', context),
                            style: const TextStyle(
                                fontWeight: FontWeight.bold
                            ),
                          ),
                        ),
                        ReadMoreText(
                          widget.aboutServiceDescription,
                          trimLines: isTablet(context) ? 5 : 3,
                          colorClickableText: HexColor('#003C97'),
                          trimMode: TrimMode.Line,
                          trimCollapsedText: translate('readMore', context),
                          trimExpandedText: translate('readLess', context),
                          style: TextStyle(
                              fontWeight: FontWeight.w100,
                              height: 1.2,
                              color: HexColor('#363636'),
                              fontSize: height(isScreenHasSmallHeight(context) ? 0.018 : 0.017, context)
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
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Text(
                            translate('termsOfTheService', context),
                            style: const TextStyle(
                                fontWeight: FontWeight.bold
                            ),
                          ),
                        ),
                        SizedBox(
                          height: height(0.055, context) * widget.termsOfTheService.length,
                          child: ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                              itemCount: widget.termsOfTheService.length,
                              itemBuilder: (context, index){
                                return SizedBox(
                                  height: height(0.055, context),
                                  child: Row(
                                    children: [
                                      Card(
                                        elevation: 5.0,
                                        margin: const EdgeInsets.symmetric(vertical: 5.0).copyWith(bottom: 0),
                                        shadowColor: const Color.fromRGBO(45, 69, 46, 0.28),
                                        color: HexColor('#FFFFFF'),
                                        child: Padding(
                                          padding: EdgeInsets.all(height(0.01, context)),
                                          child: SvgPicture.asset('assets/icons/quickAccessIcons/reportAnAccidentIcon.svg'),
                                        ),
                                      ),
                                      SizedBox(width: width(0.03, context),),
                                      SizedBox(
                                        width: width(0.74, context),
                                        child: Text(
                                          widget.termsOfTheService[index],
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize: height(isScreenHasSmallHeight(context) ? 0.016 : 0.015, context),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
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
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Row(
                              children: [
                                Text(
                                  '${translate('stepsOfTheService', context)} ',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  '( ${widget.stepsOfTheService.length} ${translate('steps', context)} )',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w100,
                                    color: HexColor('#666666'),
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
                                return SizedBox(
                                  height: height(0.02, context) + 10.0,
                                  child: Padding(
                                    padding: const EdgeInsets.only(bottom: 10.0),
                                    child: Text(
                                      '${index + 1}- ${widget.stepsOfTheService[index]}',
                                      style: TextStyle(
                                        fontSize: height(isScreenHasSmallHeight(context) ? 0.016 : 0.015, context),
                                      ),
                                    ),
                                  ),
                                );
                              }
                          ),
                        ),
                        SizedBox(
                          height: height(0.18, context),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    child: Container(
                      padding: const EdgeInsets.all(10.0),
                      color: const Color.fromRGBO(250, 250, 250, 1.0),
                      alignment: Alignment.center,
                      width: width(1, context),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
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
                              context, themeNotifier, 'startNow', termsChecked ? getPrimaryColor(context, themeNotifier) : HexColor('#DADADA'),
                              termsChecked ? HexColor('#ffffff') : HexColor('#363636'),
                                  () async {
                                if(termsChecked){
                                  String errorMessage = '';
                                  servicesProvider.isLoading = true;
                                  servicesProvider.notifyMe();
                                  try{
                                    await widget.serviceApiCall.call().whenComplete((){}).then((value){
                                      /// TODO: check this condition every time you pass new [serviceApiCall]
                                      if(value != null &&
                                          (
                                              ((!value.containsKey('PO_status_no') || value["PO_status_no"] == 0 || value["PO_status_no"] == 1) && (widget.serviceTitle != 'historicalPensionDetails') && (widget.serviceTitle != 'requestToAmendTheAnnualIncreasePercentage')) ||
                                              ((widget.serviceTitle == 'requestToAmendTheAnnualIncreasePercentage') && value["PO_status_no"] == null) ||
                                              ((widget.serviceTitle == 'historicalPensionDetails') && value['cur_getdata'].length != 0)
                                          )
                                      ){
                                        servicesProvider.result = value;
                                        Navigator.of(context).push(
                                            MaterialPageRoute(builder: (context) => widget.serviceScreen)
                                        );
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
                                }
                              }
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          if(Provider.of<ServicesProvider>(context).isLoading)
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: width(1, context),
            height: height(1, context),
            color: Colors.white70,
            child: Center(
              child: animatedLoader(context),
            ),
          )
        ],
      ),
    );
  }
}


