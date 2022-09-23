import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:ssc/utilities/hexColor.dart';

import '../../../utilities/util.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  final PageController _pageController = PageController();

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
        // onPageChanged: (index){
        //
        // },
        children: [
          const Center(child: Text('page 1')),
          const Center(child: Text('page 2')),
          Column(
            children: [
              imageSlideShow(),
            ],
          ),
          const Center(child: Text('page 4')),
          const Center(child: Text('page 5')),
        ],
      ),
      bottomNavigationBar: curvedNavigationBar(),
    );
  }

  imageSlideShow(){
    return ImageSlideshow(
        width: double.infinity,
        height: height(.23, context),
        initialPage: 0,
        indicatorColor: HexColor('#445740'),
        indicatorBackgroundColor: HexColor('#b8a56b'),
        onPageChanged: (value) {
          // print('Page changed: $value');
        },
        autoPlayInterval: 3000,
        isLoop: true,
        children: [
          InkWell(
            onTap: (){},
            child: Image.asset(
              'assets/images/test_slider_images/1.jpg',
              fit: BoxFit.cover,
            ),
          ),
          InkWell(
            onTap: (){},
            child: Image.asset(
              'assets/images/test_slider_images/2.jpg',
              fit: BoxFit.cover,
            ),
          ),
          InkWell(
            onTap: (){},
            child: Image.asset(
              'assets/images/test_slider_images/3.jpg',
              fit: BoxFit.cover,
            ),
          ),
        ]
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
