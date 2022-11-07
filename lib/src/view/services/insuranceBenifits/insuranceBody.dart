// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:ssc/src/view/services/insuranceBenifits/screens/workInjuryComplaintScreen.dart';
import 'package:ssc/src/view/services/shared/aboutTheServiceScreen.dart';

import '../../../../utilities/hexColor.dart';
import '../../../../utilities/util.dart';

class InsuranceBody extends StatefulWidget {
  const InsuranceBody({Key key}) : super(key: key);

  @override
  State<InsuranceBody> createState() => _InsuranceBodyState();
}

class _InsuranceBodyState extends State<InsuranceBody> {

  List insuranceBenefitsServices = [
    {"title": "retired", "subTitle": "requestRetiredLoan", "description": "this supposed to be about the service description", "screen": const WorkInjuryComplaintScreen()},
    {"title": "individuals", "subTitle": "unemploymentApplication", "description": "this supposed to be about the service description", "screen": const WorkInjuryComplaintScreen()},
    {"title": "maternity", "subTitle": "unemploymentApplication", "description": "this supposed to be about the service description", "screen": const WorkInjuryComplaintScreen()},
    {"title": "workInjuries", "subTitle": "report_a_sickness/work_injury_complaint", "description": "this supposed to be about the service description", "screen": const WorkInjuryComplaintScreen()},
  ];

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
          itemCount: insuranceBenefitsServices.length,
          itemBuilder: (context, index){
            return Container(
              margin: EdgeInsets.only(bottom: height(0.02, context)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: (){
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => AboutTheServiceScreen(
                            serviceScreen: insuranceBenefitsServices[index]['screen'],
                            serviceTitle: insuranceBenefitsServices[index]['subTitle'],
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
                          )
                        ),
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.only(right: 10),
                      width: width(1, context),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            translate(insuranceBenefitsServices[index]['title'], context),
                            style: TextStyle(
                                fontSize: width(isTablet(context) ? 0.03 : 0.035, context)
                            ),
                          ),
                          SizedBox(height: height(0.006, context)),
                          Text(
                            translate(insuranceBenefitsServices[index]['subTitle'], context),
                            style: TextStyle(
                                fontSize: width(isTablet(context) ? 0.025 : 0.03, context)
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Divider(
                    color: HexColor('#DEDEDE'),
                  ),
                ],
              ),
            );
          }
      ),
    );
  }
}
