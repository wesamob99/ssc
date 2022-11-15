// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ssc/src/view/services/shared/aboutTheServiceScreen.dart';
import 'package:ssc/src/view/services/shared/servicesListConstants.dart';

import '../../../../utilities/hexColor.dart';
import '../../../../utilities/util.dart';
import '../../../viewModel/utilities/theme/themeProvider.dart';

class InsuranceBody extends StatefulWidget {
  const InsuranceBody({Key key}) : super(key: key);

  @override
  State<InsuranceBody> createState() => _InsuranceBodyState();
}

class _InsuranceBodyState extends State<InsuranceBody> {

  List<Service> insuranceBenefitsServices = ServicesList.insuranceBenefitsServices;

  @override
  Widget build(BuildContext context) {
    ThemeNotifier themeNotifier = Provider.of<ThemeNotifier>(context);
    return Expanded(
      child: ListView.builder(
          itemCount: insuranceBenefitsServices.length,
          itemBuilder: (context, index){
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 3.0, horizontal: 15),
                  margin: const EdgeInsets.only(bottom: 10.0),
                  decoration: BoxDecoration(
                    color: themeNotifier.isLight()
                      ? HexColor('#F0F2F0') : HexColor('#454545'),
                    borderRadius: BorderRadius.circular(50)
                  ),
                  child: Text(
                    translate(insuranceBenefitsServices[index].supTitle, context),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: HexColor('#2D452E'),
                      fontSize: width(isTablet(context) ? 0.03 : 0.035, context)
                    ),
                  ),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: 4,
                  itemBuilder: (context, index){
                    return Column(
                      children: [
                        InkWell(
                          onTap: (){
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) => AboutTheServiceScreen(
                                    serviceScreen: insuranceBenefitsServices[index].screen,
                                    serviceTitle: insuranceBenefitsServices[index].title,
                                    aboutServiceDescription: insuranceBenefitsServices[index].description,
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
                                  )
                              ),
                            );
                          },
                          child: Container(
                            margin: EdgeInsets.only(right: 20.0, top: 10.0, bottom: index == 3 ? 25.0 : 15.0),
                            width: width(1, context),
                            child: Text(
                              translate(insuranceBenefitsServices[index].title, context),
                              style: TextStyle(
                                  fontSize: width(isTablet(context) ? 0.025 : 0.03, context)
                              ),
                            ),
                          ),
                        ),
                        if(index != 3)
                        Divider(
                          color: HexColor('#DEDEDE'),
                          thickness: 1,
                        ),
                      ],
                    );
                  },
                ),
              ],
            );
          }
      ),
    );
  }
}
