// ignore_for_file: file_names

import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:ssc/infrastructure/userSecuredStorage.dart';
import 'package:ssc/src/view/home/homeScreen.dart';
import 'package:ssc/src/view/settings/settingsScreen.dart';
import 'package:ssc/utilities/theme/themes.dart';

import '../../../infrastructure/userConfig.dart';
import '../../../utilities/hexColor.dart';
import '../../../utilities/util.dart';
import '../../viewModel/utilities/theme/themeProvider.dart';
import '../profile/profileScreen.dart';
import '../services/servicesScreen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  UserSecuredStorage userSecuredStorage = UserSecuredStorage.instance;
  final PageController _pageController = PageController(initialPage: 0);
  int pageIndex = 0;
  List<String> pageTitle = ['services', 'home', 'pastOrders', 'settings'];


  @override
  void initState() {
    UserConfig.instance.checkDataConnection();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    ThemeNotifier themeNotifier = Provider.of<ThemeNotifier>(context);
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      modalBottomSheet(context, themeNotifier);
    });
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 5,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: Colors.transparent,
              child: SvgPicture.asset('assets/logo/logo.svg'),
            ),
            SizedBox(width: width(0.01, context)),
            InkWell(
              onTap: (){
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const ProfileScreen())
                );
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children:[
                  Text(userSecuredStorage.userName, style: const TextStyle(fontSize: 14),),
                  Text(userSecuredStorage.nationalId, style: const TextStyle(fontSize: 12),),
                ],
              ),
            ),
          ],
        ),
        actions: [
          SvgPicture.asset('assets/icons/search.svg'),
          SizedBox(width: width(0.05, context)),
          SvgPicture.asset('assets/icons/location.svg'),
          SizedBox(width: width(0.05, context)),
          SvgPicture.asset('assets/icons/notifications.svg'),
          SizedBox(width: width(0.08, context)),
        ],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(UserConfig.instance.checkLanguage() ?  0 : 50),
            bottomRight: Radius.circular(UserConfig.instance.checkLanguage() ?  50 : 0)
          )
        ),
      ),
      body: Container(
        margin: EdgeInsets.only(top: height(0.004, context)),
        child: PageView(
          controller: _pageController,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            const HomeScreen(),
            const ServicesScreen(),
            Center(
              child: Text(
                translate(pageTitle[2], context)
              )
            ),
            const SettingsScreen(),
          ],
        ),
      ),
      bottomNavigationBar: curvedNavigationBar(themeNotifier),
    );
  }

  curvedNavigationBar(ThemeNotifier themeNotifier){
    return CurvedNavigationBar(
      index: pageIndex,
      backgroundColor: Colors.transparent,
      color: themeNotifier.isLight() ? Colors.white : HexColor('#171717'),
      buttonBackgroundColor: getPrimaryColor(context, themeNotifier),
      items: <Widget>[
        buildCurvedAnimationBarItem(0, 'assets/icons/mainBottomNavigationIcons/home.svg', "bottomHome"),
        buildCurvedAnimationBarItem(1, 'assets/icons/mainBottomNavigationIcons/services.svg', "bottomServices"),
        buildCurvedAnimationBarItem(2, 'assets/icons/mainBottomNavigationIcons/pastOrders.svg', "bottomMyOrders"),
        buildCurvedAnimationBarItem(3, 'assets/icons/mainBottomNavigationIcons/more.svg', "bottomMore"),
      ],
      onTap: (index) {
        setState(() {
          pageIndex = index;
        });
        _pageController.jumpToPage(index);
      },
    );
  }

  buildCurvedAnimationBarItem(index, icon, text){
    ThemeNotifier themeNotifier = Provider.of<ThemeNotifier>(context);
    Color iconColor = themeNotifier.isLight()
    ? (pageIndex == index ? Colors.white : getPrimaryColor(context, themeNotifier))
    : Colors.white;
    TextStyle textStyle = TextStyle(
      fontSize: width(0.023, context),
      color: themeNotifier.isLight() ? getPrimaryColor(context, themeNotifier) : Colors.white,
    );
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(height: height(pageIndex != index ? 0.01 : 0, context),),
        SvgPicture.asset(icon, color: iconColor, width: height(0.03, context),),
        SizedBox(height: height(pageIndex != index ? 0.002 : 0, context),),
        pageIndex != index
            ? Text(translate(text, context), style: textStyle,)
            : const SizedBox.shrink(),
      ],
    );
  }
}
