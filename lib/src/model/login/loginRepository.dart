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
  }

  /// users/resetPasswordGetDetail?userId=9661001073
}