// ignore_for_file: file_names

import 'dart:convert';

import 'package:flutter/foundation.dart';

import '../../../infrastructure/HTTPClientContract.dart';

class PayRepository{

  Future issuanceOfUnifiedPaymentCodeService(List<String> data) async {
    var response = await HTTPClientContract.instance.postHTTP(
        '/individuals/SAVE_TEMP_DATA',
        {"XML":"$data"}
    );
    if (kDebugMode) {
      print(response);
    }
    if (response != null && response.statusCode == 200) {
      return jsonDecode(response.data);
    }
    return '';
  }
}