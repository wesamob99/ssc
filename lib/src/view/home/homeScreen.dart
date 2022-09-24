import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';

import '../../../utilities/theme/themes.dart';
import '../../../utilities/util.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  List<String> images = [
    'assets/images/test_slider_images/1.jpg',
    'assets/images/test_slider_images/2.jpg',
    'assets/images/test_slider_images/3.jpg',
  ];

  @override
  Widget build(BuildContext context) {

    List<Widget> ads = [];
    for(int i=0 ; i<images.length ; i++){
      ads.add(
        InkWell(
          onTap: (){},
          child: Image.asset(
            images[i],
            fit: BoxFit.cover,
          ),
        ),
      );
    }

    return Column(
      children: [
        imageSlideShow(ads),
      ],
    );
  }

  imageSlideShow(List<Widget> children){
    return ImageSlideshow(
        width: double.infinity,
        height: height(.23, context),
        initialPage: 0,
        indicatorColor: getSSCColor(context),
        indicatorBackgroundColor: Colors.white,
        onPageChanged: (value) {
          // print('Page changed: $value');
        },
        autoPlayInterval: 3000,
        isLoop: true,
        children: children
    );
  }
}
