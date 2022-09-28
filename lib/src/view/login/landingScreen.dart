import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ssc/src/view/main/mainScreen.dart';
import 'package:ssc/src/viewModel/login/loginProvider.dart';

import 'loginScreen.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    LoginProvider loginProvider = Provider.of<LoginProvider>(context);

    return loginProvider.token == "null" ? const LoginScreen() : const MainScreen();
  }
}