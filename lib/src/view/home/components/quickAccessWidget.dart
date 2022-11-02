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
      {'icon': 'assets/icons/quickAccessIcons/unemploymentIcon.svg', 'title': "unemploymentApplication"},
      {'icon': 'assets/icons/quickAccessIcons/onePaymentIcon.svg', 'title': "onePayment"},
      {'icon': 'assets/icons/quickAccessIcons/reportAnAccidentIcon.svg', 'title': "ReportAnAccident"},
      {'icon': 'assets/icons/quickAccessIcons/optionalSubscriptionIcon.svg', 'title': "optionalSubscription" },
      {'icon': 'assets/icons/quickAccessIcons/accountStatementIcon.svg', 'title': "accountStatement"},
      {'icon': 'assets/icons/quickAccessIcons/unemploymentIcon.svg', 'title': "unemploymentApplication"},
      {'icon': 'assets/icons/quickAccessIcons/optionalSubscriptionIcon.svg', 'title': "optionalSubscription"},
      {'icon': 'assets/icons/quickAccessIcons/accountStatementIcon.svg', 'title': "accountStatement"},
    ];
    return SizedBox(
      height: height(0.12, context),
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
                      Card(
                        elevation: 5.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6.0),
                        ),
                        margin: EdgeInsets.symmetric(vertical: 3.0, horizontal: isTablet(context) ? 5.0 : 0),
                        shadowColor: const Color.fromRGBO(45, 69, 46, 0.28),
                        color: HexColor('#FFFFFF'),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: SvgPicture.asset(
                            quickAccessComponents[index]['icon'],
                            width: isTablet(context) ? 54 : 32,
                            height: isTablet(context) ? 54 : 32,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 64,
                        child: Text(
                          translate(quickAccessComponents[index]['title'], context),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: height(0.012, context),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: width(index != quickAccessComponents.length-1 ? 0.006 : 0, context))
              ],
            );
          }
      ),
    );
  }
}
