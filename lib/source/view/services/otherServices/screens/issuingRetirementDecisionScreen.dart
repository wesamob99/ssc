// ignore_for_file: file_names

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:ssc/infrastructure/userSecuredStorage.dart';
import 'package:ssc/source/viewModel/services/servicesProvider.dart';
import 'package:ssc/source/viewModel/utilities/theme/themeProvider.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../../../../../infrastructure/userConfig.dart';
import '../../../../../utilities/hexColor.dart';
import '../../../../../utilities/theme/themes.dart';
import '../../../../../utilities/util.dart';
import 'dart:math' as math;

import '../../../login/registerComponents/OTPScreen.dart';

class IssuingRetirementDecisionScreen extends StatefulWidget {
  const IssuingRetirementDecisionScreen({Key key}) : super(key: key);

  @override
  State<IssuingRetirementDecisionScreen> createState() => _IssuingRetirementDecisionScreenState();
}

class _IssuingRetirementDecisionScreenState extends State<IssuingRetirementDecisionScreen> {

  Future decisionFuture;
  Future pdfFuture;
  ServicesProvider servicesProvider;
  UserSecuredStorage userSecuredStorage;
  ThemeNotifier themeNotifier;
  String doYouAgreeWithTheDecision = '';
  String withdrawalOrDontWantToRetired = '';

