// ignore_for_file: file_names

import 'package:flutter/foundation.dart';
import 'package:ssc/infrastructure/userSecuredStorage.dart';
import 'package:ssc/models/home/userInformationsDashboard.dart';

import '../../../infrastructure/HTTPClientContract.dart';
import '../../../models/home/payOffFinancialInformations.dart';

class HomeRepository{

  Future<UserInformation> getStatisticsService() async {
    UserSecuredStorage userSecuredStorage = UserSecuredStorage.instance;
    String internalKey = userSecuredStorage.insuranceNumber.toString();
    var response = await HTTPClientContract.instance.getHTTP('/individuals/getIndvStatistics?sceNo=$internalKey');
    if (kDebugMode) {
      print(response);
    }
    if (response != null && response.statusCode == 200) {
      return userInformationFromJson(response.toString());
    }
    return null;
  }

  Future<PayOffFinancialInformation> getAmountToBePaidService() async {
    var response = await HTTPClientContract.instance.getHTTP('/individuals/GET_MAIN_INFO');
    if (kDebugMode) {
      print(response);
    }
    if (response != null && response.statusCode == 200) {
      return payOffFinancialInformationFromJson(response.toString());
    }
    return null;
  }
}