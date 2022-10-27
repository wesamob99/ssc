// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:ssc/src/view/services/shared/aboutTheServiceScreen.dart';

import '../../../../utilities/hexColor.dart';
import '../../../../utilities/util.dart';

class InsuranceBody extends StatefulWidget {
  const InsuranceBody({Key key}) : super(key: key);

  @override
  State<InsuranceBody> createState() => _InsuranceBodyState();
}

class _InsuranceBodyState extends State<InsuranceBody> {

  List mostVisitedServices = [
    {"title": "retired", "subTitle": "requestRetiredLoan", "description": "this supposed to be about the service description"},
    {"title": "individuals", "subTitle": "unemploymentApplication", "description": "this supposed to be about the service description"},
    {"title": "maternity", "subTitle": "unemploymentApplication", "description": "this supposed to be about the service description"},
    {"title": "workInjuries", "subTitle": "report_a_sickness/work_injury_complaint", "description": "this supposed to be about the service description"},
  ];

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
          itemCount: mostVisitedServices.length,
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
                            serviceTitle: mostVisitedServices[index]['subTitle'],
                            aboutServiceDescription: mostVisitedServices[index]['description'],
                            termsOfTheService: const ['hello', 'hello', 'hello', 'hello', 'hello'],
                            stepsOfTheService: const ['1text', '2text2', '3text3'],
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
                            translate(mostVisitedServices[index]['title'], context),
                            style: TextStyle(
                                fontSize: width(0.035, context)
                            ),
                          ),
                          SizedBox(height: height(0.006, context)),
                          Text(
                            translate(mostVisitedServices[index]['subTitle'], context),
                            style: TextStyle(
                                fontSize: width(0.03, context)
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
