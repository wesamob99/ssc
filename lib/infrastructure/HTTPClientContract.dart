// ignore_for_file: constant_identifier_names, prefer_typing_uninitialized_variables, file_names

import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:provider/provider.dart';
import 'package:ssc/infrastructure/userConfig.dart';
import 'package:ssc/source/view/splash/splashScreen.dart';
import 'package:ssc/source/viewModel/utilities/theme/themeProvider.dart';
import '../main.dart';
import '../source/viewModel/home/homeProvider.dart';
import '../utilities/util.dart';
import 'userSecuredStorage.dart';

dynamic httpErrorMessage(dynamic responseData) {
  var jsonData;
  if (responseData != null && !isHTML(responseData.data)) {
    jsonData = jsonDecode(responseData.data);
  }
  if (jsonData != null && jsonData['customCode'] != null) {
    return UserConfig.instance.isLanguageEnglish()
        ? jsonData['translatable']['en']
        : jsonData['translatable']['ar'];
  } else {
    return UserConfig.instance.isLanguageEnglish()
        ? 'Server Error'
        : 'خطا من الخادم';
  }
}

///***************************************************************************
///Current URL : ***> [Staging] <*********************************************
///***************************************************************************
/// [Development]: http://172.16.3.40:8081/api
/// [Staging]: https://mfiles.ssc.gov.jo:6018/eservicestg/api
/// [MohHazimLocal]: http://172.16.4.107:3005/api
/// [Stable]:
///***************************************************************************

class DevHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext context) {
    ///TODO: add your certificate verification logic here instead of [true]
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}

class HTTPClientContract {
  static const String BASE_URL = 'https://mfiles.ssc.gov.jo:6018/eservicestg/api';
  static final _dio = _createDio();
  static CancelToken _cancelToken;
  static final _baseAPI = _addInterceptors(_dio);
  static final bytesAPI = _addInterceptors(_createBytesDio());
  static HTTPClientContract _instance;

  HTTPClientContract._();

  static HTTPClientContract get instance =>
      _instance ??= HTTPClientContract._();

  static final BaseOptions _opts = BaseOptions(
    baseUrl: BASE_URL,
    responseType: ResponseType.plain,
    connectTimeout: 40000,
    receiveTimeout: 60000,
    receiveDataWhenStatusError: true,
    validateStatus: (status) => true,
  );

  static Dio _createDio() {
    _cancelToken = CancelToken();
    return Dio(_opts);
  }

  static Dio _createBytesDio() {
    _cancelToken = CancelToken();
    return Dio(BaseOptions(
      baseUrl: BASE_URL,
      responseType: ResponseType.bytes,
      connectTimeout: 30000,
      receiveTimeout: 60000,
      receiveDataWhenStatusError: true,
      validateStatus: (status) => true,
    ));
  }

  static Dio _addInterceptors(Dio dio) {
    return dio
      ..interceptors.add(InterceptorsWrapper(onRequest: (options, handler) {
        options.headers.addAll({
          if (UserSecuredStorage.instance.token.isNotEmpty)
            "Authorization": "Bearer ${UserSecuredStorage.instance.token}",
          // Headers.contentTypeHeader: Headers.jsonContentType,
        });
        return handler.next(options);
      }, onError: (e, handler) async {
        if ((e.response?.statusCode == 403 || e.response?.statusCode == 401)) {

        }
        return handler.next(e);
      }, onResponse: (response, handler) {
        return handler.next(response);
      }));
  }

  Future<Response> getHTTP(String url) async {
    checkInternetConnection();
    try {
      Response response = await _baseAPI.get(url, cancelToken: _cancelToken);
      checkSessionExpired(response);
      return response;
    } on DioError catch (e) {
      if (CancelToken.isCancel(e)) {}
      return e.response;
    }
  }

  Future<Response> postHTTP(String url, dynamic data) async {
    checkInternetConnection();
    try {
      Response response = await _baseAPI.post(url, data: data);
      checkSessionExpired(response);
      return response;
    } on DioError catch (e) {
      return e.response;
    }
  }

  Future<Response> putHTTP(String url, dynamic data) async {
    checkInternetConnection();
    try {
      Response response = await _baseAPI.put(url, data: data);
      checkSessionExpired(response);
      return response;
    } on DioError catch (e) {
      return e.response;
    }
  }

  Future<Response> deleteHTTP(String url) async {
    checkInternetConnection();
    try {
      Response response = await _baseAPI.delete(url);
      checkSessionExpired(response);
      return response;
    } on DioError catch (e) {
      return e.response;
    }
  }

  Future<Response> patchHTTP(String url, dynamic data) async {
    checkInternetConnection();
    try {
      Response response = await _baseAPI.patch(url, data: data);
      checkSessionExpired(response);
      return response;
    } on DioError catch (e) {
      return e.response;
    }
  }


  checkInternetConnection() async {
    if(!await InternetConnectionChecker().hasConnection && !Provider.of<HomeProvider>(navigatorKey.currentContext, listen: false).isSplashScreenLoading) {
      UserConfig.instance.showPlatformFlushBar(
          UserConfig.instance.isLanguageEnglish()
              ? 'No internet Connection'
              : 'لا يوجد اتصال بالانترنت. ',
          UserConfig.instance.isLanguageEnglish()
              ? 'Please make sure your device is connected to internet.'
              : 'الرجاء التاكد من الاتصال بالانترنت.',
          navigatorKey.currentContext,
          seconds: 200
      );
    }
  }

  checkSessionExpired(Response response){
    if ((response?.statusCode == 403 || response?.statusCode == 401) && !Provider.of<HomeProvider>(navigatorKey.currentContext, listen: false).isSplashScreenLoading) {
      String title = 'sessionExpired';
      String body = getTranslated('sessionExpiredDesc', navigatorKey.currentContext);
      showMyDialog(
        navigatorKey.currentContext,
        title, body, 'login',
        Provider.of<ThemeNotifier>(navigatorKey.currentContext, listen: false),
      ).then((value) {
        Navigator.of(navigatorKey.currentContext).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const SplashScreen()),
                (route) => false
        );
      });
    }
  }
}
