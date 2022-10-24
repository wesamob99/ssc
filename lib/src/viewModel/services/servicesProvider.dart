// ignore_for_file: file_names

import 'package:flutter/cupertino.dart';
import 'package:ssc/src/model/services/servicesRepository.dart';

import '../../../models/profile/userProfileData.dart';

class ServicesProvider extends ChangeNotifier {

  ServicesRepository servicesRepository = ServicesRepository();
  UserProfileData userProfileData = UserProfileData();

  Future<UserProfileData> getAccountData() async{
    userProfileData = await servicesRepository.getAccountDataService();
    notifyMe();
    return userProfileData;
  }

  void notifyMe() {
    notifyListeners();
  }
}