// ignore_for_file: file_names

import 'package:flutter/cupertino.dart';
import 'package:ssc/src/model/profile/profileRepository.dart';

import '../../../models/accountSettings/listOfNationalities.dart';
import '../../../models/accountSettings/userProfileData.dart';

class ProfileProvider extends ChangeNotifier {

  ProfileRepository profileRepository = ProfileRepository();
  bool showFloatingButton = true;
  bool isLoading = true;

  Future<UserProfileData> getAccountData({String internalKey = ''}) async{
    return await profileRepository.getAccountDataService(internalKey);
  }

  Future<List<ListOfNationalities>> getListOfNationalities() async{
    return await profileRepository.getListOfNationalitiesService();
  }

  Future logout() async{
    return await profileRepository.logoutService();
  }

  void notifyMe() {
    notifyListeners();
  }
}
