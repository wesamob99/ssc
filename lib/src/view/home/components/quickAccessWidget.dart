// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../utilities/hexColor.dart';
import '../../../../utilities/util.dart';

class QuickAccessWidget extends StatelessWidget {
  const QuickAccessWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List quickAccessComponents = [
      {'icon': 'assets/icons/unemploymentIcon.svg', 'title': "unemploymentApplication"},
      {'icon': 'assets/icons/onePaymentIcon.svg', 'title': "onePayment"},
      {'icon': 'assets/icons/reportAnAccidentIcon.svg', 'title': "ReportAnAccident"},
      {'icon': 'assets/icons/optionalSubscriptionIcon.svg', 'title': "optionalSubscription" },
      {'icon': 'assets/icons/accountStatementIcon.svg', 'title': "accountStatement"},
      {'icon': 'assets/icons/unemploymentIcon.svg', 'title': "unemploymentApplication"},
      {'icon': 'assets/icons/optionalSubscriptionIcon.svg', 'title': "optionalSubscription"},
      {'icon': 'assets/icons/accountStatementIcon.svg', 'title': "accountStatement"},
    ];
    return SizedBox(
      height: height(0.122, context),
      child: ListView.builder(
          itemCount: quickAccessComponents.length,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index){
            return Row(
              children: [
                InkWell(
                  onTap: (){},
                  highlightColor: const Color.fromRGBO(68, 87, 64, 0.4),
                  child: Column(
                    children: [
                      SizedBox(
                        width: width(0.171, context),
                        height: height(0.08, context),
                        child: Card(
                          elevation: 5.0,
                          margin: const EdgeInsets.all(3.0),
                          shadowColor: const Color.fromRGBO(45, 69, 46, 0.28),
                          color: HexColor('#FFFFFF'),
                          child: Padding(
                            padding: EdgeInsets.all(width(0.03, context)),
                            child: SvgPicture.asset(quickAccessComponents[index]['icon']),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: width(0.16, context),
                        child: Text(
                          translate(quickAccessComponents[index]['title'], context),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: height(0.0115, context)
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: width(index != quickAccessComponents.length-1 ? 0.015 : 0, context))
              ],
            );
          }
      ),
    );
  }
}
