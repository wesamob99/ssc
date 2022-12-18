// ignore_for_file: file_names

import 'package:flutter/cupertino.dart';
import 'package:ssc/src/model/accountSettings/accountSettingsRepository.dart';

import '../../../models/accountSettings/listOfNationalities.dart';
import '../../../models/accountSettings/userProfileData.dart';

class AccountSettingsProvider extends ChangeNotifier {

  AccountSettingsRepository accountSettingsRepository = AccountSettingsRepository();
  TextEditingController currentPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmNewPasswordController = TextEditingController();
  bool updatePasswordIsObscure = true;
  bool updatePasswordEnabled = false;
  bool showFloatingButton = true;
  bool isLoading = true;

  Future<UserProfileData> getAccountData({String internalKey = ''}) async{
    return await accountSettingsRepository.getAccountDataService(internalKey);
  }

  Future<List<ListOfNationalities>> getListOfNationalities() async{
    return await accountSettingsRepository.getListOfNationalitiesService();
  }

  Future updatePassword(String newPassword, String oldPassword) async{
    return await accountSettingsRepository.updatePasswordService(newPassword, oldPassword);
  }

  Future logout() async{
    return await accountSettingsRepository.logoutService();
  }

  void notifyMe() {
    notifyListeners();
  }
}
