// ignore_for_file: file_names

import 'package:flutter/material.dart';

import '../../../../../utilities/hexColor.dart';
import '../../../../../utilities/util.dart';
import '../shared/aboutTheServiceScreen.dart';
import '../shared/servicesListConstants.dart';

class MostVisitedBody extends StatefulWidget {
  const MostVisitedBody({Key key}) : super(key: key);

  @override
  State<MostVisitedBody> createState() => _MostVisitedBodyState();
}

class _MostVisitedBodyState extends State<MostVisitedBody> {

  List<Service> mostVisitedServices = ServicesList.mostVisitedServices;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemCount: mostVisitedServices.length,
        itemBuilder: (context, index){
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: (){
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => AboutTheServiceScreen(
                      serviceScreen: mostVisitedServices[index].screen,
                      serviceTitle: mostVisitedServices[index].title,
                      aboutServiceDescription: mostVisitedServices[index].description,
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
                    ))
                  );
                },
                child: Container(
                  margin: const EdgeInsets.only(right: 20),
                  width: width(1, context),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        translate(mostVisitedServices[index].supTitle, context),
                        style: TextStyle(
                          fontSize: width(isTablet(context) ? 0.03 : 0.035, context)
                        ),
                      ),
                      SizedBox(height: height(0.006, context)),
                      Text(
                        translate(mostVisitedServices[index].title, context),
                        style: TextStyle(
                          fontSize: width(isTablet(context) ? 0.025 :0.03, context)
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 15.0),
                child: Divider(
                  color: HexColor('#DEDEDE'),
                  thickness: 1,
                ),
              ),
            ],
          );
        }
      ),
    );
  }
}
