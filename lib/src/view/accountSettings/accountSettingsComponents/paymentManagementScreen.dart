// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
        child: SingleChildScrollView(
          child: Column(
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
                                    fontSize: 20,
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
                                    fontSize: 20,
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
              )
            ],
          ),
        ),
      ),
    );
  }
}
