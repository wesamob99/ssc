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
  bool resetContinueEnabled = false;
  TextEditingController resetPasswordController = TextEditingController();
  TextEditingController resetConfirmPasswordController = TextEditingController();

  /// register ***
  RegisterData registerData = RegisterData();
  TextEditingController mobileNumberController = TextEditingController();
  TextEditingController registerNationalIdController = TextEditingController();
  TextEditingController civilIdNumberController = TextEditingController();
  TextEditingController relativeNatIdController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController registerPasswordController = TextEditingController();
  TextEditingController registerConfirmPasswordController = TextEditingController();
  // at index 0 -> relative type | index 1 -> academic level
  List thirdStepSelection = ['choose', 'optionalChoose'];
  bool registerContinueEnabled = false;
  bool obscurePassword = false;

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

  Future getEncryptedPasswordService(String password) async {
    final response = await loginRepository.getEncryptedPasswordService(password);
    return response;
  }

  Future<List<Countries>> getCountries() async{
    final response = await loginRepository.getCountriesService();
    return response;
  }

  void notifyMe() {
    notifyListeners();
  }


  clearLoginData(){
    passwordController.clear();
    numberOfAttempts = 0;
    nationalIdController.clear();
    enabledSubmitButton = false;
    notifyMe();
  }

  clearForgotPasswordData(){
    enabledSendCodeButton = false;
    nationalIdController.clear();
    resetPasswordController.clear();
    resetConfirmPasswordController.clear();
    enabledSubmitButton = false;
    resetContinueEnabled = false;
    notifyMe();
  }

  clearRegisterData(){
    registerData = RegisterData();
    mobileNumberController.clear();
    registerNationalIdController.clear();
    civilIdNumberController.clear();
    relativeNatIdController.clear();
    emailController.clear();
    registerPasswordController.clear();
    registerConfirmPasswordController.clear();
    registerContinueEnabled = false;
    obscurePassword = false;
    thirdStepSelection = ['choose', 'optionalChoose'];
    notifyMe();
  }
}