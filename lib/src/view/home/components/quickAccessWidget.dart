// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ssc/src/view/services/shared/aboutTheServiceScreen.dart';
import 'package:ssc/src/view/services/shared/servicesListConstants.dart';

import '../../../../utilities/hexColor.dart';
import '../../../../utilities/util.dart';

class QuickAccessWidget extends StatelessWidget {
  const QuickAccessWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    List<Service> quickAccessServices = ServicesList.quickAccessServices;

    return SizedBox(
      height: height(isScreenHasSmallHeight(context) ? 0.14 : 0.12, context),
      child: ListView.builder(
          itemCount: quickAccessServices.length,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index){
            return Row(
              children: [
                InkWell(
                  onTap: (){
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => AboutTheServiceScreen(
                          serviceScreen: quickAccessServices[index].screen,
                          serviceTitle: quickAccessServices[index].title,
                          aboutServiceDescription: quickAccessServices[index].description,
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
                            quickAccessServices[index].icon,
                            width: isTablet(context) ? 48 : 32,
                            height: isTablet(context) ? 48 : 32,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: isTablet(context) ? 90.0 : 65.0,
                        child: Text(
                          translate(quickAccessServices[index].title, context),
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
                SizedBox(width: width(index != quickAccessServices.length-1 ? 0.006 : 0, context))
              ],
            );
          }
      ),
    );
  }
}
