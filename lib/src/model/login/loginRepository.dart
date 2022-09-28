import 'dart:convert';

import '../../../infrastructure/HTTPClientContract.dart';

class LoginRepository{

  Future loginService(String userId, String password) async {
    dynamic data;
    await getEncryptedPasswordService(password).then((value) {
      data = jsonEncode({
        "userId": userId,
        "password": value,
        "isWebsite": true
      });
    });
    var response = await HTTPClientContract.instance.postHTTP(
        '/users/login', data
    );

    if (response != null && response.statusCode == 200) {
      return response;
    }
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
}