  @override
  void initState() {
    servicesProvider = Provider.of<ServicesProvider>(context, listen: false);
    themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);
    decisionFuture = servicesProvider.getDecision();
    servicesProvider.penUpdateSeen();
    servicesProvider.reasonController.text = '';
    userSecuredStorage = UserSecuredStorage.instance;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(getTranslated('issuingRetirementDecision', context)),
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: InkWell(
            onTap: (){
              Navigator.of(context).pop();
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
          FutureBuilder(
              future: decisionFuture,
              builder: (context, snapshot){
                switch(snapshot.connectionState){
                  case ConnectionState.none:
                    return somethingWrongWidget(context, 'somethingWrongHappened', 'somethingWrongHappenedDesc'); break;
                  case ConnectionState.waiting:
                  case ConnectionState.active:
                  return Center(
                    child: animatedLoader(context),
                  ); break;
                  case ConnectionState.done:
                    if(!snapshot.hasError && snapshot.hasData){
                      return Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              userInfoCard(snapshot.data),
                              const SizedBox(height: 25.0,),
                              buildPDFViewer(snapshot.data),
                              const SizedBox(height: 25.0,),
                              if(snapshot.data['o_on_off'] == '110')
                              Column(
                                children: [
                                  buildFieldTitle(context, 'doYouAgreeWithTheDecision', required: false),
                                  const SizedBox(height: 10.0,),
                                  customTwoRadioButtons(1, 'agree', 'disagree', setState),
                                  const SizedBox(height: 20.0,),
                                  buildFieldTitle(context, 'agreeReason', required: false),
                                  const SizedBox(height: 10.0,),
                                  buildTextFormField(context, themeNotifier, servicesProvider.reasonController, 'val${getTranslated('agreeReasonHint', context)}', (value){}, minLines: 5),
                                  const SizedBox(height: 20.0,),
                                ],
                              ),
                              if(snapshot.data['o_on_off'] == '001')
                              Column(
                                  children: [
                                    Row(
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
                                            backgroundColor: HexColor('#2D452E'),
                                          ),
                                        ),
                                        SizedBox(
                                          width: width(0.8, context),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              getTranslated('WithdrawalOfObjection', context),
                                              style: TextStyle(
                                                color: HexColor('#666666'),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10.0,),
                                    buildTextFormField(context, themeNotifier, servicesProvider.reasonController, 'val${getTranslated('agreeReasonHint', context)}', (value){}, minLines: 5),
                                    const SizedBox(height: 20.0,),
                                  ],
                                ),
                              if(snapshot.data['o_on_off'] == '111')
                              Column(
                                  children: [
                                    customRadioButtonGroup(['WithdrawalOfObjection', "don'tWantToRetireAndWantToStayInclusive"], setState),
                                    const SizedBox(height: 10.0,),
                                    buildTextFormField(context, themeNotifier, servicesProvider.reasonController, 'val${getTranslated('agreeReasonHint', context)}', (value){}, minLines: 5),
                                    const SizedBox(height: 20.0,),
                                  ],
                                ),
                              if(snapshot.data['o_on_off'] == '110' || snapshot.data['o_on_off'] == "001")
                              Container(
                                alignment: Alignment.center,
                                padding: const EdgeInsets.only(bottom: 20.0),
                                child: textButton(context, themeNotifier, 'send',
                                  (checkSendEnabled(snapshot.data) ? primaryColor : HexColor('#979797')),
                                  Colors.white,
                                  () async {
                                    FocusScope.of(context).requestFocus(FocusNode());
                                    servicesProvider.isLoading = true;
                                    servicesProvider.notifyMe();
                                    String errorMessage = "";
                                    try{
                                      await servicesProvider.sendDecOtp().whenComplete((){})
                                          .then((val) async {
                                        if(val["PO_STATUS"] != 0){
                                          errorMessage = UserConfig.instance.isLanguageEnglish()
                                              ? val["PO_status_desc_EN"] : val["PO_status_desc_AR"];
                                          showMyDialog(context, 'failed', errorMessage, 'retryAgain', themeNotifier);
                                        }else {
                                          int actionType;
                                          if(snapshot.data['o_on_off'] == '110'){
                                            actionType = (doYouAgreeWithTheDecision == 'agree' ? 1 : 2);
                                          } else if(snapshot.data['o_on_off'] == '001'){
                                            actionType = 3;
                                          } else if(snapshot.data['o_on_off'] == '111'){
                                            actionType = (withdrawalOrDontWantToRetired == 'WithdrawalOfObjection' ? 3 : 4);
                                          }
                                          Navigator.of(context).push(
                                            MaterialPageRoute(builder: (context) =>
                                                OTPScreen(
                                                  type: 'phone',
                                                  contactTarget: UserSecuredStorage.instance.realMobileNumber.toString(),
                                                  flag: 3,
                                                  pActionType: actionType,
                                                ),
                                            ),
                                          );
                                        }
                                        servicesProvider.notifyMe();
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
                                  },),
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                    break;
                }
                return somethingWrongWidget(context, 'somethingWrongHappened', 'somethingWrongHappenedDesc');
              }
          ),
          if(context.watch<ServicesProvider>().isLoading)
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

  checkSendEnabled(data){
    if(data['o_on_off'] == '110'){
      return doYouAgreeWithTheDecision.isNotEmpty;
    } else if(data['o_on_off'] == '001'){
      return true;
    } else if(data['o_on_off'] == '111'){
      return withdrawalOrDontWantToRetired.isNotEmpty;
    }
  }

  Widget userInfoCard(data){
    return Card(
        elevation: 5.0,
        shadowColor: Colors.black45,
        color: getContainerColor(context),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Container(
            width: width(1, context),
            padding: const EdgeInsets.all(25.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      userSecuredStorage.userFullName,
                      style: TextStyle(
                        height: 1.4,
                        fontSize: 14,
                        color: themeNotifier.isLight() ? HexColor('#363636') : Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    // if(nationality == 'jordanian')
                    // Container(
                    //   padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
                    //   decoration: BoxDecoration(
                    //     color: const Color.fromRGBO(194, 163, 93, 1),
                    //     borderRadius: BorderRadius.circular(8.0),
                    //   ),
                    //   child: Text(
                    //     'تحتاج الى اجراء',
                    //     style: TextStyle(
                    //       color: HexColor('#543B00'),
                    //       fontWeight: FontWeight.w400,
                    //       fontSize: 12,
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
                const SizedBox(height: 15.0,),
                Row(
                  children: [
                    Text(
                      userSecuredStorage.nationalId,
                      style: TextStyle(
                        color: themeNotifier.isLight() ? HexColor('#716F6F') : Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      ' / ',
                      style: TextStyle(
                        color: themeNotifier.isLight() ? HexColor('#716F6F') : Colors.white70,
                      ),
                    ),
                    Text(
                      userSecuredStorage.internationalCode == '962'
                      ? getTranslated('jordanian', context)
                      : getTranslated('nonJordanian', context),
                      style: TextStyle(
                        color: themeNotifier.isLight() ? HexColor('#716F6F') : Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                if(data['o_on_off'] == '110')
                const SizedBox(height: 10.0,),
                if(data['o_on_off'] == '110')
                Text(
                  "يرجى قراءه قرار التبيلغ بحذر قبل الموافقة عليه او الاعتراض عليه .",
                  style: TextStyle(
                    color: themeNotifier.isLight() ? HexColor('#ED3124') : Colors.white70,
                    fontSize: 12,
                    height: 2,
                  ),
                ),
                const SizedBox(height: 10.0,),
                Text(
                  "قرار التقاعد يعتبر قطعي ونهائي إذا لم تقم بالاعتراض عليه خلال (15) يوم من اليوم التالي لتاريخ تبلغك القرار. \n\n • قراراً قابلاً للاعتراض أمام لجنة تسوية الحقوق الاستئنافية في المؤسسة، خلال خمسة عشر يوماً من اليوم التالي لتاريخ تبلغك القرار.",
                  style: TextStyle(
                    color: themeNotifier.isLight() ? HexColor('#B3913E') : Colors.white70,
                    fontSize: 12,
                    height: 1.5,
                  ),
                ),
              ],
            )
        )
    );
  }

  Widget buildPDFViewer(data){
    return IntrinsicHeight(
      child: FutureBuilder(
          future: servicesProvider.getRetirementDecisionPDFFileDetails(data['v_path'], context),
          builder: (context, snapshot){
            switch(snapshot.connectionState){
              case ConnectionState.none:
                return somethingWrongWidget(context, 'somethingWrongHappened', 'somethingWrongHappenedDesc'); break;
              case ConnectionState.waiting:
              case ConnectionState.active:
                return Center(
                  child: animatedLoader(context),
                ); break;
              case ConnectionState.done:
                if(!snapshot.hasError && snapshot.hasData){
                  return Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(15.0),
                        decoration: BoxDecoration(
                          color: HexColor('#323639'),
                          borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(16.0),
                            topLeft: Radius.circular(16.0),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                              onTap: (){
                                showMyDialog(context, 'doneSuccessfully', getTranslated('fileDownloadedAt', context) + '\n ${snapshot.data.path}', 'ok', themeNotifier, icon: 'assets/icons/pdf.svg', titleColor: '#445740');
                              },
                              child: SvgPicture.asset('assets/icons/installIcon.svg', width: 20,),
                            ),
                            Row(
                              children: [
                                Text(
                                  '${data['v_path']}.pdf',
                                  // path.basename(snapshot.data.path),
                                  style: const TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                                // const SizedBox(width: 20.0,),
                                // SvgPicture.asset('assets/icons/menuIcon.svg'),
                              ],
                            ),
                          ],
                        ),
                      ),
                      IntrinsicHeight(
                        child: Card(
                          elevation: 5.0,
                          child: SfPdfViewer.file(snapshot.data),
                        ),
                      ),
                      Container(
                        height: 50,
                        decoration: BoxDecoration(
                          color: HexColor('#323639'),
                          borderRadius: const BorderRadius.only(
                            bottomRight: Radius.circular(16.0),
                            bottomLeft: Radius.circular(16.0),
                          ),
                        ),
                      ),
                    ],
                  );
                }
                break;
            }
            return somethingWrongWidget(context, 'somethingWrongHappened', 'somethingWrongHappenedDesc');
          }
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
                doYouAgreeWithTheDecision = firstChoice;
              }
            });
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
                  backgroundColor: (flag == 1 && doYouAgreeWithTheDecision == firstChoice)
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
                doYouAgreeWithTheDecision = secondChoice;
              }
            });
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
                  backgroundColor: (flag == 1 && doYouAgreeWithTheDecision == secondChoice)
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

  Widget customRadioButtonGroup(List choices, setState){
    return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: choices.length,
        itemBuilder: (context, index){
          return Column(
            children: [
              InkWell(
                onTap: (){
                  setState(() {
                    withdrawalOrDontWantToRetired = choices[index];
                  });
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
                        backgroundColor: (withdrawalOrDontWantToRetired == choices[index])
                            ? HexColor('#2D452E') : Colors.transparent,
                      ),
                    ),
                    SizedBox(
                      width: width(0.8, context),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          getTranslated(choices[index], context),
                          style: TextStyle(
                            color: HexColor('#666666'),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10.0,)
            ],
          );
        }
    );
  }


}
