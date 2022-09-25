import 'package:flutter/material.dart';
import 'package:flutter_page_view_indicator/flutter_page_view_indicator.dart';
import 'package:provider/provider.dart';
import 'package:ssc/utilities/util.dart';

import '../../../utilities/theme/themes.dart';
import '../../viewModel/utilities/theme/themeProvider.dart';
import '../main/mainScreen.dart';

class IntroductionScreen extends StatefulWidget {
  const IntroductionScreen({Key? key}) : super(key: key);

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
          Transform.translate(
            offset: const Offset(0, 750),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: (){
                    _pageController.jumpToPage(singleIntroductionScreen.length - 1);
                  },
                  child: Text(
                    translate('skip', context),
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
                          builder: (context) => const MainScreen()
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
