// ignore_for_file: file_names

import 'package:drop_down_list/model/selected_list_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:ssc/source/model/accountSettings/accountSettingsRepository.dart';

import '../../../models/accountSettings/listOfNationalities.dart';
import '../../../models/accountSettings/userProfileData.dart';
import '../../../models/login/countries.dart';
import '../../../utilities/countries.dart';
import '../login/loginProvider.dart';

class AccountSettingsProvider extends ChangeNotifier {

  AccountSettingsRepository accountSettingsRepository = AccountSettingsRepository();
  TextEditingController currentPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmNewPasswordController = TextEditingController();
  TextEditingController mobileNumberController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController searchController = TextEditingController();
  UserProfileData accountData;
  SelectedListItem nationality;
  bool updatePasswordIsObscure = true;
  bool updatePasswordEnabled = false;
  bool showFloatingButton = true;
  bool isLoading = true;

  Future<UserProfileData> getAccountData({String internalKey = ''}) async{
    accountData = await accountSettingsRepository.getAccountDataService(internalKey);
    notifyListeners();
    return accountData;
  }

  Future<List<ListOfNationalities>> getListOfNationalities() async{
    return await accountSettingsRepository.getListOfNationalitiesService();
  }

  Future getInquireInsuredInfo() async{
    return await accountSettingsRepository.getInquireInsuredInfoService();
  }

  getNationalityData(context){
    Provider.of<LoginProvider>(context, listen: false).readCountriesJson().then((List<Countries> value){
      Countries c2 = value.where((element) => element.natcode == accountData.curGetdata[0][0].nationalityCode).first;
      Country country2 = countries.where((element) => element.dialCode == c2.callingCode).first;
      nationality = SelectedListItem(
        name: c2.country,
        natCode: c2.natcode,
        value: c2.countryEn,
        flag: country2.flag,
      );
    });
  }

  Future updateUserInfo(int flag, dynamic value) async{
    var data = {
      "params": {
        "ID": accountData.curGetdata[0][0].insuranceno.toString(),
        "ENAME1": accountData.curGetdata[0][0].ename1.toString(),
        "ENAME2": accountData.curGetdata[0][0].ename2.toString(),
        "ENAME3": accountData.curGetdata[0][0].ename3.toString(),
        "ENAME4": accountData.curGetdata[0][0].ename4.toString(),
        "BANKBRANCH_CODE": int.tryParse(accountData.curGetdata[0][0].bankbranchCode),
        "ACADEMICLEVEL": accountData.curGetdata[0][0].academiclevel.toString(),
        "RELATIONSHIPSTATUS": "",
        "LIVECONTRY": flag == 1 ? value : accountData.curGetdata[0][0].livecontry, // National Code
        "POBOX": "",
        "MOBILENUMBER": flag == 2 ? int.tryParse(value) : accountData.curGetdata[0][0].mobilenumber,
        "PHONENUMBER": "",
        "FAXNUMBER": "",
        "EMAIL": flag == 3 ? value : accountData.curGetdata[0][0].email,
        "PASSWORD": "",
        "PI_user_name": accountData.curGetdata[0][0].userName,
        "PI_INTERNATIONALCODE": accountData.curGetdata[0][0].internationalcode,
        "PI_IBAN": "---",
        "PI_BANK_NO": accountData.curGetdata[0][0].bankNo.toString(),
        "NATIONALITY_CODE": {
          "NATCODE": nationality.natCode,
          "NATDESC": nationality.name,
          "NATDESC_EN": nationality.value,
          "MANDATORY_PHONE": 0
        },
        "INTERNATIONALCODE2": accountData.curGetdata[0][0].internationalcode2,
        "MOBILENUMBER2": accountData.curGetdata[0][0].mobilenumber2
      }
    };
    return await accountSettingsRepository.updateUserInfoService(data);
  }

  Future updatePassword(String newPassword, String oldPassword) async{
    return await accountSettingsRepository.updatePasswordService(newPassword, oldPassword);
  }

  Future logout() async{
    return await accountSettingsRepository.logoutService();
  }

  void notifyMe() {
    notifyListeners();
  }
}
