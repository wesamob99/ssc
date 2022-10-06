import '../../../infrastructure/HTTPClientContract.dart';

class SettingsRepository{

  Future logoutService() async {
    var response = await HTTPClientContract.instance.postHTTP('/website/logout', {});
    print(response);
    if (response != null && response.statusCode == 200) {
      return response;
    }
  }
}