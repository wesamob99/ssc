// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:ssc/infrastructure/userConfig.dart';
import 'package:ssc/src/view/services/shared/mostVisitedBody.dart';
import 'package:ssc/utilities/hexColor.dart';
import 'package:ssc/utilities/util.dart';

import '../../viewModel/utilities/theme/themeProvider.dart';
import 'insuranceBenifits/insuranceBody.dart';

class ServicesScreen extends StatefulWidget {
  const ServicesScreen({Key key}) : super(key: key);

  @override
  State<ServicesScreen> createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServicesScreen> {

  List sideBarItems = [
    {"icon": "assets/icons/servicesIcons/mostVisited.svg",
    "title": "suggestedServices"},
    {"icon": "assets/icons/servicesIcons/retiredServices.svg",
    "title": "retirementServices"},
    {"icon": "assets/icons/servicesIcons/insuranceBenefits.svg",
    "title": "insuranceBenefits"},
    {"icon": "assets/icons/servicesIcons/maternityServices.svg",
    "title": "maternityServices"},
    {"icon": "assets/icons/servicesIcons/financeServices.svg",
    "title": "financeServices"},
    {"icon": "assets/icons/servicesIcons/otherServices.svg",
    "title": "otherServices"},
  ];

  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    ThemeNotifier themeNotifier = Provider.of<ThemeNotifier>(context);
    return Scaffold(
      body: Row(
        children: [
          sideBarWidget(themeNotifier),
          // app screen body
          Container(
            padding: const EdgeInsets.all(16),
            width: width(0.69, context),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 3.0, horizontal: 10),
                  decoration: BoxDecoration(
                    color: themeNotifier.isLight()
                      ? HexColor('#F0F2F0') : HexColor('#454545'),
                    borderRadius: BorderRadius.circular(50)
                  ),
                  child: Text(
                    translate(sideBarItems[selectedIndex]['title'], context),
                    style: TextStyle(
                      color: HexColor('#2D452E'),
                      fontSize: width(0.035, context)
                    ),
                  ),
                ),
                SizedBox(height: height(0.02, context)),
                if(selectedIndex == 0)
                const MostVisitedBody(),
                if(selectedIndex == 2)
                const InsuranceBody()
              ],
            ),
          )
        ],
      ),
    );
  }

  sideBarWidget(ThemeNotifier themeNotifier){
    return Material(
      elevation: 0.8,
      borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(UserConfig.instance.checkLanguage() ? 0 : 10),
        bottomRight: Radius.circular(UserConfig.instance.checkLanguage() ? 10 : 0)
      ),
      child: Container(
        decoration: BoxDecoration(
          color: themeNotifier.isLight()
            ? HexColor('#F0F2F0') : HexColor('#454545'),
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(UserConfig.instance.checkLanguage() ? 0 : 8),
            bottomRight: Radius.circular(UserConfig.instance.checkLanguage() ? 8 : 0)
        ),
        ),
        width: width(0.31, context),
        child: ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 6,
            itemBuilder: (context, index){
              return InkWell(
                onTap: (){
                  setState(() {
                    selectedIndex = index;
                  });
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  height: height(0.1, context),
                  color: index == selectedIndex
                      ? themeNotifier.isLight()
                      ? Colors.white : HexColor('#8A8A8A')
                      : themeNotifier.isLight()
                      ? HexColor('#F0F2F0') : HexColor('#454545'),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(sideBarItems[index]['icon'],
                          color: index == selectedIndex
                              ? themeNotifier.isLight()
                              ? HexColor('#946800') : HexColor('#8A8A8A')
                              : themeNotifier.isLight()
                          ? HexColor('#716F6F') : HexColor('#ffffff')
                      ),
                      SizedBox(height: height(0.006, context),),
                      Text(
                        translate(sideBarItems[index]['title'], context),
                        style: TextStyle(
                        color: index == selectedIndex
                            ? themeNotifier.isLight()
                            ? HexColor('#946800') : HexColor('#8A8A8A')
                            : themeNotifier.isLight()
                            ? HexColor('#716F6F') : HexColor('#ffffff'),
                        fontSize: width(0.03, context),
                        fontWeight: index == selectedIndex ? FontWeight.w600 : FontWeight.w100,
                        ),
                      )
                    ],
                  ),
                ),
              );
            }
        ),
      ),
    );
  }
}
