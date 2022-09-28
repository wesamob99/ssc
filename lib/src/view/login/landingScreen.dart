import 'package:flutter/material.dart';
import 'package:ssc/infrastructure/userSecuredStorage.dart';
import 'package:ssc/src/view/main/mainScreen.dart';

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
    print(userSecuredStorage.token);
    return userSecuredStorage.token == ""
        ? const LoginScreen()
        : const MainScreen();
  }
}