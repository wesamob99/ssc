// ignore_for_file: file_names

import 'package:flutter/foundation.dart';
import 'package:ssc/infrastructure/userSecuredStorage.dart';

import '../../../infrastructure/HTTPClientContract.dart';
import '../../../models/accountSettings/listOfNationalities.dart';
import '../../../models/accountSettings/userProfileData.dart';

class ProfileRepository{

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

  Future logoutService() async {
    var response = await HTTPClientContract.instance.postHTTP('/website/logout', {});
    if (kDebugMode) {
      print(response);
    }
    if (response != null && response.statusCode == 200) {
      return response;
    }
  }
}