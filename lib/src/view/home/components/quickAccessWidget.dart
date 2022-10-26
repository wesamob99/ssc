// ignore_for_file: file_names

import 'package:flutter/material.dart';

import '../../../../utilities/hexColor.dart';
import '../../../../utilities/util.dart';

class QuickAccessWidget extends StatelessWidget {
  const QuickAccessWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List quickAccessComponents = [
      {'icon': Icons.dangerous, 'title': "unemploymentApplication"},
      {'icon': Icons.key, 'title': "lump-sumCompensation"},
      {'icon': Icons.face, 'title': "ReportAnAccident"},
      {'icon': Icons.vaccines, 'title': "optionalSubscription"},
      {'icon': Icons.yard, 'title': "accountStatement"},
      {'icon': Icons.offline_bolt, 'title': "unemploymentApplication"},
      {'icon': Icons.qr_code, 'title': "optionalSubscription"},
      {'icon': Icons.nat, 'title': "accountStatement"},
    ];
    return SizedBox(
      height: height(0.1, context),
      child: ListView.builder(
          itemCount: quickAccessComponents.length,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index){
            return InkWell(
              onTap: (){},
              child: Row(
                children: [
                  Column(
                    children: [
                      SizedBox(
                        width: width(0.14, context),
                        height: width(0.14, context),
                        child: Card(
                          elevation: 5.0,
                          shadowColor: const Color.fromRGBO(45, 69, 46, 0.28),
                          color: HexColor('#FFFFFF'),
                          child: Icon(
                            quickAccessComponents[index]['icon'],
                            color: HexColor('#2D452E'),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: width(0.14, context),
                        child: Text(
                          translate(quickAccessComponents[index]['title'], context),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: height(0.01, context)
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: width(index != quickAccessComponents.length-1 ? 0.015 : 0, context))
                ],
              ),
            );
          }
      ),
    );
  }
}
