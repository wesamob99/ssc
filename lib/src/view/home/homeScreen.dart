import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:ssc/utilities/hexColor.dart';

import '../../../utilities/util.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(translate('home', context)),
        centerTitle: true,
      ),
      body: Column(
        children: [
          imageSlideShow(),
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
        indicatorColor: Colors.blue,
        indicatorBackgroundColor: Colors.grey,
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
      backgroundColor: Colors.transparent,
      color: HexColor('#445740'),
      buttonBackgroundColor: HexColor('#445740'),
      items: const <Widget>[
        Icon(Icons.home, size: 30, color: Colors.white),
        Icon(Icons.list, size: 30, color: Colors.white),
        Icon(Icons.compare_arrows, size: 30, color: Colors.white),
        Icon(Icons.add_alert, size: 30, color: Colors.white),
        Icon(Icons.settings, size: 30, color: Colors.white),
      ],
      onTap: (index) {
        //Handle button tap
      },
    );
  }

}
