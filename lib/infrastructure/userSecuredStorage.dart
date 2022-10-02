// ignore_for_file: constant_identifier_names, prefer_typing_uninitialized_variables

import 'dart:convert';
import 'dart:io';

import 'package:ssc/infrastructure/HTTPClientContract.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart' as hive_flutter;

class UserSecuredStorage {
  static const String _BOX_NAME = 'user_key';
  String _userNameEn = "";
  String _userNameAr = "";
  String _userImage = "";
  String _userJson = "";
  /// ***
  String _userName = "";
  // String _userGroup = "";
  // String _internalKey = "";
  String _nationalId = "";
  // String _status = "";
  // String _statusDescriptionAr = "";
  // String _statusDescriptionEn = "";
  String _email = "";
  // String _internationalCode = "";
  // String _mobileNumber = "";
  // String _nationality = "";
  String _token = "";
  var _box;

  static UserSecuredStorage? _instance;

  UserSecuredStorage._();

  static UserSecuredStorage get instance =>
      _instance ??= UserSecuredStorage._();


  /// ******
  String get userName {
    _userName = _box.get('userName') ?? "";
    return _userName;
  }

  set userName(String value) {
    addKeyPair('userName', value);
    _userName = value;
  }

  String get nationalId {
    _nationalId = _box.get('nationalId') ?? "";
    return _nationalId;
  }

  set nationalId(String value) {
    addKeyPair('nationalId', value);
    _nationalId = value;
  }
  /// ******

  String get userJson {
    _userJson = _box.get('user') ?? "";
    return _userJson;
  }

  set userJson(String value) {
    addKeyPair('user', value);
    _userJson = value;
  }

  String get token {
    _token = _box.get('token') ?? "";
    return _token;
  }

  set token(String value) {
    addKeyPair('token', value);

    _token = value;
  }

  String get email {
    _email = _box.get('email') ?? "";
    return _email;
  }

  set email(String value) {
    addKeyPair('email', value);
    _email = value;
  }

  String get userNameAr {
    _userNameEn = _box.get('userNameAr') ?? "";
    return _userNameAr;
  }

  set userNameAr(String value) {
    addKeyPair('userNameAr', value);
    _userNameAr = value;
  }

  String get userNameEn {
    _userNameEn = _box.get('userNameEn') ?? "";
    return _userNameEn;
  }

  set userNameEn(String value) {
    addKeyPair('userNameEn', value);
    _userNameEn = value;
  }

  String get userImage {
    _userImage = _box.get('userImage') ?? "";
    return _userImage;
  }

  set userImage(String value) {
    addKeyPair('userImage', value);
    _userImage = value;
  }

  void addKeyPair(dynamic key, dynamic value) {
    _box.put(key, value);
  }

  Future<void> initSecuredBox() async {
    await hive_flutter.Hive.initFlutter();
    if (Platform.isAndroid) {
      const FlutterSecureStorage secureStorage = FlutterSecureStorage();
      var containsEncryptionKey =
          await secureStorage.containsKey(key: _BOX_NAME);
      if (!containsEncryptionKey) {
        await secureStorage.write(
            key: _BOX_NAME, value: base64UrlEncode(Hive.generateSecureKey()));
      }

      String? read = await secureStorage.read(key: _BOX_NAME);
      await UserSecuredStorage.instance.openBox(
          hiveCipher: HiveAesCipher(base64Url.decode(read!)));
    } else {
      await UserSecuredStorage.instance.openBox();
    }
  }

  Future<void> openBox({HiveCipher? hiveCipher}) async {
    _box = await Hive.openBox(_BOX_NAME,
        encryptionCipher: Platform.isAndroid ? hiveCipher : null);
  }

  Future<void> clearUserData() async {
    await _box.clear();
  }

  Future refreshToken(String oldToken) async {
    var response = await HTTPClientContract.instance.postHTTP(
        'RefreshExpiredToken',
        jsonEncode({
          "TokenToRefresh": oldToken,
        }));

    if (response != null && response.statusCode == 200) {
      var myMap = jsonDecode(response.data);
      _box.put('token', myMap['Token'].toString());
      token = myMap['Token'].toString();
      return 'ok';
    }
  }
}
