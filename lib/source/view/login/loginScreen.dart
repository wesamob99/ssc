// ignore_for_file: file_names, use_build_context_synchronously

import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:ssc/source/view/login/loginComponents/loginBody.dart';
import 'package:ssc/source/viewModel/login/loginProvider.dart';
import 'package:ssc/source/viewModel/utilities/theme/themeProvider.dart';

import '../../../infrastructure/userConfig.dart';
import '../../../models/login/registerData.dart';
import '../../../utilities/hexColor.dart';
import '../../../utilities/theme/themes.dart';
import '../../../utilities/util.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  LoginProvider loginProvider;
  final PageController _pageController = PageController(initialPage: 0);
  int pageIndex = 0;

  @override
  void initState() {
    UserConfig.instance.checkDataConnection();
    loginProvider = Provider.of<LoginProvider>(context, listen: false);
    /// login
    loginProvider.numberOfAttempts = 0;
    loginProvider.enabledSubmitButton = false;
    /// forgot password
    loginProvider.enabledSendCodeButton = false;
    loginProvider.enabledSubmitButton = false;
    /// register
    loginProvider.registerData = RegisterData();
    loginProvider.registerContinueEnabled = false;
    loginProvider.thirdStepSelection = ['choose', 'optionalChoose'];
    /// all
    loginProvider.isLoading = false;
    loginProvider.flag = 0;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    ThemeNotifier themeNotifier = Provider.of<ThemeNotifier>(context);

    return GestureDetector(
      onTap: (){
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(10.0),
          child: AppBar(
            backgroundColor: Colors.transparent,
          ),
        ),
        body: SizedBox(
          height: height(1, context),
          child: PageView(
            controller: _pageController,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              const LoginBody(),
              Center(
                child: Text(translate('bottomSelfServices', context)),
              ),
              Center(
                child: Text(translate('bottomTools', context)),
              ),
              Center(
                child: Text(translate('bottomMore', context)),
              ),
            ],
          ),
        ),
        bottomNavigationBar: curvedNavigationBar(themeNotifier),
      ),
    );
  }
  curvedNavigationBar(ThemeNotifier themeNotifier){
    return CurvedNavigationBar(
      index: pageIndex,
      backgroundColor: Provider.of<LoginProvider>(context).isLoading ? Colors.white70 : Colors.transparent,
      color: themeNotifier.isLight() ? Colors.white : HexColor('#171717'),
      buttonBackgroundColor: getPrimaryColor(context, themeNotifier),
      items: <Widget>[
        buildCurvedAnimationBarItem(0, 'assets/icons/loginBottomNavigationIcons/enter.svg', "bottomEnter"),
        buildCurvedAnimationBarItem(1, 'assets/icons/loginBottomNavigationIcons/selfServices.svg', "bottomSelfServices"),
        buildCurvedAnimationBarItem(2, 'assets/icons/loginBottomNavigationIcons/tools.svg', "bottomTools"),
        buildCurvedAnimationBarItem(3, 'assets/icons/mainBottomNavigationIcons/more.svg', "bottomMore"),
      ],
      onTap: (index) {
        setState(() {
          pageIndex = index;
        });
        _pageController.jumpToPage(index);
      },
    );
  }

  buildCurvedAnimationBarItem(index, icon, text){
    ThemeNotifier themeNotifier = Provider.of<ThemeNotifier>(context);
    Color iconColor = themeNotifier.isLight()
        ? (pageIndex == index ? Colors.white : getPrimaryColor(context, themeNotifier))
        : Colors.white;
    TextStyle textStyle = TextStyle(
      fontSize: height(isScreenHasSmallHeight(context) ? 0.015 : 0.011, context),
      color: themeNotifier.isLight() ? getPrimaryColor(context, themeNotifier) : Colors.white,
    );
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(height: height(pageIndex != index ? 0.01 : 0, context),),
        Padding(
          padding: const EdgeInsets.all(2.0),
          child: SvgPicture.asset(icon, color: iconColor, width: height(isScreenHasSmallHeight(context) ? 0.042 : 0.033, context)),
        ),
        pageIndex != index
            ? Text(translate(text, context), style: textStyle,)
            : const SizedBox.shrink(),
      ],
    );
  }

}
