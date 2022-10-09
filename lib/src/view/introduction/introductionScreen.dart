// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_page_view_indicator/flutter_page_view_indicator.dart';
import 'package:provider/provider.dart';
import 'package:ssc/src/view/login/landingScreen.dart';
import 'package:ssc/utilities/util.dart';

import '../../../utilities/theme/themes.dart';
import '../../viewModel/utilities/theme/themeProvider.dart';

class IntroductionScreen extends StatefulWidget {
  const IntroductionScreen({Key key}) : super(key: key);

  @override
  State<IntroductionScreen> createState() => _IntroductionScreenState();
}

class _IntroductionScreenState extends State<IntroductionScreen> {

  final PageController _pageController = PageController();
  List<Widget> singleIntroductionScreen = [
    Container(
      color: Colors.pinkAccent,
    ),
    Container(
      color: Colors.orange,
    ),
    Container(
      color: Colors.teal,
    ),
  ];
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    ThemeNotifier themeNotifier = Provider.of<ThemeNotifier>(context);
    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: singleIntroductionScreen.length,
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding: EdgeInsets.zero,
                child: singleIntroductionScreen[index],
              );
            },
            onPageChanged: (int index) {
              setState(() {
                currentIndex = index;
              });
            },
          ),
          Container(
            alignment: Alignment.bottomCenter,
            padding: EdgeInsets.only(
              bottom: height(0.1, context)
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: (){
                    if(currentIndex != 2){
                      _pageController.jumpToPage(singleIntroductionScreen.length - 1);
                    } else{
                      _pageController.jumpToPage(0);
                    }
                  },
                  child: Text(
                    currentIndex != 2
                    ? translate('skip', context) : translate('back', context),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16
                    ),
                  ),
                ),
                PageViewIndicator(
                  length: singleIntroductionScreen.length,
                  currentIndex: currentIndex,
                  currentColor: getPrimaryColor(context, themeNotifier),
                  otherColor: Colors.white,
                ),
                GestureDetector(
                  onTap: (){
                    if(currentIndex == singleIntroductionScreen.length - 1){
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                          builder: (context) => const LandingScreen()
                        ),
                        (route) => false,
                      );
                    } else{
                      setState(() {
                        currentIndex++;
                      });
                      _pageController.jumpToPage(currentIndex);
                    }
                  },
                  child: Text(
                    currentIndex == singleIntroductionScreen.length - 1
                    ? translate('done', context) : translate('next', context),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
