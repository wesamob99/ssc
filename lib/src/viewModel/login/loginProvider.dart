import 'package:flutter/cupertino.dart';

import '../../model/login/loginRepository.dart';

class LoginProvider extends ChangeNotifier {

  LoginRepository loginRepository = LoginRepository();
  String token = "null";

  Future login(String nationalId, String password) async{
    return await loginRepository.loginService(nationalId, password);
  }

  void notifyMe() {
    notifyListeners();
  }
}