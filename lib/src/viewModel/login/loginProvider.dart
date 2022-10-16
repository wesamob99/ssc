// ignore_for_file: file_names

import 'package:flutter/cupertino.dart';
import 'package:ssc/models/login/registerData.dart';
import '../../../models/login/countries.dart';
import '../../../models/login/resetPasswordGetDetail.dart';
import '../../model/login/loginRepository.dart';

class LoginProvider extends ChangeNotifier {

  LoginRepository loginRepository = LoginRepository();

  /// login ***
  TextEditingController passwordController = TextEditingController();
  int numberOfAttempts = 0;

  /// forgot password ***
  bool enabledSendCodeButton = false;

  /// register ***
  RegisterData registerData = RegisterData();
  TextEditingController mobileNumberController = TextEditingController();
  TextEditingController registerNationalIdController = TextEditingController();
  TextEditingController civilIdNumberController = TextEditingController();
  TextEditingController relativeNatIdController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController registerPasswordController = TextEditingController();
  TextEditingController registerVerifyPasswordController = TextEditingController();
  bool registerContinueEnabled = false;
  int stepNumber = 1;

  /// login | forgot password
  TextEditingController nationalIdController = TextEditingController();
  bool enabledSubmitButton = false;


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


  clearLoginDate(){
    passwordController.clear();
    numberOfAttempts = 0;
    notifyMe();
  }

  clearForgotPasswordDate(){
    enabledSendCodeButton = false;

    notifyMe();
  }

  clearRegisterDate(){
    mobileNumberController.clear();
    registerNationalIdController.clear();
    civilIdNumberController.clear();
    relativeNatIdController.clear();
    emailController.clear();
    registerPasswordController.clear();
    registerVerifyPasswordController.clear();

    registerContinueEnabled = false;
    stepNumber = 1;
    notifyMe();
  }
}