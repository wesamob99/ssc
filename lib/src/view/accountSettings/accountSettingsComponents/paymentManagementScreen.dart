// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:ssc/infrastructure/userConfig.dart';
import 'package:ssc/src/viewModel/accountSettings/accountSettingsProvider.dart';
import 'package:ssc/src/viewModel/utilities/theme/themeProvider.dart';

import '../../../../utilities/hexColor.dart';
import '../../../../utilities/theme/themes.dart';
import '../../../../utilities/util.dart';

class PaymentManagementScreen extends StatefulWidget {
  const PaymentManagementScreen({Key key}) : super(key: key);

  @override
  State<PaymentManagementScreen> createState() => _PaymentManagementScreenState();
}

class _PaymentManagementScreenState extends State<PaymentManagementScreen> {

  ThemeNotifier themeNotifier;
  AccountSettingsProvider accountSettingsProvider;

  @override
  void initState() {
    themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);
    accountSettingsProvider = Provider.of<AccountSettingsProvider>(context, listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        centerTitle: false,
        title: Text(translate('paymentManagement', context), style: const TextStyle(fontSize: 14),),
        leading: leadingBackIcon(context),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(
              flex: 4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Material(
                          elevation: 5.0,
                          shadowColor: Colors.black54,
                          borderRadius: BorderRadius.circular(16.0),
                          child: Container(
                            padding: const EdgeInsets.all(16.0),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16.0),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  translate('balanceToBePaid', context),
                                  style: TextStyle(
                                    color: HexColor('#363636'),
                                    fontSize: 13,
                                  ),
                                ),
                                const SizedBox(height: 12.0,),
                                Row(
                                  children: [
                                    Text(
                                      '250',
                                      style: TextStyle(
                                        color: HexColor('#363636'),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 19,
                                      ),
                                    ),
                                    Text(
                                      ' ${translate('jd', context)}',
                                      style: TextStyle(
                                        color: HexColor('#363636'),
                                        fontWeight: FontWeight.w400,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12.0,),
                                Text(
                                  translate('unemploymentApplication', context),
                                  style: TextStyle(
                                    color: HexColor('#363636'),
                                    fontSize: 13,
                                  ),
                                ),
                                const SizedBox(height: 16.0,),
                                textButton(context, themeNotifier, 'payNow', getPrimaryColor(context, themeNotifier),
                                    HexColor('#ffffff'), () async {}
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16.0,),
                      Expanded(
                        child: Material(
                          elevation: 5.0,
                          shadowColor: Colors.black54,
                          borderRadius: BorderRadius.circular(16.0),
                          child: Container(
                            padding: const EdgeInsets.all(16.0),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16.0),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  translate('nextBatchDate', context),
                                  style: TextStyle(
                                    color: HexColor('#363636'),
                                    fontSize: 13,
                                  ),
                                ),
                                const SizedBox(height: 12.0,),
                                Row(
                                  children: [
                                    Text(
                                      '250',
                                      style: TextStyle(
                                        color: HexColor('#363636'),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 19,
                                      ),
                                    ),
                                    Text(
                                      ' ${translate('jd', context)}',
                                      style: TextStyle(
                                        color: HexColor('#363636'),
                                        fontWeight: FontWeight.w400,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12.0,),
                                Row(
                                  children: [
                                    Text(
                                      translate('onDate', context),
                                      style: TextStyle(
                                        color: HexColor('#363636'),
                                        fontSize: 13,
                                      ),
                                    ),
                                    Text(
                                      ' 5/1/2023',
                                      style: TextStyle(
                                        color: HexColor('#363636'),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16.0,),
                                textButton(context, themeNotifier, 'payNow', HexColor('#ffffff'),
                                    HexColor('#946800'), () async {}, borderColor: '#946800'
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 25.0,),
                  Text(
                    translate('paymentHistory', context),
                    style: TextStyle(
                      color: HexColor('#363636'),
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 9,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    buildPaymentCard('title', '250', 1, '5656'),
                    buildPaymentCard('title', '140', 2, '5656'),
                    buildPaymentCard('title', '315', 1, '5656'),
                    buildPaymentCard('title', '28', 2, '5656'),
                    buildPaymentCard('title', '88', 2, '5656'),
                    buildPaymentCard('title', '198', 2, '5656'),
                    buildPaymentCard('title', '88', 1, '5656'),
                    buildPaymentCard('title', '198', 2, '5656'),
                    buildPaymentCard('title', '88', 1, '5656'),
                    buildPaymentCard('title', '198', 2, '5656'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


  buildPaymentCard(String title, String amount, int status, String cardNo){
    String statusText = '';
    status == 1 ? statusText = 'waiting' : statusText = 'paymentCompleted';
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                UserConfig.instance.checkLanguage()
                    ? 'Pay an optional subscription fee' : 'تسديد رسوم اشتراك اختياري',
                style: TextStyle(
                  color: HexColor('#363636'),
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 10.0,),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 5.0),
                decoration: BoxDecoration(
                    color: status == 1
                      ? const Color.fromRGBO(221, 201, 129, 0.49)
                      : const Color.fromRGBO(129, 221, 199, 0.49),
                    borderRadius: BorderRadius.circular(50.0)
                ),
                child: Text(
                  translate(statusText, context),
                  style: TextStyle(
                    color: status == 1 ? HexColor('#987803') : HexColor('#248389'),
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Text(
                        amount,
                        style: TextStyle(
                          color: HexColor('#363636'),
                          fontWeight: FontWeight.bold,
                          fontSize: 19,
                        ),
                      ),
                      Text(
                        ' ${translate('jd', context)}',
                        style: TextStyle(
                          color: HexColor('#363636'),
                          fontWeight: FontWeight.w400,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10.0,),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 5.0),
                    decoration: BoxDecoration(
                        color: const Color.fromRGBO(220, 220, 220, 0.49),
                        borderRadius: BorderRadius.circular(50.0)
                    ),
                    child: Row(
                      children: [
                        Text(
                          translate('card', context),
                          style: TextStyle(
                            color: HexColor('#716F6F'),
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          ' $cardNo',
                          style: TextStyle(
                            color: HexColor('#716F6F'),
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 25.0,),
              SvgPicture.asset('assets/icons/arrow.svg')
            ],
          )
        ],
      ),
    );
  }
}
