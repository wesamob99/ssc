import 'package:flutter/cupertino.dart';
import 'package:ssc/src/model/profile/profileRepository.dart';

import '../../../models/profile/userProfileData.dart';

class ProfileProvider extends ChangeNotifier {

  ProfileRepository profileRepository = ProfileRepository();
  bool showFloatingButton = true;

  Future<UserProfileData> getAccountData() async{
    return await profileRepository.getAccountDataService();
  }

  void notifyMe() {
    notifyListeners();
  }
}
