// ignore_for_file: file_names

import 'package:flutter/material.dart';
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
        InkWell(
          onTap: () {},
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

    return SizedBox(
      height: height(.16, context),
      child: ListView.builder(
        itemCount: ads.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index){
          return InkWell(
            onTap: (){},
            child: Row(
              children: [
                Container(
                  width: width(0.8, context),
                  decoration: BoxDecoration(
                    color: getPrimaryColor(context, themeNotifier).withOpacity(0.3),
                    borderRadius: BorderRadius.circular(6.0)
                  ),
                  child: ads[index],
                ),
                SizedBox(width: width(index != ads.length-1 ? 0.04 : 0, context))
              ],
            ),
          );
        }
      ),
    );
  }
}
