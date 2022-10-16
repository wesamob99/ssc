// ignore_for_file: file_names

import 'dart:convert';

import 'package:flutter/foundation.dart';

import '../../../infrastructure/HTTPClientContract.dart';
import '../../../models/login/countries.dart';
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

  Future<List<Countries>> getCountriesService() async {
    var response = await HTTPClientContract.instance.getHTTP('/website/get_countries');
    if (kDebugMode) {
      print(response);
    }
    if (response != null && response.statusCode == 200) {
      return countriesFromJson(response.toString());
    }
    return null;
  }
}