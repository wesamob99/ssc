import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:ssc/src/view/services/components/mostVisited/mostVisitedBody.dart';
import 'package:ssc/utilities/hexColor.dart';
import 'package:ssc/utilities/util.dart';

import '../../viewModel/utilities/theme/themeProvider.dart';

class ServicesScreen extends StatefulWidget {
  const ServicesScreen({Key? key}) : super(key: key);

  @override
  State<ServicesScreen> createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServicesScreen> {

  List sideBarItems = [
    {"icon": "assets/icons/sideBarIcons/mostVisited.svg",
    "title": "suggestedServices"},
    {"icon": "assets/icons/sideBarIcons/retiredServices.svg",
    "title": "retiredServices"},
    {"icon": "assets/icons/sideBarIcons/individualsServices.svg",
    "title": "individualsServices"},
    {"icon": "assets/icons/sideBarIcons/maternityServices.svg",
    "title": "maternityServices"},
    {"icon": "assets/icons/sideBarIcons/financeServices.svg",
    "title": "financeServices"},
    {"icon": "assets/icons/sideBarIcons/otherServices.svg",
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
                      color: HexColor('#2D452E')
                    ),
                  ),
                ),
                SizedBox(height: height(0.02, context)),
                if(selectedIndex == 0)
                const MostVisitedBody()
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
      borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(10)
      ),
      child: Container(
        decoration: BoxDecoration(
          color: themeNotifier.isLight()
            ? HexColor('#F0F2F0') : HexColor('#454545'),
          borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(8)
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
                child: Container(
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
                              ? HexColor('#171717') : HexColor('#8A8A8A')
                              : themeNotifier.isLight()
                          ? HexColor('#A1A1A1') : HexColor('#ffffff')
                      ),
                      SizedBox(height: height(0.006, context),),
                      Text(
                        translate(sideBarItems[index]['title'], context),
                        style: TextStyle(
                        color: index == selectedIndex
                            ? themeNotifier.isLight()
                            ? HexColor('#171717') : HexColor('#8A8A8A')
                            : themeNotifier.isLight()
                            ? HexColor('#A1A1A1') : HexColor('#ffffff')
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
