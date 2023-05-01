// ignore_for_file: file_names, use_build_context_synchronously

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:readmore/readmore.dart';
import 'package:ssc/source/view/services/shared/servicesListConstants.dart';
import 'package:ssc/source/viewModel/services/servicesProvider.dart';
import 'package:ssc/utilities/hexColor.dart';
import 'package:ssc/utilities/util.dart';
import '../../../../../utilities/theme/themes.dart';
import '../../../../infrastructure/userConfig.dart';
import '../../../viewModel/utilities/theme/themeProvider.dart';
import 'dart:ui' as ui;

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
  ThemeNotifier themeNotifier;
  bool termsChecked = false;
  List<Service> earlyAndOldRetirements = ServicesList.earlyAndOldRetirements;

  getTextStyle(context, isColored){
    return TextStyle(
        color: isColored ? HexColor('#003C97') : HexColor('#595959'),
        fontSize: width(0.03, context)
    );
  }

  @override
  void initState() {
    servicesProvider = Provider.of<ServicesProvider>(context, listen: false);
    themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);
    servicesProvider.stepNumber = 1;
    servicesProvider.isLoading = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ThemeNotifier themeNotifier = Provider.of<ThemeNotifier>(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(getTranslated(widget.serviceTitle, context)),
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
                            getTranslated('aboutTheService', context),
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
                          trimCollapsedText: getTranslated('readMore', context),
                          trimExpandedText: getTranslated('readLess', context),
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
                            getTranslated('termsOfTheService', context),
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
                                          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
                                          child: SvgPicture.asset('assets/icons/check.svg', width: 15, height: 15,),
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
                                  '${getTranslated('stepsOfTheService', context)} ',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  '( ${widget.stepsOfTheService.length} ${getTranslated('steps', context)} )',
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
                                      Text(getTranslated('termsAndConditionsAndPoliciesAgreement11', context), style: getTextStyle(context, false),),
                                      Text(getTranslated('termsAndConditionsAndPoliciesAgreement2', context), style: getTextStyle(context, true)),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(getTranslated('termsAndConditionsAndPoliciesAgreement3', context), style: getTextStyle(context, true)),
                                      Text(getTranslated('termsAndConditionsAndPoliciesAgreement4', context), style: getTextStyle(context, false))
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
                                          ((widget.serviceTitle == 'membershipRequest') && (value["PO_status_no"] == 0 || value["PO_status_no"] == 1)) || /// membership request - طلب اختياري
                                          ((widget.serviceTitle == 'requestToAmendTheAnnualIncreasePercentage') && value["PO_status_no"] == null) || /// request to amend the annual increase percentage - طلب تعديل نسبة الزيادة السنوية
                                          ((widget.serviceTitle == 'historicalPensionDetails') && value['cur_getdata'].length != 0) || /// historical pension details - الرواتب التقاعديه التاريخيه
                                          ((widget.serviceTitle == 'earlyRetirementRequest') && value['P_Message'][0][0]['PO_STATUS'] == 0) || /// early retirement - تقاعد مبكر
                                          ((widget.serviceTitle == 'applicationForOldAgePension') && value['P_Message'][0][0]['PO_STATUS'] == 0) || /// old age retirement - تقاعد شيخوخه
                                          ((widget.serviceTitle == 'report_a_sickness/work_injury_complaint') && value != null) || /// report_a_sickness/work_injury_complaint - تبليغ عن حادث العمل / مرض مهني
                                          ((widget.serviceTitle == 'deceasedRetirementApplication') && value != null) || /// report_a_sickness/work_injury_complaint - تبليغ عن حادث العمل / مرض مهني
                                          ((widget.serviceTitle == 'applicationForPensionersLoan') && value['P_Message'][0][0]['PO_STATUS'] == 0) || /// Application for pensioners loan - طلب سلفة تقاعد
                                          ((widget.serviceTitle == 'applicationOfReschedulePensionersLoan') && value['P_Message'][0][0]['PO_STATUS'] == 0) || /// Application of reschedule pensioners loan - إعادة جدولة سلف المتقاعدين
                                          ((widget.serviceTitle == 'issuingRetirementDecision') && value['PO_STATUS'] == 0) || /// Issuing a retirement decision - تبليغ قرار التقاعد
                                          ((widget.serviceTitle == 'maternityAllowanceApplication') && value['P_Message'][0][0]['PO_STATUS'] == 0) || /// Maternity allowance application - طلب بدل امومة
                                          ((widget.serviceTitle == 'oneTimeCompensationRequest') && value['P_Message'][0][0]['PO_STATUS'] == 0) /// One-time compensation request - طلب  تعويض الدفعة الواحده
                                        )
                                      ){
                                        servicesProvider.result = value;
                                        Navigator.of(context).push(
                                            MaterialPageRoute(builder: (context) => widget.serviceScreen)
                                        );
                                      } else{
                                        if((widget.serviceTitle == 'earlyRetirementRequest') || (widget.serviceTitle == 'applicationForPensionersLoan')){
                                          errorMessage = UserConfig.instance.isLanguageEnglish()
                                          ? value['P_Message'][0][0]['PO_STATUS_DESC_EN'] : value['P_Message'][0][0]['PO_STATUS_DESC_AR'];
                                          showMyDialog(context, 'failed', errorMessage ?? getTranslated('thereAreNoData', context), 'ok', themeNotifier);
                                        } else if((widget.serviceTitle == 'issuingRetirementDecision') && value['PO_STATUS'] == -3) {
                                          showMyDialog(context, 'aRetirementDecisionCannotBeIssuedWithoutSubmittingRetirementApplication', '',
                                              'submitRetirementApplication', themeNotifier, icon: 'assets/icons/failedApplication.svg', titleColor: '#363636',
                                            buttonBackgroundColor: '#ffffff', buttonForegroundColor: '#003C97', onPressed: (){
                                              Navigator.of(context).pop();
                                              showRetirementsBottomSheet();
                                            }
                                          );
                                        } else if((widget.serviceTitle == 'issuingRetirementDecision')){
                                          errorMessage = UserConfig.instance.isLanguageEnglish()
                                              ? value["PO_status_desc_EN"] : value["PO_status_desc_AR"];
                                          showMyDialog(context, 'failed', errorMessage ?? getTranslated('thereAreNoData', context), 'ok', themeNotifier);
                                        } else if((widget.serviceTitle == 'maternityAllowanceApplication') || (widget.serviceTitle == 'oneTimeCompensationRequest')){
                                          errorMessage = UserConfig.instance.isLanguageEnglish()
                                              ? value['P_Message'][0][0]["PO_STATUS_DESC_EN"] : value['P_Message'][0][0]["PO_STATUS_DESC_AR"];
                                          showMyDialog(context, 'failed', errorMessage ?? getTranslated('thereAreNoData', context), 'ok', themeNotifier);
                                        } else{
                                          errorMessage = UserConfig.instance.isLanguageEnglish()
                                              ? value["pO_status_desc_en"] : value["pO_status_desc_ar"];
                                          showMyDialog(context, 'failed', errorMessage ?? getTranslated('thereAreNoData', context), 'ok', themeNotifier);
                                        }
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
            color: themeNotifier.isLight() ? Colors.white70 : Colors.black45,
            child: Center(
              child: animatedLoader(context),
            ),
          )
        ],
      ),
    );
  }

  showRetirementsBottomSheet(){
    return showModalBottomSheet(
        isScrollControlled: true,
        isDismissible: true,
        enableDrag: true,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(25.0))
        ),
        constraints: BoxConstraints(
            maxHeight: height(0.6, context)
        ),
        context: context,
        barrierColor: Colors.black26,
        builder: (context) {
          return GestureDetector(
            onTap: (){
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: BackdropFilter(
              filter: ui.ImageFilter.blur(
                sigmaX: 2.0,
                sigmaY: 2.0,
              ),
              child: Material(
                elevation: 100,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(25.0),
                  topRight: Radius.circular(25.0),
                ),
                color: const Color.fromRGBO(250, 250, 250, 0.9),
                shadowColor: Colors.black,
                child: IntrinsicHeight(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0).copyWith(top: 15.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(),
                            Container(
                              width: 45,
                              height: 6,
                              decoration: BoxDecoration(
                                  color: HexColor('#000000'),
                                  borderRadius: const BorderRadius.all(Radius.circular(25.0))),
                            ),
                            InkWell(
                              onTap: (){
                                Navigator.of(context).pop();
                              },
                              child: SvgPicture.asset('assets/icons/close.svg'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 25.0,),
                        Text(
                          getTranslated('chooseTheRetirementApplicationYouWouldLikeToApplyFor', context),
                          style: const TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 20.0,),
                        Row(
                          children: [
                            Expanded(
                              child: textButton(
                                context, themeNotifier, 'earlyRetirementRequest',
                                Colors.white, HexColor('#363636'), (){
                                Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => AboutTheServiceScreen(
                                        serviceTitle: earlyAndOldRetirements[0].title,
                                        aboutServiceDescription: earlyAndOldRetirements[0].description,
                                        termsOfTheService: const [
                                          'موظفي القطاع الخاص',
                                          'موظف موقوف عن العمل',
                                          'لديك 36 اشتراك او رصيد اكثر من 300 د.ا',
                                          'ان تكون قد استفدت من بدل التعطل ثلاث مرات او اقل خلال فتره الشمول',
                                        ],
                                        stepsOfTheService: const [
                                          'التأكد من المعلومات الشخصية لمقدم الخدمة',
                                          'تعبئة طلب الخدمة',
                                          'تقديم الطلب'
                                        ],
                                        serviceScreen: earlyAndOldRetirements[0].screen,
                                        serviceApiCall: earlyAndOldRetirements[0].serviceApiCall,
                                      ),
                                    )
                                );
                              }, verticalPadding: 30.0
                              ),
                            ),
                            const SizedBox(width: 10.0,),
                            Expanded(
                              child: textButton(
                                context, themeNotifier, 'applicationForOldAgePension',
                                Colors.white, HexColor('#363636'), (){
                                Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => AboutTheServiceScreen(
                                        serviceTitle: earlyAndOldRetirements[1].title,
                                        aboutServiceDescription: earlyAndOldRetirements[1].description,
                                        termsOfTheService: const [
                                          'موظفي القطاع الخاص',
                                          'موظف موقوف عن العمل',
                                          'لديك 36 اشتراك او رصيد اكثر من 300 د.ا',
                                          'ان تكون قد استفدت من بدل التعطل ثلاث مرات او اقل خلال فتره الشمول',
                                        ],
                                        stepsOfTheService: const [
                                          'التأكد من المعلومات الشخصية لمقدم الخدمة',
                                          'تعبئة طلب الخدمة',
                                          'تقديم الطلب'
                                        ],
                                        serviceScreen: earlyAndOldRetirements[1].screen,
                                        serviceApiCall: earlyAndOldRetirements[1].serviceApiCall,
                                      ),
                                    )
                                );
                                }, verticalPadding: 30.0
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20.0,),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        }
    );
  }

}


