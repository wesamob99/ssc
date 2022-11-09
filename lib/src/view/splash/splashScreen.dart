// ignore_for_file: file_names, use_build_context_synchronously

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dialogs/flutter_dialogs.dart';
import 'package:flutter_svg/svg.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:provider/provider.dart';
import 'package:ssc/infrastructure/userSecuredStorage.dart';
import 'package:ssc/src/view/login/loginScreen.dart';
import 'package:ssc/src/view/main/mainScreen.dart';
import 'package:ssc/src/viewModel/home/homeProvider.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:ssc/utilities/hexColor.dart';

import '../../../models/home/payOffFinancialInformations.dart';
import '../../../utilities/util.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    // checkDataConnection();
    super.initState();
  }

  checkDataConnection() async{
    InternetConnectionChecker().onStatusChange.listen((event) async{
      checkDataConnection();
    });

    InternetConnectionStatus connection = await InternetConnectionChecker().connectionStatus;
    PayOffFinancialInformation result;
    // result = await Provider.of<HomeProvider>(context, listen: false).getStatistics();
    try{
    result = await Provider.of<HomeProvider>(context, listen: false).getAmountToBePaid();
    }catch(e){
      if (kDebugMode) {
        print(e.toString());
      }
    }
    if(InternetConnectionStatus.connected == connection){
      Widget screen = const LoginScreen();
      if(UserSecuredStorage.instance.token.isNotEmpty &&
          UserSecuredStorage.instance.nationalId.isNotEmpty &&
          (result != null && result.success != false)
      ){
        screen = const MainScreen();
      } else{
        screen = const LoginScreen();
        UserSecuredStorage.instance.token = '';
      }
      if (!mounted) return;
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => screen), (route) => false);
    }else if(InternetConnectionStatus.disconnected == connection){
      if (!mounted) return;
      _showAlert(context);
    }
  }

  _showAlert(BuildContext context){
    showPlatformDialog(
      context: context,
      builder: (_) => BasicDialogAlert(
        title: Text(
          translate('networkError', context)
        ),
        content: Text(
          translate('networkErrorDescription', context)
        ),
        actions: [
          BasicDialogAction(
            title: Text(translate('ok', context)),
            onPressed: (){
              Navigator.of(context).pop();
            },
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarBrightness: Brightness.dark
      ),
    );
    return Scaffold(
      body: Center(
        child: Stack(
          children: [
            Opacity(
              opacity: 0.5,
              child: Container(
                alignment: Alignment.bottomLeft,
                child: SvgPicture.asset(
                    'assets/logo/logo_tree.svg'
                ),
              ),
            ),
            SizedBox(
              width: width(1, context),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SvgPicture.asset('assets/logo/logo_with_name.svg', width: width(0.65, context)),
                  SizedBox(height: height(0.1, context),),
                  SizedBox(
                    width: width(isTablet(context) ? 0.3 : 0.5, context),
                    height: width(isTablet(context) ? 0.3 : 0.5, context),
                    child: LoadingIndicator(
                        indicatorType: Indicator.ballSpinFadeLoader, /// Required, The loading type of the widget
                        colors: [
                          HexColor('#445740').withOpacity(0.8), HexColor('#946800').withOpacity(0.8), HexColor('#445740').withOpacity(0.7), HexColor('#946800').withOpacity(0.7),
                          HexColor('#445740').withOpacity(0.6), HexColor('#946800').withOpacity(0.6), HexColor('#445740').withOpacity(0.5), HexColor('#946800').withOpacity(0.5)
                        ],
                        backgroundColor: Colors.transparent,      /// Optional, Background of the widget
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
