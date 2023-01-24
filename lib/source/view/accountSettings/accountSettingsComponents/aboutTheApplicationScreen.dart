// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../utilities/hexColor.dart';
import '../../../../utilities/util.dart';

class AboutTheApplicationScreen extends StatelessWidget {
  const AboutTheApplicationScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(translate('aboutSscApplication', context), style: const TextStyle(fontSize: 14),),
        leading: leadingBackIcon(context),
      ),
      body: Stack(
        children: [
          Opacity(
            opacity: 0.5,
            child: Container(
              alignment: Alignment.bottomLeft,
              child: SvgPicture.asset(
                  'assets/logo/logo_tree.svg'
              ),
            ),
          ),
          Container(
            width: width(1, context),
            height: height(0.8, context),
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset('assets/logo/logo_with_name.svg'),
                SizedBox(height: height(0.07, context)),
                Text(
                  translate('version', context) + "  3.0.2",
                  style: TextStyle(
                    color: HexColor('#363636'),
                    fontWeight: FontWeight.w500,
                    fontSize: 18
                  ),
                ),
                SizedBox(height: height(0.015, context)),
                Text(
                  translate('allRightReserved', context),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      color: Color.fromRGBO(95, 95, 95, 0.65),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
