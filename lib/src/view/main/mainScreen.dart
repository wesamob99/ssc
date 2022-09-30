import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:ssc/src/view/home/homeScreen.dart';
import 'package:ssc/src/view/settings/settingsScreen.dart';

import '../../../infrastructure/userConfig.dart';
import '../../../utilities/theme/themes.dart';
import '../../../utilities/util.dart';
import '../../viewModel/utilities/theme/themeProvider.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

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
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children:[
                Text(translate('wesam', context), style: const TextStyle(fontSize: 14),),
                const Text('9991060554', style: TextStyle(fontSize: 12),),
              ],
            ),
          ],
        ),
        actions: [
          SvgPicture.asset('assets/icons/search.svg'),
          SizedBox(width: width(0.06, context)),
          SvgPicture.asset('assets/icons/location.svg'),
          SizedBox(width: width(0.06, context)),
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
            Center(
                child: Text(
                    translate(pageTitle[0], context)
                )
            ),
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
      color: getPrimaryColor(context, themeNotifier),
      buttonBackgroundColor: getPrimaryColor(context, themeNotifier),
      items: const <Widget>[
        Icon(Icons.home, size: 26, color: Colors.white),
        Icon(Icons.list, size: 26, color: Colors.white),
        Icon(Icons.refresh, size: 26, color: Colors.white),
        Icon(Icons.settings, size: 26, color: Colors.white),
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
