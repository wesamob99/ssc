// ignore_for_file: file_names

import 'package:flutter/cupertino.dart';
import '../../../models/login/countries.dart';
import '../../../models/login/resetPasswordGetDetail.dart';
import '../../model/login/loginRepository.dart';

class LoginProvider extends ChangeNotifier {

  TextEditingController nationalIdController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  LoginRepository loginRepository = LoginRepository();
  bool enabledSubmitButton = false;
  bool enabledSendCodeButton = false;
  bool showResetPasswordBody = false;
  bool showBottomNavigationBar = true;
  int numberOfAttempts = 0;

  Future login(String nationalId, String password) async{
    final response = await loginRepository.loginService(nationalId, password);
    return response;
  }

  Future<ResetPasswordGetDetail> resetPasswordGetDetail(String userId) async{
    final response = await loginRepository.resetPasswordGetDetailService(userId);
    return response;
  }

  Future resetPasswordSendMobileOTP(String userId) async{
    final response = await loginRepository.resetPasswordSendMobileOTPService(userId);
    return response;
  }

  Future resetPasswordCheckMobileOTP(String userId, int otp) async{
    final response = await loginRepository.resetPasswordCheckMobileOTPService(userId, otp);
    return response;
  }

  Future resetPasswordSendEmailCode(String userId) async{
    final response = await loginRepository.resetPasswordSendEmailCodeService(userId);
    return response;
  }

  Future<List<Countries>> getCountries() async{
    final response = await loginRepository.getCountriesService();
    return response;
  }

  void notifyMe() {
    notifyListeners();
  }
}