import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';

import '../../../utilities/hexColor.dart';
import '../../../utilities/util.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        imageSlideShow(),
      ],
    );
  }

  imageSlideShow(){
    return ImageSlideshow(
        width: double.infinity,
        height: height(.23, context),
        initialPage: 0,
        indicatorColor: HexColor('#445740'),
        indicatorBackgroundColor: Colors.white,
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
}
