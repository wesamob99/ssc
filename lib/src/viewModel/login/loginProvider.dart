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
  TextEditingController dateOfBirthController = TextEditingController(text: DateTime.now().toString());
  // at index 0 -> relative type | index 1 -> academic level
  List thirdStepSelection = ['choose', 'optionalChoose'];
  bool registerContinueEnabled = false;
  bool registerObscurePassword = true;
  List<Countries> countries = [];

  /// login | forgot password
  TextEditingController nationalIdController = TextEditingController();
  bool enabledSubmitButton = false;

  /// all
  bool isLoading = false;


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

  Future<void> readCountriesJson() async {
    countries = [];
    final String response = await rootBundle.loadString('assets/jsonFiles/countries.json');
    countries = countriesFromJson(response);
    notifyListeners();
  }

  Future registerSubmitSecondStep(
      int nationality, int nationalNo,
      int personalNo, String cardNo,
      dynamic birthDate, int secNo,
      int natCode, int relNatNo, int relType
    ) async{
    final response = await loginRepository.registerSubmitSecondStepService(
        nationality, nationalNo,
        personalNo, cardNo,
        birthDate, secNo,
        natCode, relNatNo, relType);
    return response;
  }

  Future sendRegisterMobileOTP(int phoneNumber, String countryCode) async{
    final response = await loginRepository.sendRegisterMobileOTPService(phoneNumber, countryCode);
    return response;
  }

  Future checkRegisterMobileOTP(int phoneNumber, String countryCode, int code) async{
    final response = await loginRepository.checkRegisterMobileOTPService(phoneNumber, countryCode, code);
    return response;
  }

  Future sendRegisterEmailOTP(String email) async{
    final response = await loginRepository.sendRegisterEmailOTPService(email);
    return response;
  }

  Future checkRegisterEmailOTP(String email, int code) async{
    final response = await loginRepository.checkRegisterEmailOTPService(email, code);
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
    notifyMe();
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
    dateOfBirthController.clear();
    registerContinueEnabled = false;
    thirdStepSelection = ['choose', 'optionalChoose'];
    isLoading = false;
    notifyMe();
  }
}