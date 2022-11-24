// ignore_for_file: file_names

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:ssc/infrastructure/userSecuredStorage.dart';

import '../../../infrastructure/HTTPClientContract.dart';
import '../../../models/services/optionalSubGetDetail.dart';

class ServicesRepository{

  // deleted
  // Future<UserProfileData> getAccountDataService() async {
  //   UserSecuredStorage userSecuredStorage = UserSecuredStorage.instance;
  //   String internalKey = userSecuredStorage.insuranceNumber.toString();
  //   var response = await HTTPClientContract.instance.getHTTP('/individuals/GET_INDIVIDUALUSERINFOSP?PIINSURANCENO=$internalKey');
  //   if (kDebugMode) {
  //     print(response);
  //   }
  //   if (response != null && response.statusCode == 200) {
  //     return userProfileDataFromJson(response.toString());
  //   }
  //   return null;
  // }

  Future<OptionalSubGetDetail> optionalSubGetDetailService() async {
    UserSecuredStorage userSecuredStorage = UserSecuredStorage.instance;
    String internalKey = userSecuredStorage.insuranceNumber.toString();
    var response = await HTTPClientContract.instance.getHTTP('/individuals/OptionalSub_GetDetail_new?PI_user_name=$internalKey');
    if (kDebugMode) {
      print(response);
    }
    if (response != null && response.statusCode == 200) {
      return optionalSubGetDetailFromJson(response.toString());
    }
    return null;
  }

  // if (isFirstOptionalSub == 0 or 2) -> submit membership request will call this service
  Future optionalSubInsertNewService(CurGetdatum datum) async {
    var response = await HTTPClientContract.instance.postHTTP(
        'individuals/OPTIONAL_SUB_INSERT_NEW',
        {
          "SECNO": datum.secno,
          "NAME1": datum.name1,
          "NAME3": datum.name3,
          "MNAME1": datum.mname1,
          "LAST_SALARY": datum.lastSalary,
          "MOBILE": datum.mobile,
          "BRANCH": datum.branch,
          "NAT_NO": datum.natNo,
          "NAME2": datum.name2,
          "NAME4": datum.name4,
          "DOB": datum.dob,
          "EMAIL": datum.email,
          "LIVELOCATION": datum.livelocation,
          "PHONECODE": "",
          "INTERNATIONAL_CODE": datum.internationalCode,
          "ADDRESS": datum.address,
          "REFERANCE_MOBILE": datum.referanceMobile,
          "SALARYREQUST": null,
          "MONTHLYPAY": 45.5,
          "SEX": datum.sex,
          "REG_PER": datum.regPer,
          "MAXIMUMSALARYFORCHOOSE": datum.maximumsalaryforchoose,
          "MINIMUMSALARYFORCHOOSE": datum.minimumsalaryforchoose,
          "SUBMITTION_TYPE": 1,
          "NOOFINCREMENTS": datum.noofincrements,
          "MAX_PER_OF_INC": datum.maxPerOfInc,
          "SELECTED_NOOFINCREMENTS": 1,
          "SELECTED_MAX_PER_OF_INC": 1,
          "APPLIED_SALARY": datum.lastSalary,
          "PERCENT_DECREASEVAL": null,
          "HASBENEFITOFDEC": datum.hasbenefitofdec,
          "HASBENEFITOFINC": datum.hasbenefitofinc,
          "MINIMUMSALARYFORDEC": datum.minimumsalaryfordec,
          "MAXIMUMSALARYFORDEC": datum.maximumsalaryfordec,
          "EXECLUDED_FROM_PENSION_MONTHS": null,
          "SALARY": null
        }
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