// ignore_for_file: camel_case_types, constant_identifier_names

import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:mutex/mutex.dart';

import '../main.dart';


enum ENV_TYPE { DEV, PROD }

class UserConfig {
  static const ENV_TYPE env_type = ENV_TYPE.DEV;
  static UserConfig? _instance;

  UserConfig._();

  static UserConfig get instance => _instance ??= UserConfig._();

  Future<Flushbar>? flushBar;
  StreamSubscription? networkListener;
  SharedPreferences? _prefs;
  bool gms = false, hms = false;
  bool googleServicesActivated = false;
  bool lightTheme = true;
  bool isConnected = false;
  int inboxCount = 0;

  String language = "English";

  SharedPreferences? get prefs {
    if (_prefs == null) {
      initSharedPreferences();
    }

    return _prefs;
  }

  set prefs(SharedPreferences? value) {
    _prefs = value;
  }

  Future initSharedPreferences() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // ////////////////
  //
  // Future<void> setHomeDesign(HomeSettings list, String key) async {
  //   _prefs?.setString(key,homeSettingsToJson(list) );
  // }
  //
  // HomeSettings getHomeDesign(String key)  {
  //
  //   final homeSettings = homeSettingsFromJson(_prefs.getString(key) ??homeSettingsToJson(HomeSettings(homeSettings: [])) );
  //   return homeSettings;
  // }
  //
  // ////////////////

  bool checkLanguage() {
    return language == 'English' ? true : false;
  }

  Future<Flushbar> showPlatformFlushBar(
      String title, String message, BuildContext context, {int seconds = 3}) async {
    final flushBar = this.flushBar;
    if (flushBar != null) {
      flushBar.then((value) => value.dismiss());
    }

    return Flushbar(
      title: title,
      message: message,
      duration: Duration(seconds: seconds),
      margin: const EdgeInsets.all(8),
      borderRadius: BorderRadius.circular(8),
    )..show(context);
  }

  checkDataConnection() async {
    networkListener =
        InternetConnectionChecker().onStatusChange.listen((status) async {
          switch (status) {
            case InternetConnectionStatus.connected:
              {
                final m = Mutex();
                try {
                  await m.acquire();
                  flushBar?.then((value) => value.dismiss());
                  await showPlatformFlushBar(
                      checkLanguage()
                          ? 'Your are connected now'
                          : 'انت متصل الان',
                      checkLanguage()
                          ? 'You have successfully connected to the internet.'
                          : 'تم الاتصال بالشبكة.',
                      navigatorKey.currentContext!,
                      seconds: 3);
                  flushBar = null;
                } finally {
                  m.release();
                }
              }
              break;
            case InternetConnectionStatus.disconnected:
              {
                final m = Mutex();
                try {
                  await m.acquire();
                  flushBar?.then((value) => value.dismiss());
                  flushBar = showPlatformFlushBar(
                      checkLanguage()
                          ? 'No internet Connection'
                          : 'لا يوجد اتصال انترنت. ',
                      checkLanguage()
                          ? 'Please make sure your device is connected to internet.'
                          : 'الرجاء التاكد من اتصال الانترنت.',
                      navigatorKey.currentContext!,
                      seconds: 200);
                } finally {
                  m.release();
                }
              }
              break;
          }
        });
  }
}
