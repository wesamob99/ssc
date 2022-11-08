// ignore_for_file: file_names

import 'dart:convert';

import 'package:flutter/foundation.dart';

import '../../../infrastructure/HTTPClientContract.dart';
import '../../../models/login/resetPasswordGetDetail.dart';
import '../../../models/login/userData.dart';

class LoginRepository{

  Future<UserData> loginService(String userId, String password) async {
    dynamic data;
    await getEncryptedPasswordService(password).then((value) {
      data = jsonEncode({
        "userId": userId,
        "password": value,
        "isWebsite": false
      });
    });
    var response = await HTTPClientContract.instance.postHTTP(
        '/users/login', data
    );

    if (kDebugMode) {
      print(response);
    }
    if (response != null && response.statusCode == 200) {
      return userDataFromJson(response.toString());
    }
    return null;
  }

  Future<String> getEncryptedPasswordService(String password) async {
    var response = await HTTPClientContract.instance.postHTTP(
        '/users/encryptPassword', {"password": password});

    if (response != null && response.statusCode == 200) {
      var data = jsonDecode(response.data);
      return data["encrtptedPassword"];
    }
    return '';
  }

  Future<ResetPasswordGetDetail> resetPasswordGetDetailService(String userId) async {
    var response = await HTTPClientContract.instance.getHTTP('/users/resetPasswordGetDetail?userId=$userId');
    if (kDebugMode) {
      print(response);
    }
    if (response != null && response.statusCode == 200) {
      return resetPasswordGetDetailFromJson(response.toString());
    }
    return null;
  }

  Future resetPasswordSendMobileOTPService(String userId) async {
    var response = await HTTPClientContract.instance.postHTTP(
        '/users/resetPasswordSendOtp', {
      "params": {
        "userId": userId
      }
    }
    );
    if (kDebugMode) {
      print(response);
    }
    if (response != null && response.statusCode == 200) {
      return jsonDecode(response.data);
    }
    return '';
  }

  Future resetPasswordCheckMobileOTPService(String userId, int otp) async {
    var response = await HTTPClientContract.instance.postHTTP(
        '/users/resetPasswordCheckOtp',
      {
        "userId": userId,
        "otpCode": otp,
        "token": "",
        "password": "",
        "reRegisterPass": false
      }
    );
    if (kDebugMode) {
      print(response);
    }
    if (response != null && response.statusCode == 200) {
      return jsonDecode(response.data);
    }
    return '';
  }

  Future resetPasswordSendEmailCodeService(String userId) async {
    var response = await HTTPClientContract.instance.postHTTP(
        '/users/sendResetPasswordEmail',
        {
          "userId": userId
        }
    );
    if (kDebugMode) {
      print(response);
    }
    if (response != null && response.statusCode == 200) {
      return jsonDecode(response.data);
    }
    return '';
  }

  Future registerSubmitSecondStepService(
      int nationality, int nationalNo,
      int personalNo, String cardNo,
      DateTime birthDate, int secNo,
      int natCode, int relNatNo, int relType
    ) async {
    var response = await HTTPClientContract.instance.postHTTP(
        '/mobile/INDV_VALIDATE_PERS_RELATIVES',
      {
        'nationality': nationality, // 1- Jordanian 2- non-Jordanian
        'natNo':  nationalNo, // national number
        'persNo': personalNo, //personal number
        'cardNo': cardNo, // personal card number
        'birthDate' : birthDate,
        'secNo': secNo, // insurance number
        'natCode':  natCode, // national code,
        'relNatNo' : relNatNo, // relative national number
        'relType':  relType // relative type
      }
    );
    if (kDebugMode) {
      print(response);
    }
    if (response != null && response.statusCode == 200) {
      return jsonDecode(response.data);
    }
    return '';
  }

  Future sendRegisterMobileOTPService(int phoneNumber, String countryCode) async {
    var response = await HTTPClientContract.instance.postHTTP(
        '/mobile/mobile-code',
        {
          "phoneNumber": phoneNumber,// number  // mobile number (9 digits) : 781******
          "countryCode": countryCode// string // country code : 00962
        }
    );
    if (kDebugMode) {
      print(response);
    }
    if (response != null && response.statusCode == 200) {
      return jsonDecode(response.data);
    }
    return '';
  }

  Future checkRegisterMobileOTPService(int phoneNumber, String countryCode, int code) async {
    var response = await HTTPClientContract.instance.postHTTP(
        '/mobile/mobile-code-verify',
        {
          "phoneNumber": phoneNumber, //number // mobile number (9 digits) : 781******
          "countryCode": countryCode, // string // country code : 00962
          "code": code, // number // OTP code
        }
    );
    if (kDebugMode) {
      print(response);
    }
    if (response != null && response.statusCode == 200) {
      return jsonDecode(response.data);
    }
    return '';
  }

  Future sendRegisterEmailOTPService(String email) async {
    var response = await HTTPClientContract.instance.postHTTP(
        '/mobile/email-code',
        {
          "email": email, // string // user email
        }
    );
    if (kDebugMode) {
      print(response);
    }
    if (response != null && response.statusCode == 200) {
      return jsonDecode(response.data);
    }
    return '';
  }

  Future checkRegisterEmailOTPService(String email, int code) async {
    var response = await HTTPClientContract.instance.postHTTP(
        '/mobile/email-code-verify',
        {
          "email": email,// string // user email
          "code": code// number // OTP code
        }
    );
    if (kDebugMode) {
      print(response);
    }
    if (response != null && response.statusCode == 200) {
      return jsonDecode(response.data);
    }
    return '';
  }
}