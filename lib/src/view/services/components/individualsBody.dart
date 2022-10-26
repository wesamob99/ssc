// ignore_for_file: file_names

import 'package:flutter/material.dart';

import '../../../../utilities/hexColor.dart';
import '../../../../utilities/util.dart';
import '../complaints/workInjuryComplaintScreen.dart';

class IndividualsBody extends StatefulWidget {
  const IndividualsBody({Key key}) : super(key: key);

  @override
  State<IndividualsBody> createState() => _IndividualsBodyState();
}

class _IndividualsBodyState extends State<IndividualsBody> {

  List mostVisitedServices = [
    {"title": "retired", "subTitle": "requestRetiredLoan"},
    {"title": "individuals", "subTitle": "unemploymentApplication"},
    {"title": "maternity", "subTitle": "unemploymentApplication"},
  ];

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
          itemCount: 3,
          itemBuilder: (context, index){
            return Container(
              margin: EdgeInsets.only(bottom: height(0.02, context)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: (){
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => const WorkInjuryComplaintScreen())
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
