// ignore_for_file: file_names

import 'package:flutter/material.dart';

import '../../../../../utilities/hexColor.dart';
import '../../../../../utilities/util.dart';

class MostVisitedBody extends StatefulWidget {
  const MostVisitedBody({Key key}) : super(key: key);

  @override
  State<MostVisitedBody> createState() => _MostVisitedBodyState();
}

class _MostVisitedBodyState extends State<MostVisitedBody> {

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
                Container(
                  margin: const EdgeInsets.only(right: 10),
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