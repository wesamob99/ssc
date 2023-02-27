// ignore_for_file: file_names

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
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
  bool resetObscurePassword = true;
  TextEditingController resetPasswordController = TextEditingController();
  TextEditingController resetConfirmPasswordController = TextEditingController();

  /// register ***
  RegisterData registerData = RegisterData();
  TextEditingController jordanianMobileNumberController = TextEditingController();
  TextEditingController foreignMobileNumberController = TextEditingController();
  TextEditingController registerNationalIdController = TextEditingController();
  TextEditingController civilIdNumberController = TextEditingController();
  TextEditingController relativeNatIdController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController registerPasswordController = TextEditingController();
  TextEditingController registerConfirmPasswordController = TextEditingController();
  TextEditingController passportNumberController = TextEditingController();
  TextEditingController insuranceNumberController = TextEditingController();
  // at index 0 -> relative type | index 1 -> academic level
  List thirdStepSelection = ['choose', 'optionalChoose'];
  bool registerContinueEnabled = false;
  bool registerObscurePassword = true;
  List<Countries> countries = [];
  DateTime selectedDateOfBirth = DateTime.now();

  /// login | forgot password
  TextEditingController nationalIdController = TextEditingController();
  bool enabledSubmitButton = false;

  /// all
  bool isLoading = false;
  int flag = 0; // if flag == 0, then its normal register, if it's equal to 1 then it's re-register


  Future login(String nationalId, String password) async{
    final response = await loginRepository.loginService(nationalId, password);
    return response;
  }

  Future<ResetPasswordGetDetail> resetPasswordGetDetail(String userId) async{
    final response = await loginRepository.resetPasswordGetDetailService(userId);
    return response;
  }

  // deleted
  // Future resetPasswordSendMobileOTP(String userId) async{
  //   final response = await loginRepository.resetPasswordSendMobileOTPService(userId);
  //   return response;
  // }

  Future resetPassword(String userId, String password, int mobileNumber, String countryCode, int code, String email) async{
    final response = await loginRepository.resetPasswordService(userId, password, mobileNumber, countryCode, code, email);
    return response;
  }

  // deleted
  // Future resetPasswordSendEmailCode(String userId) async{
  //   final response = await loginRepository.resetPasswordSendEmailCodeService(userId);
  //   return response;
  // }

  Future resetPasswordVerifyEmail(String userId, String email) async{
    final response = await loginRepository.resetPasswordVerifyEmailService(userId, email);
    return response;
  }

  Future getEncryptedPassword(String password) async {
    final response = await loginRepository.getEncryptedPasswordService(password);
    return response;
  }

  Future registerUser() async {
    if(flag == 1){
      registerData.nationalNumber = registerData.nationalNumber.toString();
      registerData.personalNumber = registerData.nationalNumber.toString();
      registerData.userId = registerData.userId.toString();
    }
    final response = await loginRepository.registerUserService(registerData);
    return response;
  }

  Future<List<Countries>> readCountriesJson() async {
    countries = [];
    final String response = await rootBundle.loadString('assets/jsonFiles/countries.json');
    countries = countriesFromJson(response);
    notifyListeners();
    return countries;
  }

  Future registerSubmitSecondStep(
      int nationality, int nationalNo,
      int personalNo, String cardNo,
      String birthDate, int secNo,
      int natCode, int relNatNo, int relType
    ) async{
    final response = await loginRepository.registerSubmitSecondStepService(
        nationality, nationalNo,
        personalNo, cardNo,
        birthDate, secNo,
        natCode, relNatNo, relType, flag);
    return response;
  }

  Future sendMobileOTP(int phoneNumber, String countryCode, int firstTime) async{
    final response = await loginRepository.sendMobileOTPService(phoneNumber, countryCode, firstTime);
    return response;
  }

  Future checkMobileOTP(int phoneNumber, String countryCode, int code, int firstTime) async{
    final response = await loginRepository.checkMobileOTPService(phoneNumber, countryCode, code, firstTime);
    return response;
  }

  Future sendEmailOTP(String email, int firstTime) async{
    final response = await loginRepository.sendEmailOTPService(email, firstTime);
    return response;
  }

  Future checkRegisterEmailOTP(String email, int code, int firstTime) async{
    final response = await loginRepository.checkRegisterEmailOTPService(email, code, firstTime);
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
    isLoading = false;
    notifyMe();
  }

  clearForgotPasswordData(){
    enabledSendCodeButton = false;
    nationalIdController.clear();
    resetPasswordController.clear();
    resetConfirmPasswordController.clear();
    enabledSubmitButton = false;
    resetContinueEnabled = false;
    isLoading = false;
  }

  clearRegisterData(){
    registerData = RegisterData();
    jordanianMobileNumberController.clear();
    foreignMobileNumberController.clear();
    registerNationalIdController.clear();
    civilIdNumberController.clear();
    relativeNatIdController.clear();
    emailController.clear();
    registerPasswordController.clear();
    registerConfirmPasswordController.clear();
    selectedDateOfBirth = DateTime.now();
    registerContinueEnabled = false;
    thirdStepSelection = ['choose', 'optionalChoose'];
    isLoading = false;
    notifyMe();
  }
}