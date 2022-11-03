// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ssc/src/view/services/shared/aboutTheServiceScreen.dart';

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
      height: height(isScreenHasSmallHeight(context) ? 0.14 : 0.12, context),
      child: ListView.builder(
          itemCount: quickAccessComponents.length,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index){
            return Row(
              children: [
                InkWell(
                  onTap: (){
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => AboutTheServiceScreen(
                          serviceTitle: quickAccessComponents[index]['title'],
                          aboutServiceDescription: ' بدلات التعطل عن العمل التي تقوم بصرفها والتي تخص المؤمن عليهم المشتركين بالضمان والعاملين في منشآت القطاع الخاص ممن يتعطّلون مؤقتاً عن العمل هي مبالغ غير مستردّة ولا يطالب المؤمن عليهم بإعادتها إلاّ في حال ثبت أن المؤمن عليه تقاضى أياً من هذه البدلات دون وجه حق إلاّ في حال ثبت أن المؤمن عليه تقاضى أياً من هذه البدلات إلاّ في حال ثبت أن المؤمن عليه تقاضى أياً من هذه البدلات',//mostVisitedServices[index]['description'],
                          termsOfTheService: const [
                            'موظفي القطاع الخاص',
                            'موظف موقوف عن العمل',
                            'لديك 36 اشتراك او رصيد اكثر من 300 د.ا',
                            'ان تكون قد استفدت من بدل التعطل ثلاث مرات او اقل خلال فتره الشمول',
                          ],
                          stepsOfTheService: const [
                            'التأكد من المعلومات الشخصية لمقدم الخدمة',
                            'تعبئة طلب الخدمة',
                            'تقديم الطلب'
                          ],
                        ),
                      ),
                    );
                  },
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
                          padding: EdgeInsets.all(isTablet(context) ? 17.0 : 14.0),
                          child: SvgPicture.asset(
                            quickAccessComponents[index]['icon'],
                            width: isTablet(context) ? 48 : 32,
                            height: isTablet(context) ? 48 : 32,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: isScreenHasSmallHeight(context) ? 65 : isTablet(context) ? 90.0 : 67.0,
                        child: Text(
                          translate(quickAccessComponents[index]['title'], context),
                          textAlign: TextAlign.center,
                          maxLines: isScreenHasSmallHeight(context) ? 2 : 3,
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
