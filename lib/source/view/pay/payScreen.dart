
// ignore_for_file: file_names

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:ssc/source/view/pay/paymentMethodsScreen.dart';
import 'package:ssc/source/viewModel/pay/payProvider.dart';
import 'package:ssc/source/viewModel/utilities/theme/themeProvider.dart';
import 'package:ssc/utilities/theme/themes.dart';

import '../../../infrastructure/userConfig.dart';
import '../../../models/home/payOffFinancialInformations.dart';
import '../../../utilities/hexColor.dart';
import '../../../utilities/util.dart';

class PayScreen extends StatefulWidget {
  final List<SubPayCur> payments;
  const PayScreen({Key key, @required this.payments}) : super(key: key);

  @override
  State<PayScreen> createState() => _PayScreenState();
}

class _PayScreenState extends State<PayScreen> {

  PayProvider payProvider;
  List<Payments> payments = [];
  double totalSummation;

  @override
  void initState() {
    payProvider = Provider.of<PayProvider>(context, listen: false);
    payProvider.isLoading = false;
    totalSummation = 0.000;
    for (var element in widget.payments) {
      payments.add(
        Payments(title: element.subTypeDesc, date: element.chkDate, value: double.tryParse(element.chkAmt.toString()), icon: 'assets/icons/servicesIcons/individualsServices.svg'),
      );
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ThemeNotifier themeNotifier = Provider.of<ThemeNotifier>(context);

    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(getTranslated('payments', context)),
        leading: leadingBackIcon(context),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0).copyWith(top: 25.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  constraints: BoxConstraints(
                    maxHeight: height(0.6, context)
                  ),
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    itemCount: payments.length,
                    itemBuilder: (context, index){
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: InkWell(
                          onTap: (){
                            setState(() {
                              payments[index].isChecked = !payments[index].isChecked;
                              widget.payments[index].isChecked = payments[index].isChecked;
                              if(payments[index].isChecked){
                                totalSummation += payments[index].value;
                              }else{
                                totalSummation -= payments[index].value;
                              }
                            });
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(3.0),
                                    decoration: BoxDecoration(
                                        color: HexColor('#DADADA'),
                                        borderRadius: BorderRadius.circular(3.0)
                                    ),
                                    child: Container(
                                      width: width(isTablet(context) ? 0.03 : 0.04, context),
                                      height: width(isTablet(context) ? 0.03 : 0.04, context),
                                      decoration: BoxDecoration(
                                          color: payments[index].isChecked ? HexColor('#2D452E') : HexColor('#DADADA'),
                                          borderRadius: BorderRadius.circular(4.0)
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.symmetric(horizontal: 10.0),
                                    padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8.0),
                                        border: Border.all(
                                            color: HexColor('#E8EBE8'),
                                            width: 1.0
                                        )
                                    ),
                                    child: SvgPicture.asset(
                                      payments[index].icon,
                                      color: themeNotifier.isLight() ? HexColor('#2D452E') : HexColor('#b4cfb4'),
                                      height: width(isTablet(context) ? 0.066 : 0.07, context),
                                      width: width(isTablet(context) ? 0.066 : 0.07, context),
                                    ),
                                  ),
                                  SizedBox(
                                    width: width(0.44, context),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          payments[index].title,
                                          style: TextStyle(
                                            color: themeNotifier.isLight() ? HexColor('#363636') : Colors.white,
                                            fontSize: isTablet(context) ? 20 : 14
                                          ),
                                        ),
                                        const SizedBox(height: 5.0),
                                        Text(
                                          payments[index].date,
                                          style: TextStyle(
                                              color: themeNotifier.isLight() ? HexColor('#666666') : Colors.white70,
                                              fontSize: isTablet(context) ? 18 : 12
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                              Row(
                                children: [
                                  Text(
                                    payments[index].value.toString(),
                                    style: TextStyle(
                                      color: themeNotifier.isLight() ? HexColor('#363636') : Colors.white,
                                      fontSize: isTablet(context) ? 24 : 18,
                                    ),
                                  ),
                                  Text(
                                    ' ${getTranslated('jd', context)}',
                                    style: TextStyle(
                                      color: themeNotifier.isLight() ? HexColor('#363636') : Colors.white,
                                      fontSize: isTablet(context) ? 20 : 14,
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        )
                      );
                    }
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 25.0),
                  child: LayoutBuilder(
                    builder: (BuildContext context, BoxConstraints constraints) {
                      return Flex(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        direction: Axis.horizontal,
                        children: List.generate(
                          (constraints.constrainWidth() / (2 * 10.0)).floor(), (_) {
                            return SizedBox(
                              width: 10.0,
                              height: 1.0,
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  color: themeNotifier.isLight() ? HexColor('#363636') : Colors.white,
                                ),
                              ),
                            );
                          }
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        getTranslated('totalSummation', context),
                        style: TextStyle(
                          color: themeNotifier.isLight() ? HexColor('#363636') : Colors.white,
                          fontSize: isTablet(context) ? 20 : 14,
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            totalSummation.toStringAsFixed(3),
                            style: TextStyle(
                              color: themeNotifier.isLight() ? HexColor('#363636') : Colors.white,
                              fontSize: isTablet(context) ? 24 : 18,
                            ),
                          ),
                          Text(
                            ' ${getTranslated('jd', context)}',
                            style: TextStyle(
                              color: HexColor('#363636'),
                              fontSize: isTablet(context) ? 20 : 14,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                const Expanded(child: SizedBox.shrink()),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: textButton(
                    context,
                    themeNotifier,
                    'issuanceOfUnifiedPaymentCode',
                    payments.any((element) => element.isChecked == true) ? primaryColor : HexColor('#DADADA'),
                    payments.any((element) => element.isChecked == true) ? Colors.white : HexColor('#363636'),
                    (){
                      if(payments.any((element) => element.isChecked == true)){
                        String errorMessage = "";
                        payProvider.isLoading = true;
                        payProvider.notifyMe();
                        try{
                        payProvider.issuanceOfUnifiedPaymentCode(widget.payments).whenComplete((){}).then((value){
                          if(value['PO_STATUS'] == 0){
                            showMyDialog(
                                context, 'unifiedPaymentCodeReleased', getTranslated('yourUnifiedPaymentCodeIs', context),
                                'continueToPay', themeNotifier, icon: 'assets/icons/unifiedCodeReleased.svg', titleColor: themeNotifier.isLight() ? '#363636' : '#ffffff',
                                extraWidgetBody: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 15.0,),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          flex: 6,
                                          child: Container(
                                            alignment: Alignment.center,
                                            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                  color: themeNotifier.isLight() ? HexColor('#445740') : HexColor('#6f846b'),
                                                ),
                                                borderRadius: BorderRadius.circular(8.0)
                                            ),
                                            child: Text(
                                              '${value['PO_PAY_COD']}',
                                              style: TextStyle(
                                                color: themeNotifier.isLight() ? HexColor('#363636') : Colors.white,
                                                fontSize: isTablet(context) ? 22 : 16,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 3,
                                          child: TextButton.icon(
                                            onPressed: () async{
                                              await Clipboard.setData(
                                                  ClipboardData(text: '${value['PO_PAY_COD']}')
                                              );
                                            },
                                            icon: Icon(
                                              Icons.copy,
                                              color: themeNotifier.isLight() ? HexColor('#003C97') : HexColor('#00b0ff'),
                                            ),
                                            label: Text(
                                              getTranslated('copy', context),
                                              style: TextStyle(
                                                  color: themeNotifier.isLight() ? HexColor('#003C97') : HexColor('#00b0ff'),
                                                  decoration: TextDecoration.underline
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                    const SizedBox(height: 15.0,),
                                    Text(
                                      getTranslated('codeExpiration', context),
                                      style: TextStyle(
                                        color: HexColor('#FF0000'),
                                        fontSize: isTablet(context) ? 18 : 12,
                                      ),
                                    ),
                                  ],
                                ),
                                onPressed: (){
                                  Navigator.of(context).pop();
                                  Navigator.of(context).push(
                                      MaterialPageRoute(builder: (context) => PaymentMethodsScreen(payCode: '${value['PO_PAY_COD']}'))
                                  );
                                }
                            );
                          } else{
                            errorMessage = UserConfig.instance.checkLanguage()
                                ? value["PO_STATUS_DESC_EN"] : value["PO_STATUS_DESC_AR"];
                            showMyDialog(context, 'failed', errorMessage, 'ok', themeNotifier);
                          }
                          payProvider.isLoading = false;
                          payProvider.notifyMe();
                        });
                        }catch(e){
                          payProvider.isLoading = false;
                          payProvider.notifyMe();
                          if(kDebugMode){
                            print(e.toString());
                          }
                        }
                      }
                    },
                  ),
                )
              ],
            ),
          ),
          if(Provider.of<PayProvider>(context, listen: true).isLoading)
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
}

class Payments{
  final String title;
  final String date;
  final String icon;
  final double value;
  bool isChecked;

  Payments({this.title, this.date, this.icon, this.value ,this.isChecked = false});
}