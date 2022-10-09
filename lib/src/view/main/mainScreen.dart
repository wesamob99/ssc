// ignore_for_file: file_names

import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:ssc/infrastructure/userSecuredStorage.dart';
import 'package:ssc/src/view/home/homeScreen.dart';
import 'package:ssc/src/view/settings/settingsScreen.dart';
import 'package:ssc/utilities/theme/themes.dart';

import '../../../infrastructure/userConfig.dart';
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
  Widget build(BuildContext context) {
    ThemeNotifier themeNotifier = Provider.of<ThemeNotifier>(context);
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
    Color iconColor = Colors.white; //themeNotifier.isLight() ? HexColor('#171717') : Colors.white;
    TextStyle textStyle = TextStyle(
      fontSize: width(0.025, context),
      color: Colors.white,
    );
    return CurvedNavigationBar(
      index: pageIndex,
      backgroundColor: Colors.transparent,
      color: getPrimaryColor(context, themeNotifier), //themeNotifier.isLight() ? Colors.white : HexColor('#171717'),
      buttonBackgroundColor: getPrimaryColor(context, themeNotifier), //themeNotifier.isLight() ? Colors.white : HexColor('#171717'),
      items: <Widget>[
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: height(pageIndex != 0 ? 0.01 : 0, context),),
            SvgPicture.asset('assets/icons/bottomNavigationIcons/home.svg',
              color: iconColor, width: height(0.03, context),
            ),
            SizedBox(height: height(pageIndex != 0 ? 0.002 : 0, context),),
            pageIndex != 0
                ? Text(translate("bottomHome", context), style: textStyle,)
                : const SizedBox.shrink(),
          ],
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: height(pageIndex != 1 ? 0.01 : 0, context),),
            SvgPicture.asset('assets/icons/bottomNavigationIcons/services.svg',
              color: iconColor, width: height(0.03, context),
            ),
            SizedBox(height: height(pageIndex != 1 ? 0.002 : 0, context),),
            pageIndex != 1
                ? Text(translate("bottomServices", context), style: textStyle,)
                : const SizedBox.shrink(),
          ],
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: height(pageIndex != 2 ? 0.01 : 0, context),),
            SvgPicture.asset('assets/icons/bottomNavigationIcons/pastOrders.svg',
              color: iconColor, width: height(0.03, context),
            ),
            SizedBox(height: height(pageIndex != 2 ? 0.002 : 0, context),),
            pageIndex != 2
                ? Text(translate("bottomMyOrders", context), style: textStyle,)
                : const SizedBox.shrink(),
          ],
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: height(pageIndex != 3 ? 0.01 : 0, context),),
            SvgPicture.asset('assets/icons/bottomNavigationIcons/more.svg',
              color: iconColor, width: height(0.03, context),
          ),
          SizedBox(height: height(pageIndex != 3 ? 0.002 : 0, context),),
          pageIndex != 3
              ? Text(translate("bottomMore", context), style: textStyle,)
              : const SizedBox.shrink(),
          ],
        ),
      ],
      onTap: (index) {
        setState(() {
          pageIndex = index;
        });
        _pageController.jumpToPage(index);
      },
    );
  }

}
