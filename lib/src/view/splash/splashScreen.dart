// ignore_for_file: file_names, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dialogs/flutter_dialogs.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:ssc/infrastructure/userSecuredStorage.dart';
import 'package:ssc/src/view/login/loginScreen.dart';
import 'package:ssc/src/view/main/mainScreen.dart';

import '../../../utilities/util.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    checkDataConnection();
    super.initState();
  }

  checkDataConnection() async{
    InternetConnectionChecker().onStatusChange.listen((event) async{
      checkDataConnection();
    });

    InternetConnectionStatus connection = await InternetConnectionChecker().connectionStatus;
    if(InternetConnectionStatus.connected == connection){
      Widget screen = const LoginScreen();
      if(UserSecuredStorage.instance.token.isNotEmpty &&
          UserSecuredStorage.instance.nationalId.isNotEmpty){
        screen = const MainScreen();
      } else{
        screen = const LoginScreen();
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('splash screen'),
            SizedBox(height: height(0.1, context),),
            const CircularProgressIndicator()
          ],
        ),
      ),
    );
  }
}
