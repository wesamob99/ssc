import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:ssc/src/viewModel/services/servicesProvider.dart';

import '../../../../../infrastructure/userConfig.dart';
import '../../../../../utilities/util.dart';
import 'dart:math' as math;

class EarlyRetirementRequestScreen extends StatefulWidget {
  const EarlyRetirementRequestScreen({Key key}) : super(key: key);

  @override
  State<EarlyRetirementRequestScreen> createState() => _EarlyRetirementRequestScreenState();
}

class _EarlyRetirementRequestScreenState extends State<EarlyRetirementRequestScreen> {

  ServicesProvider servicesProvider;

  @override
  void initState() {
    servicesProvider = Provider.of<ServicesProvider>(context, listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(translate('earlyRetirementRequest', context)),
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: InkWell(
            onTap: (){
              switch(servicesProvider.stepNumber){
                case 1: Navigator.of(context).pop(); break;
                case 2: servicesProvider.stepNumber = 1; break;
                case 3: servicesProvider.stepNumber = 2; break;
              }
              servicesProvider.notifyMe();
            },
            child: Transform.rotate(
              angle: UserConfig.instance.checkLanguage()
                  ? -math.pi / 1.0 : 0,
              child: SvgPicture.asset(
                  'assets/icons/backWhite.svg'
              ),
            ),
          ),
        ),
      ),
      body: Container(),
    );
  }
}
