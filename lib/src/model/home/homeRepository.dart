import 'package:ssc/infrastructure/userSecuredStorage.dart';
import 'package:ssc/models/home/userInformationsDashboard.dart';

import '../../../infrastructure/HTTPClientContract.dart';

class HomeRepository{

  Future<UserInformation> getStatisticsService() async {
    UserSecuredStorage userSecuredStorage = UserSecuredStorage.instance;
    String internalKey = userSecuredStorage.internalKey.toString();
    var response = await HTTPClientContract.instance.getHTTP('/individuals/getIndvStatistics?sceNo=$internalKey');
    print(response);
    if (response != null && response.statusCode == 200) {
      return userInformationFromJson(response.toString());
    } else if(userInformationFromJson(response.toString()).success == false){
      // return userInformationFromJson(response.toString()).success;
      /// TODO: check if session expired
    }
  }
}