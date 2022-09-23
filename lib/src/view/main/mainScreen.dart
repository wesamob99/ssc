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
  int pageIndex = 2;
  List<String> pageTitle = ['profile', 'services', 'home', 'notifications', 'settings'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(translate(pageTitle[pageIndex], context)),
        centerTitle: true,
      ),
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          Center(
            child: Text(
              translate(pageTitle[0], context)
            )
          ),
          Center(
            child: Text(
              translate(pageTitle[1], context)
            )
          ),
          const HomeScreen(),
          Center(
            child: Text(
              translate(pageTitle[3], context)
            )
          ),
          const SettingsScreen(),
        ],
      ),
      bottomNavigationBar: curvedNavigationBar(),
    );
  }

  curvedNavigationBar(){
    return CurvedNavigationBar(
      index: pageIndex,
      backgroundColor: Colors.transparent,
      color: HexColor('#445740'),
      buttonBackgroundColor: HexColor('#445740'),
      items: const <Widget>[
        Icon(Icons.person, size: 30, color: Colors.white),
        Icon(Icons.list, size: 30, color: Colors.white),
        Icon(Icons.home, size: 30, color: Colors.white),
        Icon(Icons.notifications_active, size: 30, color: Colors.white),
        Icon(Icons.settings, size: 30, color: Colors.white),
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
