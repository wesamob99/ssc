
// ignore_for_file: file_names

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:ssc/src/view/pay/paymentMethodsScreen.dart';
import 'package:ssc/src/viewModel/pay/payProvider.dart';
import 'package:ssc/src/viewModel/utilities/theme/themeProvider.dart';
import 'package:ssc/utilities/theme/themes.dart';

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
        title: Text(translate('payments', context)),
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
                                      color: HexColor('#2D452E'),
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
                                            color: HexColor('#363636'),
                                            fontSize: width(isTablet(context) ? 0.027 : 0.031, context)
                                          ),
                                        ),
                                        const SizedBox(height: 5.0),
                                        Text(
                                          payments[index].date,
                                          style: TextStyle(
                                              color: HexColor('#666666'),
                                              fontSize: width(isTablet(context) ? 0.023 : 0.027, context)
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
                                      color: HexColor('#363636'),
                                      fontSize: width(isTablet(context) ? 0.036 : 0.04, context),
                                    ),
                                  ),
                                  Text(
                                    ' ${translate('jd', context)}',
                                    style: TextStyle(
                                      color: HexColor('#363636'),
                                      fontSize: width(isTablet(context) ? 0.026 : 0.03, context),
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
                                  color: HexColor('#363636'),
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
                        translate('totalSummation', context),
                        style: TextStyle(
                          color: HexColor('#363636'),
                          fontSize: width(isTablet(context) ? 0.036 : 0.04, context),
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            totalSummation.toStringAsFixed(3),
                            style: TextStyle(
                              color: HexColor('#363636'),
                              fontSize: width(isTablet(context) ? 0.036 : 0.04, context),
                            ),
                          ),
                          Text(
                            ' ${translate('jd', context)}',
                            style: TextStyle(
                              color: HexColor('#363636'),
                              fontSize: width(isTablet(context) ? 0.026 : 0.03, context),
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
                        payProvider.isLoading = true;
                        payProvider.notifyMe();
                        try{
                        payProvider.issuanceOfUnifiedPaymentCode(widget.payments).whenComplete((){}).then((value){
                          if(value['PO_STATUS'] == 0){
                            showMyDialog(
                                context, 'unifiedPaymentCodeReleased', translate('yourUnifiedPaymentCodeIs', context),
                                'continueToPay', themeNotifier, icon: 'assets/icons/unifiedCodeReleased.svg', titleColor: '#363636',
                                extraWidgetBody: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 15.0,),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                color: HexColor('#445740'),
                                              ),
                                              borderRadius: BorderRadius.circular(12.0)
                                          ),
                                          child: Text(
                                            '${value['PO_PAY_COD']}',
                                            style: TextStyle(
                                              color: HexColor('#363636'),
                                              fontSize: width(isTablet(context) ? 0.03 : 0.034, context),
                                            ),
                                          ),
                                        ),
                                        TextButton.icon(
                                          onPressed: () async{
                                            await Clipboard.setData(
                                                ClipboardData(text: '${value['PO_PAY_COD']}')
                                            );
                                          },
                                          icon: Icon(
                                            Icons.copy,
                                            color: HexColor('#003C97'),
                                          ),
                                          label: Text(
                                            translate('copy', context),
                                            style: TextStyle(
                                                color: HexColor('#003C97'),
                                                decoration: TextDecoration.underline
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                    const SizedBox(height: 15.0,),
                                    Text(
                                      translate('codeExpiration', context),
                                      style: TextStyle(
                                        color: HexColor('#FF0000'),
                                        fontSize: width(isTablet(context) ? 0.026 : 0.03, context),
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
            height: height(0.78, context),
            color: Colors.white70,
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