// ignore_for_file: constant_identifier_names, prefer_typing_uninitialized_variables, file_names

import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:ssc/infrastructure/userConfig.dart';
import '../utilities/util.dart';
import 'userSecuredStorage.dart';

dynamic httpErrorMessage(dynamic responseData) {
  var jsonData;
  if (responseData != null && !isHTML(responseData.data)) {
    jsonData = jsonDecode(responseData.data);
  }
  if (jsonData != null && jsonData['customCode'] != null) {
    return UserConfig.instance.checkLanguage()
        ? jsonData['translatable']['en']
        : jsonData['translatable']['ar'];
  } else {
    return UserConfig.instance.checkLanguage()
        ? 'Server Error'
        : 'خطا من الخادم';
  }
}

///***************************************************************************
///Current URL : ***> [Staging] <***
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
  static const int _MAX_RETRY = 7;
  static const ResponseType _DEFAULT_RESPONSE_TYPE = ResponseType.plain;
  static int _retryCount = 0;
  static CancelToken _cancelToken;
  static final _baseAPI = _addInterceptors(_dio);
  static final bytesAPI = _addInterceptors(_createBytesDio());
  static HTTPClientContract _instance;

  HTTPClientContract._();

  static HTTPClientContract get instance =>
      _instance ??= HTTPClientContract._();

  static final BaseOptions _opts = BaseOptions(
    baseUrl: BASE_URL,
    responseType: _DEFAULT_RESPONSE_TYPE,
    connectTimeout: 30000,
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
          try {
            if (_retryCount > _MAX_RETRY) {
              _retryCount = 0;
              return handler.next(e);
            }
            _retryCount++;
            final RequestOptions options = e.response?.requestOptions;
            options?.headers['Authorization'] = "Bearer ${UserSecuredStorage.instance.token}";
            final Response response = await dio.fetch(options);
            _retryCount = 0;
            return handler.resolve(response);
          } on DioError catch(e){
            _retryCount = 0;
            return handler.next(e);
          }
        } else {
          _retryCount = 0;
          return handler.next(e);
        }
      }, onResponse: (response, handler) {
        return handler.next(response);
      }));
  }

  Future<Response> getHTTP(String url) async {
    try {
      Response response = await _baseAPI.get(url, cancelToken: _cancelToken);
      return response;
    } on DioError catch (e) {
      if (CancelToken.isCancel(e)) {}
      return e.response;
    }
  }

  Future<Response> postHTTP(String url, dynamic data) async {
    try {
      Response response = await _baseAPI.post(url, data: data);
      return response;
    } on DioError catch (e) {
      return e.response;
    }
  }

  Future<Response> putHTTP(String url, dynamic data) async {
    try {
      Response response = await _baseAPI.put(url, data: data);
      return response;
    } on DioError catch (e) {
      return e.response;
    }
  }

  Future<Response> deleteHTTP(String url) async {
    try {
      Response response = await _baseAPI.delete(url);
      return response;
    } on DioError catch (e) {
      return e.response;
    }
  }

  Future<Response> patchHTTP(String url, dynamic data) async {
    try {
      Response response = await _baseAPI.patch(url, data: data);
      return response;
    } on DioError catch (e) {
      return e.response;
    }
  }

}
