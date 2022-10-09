// ignore_for_file: file_names

import 'package:flutter/foundation.dart';

import '../../../infrastructure/HTTPClientContract.dart';

class SettingsRepository{

  Future logoutService() async {
    var response = await HTTPClientContract.instance.postHTTP('/website/logout', {});
    if (kDebugMode) {
      print(response);
    }
    if (response != null && response.statusCode == 200) {
      return response;
    }
  }
}