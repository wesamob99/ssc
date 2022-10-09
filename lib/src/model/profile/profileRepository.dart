import 'package:ssc/infrastructure/userSecuredStorage.dart';

import '../../../infrastructure/HTTPClientContract.dart';
import '../../../models/profile/userProfileData.dart';

class ProfileRepository{

  Future<UserProfileData> getAccountDataService() async {
    UserSecuredStorage userSecuredStorage = UserSecuredStorage.instance;
    String internalKey = userSecuredStorage.internalKey.toString();
    print('internalKey: $internalKey');
    var response = await HTTPClientContract.instance.getHTTP('/individuals/GET_INDIVIDUALUSERINFOSP?PIINSURANCENO=$internalKey');
    print(response);
    if (response != null && response.statusCode == 200) {
      return userProfileDataFromJson(response.toString());
    }
  }
}