import 'dart:convert';

import 'package:ssc/infrastructure/userSecuredStorage.dart';

import '../../../infrastructure/HTTPClientContract.dart';

class ProfileRepository{

  Future getAccountDataService() async {
    UserSecuredStorage userSecuredStorage = UserSecuredStorage.instance;
    String internalKey = userSecuredStorage.internalKey.toString();
    print('internalKey: $internalKey');
    var response = await HTTPClientContract.instance.getHTTP('/individuals/GET_INDIVIDUALUSERINFOSP?PIINSURANCENO=$internalKey');
    print(response);
    if (response != null && response.statusCode == 200) {
      return jsonDecode(response.toString());
    }
  }
}