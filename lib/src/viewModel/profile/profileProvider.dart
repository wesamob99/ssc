// ignore_for_file: file_names

import 'package:flutter/cupertino.dart';
import 'package:ssc/src/model/profile/profileRepository.dart';

import '../../../models/profile/userProfileData.dart';

class ProfileProvider extends ChangeNotifier {

  ProfileRepository profileRepository = ProfileRepository();
  bool showFloatingButton = true;

  Future<UserProfileData> getAccountData({String internalKey = ''}) async{
    return await profileRepository.getAccountDataService(internalKey);
  }

  void notifyMe() {
    notifyListeners();
  }
}
