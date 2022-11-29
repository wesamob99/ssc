// ignore_for_file: file_names

import 'package:flutter/foundation.dart';
import 'package:ssc/infrastructure/userSecuredStorage.dart';

import '../../../infrastructure/HTTPClientContract.dart';
import '../../../models/profile/userProfileData.dart';

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
}