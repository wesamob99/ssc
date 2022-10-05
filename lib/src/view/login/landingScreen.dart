import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ssc/infrastructure/userSecuredStorage.dart';
import 'package:ssc/src/view/main/mainScreen.dart';
import 'package:ssc/src/viewModel/login/loginProvider.dart';

import 'loginScreen.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({Key? key}) : super(key: key);

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  @override
  Widget build(BuildContext context) {
    UserSecuredStorage userSecuredStorage = UserSecuredStorage.instance;
    if(Provider.of<LoginProvider>(context).tokenUpdated){
      setState(() {});
      Provider.of<LoginProvider>(context, listen: false).tokenUpdated = false;
    }

    return (userSecuredStorage.token.isEmpty ||
    userSecuredStorage.nationalId.isEmpty ||
    userSecuredStorage.internalKey.isEmpty)
        ? const LoginScreen()
        : const MainScreen();
  }
}