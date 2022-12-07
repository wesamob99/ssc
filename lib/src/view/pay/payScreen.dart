
// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:ssc/src/viewModel/utilities/theme/themeProvider.dart';
import 'package:ssc/utilities/theme/themes.dart';

import '../../../utilities/hexColor.dart';
import '../../../utilities/util.dart';

class PayScreen extends StatefulWidget {
  const PayScreen({Key key}) : super(key: key);

  @override
  State<PayScreen> createState() => _PayScreenState();
}

class _PayScreenState extends State<PayScreen> {

  List<Payments> payments = [
    Payments(title: 'optionalSubscription', date: '12/04/2022', value: '180.4', icon: 'assets/icons/servicesIcons/individualsServices.svg'),
    Payments(title: 'optionalSubscription', date: '1/7/2022', value: '412', icon: 'assets/icons/servicesIcons/otherServices.svg'),
    Payments(title: 'optionalSubscription', date: '28/6/2021', value: '93.65', icon: 'assets/icons/servicesIcons/retiredServices.svg'),
    Payments(title: 'optionalSubscription', date: '5/9/2017', value: '340', icon: 'assets/icons/servicesIcons/financeServices.svg'),
  ];

  @override
  Widget build(BuildContext context) {
    ThemeNotifier themeNotifier = Provider.of<ThemeNotifier>(context);

    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(translate('payments', context)),
        leading: leadingBackIcon(context),
      ),
      body: Padding(
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
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: (){
                            setState(() {
                              payments[index].isChecked = !payments[index].isChecked;
                            });
                          },
                          child: Row(
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
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    translate(payments[index].title, context),
                                    style: TextStyle(
                                      color: HexColor('#363636'),
                                      fontSize: width(isTablet(context) ? 0.028 : 0.032, context)
                                    ),
                                  ),
                                  const SizedBox(height: 5.0),
                                  Text(
                                    payments[index].date,
                                    style: TextStyle(
                                        color: HexColor('#666666'),
                                        fontSize: width(isTablet(context) ? 0.024 : 0.028, context)
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              payments[index].value,
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
                        '1026.5',
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
                'continue',
                payments.any((element) => element.isChecked == true) ? primaryColor : HexColor('#DADADA'),
                payments.any((element) => element.isChecked == true) ? Colors.white : HexColor('#363636'),
                (){},
              ),
            )
          ],
        ),
      ),
    );
  }
}

class Payments{
  final String title;
  final String date;
  final String icon;
  final String value;
  bool isChecked;

  Payments({this.title, this.date, this.icon, this.value ,this.isChecked = false});
}