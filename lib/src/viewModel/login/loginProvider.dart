// ignore_for_file: file_names

import 'package:flutter/cupertino.dart';
import '../../../models/login/resetPasswordGetDetail.dart';
import '../../model/login/loginRepository.dart';

class LoginProvider extends ChangeNotifier {

  LoginRepository loginRepository = LoginRepository();
  bool tokenUpdated = false;
  String formValid = 'null';
  List<int> errorType = [];
  String errorMessage = '';
  bool enabledSubmitButton = false;
  bool enabledSendCodeButton = false;
  bool showResetPasswordBody = false;

  Future login(String nationalId, String password) async{
    final response = await loginRepository.loginService(nationalId, password);
    return response;
  }

  Future<ResetPasswordGetDetail> resetPasswordGetDetail(String userId) async{
    final response = await loginRepository.resetPasswordGetDetailService(userId);
    return response;
  }

  void notifyMe() {
    notifyListeners();
  }
}