import 'package:flutter/material.dart';

import '../../../../infrastructure/userConfig.dart';

class GlobalAppProvider extends ChangeNotifier {
  String languageText = "English";

  language() {
    languageText = languageText == "English" ? "عربي" : "English";
    UserConfig.instance.language = languageText;
  }

  Locale _appLocale = const Locale('en');

  Locale get appLocal => _appLocale;

  GlobalAppProvider(this._appLocale);

  Future fetchLocale() async {
    if (UserConfig.instance.prefs?.getString('language_code') == null) {
      _appLocale = const Locale('en');
      UserConfig.instance.language = "English";
      return Null;
    }
    _appLocale = Locale(UserConfig.instance.prefs!.getString('language_code')!);
    UserConfig.instance.language =
        UserConfig.instance.prefs?.getString('language_code') == "en"
            ? "English"
            : "عربي";
    return Null;
  }

  void changeLanguage(Locale type) async {
    if (type == const Locale("ar")) {
      UserConfig.instance.language = 'عربي';
      _appLocale = const Locale("ar", "JO");
      await UserConfig.instance.prefs?.setString('language_code', 'ar');
      await UserConfig.instance.prefs?.setString('countryCode', '');
    } else {
      UserConfig.instance.language = 'English';
      _appLocale = const Locale("en");
      await UserConfig.instance.prefs?.setString('language_code', 'en');
      await UserConfig.instance.prefs?.setString('countryCode', 'US');
    }
  }

  void notifyMe() {
    notifyListeners();
  }
}
