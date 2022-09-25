import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:provider/provider.dart';

import '../../../utilities/theme/themes.dart';
import '../../../utilities/util.dart';
import '../../viewModel/utilities/theme/themeProvider.dart';

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

    ThemeNotifier themeNotifier = Provider.of<ThemeNotifier>(context);

    List<Widget> ads = [];
    for(int i=0 ; i<images.length ; i++){
      ads.add(
        InkWell(
          onTap: (){},
          child: Image.asset(
            images[i],
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___){
              return const Icon(
                Icons.error_outline,
                color: Colors.red,
                size: 36,
              );
            },
          ),
        ),
      );
    }

    return Column(
      children: [
        imageSlideShow(ads, themeNotifier),
        SizedBox(height: height(0.02, context),),
        Expanded(
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              mainAxisSpacing: 5,
              crossAxisSpacing: 5
            ),
            itemCount: 8,
            itemBuilder: (context, index){
              return SizedBox(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: width(0.09, context),
                      backgroundColor: themeNotifier.isLight()
                        ? getGrey2Color(context)
                        : getContainerColor(context),
                      child: Icon(
                        Icons.miscellaneous_services,
                        color: getPrimaryColor(context, themeNotifier),
                      ),
                    ),
                    Text('data #$index')
                  ],
                ),
              );
            },
          ),
        )
      ],
    );
  }

  imageSlideShow(List<Widget> children, ThemeNotifier themeNotifier){
    return ImageSlideshow(
        width: double.infinity,
        height: height(.28, context),
        initialPage: 0,
        indicatorColor: getPrimaryColor(context, themeNotifier),
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
