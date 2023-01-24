// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:ssc/source/view/main/mainScreen.dart';
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
                                  color: methods[index]['isSelected']
                                      ? themeNotifier.isLight() ? HexColor('#363636') : Colors.white
                                      : HexColor('#B3B3B3'),
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
              padding: const EdgeInsets.only(top: 33, bottom: 18),
              child: Text(
                translate('steps', context),
                style: TextStyle(
                  fontSize: isTablet(context) ? 25 : 16,
                  fontWeight: FontWeight.w600
                ),
              ),
            ),
            if(methods[0]['isSelected'])
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                      padding: const EdgeInsets.only(bottom: 23),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            translate('bankStep_1', context),
                            style: TextStyle(
                              fontSize: isTablet(context) ? 20 : 14,
                            ),
                          ),
                          const SizedBox(height: 10.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                      color: themeNotifier.isLight() ? HexColor('#445740') : HexColor('#6f846b'),
                                    ),
                                    borderRadius: BorderRadius.circular(12.0)
                                ),
                                child: Text(
                                  widget.payCode,
                                  style: TextStyle(
                                    color: themeNotifier.isLight() ? HexColor('#363636') : Colors.white,
                                    fontSize: isTablet(context) ? 22 : 16,
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
                                  color: themeNotifier.isLight() ? HexColor('#003C97') : HexColor('#00b0ff'),
                                ),
                                label: Text(
                                  translate('copy', context),
                                  style: TextStyle(
                                      color: themeNotifier.isLight() ? HexColor('#003C97') : HexColor('#00b0ff'),
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
                    padding: const EdgeInsets.only(bottom: 21),
                    child: Text(
                      translate('bankStep_2', context),
                      style: TextStyle(
                        fontSize: isTablet(context) ? 20 : 14,
                      ),
                    ),
                  ),
                  Text(
                    translate('bankStep_3', context),
                    style: TextStyle(
                      fontSize: isTablet(context) ? 20 : 14,
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
