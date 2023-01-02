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

import '../../../models/home/payOffFinancialInformations.dart';
import '../../../utilities/hexColor.dart';
import '../../../utilities/util.dart';
import '../../viewModel/services/servicesProvider.dart';
import '../../viewModel/utilities/theme/themeProvider.dart';

class SplashScreen extends StatefulWidget {
  final bool fromMain;
  const SplashScreen({Key key, this.fromMain = false}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    Provider.of<ServicesProvider>(context, listen: false).readCountriesJson();
    Future.delayed(Duration(milliseconds: widget.fromMain ? 2000 : 1500), (){
      checkDataConnection();
    });
    super.initState();
  }

  checkDataConnection() async{
    InternetConnectionChecker().onStatusChange.listen((event) async{
      checkDataConnection();
    });

    InternetConnectionStatus connection = await InternetConnectionChecker().connectionStatus;
    PayOffFinancialInformation result;
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
          translate('networkError', context),
          style: const TextStyle(
            fontWeight: FontWeight.w500
          ),
        ),
        content: Text(
          translate('networkErrorDescription', context)
        ),
        actions: [
          BasicDialogAction(
            title: Text(translate('ok', context)),
            onPressed: (){
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (context) => const LoginScreen(),
                  ), (route) => false
              );
            },
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ThemeNotifier themeNotifier = Provider.of<ThemeNotifier>(context);

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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset('assets/logo/logo.svg', width: 70),
                      const SizedBox(width: 10.0),
                      SvgPicture.asset(
                        'assets/logo/name.svg',
                        width: 230,
                        color: themeNotifier.isLight()
                            ? HexColor('#51504E')
                            : HexColor('ffffff'),
                      ),
                    ],
                  ),
                  // Image.asset('assets/logo/logo_with_name.png', width: width(isTablet(context) ? 0.42 : 0.62, context),),
                  SizedBox(height: height(0.1, context),),
                  loadingIndicator(context, themeNotifier),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
