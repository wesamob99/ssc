import 'package:flutter/cupertino.dart';

import '../../model/login/loginRepository.dart';

class LoginProvider extends ChangeNotifier {

  LoginRepository loginRepository = LoginRepository();

  Future login() async{
    return await loginRepository.loginService('200', 'abcd@1234');
  }

  void notifyMe() {
    notifyListeners();
  }
}