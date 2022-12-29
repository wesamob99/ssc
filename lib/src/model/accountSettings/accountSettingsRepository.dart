// ignore_for_file: file_names

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:ssc/infrastructure/userSecuredStorage.dart';

import '../../../infrastructure/HTTPClientContract.dart';
import '../../../models/accountSettings/listOfNationalities.dart';
import '../../../models/accountSettings/userProfileData.dart';

class AccountSettingsRepository{

  Future<UserProfileData> getAccountDataService(internalKey) async {
    UserSecuredStorage userSecuredStorage = UserSecuredStorage.instance;
    if(internalKey == '') {
      internalKey = userSecuredStorage.insuranceNumber.toString();
    }
    var response = await HTTPClientContract.instance.getHTTP('/individuals/GET_INDIVIDUALUSERINFOSP?PIINSURANCENO=$internalKey');
    if (kDebugMode) {
      print(response);
    }
    if (response != null && response.statusCode == 200) {
      return userProfileDataFromJson(response.toString());
    }
    return null;
  }

  Future<List<ListOfNationalities>> getListOfNationalitiesService() async {
    var response = await HTTPClientContract.instance.getHTTP('/corporations/GET_LIST_OF_NationalitiesSP');
    if (kDebugMode) {
      print('response: $response');
    }
    if (response != null && response.statusCode == 200) {
      return listOfNationalitiesFromJson(response.toString())[0];
    }
    return null;
  }

  Future updateUserInfoService(data) async {
    var response = await HTTPClientContract.instance.postHTTP(
        '/individuals/UPDATE_INDIVIDUALUSERINFO', data
    );

    if (response != null && response.statusCode == 200) {
      return jsonDecode(response.data);
    }
    return '';
  }

  Future updatePasswordService(String newPassword, String oldPassword) async {
    UserSecuredStorage userSecuredStorage = UserSecuredStorage.instance;

    dynamic data = {
      "userId":userSecuredStorage.nationalId,
      "password": "",
      "confirmPassword": newPassword,
      "oldPassword": ""
    };
    await getEncryptedPasswordService(newPassword).then((newHashedPassword) {
      data['password'] = newHashedPassword;
    }).whenComplete(() async {
      await getEncryptedPasswordService(oldPassword).then((oldHashedPassword) {
        data['oldPassword'] = oldHashedPassword;
      });
    });

    var response = await HTTPClientContract.instance.postHTTP(
      '/users/resetUserPassword',
      data
    );
    if (kDebugMode) {
      print(response);
    }
    if (response != null && response.statusCode == 200) {
      return jsonDecode(response.toString());
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

  Future logoutService() async {
    var response = await HTTPClientContract.instance.postHTTP('/website/logout', {});
    if (kDebugMode) {
      print(response);
    }
    if (response != null && response.statusCode == 200) {
      return response;
    }
  }

  Future getInquireInsuredInfoService() async {
    var response = await HTTPClientContract.instance.getHTTP('/individuals/inquire_insured_info_new');
    if (kDebugMode) {
      print('response: $response');
    }
    if (response != null && response.statusCode == 200) {
      return jsonDecode(response.toString());
    }
    return null;
  }
}