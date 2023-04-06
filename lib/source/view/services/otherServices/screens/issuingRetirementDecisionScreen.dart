// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:ssc/infrastructure/userSecuredStorage.dart';
import 'package:ssc/source/viewModel/services/servicesProvider.dart';
import 'package:ssc/source/viewModel/utilities/theme/themeProvider.dart';

import '../../../../../infrastructure/userConfig.dart';
import '../../../../../utilities/hexColor.dart';
import '../../../../../utilities/theme/themes.dart';
import '../../../../../utilities/util.dart';
import 'dart:math' as math;

class IssuingRetirementDecisionScreen extends StatefulWidget {
  const IssuingRetirementDecisionScreen({Key key}) : super(key: key);

  @override
  State<IssuingRetirementDecisionScreen> createState() => _IssuingRetirementDecisionScreenState();
}

class _IssuingRetirementDecisionScreenState extends State<IssuingRetirementDecisionScreen> {

  ServicesProvider servicesProvider;
  UserSecuredStorage userSecuredStorage;
  ThemeNotifier themeNotifier;

  @override
  void initState() {
    servicesProvider = Provider.of<ServicesProvider>(context, listen: false);
    themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);
    userSecuredStorage = UserSecuredStorage.instance;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(getTranslated('issuingRetirementDecision', context)),
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: InkWell(
            onTap: (){
              Navigator.of(context).pop();
            },
            child: Transform.rotate(
              angle: UserConfig.instance.isLanguageEnglish()
                  ? -math.pi / 1.0 : 0,
              child: SvgPicture.asset(
                  'assets/icons/backWhite.svg'
              ),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            card(),
          ],
        ),
      ),
    );
  }


  card(){
    return Card(
        elevation: 5.0,
        shadowColor: Colors.black45,
        color: getContainerColor(context),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Container(
            width: width(1, context),
            padding: const EdgeInsets.all(25.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      userSecuredStorage.userFullName,
                      style: TextStyle(
                        height: 1.4,
                        fontSize: 14,
                        color: themeNotifier.isLight() ? HexColor('#363636') : Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    // if(nationality == 'jordanian')
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
                      decoration: BoxDecoration(
                        color: const Color.fromRGBO(194, 163, 93, 1),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Text(
                        'تحتاج الى اجراء',
                        style: TextStyle(
                          color: HexColor('#543B00'),
                          fontWeight: FontWeight.w400,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15.0,),
                Row(
                  children: [
                    Text(
                      userSecuredStorage.nationalId,
                      style: TextStyle(
                        color: themeNotifier.isLight() ? HexColor('#716F6F') : Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      ' / ',
                      style: TextStyle(
                        color: themeNotifier.isLight() ? HexColor('#716F6F') : Colors.white70,
                      ),
                    ),
                    Text(
                      userSecuredStorage.internationalCode == '962'
                      ? getTranslated('jordanian', context)
                      : getTranslated('nonJordanian', context),
                      style: TextStyle(
                        color: themeNotifier.isLight() ? HexColor('#716F6F') : Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 25.0,),
                Text(
                  "يرجى قراءه قرار التبيلغ بحذر قبل الموافقة عليه او الاعتراض عليه .",
                  style: TextStyle(
                    color: themeNotifier.isLight() ? HexColor('#ED3124') : Colors.white70,
                    fontSize: 12,
                    height: 2,
                  ),
                ),
                const SizedBox(height: 25.0,),
                Text(
                  "قرار التقاعد يعتبر قطعي ونهائي إذا لم تقم بالاعتراض عليه خلال (15) يوم من اليوم التالي لتاريخ تبلغك القرار. \n\n • قراراً قابلاً للاعتراض أمام لجنة تسوية الحقوق الاستئنافية في المؤسسة، خلال خمسة عشر يوماً من اليوم التالي لتاريخ تبلغك القرار.",
                  style: TextStyle(
                    color: themeNotifier.isLight() ? HexColor('#B3913E') : Colors.white70,
                    fontSize: 12,
                    height: 2,
                  ),
                ),
              ],
            )
        )
    );
  }
}
