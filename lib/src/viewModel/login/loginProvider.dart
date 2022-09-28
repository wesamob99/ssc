import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:ssc/infrastructure/userSecuredStorage.dart';

import '../../model/login/loginRepository.dart';

class LoginProvider extends ChangeNotifier {

  LoginRepository loginRepository = LoginRepository();
  UserSecuredStorage userSecuredStorage = UserSecuredStorage.instance;
  bool tokenUpdated = false;

  Future login(String nationalId, String password) async{
    final response = await loginRepository.loginService(nationalId, password);
    var data = jsonDecode(response.data);
    return data["token"];
  }

  void notifyMe() {
    notifyListeners();
  }
}