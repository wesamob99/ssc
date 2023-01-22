// ignore_for_file: file_names

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:ssc/infrastructure/userConfig.dart';
import 'package:ssc/src/viewModel/accountSettings/accountSettingsProvider.dart';
import 'package:ssc/src/viewModel/utilities/theme/themeProvider.dart';

import '../../../../utilities/hexColor.dart';
import '../../../../utilities/theme/themes.dart';
import '../../../../utilities/util.dart';
import 'dart:ui' as ui;

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
      backgroundColor: themeNotifier.isLight() ? Colors.grey.shade100 : HexColor('212121'),
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
            Column(
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
                            color: getContainerColor(context),
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                translate('balanceToBePaid', context),
                                style: TextStyle(
                                  color: !themeNotifier.isLight() ? Colors.white : HexColor('#363636'),
                                  fontSize: 13,
                                ),
                              ),
                              const SizedBox(height: 12.0,),
                              Row(
                                children: [
                                  Text(
                                    '250',
                                    style: TextStyle(
                                      color: !themeNotifier.isLight() ? Colors.white : HexColor('#363636'),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 19,
                                    ),
                                  ),
                                  Text(
                                    ' ${translate('jd', context)}',
                                    style: TextStyle(
                                      color: !themeNotifier.isLight() ? Colors.white : HexColor('#363636'),
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
                                  color: !themeNotifier.isLight() ? Colors.white : HexColor('#363636'),
                                  fontSize: 13,
                                ),
                              ),
                              const SizedBox(height: 16.0,),
                              textButton(context, themeNotifier, 'addToPay', getPrimaryColor(context, themeNotifier),
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
                            color: getContainerColor(context),
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                translate('nextBatchDate', context),
                                style: TextStyle(
                                  color: !themeNotifier.isLight() ? Colors.white : HexColor('#363636'),
                                  fontSize: 13,
                                ),
                              ),
                              const SizedBox(height: 12.0,),
                              Row(
                                children: [
                                  Text(
                                    '250',
                                    style: TextStyle(
                                      color: !themeNotifier.isLight() ? Colors.white : HexColor('#363636'),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 19,
                                    ),
                                  ),
                                  Text(
                                    ' ${translate('jd', context)}',
                                    style: TextStyle(
                                      color: !themeNotifier.isLight() ? Colors.white : HexColor('#363636'),
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
                                      color: !themeNotifier.isLight() ? Colors.white : HexColor('#363636'),
                                      fontSize: 13,
                                    ),
                                  ),
                                  Text(
                                    ' 5/1/2023',
                                    style: TextStyle(
                                      color: !themeNotifier.isLight() ? Colors.white : HexColor('#363636'),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16.0,),
                              textButton(context, themeNotifier, 'addToPay', Colors.transparent,
                                  themeNotifier.isLight() ? HexColor('#946800') : HexColor('#c99639'), () async {},
                                  borderColor: themeNotifier.isLight() ? '#946800': '#c99639'
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 25.0,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      translate('paymentHistory', context),
                      style: TextStyle(
                        color: !themeNotifier.isLight() ? Colors.white : HexColor('#363636'),
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    Row(
                      children: [
                        SvgPicture.asset('assets/icons/profileIcons/filter.svg'),
                        const SizedBox(width: 5.0,),
                        SvgPicture.asset('assets/icons/profileIcons/pdf.svg'),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 15.0,)
              ],
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    buildPaymentCard('title', '250', 2, '5656'),
                    buildPaymentCard('title', '140', 2, '5656'),
                    buildPaymentCard('title', '315', 2, '5656'),
                    buildPaymentCard('title', '28', 2, '5656'),
                    buildPaymentCard('title', '88', 2, '5656'),
                    buildPaymentCard('title', '198', 2, '5656'),
                    buildPaymentCard('title', '88', 2, '5656'),
                    buildPaymentCard('title', '198', 2, '5656'),
                    buildPaymentCard('title', '88', 2, '5656'),
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
    return InkWell(
      onTap: () => paymentDetailsModalBottomSheet(),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 10.0, top: 10),
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
                    color:!themeNotifier.isLight() ? Colors.white :  HexColor('#363636'),
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
                      color: status == 1
                          ? !themeNotifier.isLight() ? HexColor('#ffd86d') : HexColor('#987803')
                          : !themeNotifier.isLight() ? HexColor('#8fe5eb') : HexColor('#248389'),
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
                            color: !themeNotifier.isLight() ? Colors.white : HexColor('#363636'),
                            fontWeight: FontWeight.bold,
                            fontSize: 19,
                          ),
                        ),
                        Text(
                          ' ${translate('jd', context)}',
                          style: TextStyle(
                            color: !themeNotifier.isLight() ? Colors.white : HexColor('#363636'),
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
                              color: !themeNotifier.isLight() ? Colors.white : HexColor('#716F6F'),
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            ' $cardNo',
                            style: TextStyle(
                              color: !themeNotifier.isLight() ? Colors.white : HexColor('#716F6F'),
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
      ),
    );
  }

  paymentDetailsModalBottomSheet(){
    return showModalBottomSheet(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(25.0))
        ),
        context: context,
        barrierColor: Colors.black26,
        isScrollControlled: true,
        constraints: BoxConstraints(
          maxHeight: height(0.9, context)
        ),
        builder: (context) {
          return BackdropFilter(
            filter: ui.ImageFilter.blur(
              sigmaX: 1.0,
              sigmaY: 1.0,
            ),
            child: Material(
              elevation: 100,
              borderRadius: BorderRadius.circular(25.0),
              color: getContainerColor(context),
              shadowColor: Colors.black,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0).copyWith(top: 15.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          width: 45,
                          height: 6,
                          decoration: BoxDecoration(
                              color: !themeNotifier.isLight() ? Colors.white : HexColor('#000000'),
                              borderRadius: const BorderRadius.all(Radius.circular(25.0))),
                        ),
                      ],
                    ),
                    const SizedBox(height: 25.0,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          translate('paymentDetail', context),
                          style: TextStyle(
                            color: !themeNotifier.isLight() ? Colors.white : HexColor('#363636'),
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                        InkWell(
                          onTap: (){
                            Navigator.of(context).pop();
                          },
                          child: SvgPicture.asset('assets/icons/close.svg', color: !themeNotifier.isLight() ? Colors.white : HexColor('#363636'),),
                        )
                      ],
                    ),
                    const SizedBox(height: 25.0,),
                    SizedBox(
                      width: width(1, context),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            UserConfig.instance.checkLanguage()
                                ? 'Pay an optional subscription fee' : 'تسديد رسوم اشتراك اختياري',
                            style: TextStyle(
                              color: !themeNotifier.isLight() ? Colors.white : HexColor('#363636'),
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 15.0,),
                          Text(
                            '25/12/2022',
                            style: TextStyle(
                              color: !themeNotifier.isLight() ? Colors.white : HexColor('#363636'),
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30.0,),
                    Text(
                      UserConfig.instance.checkLanguage()
                          ? 'The amount paid' : 'المبلغ المدفوع',
                      style: TextStyle(
                        color: !themeNotifier.isLight() ? Colors.white : HexColor('#363636'),
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 15.0,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '250',
                          style: TextStyle(
                            color: !themeNotifier.isLight() ? Colors.white : HexColor('#363636'),
                            fontWeight: FontWeight.w700,
                            fontSize: 35,
                          ),
                        ),
                        Text(
                          ' ${translate('jd', context)}',
                          style: TextStyle(
                            color: !themeNotifier.isLight() ? Colors.white : HexColor('#363636'),
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15.0,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          translate('card', context),
                          style: TextStyle(
                            color: !themeNotifier.isLight() ? Colors.white70 : HexColor('#716F6F'),
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          ' 5656',
                          style: TextStyle(
                            color: !themeNotifier.isLight() ? Colors.white70 : HexColor('#716F6F'),
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 40.0, bottom: 30.0),
                      child: DottedBorder(
                        radius: const Radius.circular(8.0),
                        padding: EdgeInsets.zero,
                        color: !themeNotifier.isLight() ? Colors.white : HexColor('#979797'),
                        borderType: BorderType.Rect,
                        dashPattern: const [8],
                        strokeWidth: 1.2, child: Container(),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: width(0.1, context)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                translate('paymentStatus', context),
                                style: TextStyle(
                                  color: !themeNotifier.isLight() ? Colors.white70 : HexColor('#979797'),
                                  fontSize: 14,
                                ),
                              ),
                              Text(
                                translate('paymentDueDate', context),
                                style: TextStyle(
                                  color: !themeNotifier.isLight() ? Colors.white70 : HexColor('#979797'),
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 15.0,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                translate('payed', context),
                                style: TextStyle(
                                  color: !themeNotifier.isLight() ? Colors.white : HexColor('#595959'),
                                  fontSize: 14,
                                ),
                              ),
                              Text(
                                '25/12/2022',
                                style: TextStyle(
                                  color: !themeNotifier.isLight() ? Colors.white : HexColor('#595959'),
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 40,),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: width(0.1, context)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                translate('invoiceNumber', context),
                                style: TextStyle(
                                  color: !themeNotifier.isLight() ? Colors.white70 : HexColor('#979797'),
                                  fontSize: 14,
                                ),
                              ),
                              Text(
                                translate('payDate', context),
                                style: TextStyle(
                                  color: !themeNotifier.isLight() ? Colors.white70 : HexColor('#979797'),
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 15.0,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '435975',
                                style: TextStyle(
                                  color: !themeNotifier.isLight() ? Colors.white : HexColor('#595959'),
                                  fontSize: 14,
                                ),
                              ),
                              Text(
                                '25/12/2022',
                                style: TextStyle(
                                  color: !themeNotifier.isLight() ? Colors.white : HexColor('#595959'),
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        }
    );
  }
}
