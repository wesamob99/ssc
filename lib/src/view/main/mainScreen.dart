import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ssc/src/view/home/homeScreen.dart';
import 'package:ssc/src/view/settings/settingsScreen.dart';
import 'package:ssc/utilities/hexColor.dart';

import '../../../utilities/util.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  final PageController _pageController = PageController(initialPage: 2);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(translate('home', context)),
        centerTitle: true,
      ),
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: const [
          Center(child: Text('page 1')),
          Center(child: Text('page 2')),
          HomeScreen(),
          Center(child: Text('page 4')),
          SettingsScreen(),
        ],
      ),
      bottomNavigationBar: curvedNavigationBar(),
    );
  }

  curvedNavigationBar(){
    return CurvedNavigationBar(
      index: 2,
      backgroundColor: Colors.transparent,
      color: HexColor('#445740'),
      buttonBackgroundColor: HexColor('#445740'),
      items: const <Widget>[
        Icon(Icons.compare_arrows, size: 30, color: Colors.white),
        Icon(Icons.list, size: 30, color: Colors.white),
        Icon(Icons.home, size: 30, color: Colors.white),
        Icon(Icons.add_alert, size: 30, color: Colors.white),
        Icon(Icons.settings, size: 30, color: Colors.white),
      ],
      onTap: (index) {
        _pageController.jumpToPage(index);
      },
    );
  }

}
