// ignore_for_file: file_names

import 'package:flutter/cupertino.dart';
import 'package:ssc/source/model/settings/settingsRepository.dart';

class SettingsProvider extends ChangeNotifier {

  SettingsRepository settingsRepository = SettingsRepository();

  Future logout() async{
    return await settingsRepository.logoutService();
  }

  void notifyMe() {
    notifyListeners();
  }
}
