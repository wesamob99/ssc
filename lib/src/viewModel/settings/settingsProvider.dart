import 'package:flutter/cupertino.dart';
import 'package:ssc/src/model/settings/settingsRepository.dart';

class SettingsProvider extends ChangeNotifier {

  SettingsRepository settingsRepository = SettingsRepository();

  Future logout() async{
    return await settingsRepository.logoutService();
  }

  void notifyMe() {
    notifyListeners();
  }
}
