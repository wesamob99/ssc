import 'dart:convert';

import '../../../infrastructure/HTTPClientContract.dart';
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

    print(response);
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
}