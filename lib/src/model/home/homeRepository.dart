import 'dart:convert';

import 'package:ssc/infrastructure/userSecuredStorage.dart';

import '../../../infrastructure/HTTPClientContract.dart';

class HomeRepository{

  Future getStatisticsService() async {
    UserSecuredStorage userSecuredStorage = UserSecuredStorage.instance;
    String internalKey = userSecuredStorage.internalKey.toString();
    var response = await HTTPClientContract.instance.getHTTP('/individuals/getIndvStatistics?sceNo=$internalKey');
    print(response);
    if (response != null && response.statusCode == 200) {
      return jsonDecode(response.toString());
    }
  }
}