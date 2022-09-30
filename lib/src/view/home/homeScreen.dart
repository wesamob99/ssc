import 'package:ai_progress/ai_progress.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:provider/provider.dart';
import 'package:ssc/utilities/hexColor.dart';

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
    for (int i = 0; i < images.length; i++) {
      ads.add(
        InkWell(
          onTap: () {},
          child: Image.asset(
            images[i],
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) {
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

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0).copyWith(top: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(translate('overview', context)),
          ),
          SizedBox(
            width: width(1, context),
            height: height(0.16, context),
            child: Row(
              children: [
                SizedBox(
                  width: width(0.35, context),
                  child: Column(
                    children: [
                      Flexible(
                        child: Material(
                          elevation: 0.7,
                          borderRadius: BorderRadius.circular(14),
                          child: Container(
                            width: width(0.35, context),
                            decoration: BoxDecoration(
                              color: getContainerColor(context),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(translate('subscriptions', context),
                                    style: TextStyle(
                                        fontSize: width(0.03, context))),
                                SizedBox(
                                  height: height(0.002, context),
                                ),
                                Text(
                                  '40',
                                  style: TextStyle(
                                      color: HexColor('#37662D'),
                                      fontWeight: FontWeight.bold,
                                      fontSize: width(0.03, context)),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: height(0.005, context),
                      ),
                      Flexible(
                        child: Material(
                          elevation: 0.7,
                          borderRadius: BorderRadius.circular(14),
                          child: Container(
                            width: width(0.35, context),
                            decoration: BoxDecoration(
                              color: getContainerColor(context),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(translate('idleBalance', context),
                                    style: TextStyle(
                                        fontSize: width(0.03, context))),
                                SizedBox(
                                  height: height(0.002, context),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      '455-',
                                      style: TextStyle(
                                          color: HexColor('#BC0D0D'),
                                          fontWeight: FontWeight.bold,
                                          fontSize: width(0.03, context)),
                                    ),
                                    Text(
                                      translate('jd', context),
                                      style: TextStyle(
                                          color: themeNotifier.isLight()
                                              ? Colors.black
                                              : Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: width(0.03, context)),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  width: width(0.015, context),
                ),
                Expanded(
                  child: Material(
                    elevation: 0.7,
                    borderRadius: BorderRadius.circular(14),
                    child: Container(
                      decoration: BoxDecoration(
                        color: getContainerColor(context),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: width(0.03, context)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text('شركة القواسمي وشركاة',
                                style:
                                    TextStyle(fontSize: width(0.03, context))),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('الأجر الخاضع للضمان',
                                    style: TextStyle(
                                        fontSize: width(0.03, context))),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      '1400',
                                      style: TextStyle(
                                          color: HexColor('#37662D'),
                                          fontWeight: FontWeight.bold,
                                          fontSize: width(0.03, context)),
                                    ),
                                    Text(
                                      translate('jd', context),
                                      style: TextStyle(
                                          color: themeNotifier.isLight()
                                              ? Colors.black
                                              : Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: width(0.03, context)),
                                    ),
                                  ],
                                )
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('قيمة الإقتطاع',
                                    style: TextStyle(
                                        fontSize: width(0.03, context))),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      '105',
                                      style: TextStyle(
                                          color: HexColor('#BE8703'),
                                          fontWeight: FontWeight.bold,
                                          fontSize: width(0.03, context)),
                                    ),
                                    Text(
                                      translate('jd', context),
                                      style: TextStyle(
                                          color: themeNotifier.isLight()
                                              ? Colors.black
                                              : Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: width(0.03, context)),
                                    ),
                                  ],
                                )
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('تاريخ آخر دفعه',
                                    style: TextStyle(
                                        fontSize: width(0.03, context))),
                                Text('22/7/2022',
                                    style: TextStyle(
                                        fontSize: width(0.03, context))),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: height(0.01, context),
          ),
          SizedBox(
            width: width(1, context),
            child: Row(
              children: [
                Expanded(
                  child: Material(
                    elevation: 0.7,
                    borderRadius: BorderRadius.circular(14),
                    child: Container(
                      decoration: BoxDecoration(
                        color: getContainerColor(context),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: width(0.03, context),
                          vertical: width(0.01, context),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              'عدد الإشتراكات المتبقية لإستحقاق التقاعد',
                              style: TextStyle(fontSize: width(0.03, context)),
                            ),
                            SizedBox(
                              width: width(1, context),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    '300/40',
                                    style: TextStyle(
                                        fontSize: width(0.025, context)),
                                  ),
                                  Container(
                                    width: width(1, context),
                                    height: 15,
                                    padding: const EdgeInsets.all(5),
                                    child: AirLinearStateProgressIndicator(
                                      size: const Size(0, 0),
                                      value: 40,
                                      valueColor: HexColor('#2D452E'),
                                      pathColor: HexColor('#EAEAEA'),
                                      pathStrokeWidth: height(0.008, context),
                                      valueStrokeWidth: height(0.008, context),
                                      roundCap: true,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: height(0.015, context),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(translate('circularsAdvertisements', context)),
          ),
          imageSlideShow(ads, themeNotifier),
          SizedBox(
            height: height(0.015, context),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(translate('pastYearsPays', context)),
          ),
        ],
      ),
    );
  }

  imageSlideShow(List<Widget> children, ThemeNotifier themeNotifier) {
    return ImageSlideshow(
        width: double.infinity,
        height: height(.22, context),
        initialPage: 0,
        indicatorColor: getPrimaryColor(context, themeNotifier),
        indicatorBackgroundColor: Colors.white,
        onPageChanged: (value) {
          // print('Page changed: $value');
        },
        autoPlayInterval: 3000,
        isLoop: true,
        children: children);
  }
}
