// ignore_for_file: file_names, use_build_context_synchronously

import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:local_auth/local_auth.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ssc/infrastructure/userSecuredStorage.dart';
import 'package:ssc/source/view/home/homeScreen.dart';
import 'package:ssc/source/view/settings/settingsScreen.dart';
import 'package:ssc/utilities/theme/themes.dart';

import '../../../infrastructure/userConfig.dart';
import '../../../utilities/constants.dart';
import '../../../utilities/hexColor.dart';
import '../../../utilities/util.dart';
import '../../viewModel/utilities/theme/themeProvider.dart';
import '../accountSettings/accountSettingsScreen.dart';
import '../services/servicesScreen.dart';
import 'mainAppBarScreens/searchScreen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  final LocalAuthentication authentication = LocalAuthentication();
  bool supportState = false;
  String authorized = 'Not Authorized';
  bool isAuthenticating = false;
  ThemeNotifier themeNotifier;
  UserSecuredStorage userSecuredStorage = UserSecuredStorage.instance;
  Future<SharedPreferences> prefs = SharedPreferences.getInstance();
  final PageController _pageController = PageController(initialPage: 0);
  int pageIndex = 0;
  List<String> pageTitle = ['services', 'home', 'pastOrders', 'settings'];
  String firstLogin = 'true';


  @override
  void initState() {
    themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);
    UserConfig.instance.checkDataConnection();

    //check whether there is local authentication available on this device or not
    // authentication.canCheckBiometrics.then((bool isSupported){
    //   // TODO: *** Login Suggestion ***
    //   showLoginSuggestion(themeNotifier, isSupported);
    // });

    super.initState();
  }

  //authenticate() method uses biometric authentication
  Future<void> _authenticate() async{
    bool authenticated = false;
    try{
      setState(() {
        isAuthenticating = true;
        authorized = 'Authenticating';
      });

      authenticated = await authentication.authenticate(
        localizedReason: 'Let OS determine authentication method',
        options: const AuthenticationOptions(
          stickyAuth: true, biometricOnly: true
        )
      );
      if (authenticated) {
        showMyDialog(
            context,
            'fingerprintActivated',
            getTranslated('fingerprintActivatedDesc', context),
            'ok',
            themeNotifier,
            titleColor: '#363636',
            icon: 'assets/icons/fingerprint.svg'
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Face ID authentication failed.'),
          ),
        );
      }
      setState(() {
        isAuthenticating = false;
      });
    } on PlatformException catch(e){
      setState(() {
        isAuthenticating = false;
        authorized = 'Error - ${e.message}';
      });
      return;
    }
    if(!mounted){
      return;
    }
    setState(() => authorized = authenticated ? "Authorized" : "Not authorized");
  }

  showLoginSuggestion(themeNotifier, bool supportState){
    prefs.then((value) {
      firstLogin = value.getString(Constants.FIRST_LOGIN) ?? 'true';
      if(firstLogin == 'true') {
        SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
          loginSuggestionsModalBottomSheet(context, themeNotifier, supportState, (){
            _authenticate();
            Navigator.of(context).pop();
            Navigator.of(context).pop();
          });
        });
      }
    });
  }

  void didChangeAppLifecycleState(AppLifecycleState state) async{
    if(state == AppLifecycleState.resumed){
      UserConfig.instance.checkDataConnection();
    } else if(state == AppLifecycleState.inactive ||
        state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached){
      if(UserConfig.instance.networkListener != null){
        await UserConfig.instance.networkListener.cancel();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    ThemeNotifier themeNotifier = Provider.of<ThemeNotifier>(context);
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 5,
        centerTitle: false,
        title: InkWell(
          onTap: (){
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const AccountSettingsScreen())
            );
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5.0),
            child: userSecuredStorage.insuranceNumber.isNotEmpty
            ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children:[
                Text(userSecuredStorage.userName, style: const TextStyle(fontSize: 14),),
                const SizedBox(height: 2.0),
                Text(userSecuredStorage.insuranceNumber, style: const TextStyle(fontSize: 12),),
              ],
            ) : Text(userSecuredStorage.userName, style: const TextStyle(fontSize: 14),),
          ),
        ),
        actions: [
          InkWell(
            onTap: (){
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const SearchScreen())
              );
            },
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: width(0.025, context)),
              child: SvgPicture.asset('assets/icons/search.svg'),
            ),
          ),
          InkWell(
            onTap: (){},
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: width(0.025, context)),
              child: SvgPicture.asset('assets/icons/location.svg'),
            ),
          ),
          InkWell(
            onTap: (){},
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: width(0.025, context)),
              child: SvgPicture.asset('assets/icons/notifications.svg'),
            ),
          ),
          SizedBox(width: width(0.05, context),)
        ],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(UserConfig.instance.isLanguageEnglish() ?  0 : 50),
            bottomRight: Radius.circular(UserConfig.instance.isLanguageEnglish() ?  50 : 0)
          )
        ),
      ),
      body: Container(
        margin: EdgeInsets.only(top: height(0.004, context)),
        child: PageView(
          controller: _pageController,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            const HomeScreen(),
            // ignore: prefer_const_constructors
            ServicesScreen(),
            Center(
              child: Text(
                getTranslated(pageTitle[2], context)
              )
            ),
            const SettingsScreen(),
          ],
        ),
      ),
      bottomNavigationBar: curvedNavigationBar(themeNotifier),
    );
  }

  curvedNavigationBar(ThemeNotifier themeNotifier){
    return Material(
      elevation: 50,
      child: CurvedNavigationBar(
        index: pageIndex,
        backgroundColor: themeNotifier.isLight() ? const Color.fromRGBO(250, 250, 250, 1.0) : HexColor('#212121'),
        color: themeNotifier.isLight() ? Colors.white : HexColor('#171717'),
        buttonBackgroundColor: getPrimaryColor(context, themeNotifier),
        items: <Widget>[
          buildCurvedAnimationBarItem(0, 'assets/icons/mainBottomNavigationIcons/home.svg', "bottomHome"),
          buildCurvedAnimationBarItem(1, 'assets/icons/mainBottomNavigationIcons/services.svg', "bottomServices"),
          buildCurvedAnimationBarItem(2, 'assets/icons/mainBottomNavigationIcons/pastOrders.svg', "bottomMyOrders"),
          buildCurvedAnimationBarItem(3, 'assets/icons/mainBottomNavigationIcons/more.svg', "bottomMore"),
        ],
        onTap: (index) {
          setState(() {
            pageIndex = index;
          });
          _pageController.jumpToPage(index);
        },
      ),
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
          child: SvgPicture.asset(icon, color: iconColor, width: height(isScreenHasSmallHeight(context) ? 0.042 : 0.033, context),),
        ),
        pageIndex != index
            ? Text(getTranslated(text, context), style: textStyle,)
            : const SizedBox.shrink(),
      ],
    );
  }
}