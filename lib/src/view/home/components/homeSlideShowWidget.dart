// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:provider/provider.dart';

import '../../../../utilities/theme/themes.dart';
import '../../../../utilities/util.dart';
import '../../../viewModel/utilities/theme/themeProvider.dart';

class HomeSlideShowWidget extends StatelessWidget {
  const HomeSlideShowWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeNotifier themeNotifier = Provider.of<ThemeNotifier>(context);
    List<String> images = [
      'assets/images/test_slider_images/1.jpg',
      'assets/images/test_slider_images/2.jpg',
      'assets/images/test_slider_images/3.jpg',
    ];
    List<Widget> ads = [];
    for (int i = 0; i < images.length; i++) {
      ads.add(
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(6.0),
            child: Image.asset(
              images[i],
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) {
                return Center(
                  child: CircularProgressIndicator(
                    color: getPrimaryColor(context, themeNotifier),
                  ),
                );
              },
            ),
          ),
        ),
      );
    }

    return ImageSlideshow(
      width: double.infinity,
      height: height(isTablet(context) ? 0.2 : 0.18, context),
      initialPage: 0,
      indicatorColor: primaryColor,
      indicatorBackgroundColor: Colors.white,
      onPageChanged: (value) {},
      autoPlayInterval: 3500,
      isLoop: true,
      children: ads,
    );
  }
}
