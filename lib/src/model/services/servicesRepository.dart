// ignore_for_file: file_names

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:ssc/infrastructure/userSecuredStorage.dart';

import '../../../infrastructure/HTTPClientContract.dart';

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

  Future optionalSubGetDetailService() async {
    UserSecuredStorage userSecuredStorage = UserSecuredStorage.instance;
    String internalKey = userSecuredStorage.insuranceNumber.toString();
    var response = await HTTPClientContract.instance.getHTTP('/individuals/OptionalSub_GetDetail_new?PI_user_name=$internalKey');
    if (kDebugMode) {
      print(response);
    }
    if (response != null && response.statusCode == 200) {
      return jsonDecode(response.toString());
    }
    return null;
  }

  /// if (isFirstOptionalSub == [0] or [2]) -> send membership request will call this service
  Future optionalSubInsertNewService(result, double monthlyPay, double appliedSalary ,int submissionType, int selectedNumberOfIncrements, int selectedMaxPerForInc) async {
    var data = {
      "SECNO": result['SECNO'],
      "NAME1": result['NAME1'],
      "NAME3": result['NAME3'],
      "MNAME1": result['MNAME1'],
      "LAST_SALARY": result['LAST_SALARY'],
      "MOBILE": result['MOBILE'],
      "BRANCH": result['BRANCH'],
      "NAT_NO": result['NAT_NO'],
      "NAME2": result['NAME2'],
      "NAME4": result['NAME4'],
      "DOB": result['DOB'],
      "EMAIL": result['EMAIL'],
      "LIVELOCATION": result['LIVELOCATION'],
      "PHONECODE": '',
      "INTERNATIONAL_CODE": result['INTERNATIONAL_CODE'],
      "ADDRESS": result['ADDRESS'],
      "REFERANCE_MOBILE": result['REFERANCE_MOBILE'],
      "SALARYREQUST": null,
      "MONTHLYPAY": monthlyPay,
      "SEX": result['SEX'],
      "REG_PER": result['REG_PER'],
      "MAXIMUMSALARYFORCHOOSE": result['MAXIMUMSALARYFORCHOOSE'],
      "MINIMUMSALARYFORCHOOSE": result['MINIMUMSALARYFORCHOOSE'],
      "SUBMITTION_TYPE": submissionType,
      "NOOFINCREMENTS": result['NOOFINCREMENTS'],
      "MAX_PER_OF_INC": result['MAX_PER_OF_INC'],
      "SELECTED_NOOFINCREMENTS": selectedNumberOfIncrements,
      "SELECTED_MAX_PER_OF_INC": selectedMaxPerForInc,
      "APPLIED_SALARY": appliedSalary,
      "PERCENT_DECREASEVAL": null,
      "HASBENEFITOFDEC": result['HASBENEFITOFDEC'],
      "HASBENEFITOFINC": result['HASBENEFITOFINC'],
      "MINIMUMSALARYFORDEC": result['MINIMUMSALARYFORDEC'],
      "MAXIMUMSALARYFORDEC": result['MAXIMUMSALARYFORDEC'],
      "EXECLUDED_FROM_PENSION_MONTHS": null,
      "SALARY": null
    };
    var response = await HTTPClientContract.instance.postHTTP(
        '/individuals/OPTIONAL_SUB_INSERT_NEW', data
    );
    if (kDebugMode) {
      print(response);
    }
    if (response != null && response.statusCode == 200) {
      return jsonDecode(response.data);
    }
    return '';
  }

  /// if (isFirstOptionalSub == [1]) -> send membership request will call this service
  Future optionalSubFirstInsertNewService(result, double monthlyPay, double appliedSalary ,int submissionType, int selectedNumberOfIncrements, int selectedMaxPerForInc) async {
    var data = {
      "SECNO": result['SECNO'],
      "NAME1": result['NAME1'],
      "NAME3": result['NAME3'],
      "MNAME1": result['MNAME1'],
      "LAST_SALARY": result['LAST_SALARY'],
      "MOBILE": result['MOBILE'],
      "BRANCH": result['BRANCH'],
      "NAT_NO": result['NAT_NO'],
      "NAME2": result['NAME2'],
      "NAME4": result['NAME4'],
      "DOB": result['DOB'],
      "EMAIL": result['EMAIL'],
      "LIVELOCATION": result['LIVELOCATION'],
      "PHONECODE": null,
      "INTERNATIONAL_CODE": result['INTERNATIONAL_CODE'],
      "ADDRESS": result['ADDRESS'],
      "REFERANCE_MOBILE": result['REFERANCE_MOBILE'],
      "SALARYREQUST": null,
      "MONTHLYPAY": monthlyPay,
      "SEX": result['SEX'],
      "REG_PER": result['REG_PER'],
      "MAXIMUMSALARYFORCHOOSE": result['MAXIMUMSALARYFORCHOOSE'],
      "MINIMUMSALARYFORCHOOSE": result['MINIMUMSALARYFORCHOOSE'],
      "SUBMITTION_TYPE": submissionType,
      "NOOFINCREMENTS": result['NOOFINCREMENTS'],
      "MAX_PER_OF_INC": result['MAX_PER_OF_INC'],
      "SELECTED_NOOFINCREMENTS": selectedNumberOfIncrements,
      "SELECTED_MAX_PER_OF_INC": selectedMaxPerForInc,
      "APPLIED_SALARY": appliedSalary,
      "PERCENT_DECREASEVAL": null,
      "HASBENEFITOFDEC": result['HASBENEFITOFDEC'],
      "HASBENEFITOFINC": result['HASBENEFITOFINC'],
      "MINIMUMSALARYFORDEC": result['MINIMUMSALARYFORDEC'],
      "MAXIMUMSALARYFORDEC": result['MAXIMUMSALARYFORDEC'],
      "EXECLUDED_FROM_PENSION_MONTHS": null,
      "SALARY": null
    };
    var response = await HTTPClientContract.instance.postHTTP(
        '/individuals/OptionalSubFirst_insert_new', data
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