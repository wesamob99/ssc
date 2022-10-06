import 'package:flutter/cupertino.dart';
import 'package:ssc/src/model/profile/profileRepository.dart';

class ProfileProvider extends ChangeNotifier {

  ProfileRepository profileRepository = ProfileRepository();
  bool showFloatingButton = true;

  Future getAccountData() async{
    return await profileRepository.getAccountDataService();
  }

  void notifyMe() {
    notifyListeners();
  }
}
