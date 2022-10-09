// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class ThemeNotifier with ChangeNotifier {
  ThemeMode _themeMode;

  ThemeNotifier(this._themeMode);

  getThemeMode() => _themeMode;

  setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    notifyListeners();
  }

  bool isLight() {
    if (_themeMode == ThemeMode.light) {
      return true;
    } else if (_themeMode == ThemeMode.dark) {
      return false;
    } else if (_themeMode == ThemeMode.system) {
      var brightness = SchedulerBinding.instance.window.platformBrightness;
      bool darkModeOn = brightness == Brightness.dark;
      if (darkModeOn == false) {
        return true;
      } else {
        return false;
      }
    }
    return true;
  }

  int getThemeType() {
    if (_themeMode == ThemeMode.light) {
      return 0;
    } else if (_themeMode == ThemeMode.dark) {
      return 1;
    } else if (_themeMode == ThemeMode.system) {
      return 2;
    }

    return 0;
  }

  Color getIconColor() {
    if (_themeMode == ThemeMode.light) {
      return Colors.black;
    } else if (_themeMode == ThemeMode.dark) {
      return Colors.white;
    } else {
      return const Color(0xFFBDBDBD);
    }
  }

  void notifyMe() {
    notifyListeners();
  }
}
