// ignore_for_file: file_names, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ssc/source/viewModel/services/servicesProvider.dart';
import 'package:ssc/utilities/hexColor.dart';
import 'package:ssc/utilities/util.dart';
import '../../../../../utilities/theme/themes.dart';

import '../../../../viewModel/utilities/theme/themeProvider.dart';
import '../../shared/aboutTheServiceScreen.dart';

class OneTimeRefundInquiryScreen extends StatefulWidget {
  final String serviceTitle;
  final String aboutServiceDescription;
  final List<String> termsOfTheService;
  final List<String> stepsOfTheService;
  final Widget serviceScreen;
  final Future<dynamic> Function() serviceApiCall;
  const OneTimeRefundInquiryScreen({
    Key key,
    @required this.serviceTitle,
    @required this.aboutServiceDescription,
    @required this.termsOfTheService,
    @required this.stepsOfTheService,
    @required this.serviceScreen,
    @required this.serviceApiCall
  }) : super(key: key);

  @override
  State<OneTimeRefundInquiryScreen> createState() => _OneTimeRefundInquiryScreenState();
}

class _OneTimeRefundInquiryScreenState extends State<OneTimeRefundInquiryScreen> {
  Future oneTimeRefundInquiryFuture;
  ServicesProvider servicesProvider;
  ThemeNotifier themeNotifier;

  @override
  void initState() {
    servicesProvider = Provider.of<ServicesProvider>(context, listen: false);
    themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);
    oneTimeRefundInquiryFuture = servicesProvider.getOneTimeRefundInquiry();
    servicesProvider.isLoading = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ThemeNotifier themeNotifier = Provider.of<ThemeNotifier>(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(getTranslated('oneTimeRefundInquiry', context)),
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
                  FutureBuilder(
                      future: oneTimeRefundInquiryFuture,
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
                              return  SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Card(
                                        elevation: 6.0,
                                        shadowColor: Colors.black45,
                                        color: getContainerColor(context),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(15.0),
                                        ),
                                        child: Container(
                                          width: width(1, context),
                                          padding: const EdgeInsets.all(20.0),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.end,
                                                children: [
                                                  Container(
                                                    padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
                                                    decoration: BoxDecoration(
                                                      color: const Color.fromRGBO(153, 216, 140, 0.4),
                                                      borderRadius: BorderRadius.circular(8.0),
                                                    ),
                                                    child: Text(
                                                      getTranslated('paidOff', context),
                                                      style: TextStyle(
                                                        color: HexColor('#363636'),
                                                        fontWeight: FontWeight.w400,
                                                        fontSize: isScreenHasSmallWidth(context) ? 13 : 15,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Text(
                                                'سلفة من حساب التعويض تمكين 2',
                                                style: TextStyle(
                                                  height: 1.4,
                                                  color: themeNotifier.isLight() ? HexColor('#363636') : Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: isScreenHasSmallWidth(context) ? 13 : 15,
                                                ),
                                              ),
                                              const SizedBox(height: 20.0,),
                                              Row(
                                                children: [
                                                  SizedBox(
                                                    width: width(0.3, context),
                                                    child: Text(
                                                      getTranslated('exchangeDate', context),
                                                      style: TextStyle(
                                                        color: HexColor('#716F6F'),
                                                        fontWeight: FontWeight.w400,
                                                        fontSize: isScreenHasSmallWidth(context) ? 13 : 15,
                                                      ),
                                                    ),
                                                  ),
                                                  Text(
                                                    '12/10/2023',
                                                    style: TextStyle(
                                                      color: HexColor('#363636'),
                                                      fontWeight: FontWeight.w400,
                                                      fontSize: isScreenHasSmallWidth(context) ? 13 : 15,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 20.0,),
                                              Row(
                                                children: [
                                                  SizedBox(
                                                    width: width(0.3, context),
                                                    child: Text(
                                                      getTranslated('totalAmount', context),
                                                      style: TextStyle(
                                                        color: HexColor('#716F6F'),
                                                        fontWeight: FontWeight.w400,
                                                        fontSize: isScreenHasSmallWidth(context) ? 13 : 15,
                                                      ),
                                                    ),
                                                  ),
                                                  Text(
                                                    '300 ${getTranslated('jd', context)}',
                                                    style: const TextStyle(
                                                      fontSize: 13,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 20.0,),
                                              Divider(color: HexColor('#363636'), thickness: 0.2,),
                                              const SizedBox(height: 10.0,),
                                              InkWell(
                                                onTap: (){},
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.end,
                                                  children: [
                                                    const Icon(Icons.refresh),
                                                    const SizedBox(width: 5.0,),
                                                    Text(
                                                      getTranslated('returnMoney', context),
                                                      style: const TextStyle(
                                                        fontSize: 13,
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                    ),
                                  ],
                                ),
                              );
                            }
                            break;
                        }
                        return somethingWrongWidget(context, 'somethingWrongHappened', 'somethingWrongHappenedDesc');
                      }
                  ),
                  Positioned(
                    bottom: 0,
                    child: Container(
                      padding: const EdgeInsets.all(10.0),
                      color: const Color.fromRGBO(250, 250, 250, 1.0),
                      alignment: Alignment.center,
                      width: width(1, context) - 32.0,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          textButton(
                              context, themeNotifier, 'addNewRequest', HexColor('#ffffff'), getPrimaryColor(context, themeNotifier),
                                  () async {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => AboutTheServiceScreen(
                                          serviceScreen: widget.serviceScreen,
                                          serviceTitle: widget.serviceTitle,
                                          aboutServiceDescription: widget.aboutServiceDescription,
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
                                          serviceApiCall: widget.serviceApiCall,
                                        ),
                                      ),
                                    );
                              }, borderColor: '#2D452E',
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

}


