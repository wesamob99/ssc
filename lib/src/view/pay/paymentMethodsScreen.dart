// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:ssc/src/view/main/mainScreen.dart';
import 'package:ssc/utilities/hexColor.dart';
import 'package:ssc/utilities/theme/themes.dart';

import '../../../utilities/util.dart';
import '../../viewModel/utilities/theme/themeProvider.dart';

class PaymentMethodsScreen extends StatefulWidget {
  final String payCode;
  const PaymentMethodsScreen({Key key, @required this.payCode}) : super(key: key);

  @override
  State<PaymentMethodsScreen> createState() => _PaymentMethodsScreenState();
}

class _PaymentMethodsScreenState extends State<PaymentMethodsScreen> {

  List methods = [
    {"name": "bank", "icon": "assets/icons/bank.svg", "isSelected": true},
    {"name": "eFawateercom", "icon": "assets/icons/eFawateercom.svg", "isSelected": false},
    {"name": "cliq", "icon": "assets/icons/eFawateercom.svg", "isSelected": false},
  ];

  @override
  Widget build(BuildContext context) {
    ThemeNotifier themeNotifier = Provider.of<ThemeNotifier>(context);

    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(translate('paymentMethods', context)),
        leading: leadingBackIcon(context),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: width(0.26, context),
              width: width(1, context),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: methods.length,
                itemBuilder: (context, index){
                  return Row(
                    children: [
                      InkWell(
                        onTap: (){
                          for (var element in methods) {
                            if(element == methods[index]){
                              setState(() {
                                element['isSelected'] = true;
                              });
                            } else{
                              setState(() {
                                element['isSelected'] = false;
                              });
                            }
                          }
                        },
                        splashColor: primaryColor.withOpacity(0.3),
                        highlightColor: Colors.transparent,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          width: width(0.25, context),
                          height: width(0.25, context),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.0),
                              border: Border.all(
                                color: methods[index]['isSelected'] ? HexColor('#445740') : HexColor('#C9C9C9'),
                              )
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                methods[index]['icon'], width: width(0.09, context), height: width(0.09, context),
                              ),
                              const SizedBox(height: 7.0),
                              Text(
                                translate(methods[index]['name'], context),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: methods[index]['isSelected'] ? HexColor('#363636') : HexColor('#B3B3B3'),
                                  fontSize: 11
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                    ],
                  );
                }
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: height(0.05, context), bottom: height(0.035, context)),
              child: Text(
                translate('steps', context),
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600
                ),
              ),
            ),
            if(methods[0]['isSelected'])
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                      padding: EdgeInsets.only(bottom: height(0.012, context)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            translate('bankStep_1', context),
                          ),
                          const SizedBox(height: 10.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
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
                                  widget.payCode,
                                  style: TextStyle(
                                    color: HexColor('#363636'),
                                    fontSize: width(isTablet(context) ? 0.036 : 0.04, context),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 5.0),
                              TextButton.icon(
                                onPressed: () async{
                                  await Clipboard.setData(
                                      ClipboardData(text: widget.payCode)
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
                        ],
                      )
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: height(0.024, context)),
                    child: Text(
                      translate('bankStep_2', context),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: height(0.024, context)),
                    child: Text(
                      translate('bankStep_3', context),
                    ),
                  ),
                ],
              ),
            const Expanded(child: SizedBox.shrink()),
            Container(
              padding: EdgeInsets.only(bottom: height(0.07, context)),
              alignment: Alignment.center,
              width: width(1, context),
              child: textButton(context, themeNotifier, 'goToTheHomePage', primaryColor, Colors.white, (){
                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const MainScreen()), (route) => false);
              }),
            )
          ],
        ),
      ),
    );
  }
}
