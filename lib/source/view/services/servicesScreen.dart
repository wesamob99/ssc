// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:ssc/infrastructure/userConfig.dart';
import 'package:ssc/infrastructure/userSecuredStorage.dart';
import 'package:ssc/source/view/services/mostVisited/mostVisitedBody.dart';
import 'package:ssc/source/view/services/retirementServices/retirementBody.dart';
import 'package:ssc/utilities/hexColor.dart';
import 'package:ssc/utilities/util.dart';

import '../../viewModel/utilities/theme/themeProvider.dart';
import 'insuranceServices/insuranceBody.dart';
import 'optionalAndFreeInclusion/optionalAndFreeInclusionBody.dart';

class ServicesScreen extends StatefulWidget {
  const ServicesScreen({Key key}) : super(key: key);

  @override
  State<ServicesScreen> createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServicesScreen> {

  List sideBarItems = [
    {"icon": "assets/icons/servicesIcons/mostVisited.svg", "title": "mostVisitedServices"},
    {"icon": "assets/icons/servicesIcons/retiredServices.svg", "title": "retirementServices"},
    {"icon": "assets/icons/servicesIcons/optionalAndFreeInclusionServices.svg", "title": "optionalAndFreeInclusionServices"},
    {"icon": "assets/icons/servicesIcons/financeServices.svg", "title": "financeServices"},
    {"icon": "assets/icons/servicesIcons/maternityServices.svg", "title": "maternityServices"},
    {"icon": "assets/icons/servicesIcons/insuranceBenefits.svg", "title": "insuranceBenefits"},
    {"icon": "assets/icons/servicesIcons/otherServices.svg", "title": "otherServices"},
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
            padding: const EdgeInsets.all(16.0).copyWith(top: 0.0),
            width: width(0.69, context),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // if(selectedIndex == 2)
                // Container(
                //   padding: const EdgeInsets.symmetric(vertical: 3.0, horizontal: 15),
                //   margin: const EdgeInsets.only(top: 10.0),
                //   decoration: BoxDecoration(
                //     color: themeNotifier.isLight()
                //       ? HexColor('#F0F2F0') : HexColor('#454545'),
                //     borderRadius: BorderRadius.circular(50)
                //   ),
                //   child: Text(
                //     translate(sideBarItems[selectedIndex]['title'], context),
                //     textAlign: TextAlign.center,
                //     style: TextStyle(
                //       color: HexColor('#2D452E'),
                //       fontSize: width((isTablet(context) || sideBarItems[selectedIndex]['title'].length > 20) ? 0.03 : 0.035, context)
                //     ),
                //   ),
                // ),
                SizedBox(height: height(0.02, context)),
                if(selectedIndex == 0)
                const MostVisitedBody(),
                if(selectedIndex == 1)
                const RetirementBody(),
                if(selectedIndex == 2)
                const OptionalAndFreeInclusionBody(),
                if(selectedIndex == 5)
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
        width: width(isTablet(context) ? 0.29 : 0.31, context),
        child: ListView.builder(
            // physics: const NeverScrollableScrollPhysics(),
            itemCount: sideBarItems.length,
            itemBuilder: (context, index){
              return (sideBarItems[index]['title'] != 'maternityServices') ||
              (sideBarItems[index]['title'] == 'maternityServices' && UserSecuredStorage.instance.gender == '2')
              ? InkWell(
                onTap: (){
                  setState(() {
                    selectedIndex = index;
                  });
                },
                child: AnimatedContainer(
                  padding: const EdgeInsets.symmetric(horizontal: 5.0),
                  duration: const Duration(milliseconds: 300),
                  height: height(0.1, context),
                  color: index == selectedIndex
                      ? themeNotifier.isLight()
                      ? Colors.white : HexColor('#8a8a8a')
                      : themeNotifier.isLight()
                      ? HexColor('#F0F2F0') : HexColor('#454545'),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(sideBarItems[index]['icon'],
                          color: index == selectedIndex
                              ? themeNotifier.isLight()
                              ? HexColor('#946800') : HexColor('#ffc668')
                              : themeNotifier.isLight()
                          ? HexColor('#716F6F') : HexColor('#ffffff'),
                        height: height(0.04, context), width: height(0.04, context),
                      ),
                      SizedBox(height: height(0.006, context),),
                      Text(
                        getTranslated(sideBarItems[index]['title'], context),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                        color: index == selectedIndex
                            ? themeNotifier.isLight()
                            ? HexColor('#946800') : HexColor('#ffc668')
                            : themeNotifier.isLight()
                            ? HexColor('#716F6F') : HexColor('#ffffff'),
                        fontSize: width(isTablet(context) ? 0.021 : 0.028, context),
                        fontWeight: index == selectedIndex ? FontWeight.w600 : FontWeight.w100,
                        ),
                      )
                    ],
                  ),
                ),
              ) : const SizedBox.shrink();
            }
        ),
      ),
    );
  }
}
