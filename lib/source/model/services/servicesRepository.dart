// ignore_for_file: file_names

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:ssc/infrastructure/userSecuredStorage.dart';

import '../../../infrastructure/HTTPClientContract.dart';
import '../../../models/services/pensionPaymentModel.dart';

class ServicesRepository{

  Future getAccountDataService() async {
    UserSecuredStorage userSecuredStorage = UserSecuredStorage.instance;
    String internalKey = userSecuredStorage.insuranceNumber.toString();
    var response = await HTTPClientContract.instance.getHTTP('/individuals/GET_INDIVIDUALUSERINFOSP?PIINSURANCENO=$internalKey');
    if (kDebugMode) {
      print(response);
    }
    if (response != null && response.statusCode == 200) {
      return jsonDecode(response.toString());
    }
    return null;
  }

  Future getDecExistence() async {
    var response = await HTTPClientContract.instance.getHTTP('/individuals/dec_existence');
    if (kDebugMode) {
      print(response);
    }
    if (response != null && response.statusCode == 200) {
      return jsonDecode(response.toString());
    }
    return null;
  }

  Future getInquiryInsuredInformationService() async {
    UserSecuredStorage userSecuredStorage = UserSecuredStorage.instance;
    String internalKey = userSecuredStorage.insuranceNumber.toString();
    var response = await HTTPClientContract.instance.getHTTP('/individuals/inquiryInsuredInformation?sceNo=$internalKey');
    if (kDebugMode) {
      print(response);
    }
    if (response != null && response.statusCode == 200) {
      return jsonDecode(response.toString());
    }
    return null;
  }

  Future getInsuredInformationReportService(value) async {
    var data = {
      "formObj": jsonEncode(value["cur_getdata"][0][0]),
      "periods": jsonEncode(value["cur_getdata2"][0]),
      "salaries": jsonEncode(value["cur_getdata3"][0]),
    };
    var response = await HTTPClientContract.instance.postHTTP(
        '/individuals/InsuredInformationReport', data
    );
    if (kDebugMode) {
      print(response);
    }
    if (response != null && response.statusCode == 200) {
      return response;
    }
    return '';
  }

  Future getActivePaymentService(String serviceType, String nat) async {
    var response = await HTTPClientContract.instance.getHTTP('/website/getActivePayment?p_service_type=$serviceType&NAT=$nat');
    if (kDebugMode) {
      print(response);
    }
    if (response != null && response.statusCode == 200) {
      return jsonDecode(response.data);
    }
    return '';
  }

  Future getRequiredDocumentsService(result, serviceNo) async {
    var data = {
      "params":{
        "Data": result,
        "SERVICE_NO": serviceNo
      }
    };
    if (kDebugMode) {
      print('data: ${jsonEncode(data)}');
    }
    var response = await HTTPClientContract.instance.postHTTP(
        '/website/GetDocumentRequired', data
    );
    if (kDebugMode) {
      print(response);
    }
    if (response != null && response.statusCode == 200) {
      return jsonDecode(response.data);
    }
    return '';
  }

  Future saveFileService(file) async {
    var formData = FormData();
    formData.files.add(MapEntry("Excel", await MultipartFile.fromFile(file.path)));

    var response = await HTTPClientContract.instance.postHTTP(
        '/ftp/saveFile?fileName=&folderName=24', formData
    );
    if (kDebugMode) {
      print(response);
    }
    if (response != null && response.statusCode == 200) {
      return jsonDecode(response.data);
    }
    return '';
  }

  /// **************************************************************MEMBERSHIP - START******************************************************************************
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
  Future optionalSubInsertNewService(result, int firstOptionalSub,double monthlyPay, double appliedSalary ,int submissionType, int selectedNumberOfIncrements, int selectedMaxPerForInc, String percentDecreaseVal, String selectedMonth) async {
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
      "SALARYREQUST": firstOptionalSub == 2 ? appliedSalary : null,
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
      "APPLIED_SALARY": firstOptionalSub == 2 ? 0 : appliedSalary,
      "PERCENT_DECREASEVAL": percentDecreaseVal != 'null' ? double.parse(percentDecreaseVal) : null,
      "HASBENEFITOFDEC": result['HASBENEFITOFDEC'],
      "HASBENEFITOFINC": result['HASBENEFITOFINC'],
      "MINIMUMSALARYFORDEC": result['MINIMUMSALARYFORDEC'],
      "MAXIMUMSALARYFORDEC": result['MAXIMUMSALARYFORDEC'],
      "EXECLUDED_FROM_PENSION_MONTHS": selectedMonth,
      "SALARY": selectedMonth != null ? appliedSalary : null
    };
    if (kDebugMode) {
      print(jsonEncode(data));
    }
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
  Future optionalSubFirstInsertNewService(result, double monthlyPay, double salaryRequest ,int submissionType) async {
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
      "ADDRESS": result['ADDRESS'] ?? "jordan",
      "REFERANCE_MOBILE": result['REFERANCE_MOBILE'],
      "SALARYREQUST": salaryRequest,
      "MONTHLYPAY": monthlyPay,
      "SEX": result['SEX'],
      "REG_PER": result['REG_PER'],
      "MAXIMUMSALARYFORCHOOSE": result['MAXIMUMSALARYFORCHOOSE'],
      "MINIMUMSALARYFORCHOOSE": result['MINIMUMSALARYFORCHOOSE'],
      "SUBMITTION_TYPE": submissionType,
      "NOOFINCREMENTS": result['NOOFINCREMENTS'],
      "MAX_PER_OF_INC": result['MAX_PER_OF_INC'],
      "SELECTED_NOOFINCREMENTS": null,
      "SELECTED_MAX_PER_OF_INC": null,
      "APPLIED_SALARY": 0,
      "PERCENT_DECREASEVAL": null,
      "HASBENEFITOFDEC": result['HASBENEFITOFDEC'],
      "HASBENEFITOFINC": result['HASBENEFITOFINC'],
      "MINIMUMSALARYFORDEC": result['MINIMUMSALARYFORDEC'],
      "MAXIMUMSALARYFORDEC": result['MAXIMUMSALARYFORDEC'],
      "EXECLUDED_FROM_PENSION_MONTHS": null,
      "SALARY": null
    };

    if (kDebugMode) {
      print('data: ${jsonEncode(data)}');
    }
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

  Future optionalSubIncGetDetailNewService() async {
    UserSecuredStorage userSecuredStorage = UserSecuredStorage.instance;
    String internalKey = userSecuredStorage.insuranceNumber.toString();
    var response = await HTTPClientContract.instance.getHTTP('/individuals/OptionalSub_Inc_GetDetail_new?secno=$internalKey');
    if (kDebugMode) {
      print(response);
    }
    if (response != null && response.statusCode == 200) {
      return jsonDecode(response.toString());
    }
    return null;
  }

  Future submitOptionSubIncrementService(int selectedRate, double newSalary) async {
    var response = await HTTPClientContract.instance.postHTTP(
        '/individuals/SubmitOptionSubIncrement', {"SELECTED_MAX_PER_OF_INC":selectedRate,"BRANCH":60,"SALARYAFTER":newSalary}
    );
    if (kDebugMode) {
      print(response);
    }
    if (response != null && response.statusCode == 200) {
      return jsonDecode(response.data);
    }
    return '';
  }
/// **************************************************************MEMBERSHIP - END******************************************************************************

/// **************************************************************UPDATE USER MOBILE NUMBER - START*************************************************************
  Future updateUserMobileNumberSendOTPService(String newNumber) async {
    UserSecuredStorage userSecuredStorage = UserSecuredStorage.instance;
    int internationalCode = int.tryParse(userSecuredStorage.internationalCode.toString());
    String nationalId = userSecuredStorage.nationalId.toString();
    var response = await HTTPClientContract.instance.postHTTP(
        '/individuals/UPD_USER_PROFILE_INDV_SENDOTP', {"params":{"PI_USERNAME":nationalId,"PI_INTERNATIONALCODE":internationalCode,"PI_MOBILENO":newNumber}}
    );
    if (kDebugMode) {
      print(response);
    }
    if (response != null && response.statusCode == 200) {
      return jsonDecode(response.data);
    }
    return '';
  }

  Future updateUserMobileNumberCheckOTPService(String code) async {
    UserSecuredStorage userSecuredStorage = UserSecuredStorage.instance;
    String nationalId = userSecuredStorage.nationalId.toString();
    var response = await HTTPClientContract.instance.postHTTP(
        '/individuals/UPD_USER_PROFILE_INDV_CHECKOTP', {"params":{"PI_OTP":code,"PI_USER_NAME":nationalId}}
    );
    if (kDebugMode) {
      print(response);
    }
    if (response != null && response.statusCode == 200) {
      return jsonDecode(response.data);
    }
    return '';
  }


  Future updateUserEmailSendOTPService(String email, int firstTime) async {
    var response = await HTTPClientContract.instance.postHTTP(
        '/mobile/email-code',
        {
          "email": email, // string // user email
          "reset": firstTime // 0 -> first time, 1-> reset
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

  Future updateUserEmailCheckOTPService(String email, int code, int firstTime) async {
    var response = await HTTPClientContract.instance.postHTTP(
        '/mobile/email-code-verify',
        {
          "email": email,// string // user email
          "code": code, // number // OTP code
          "reset": firstTime// number // 0 -> first time, 1-> reset
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

/// **************************************************************UPDATE USER MOBILE NUMBER - END***************************************************************

/// **************************************************************EARLY RETIREMENT - START**********************************************************************

  Future getPensionsBasicInformationsService() async {
    UserSecuredStorage userSecuredStorage = UserSecuredStorage.instance;
    String internalKey = userSecuredStorage.insuranceNumber.toString();
    var response = await HTTPClientContract.instance.getHTTP('/individuals/pensionsBasicInformation?sceNo=$internalKey');
    if (kDebugMode) {
      print(response);
    }
    if (response != null && response.statusCode == 200) {
      return jsonDecode(response.toString());
    }
    return null;
  }

  Future getDependentInfoService(String id) async { // get dependent details when adding new dependent from the national ID
    var response = await HTTPClientContract.instance.getHTTP('/website/support_GetDetail?pi_relative_nat_pers_no=$id&PI_relatiev_nat=1');
    if (kDebugMode) {
      print(response);
    }
    if (response != null && response.statusCode == 200) {
      return jsonDecode(response.toString());
    }
    return null;
  }

  Future<PensionPaymentModel> getPensionPaymentSPService(String year) async {
    UserSecuredStorage userSecuredStorage = UserSecuredStorage.instance;
    String internalKey = userSecuredStorage.insuranceNumber.toString();
    var response = await HTTPClientContract.instance.getHTTP('/individuals/pension_paymentSP?pi_secno=$internalKey&Pi_year=$year');
    if (kDebugMode) {
      print(response);
    }
    if (response != null && response.statusCode == 200) {
      return pensionPaymentModelFromJson(response.toString());
    }
    return null;
  }

  Future getApplicationService(int appType) async {
    UserSecuredStorage userSecuredStorage = UserSecuredStorage.instance;
    String nationalId = userSecuredStorage.nationalId.toString();
    var response = await HTTPClientContract.instance.getHTTP('/website/get_application?p_app_id=$nationalId&p_app_type=$appType&p_status=1&p_id=null&isDefense=null');
    if (kDebugMode) {
      print(response);
    }
    if (response != null && response.statusCode == 200) {
      return jsonDecode(response.toString());
    }
    return null;
  }

  Future addNewDependentService(String natID) async {
    var response = await HTTPClientContract.instance.getHTTP('/website/support_GetDetail?pi_relative_nat_pers_no=$natID&PI_relatiev_nat=1');
    if (kDebugMode) {
      print(response);
    }
    if (response != null && response.statusCode == 200) {
      return jsonDecode(response.toString());
    }
    return null;
  }

  Future deleteDependentService(int id) async {
    var response = await HTTPClientContract.instance.postHTTP(
        '/website/DELETE_DEP', {"PI_ID": id}
    );
    if (kDebugMode) {
      print(response);
    }
    if (response != null && response.statusCode == 200) {
      return jsonDecode(response.data);
    }
    return '';
  }

  Future setEarlyRetirementApplicationService(result, docs, paymentInfo, int authorizedToSign, int wantInsurance, int serviceType) async {
    var row = {
      /// payment info
      "PAYMENT_METHOD": paymentInfo['PAYMENT_METHOD'],
      "BANK_LOCATION": paymentInfo['BANK_LOCATION'],
      "BRANCH_ID": paymentInfo['BRANCH_ID'],
      "BRANCH_NAME": paymentInfo['BRANCH_NAME'],
      "BANK_ID": paymentInfo['BANK_ID'],
      "BANK_NAME": paymentInfo['BANK_NAME'],
      "ACCOUNT_NAME": paymentInfo['ACCOUNT_NAME'],
      "PAYMENT_COUNTRY": paymentInfo['PAYMENT_COUNTRY'],
      "PAYMENT_COUNTRY_CODE": paymentInfo['PAYMENT_COUNTRY_CODE'],
      "PAYMENT_PHONE": paymentInfo['PAYMENT_PHONE'],
      "SWIFT_CODE": paymentInfo['SWIFT_CODE'],
      "BANK_DETAILS": paymentInfo['BANK_DETAILS'],
      "IBAN": paymentInfo['IBAN'] ?? "",
      "CASH_BANK_ID": paymentInfo['CASH_BANK_ID'],
      "REP_NATIONALITY": paymentInfo['REP_NATIONALITY'],
      "REP_NATIONAL_NO": paymentInfo['REP_NATIONAL_NO'],
      "REP_NAME": paymentInfo['REP_NAME'],
      "WALLET_TYPE": paymentInfo['WALLET_TYPE'],
      "WALLET_OTP_VERIVIED": paymentInfo['WALLET_OTP_VERIVIED'],
      "WALLET_OTP": paymentInfo['WALLET_OTP'],
      "WALLET_PHONE": paymentInfo['WALLET_PHONE'],
      "WALLET_PHONE_VERIVIED": paymentInfo['WALLET_PHONE_VERIVIED'],
      "WALLET_PASSPORT_NUMBER": paymentInfo['WALLET_PASSPORT_NUMBER'],
      "PEN_IBAN": paymentInfo['PEN_IBAN'],
      "IBAN_CONFIG": "1",
      /// ***
      "IFSC": result['p_per_info'][0][0]['IFSC'] ?? "",
      "APPROVE_DISCLOSURE": 1,
      "NOT_APPROVE_REASON": null,
      "SIG_ATHORIZED": authorizedToSign,
      "WANT_INSURANCE": wantInsurance,
      "OFFNO": result['p_per_info'][0][0]['OFFNO'],
      "AGREE_TERMS": 1,
      "SECNO": result['p_per_info'][0][0]['SECNO'],
      "NAT_DESC": result['p_per_info'][0][0]['NAT_DESC'],
      "NAT": result['p_per_info'][0][0]['NAT'],
      "NAT_NO": result['p_per_info'][0][0]['NAT_NO'],
      "PERS_NO": result['p_per_info'][0][0]['PERS_NO'],
      "LAST_EST_NAME": result['p_per_info'][0][0]['LAST_EST_NAME'],
      "NAME1": result['p_per_info'][0][0]['NAME1'],
      "NAME2": result['p_per_info'][0][0]['NAME2'],
      "NAME3": result['p_per_info'][0][0]['NAME3'],
      "NAME4": result['p_per_info'][0][0]['NAME4'],
      "FULL_NAME_EN": result['p_per_info'][0][0]['FULL_NAME_EN'],
      "EMAIL": result['p_per_info'][0][0]['EMAIL'],
      "MOBILE": result['p_per_info'][0][0]['MOBILE'],
      "INTERNATIONAL_CODE": result['p_per_info'][0][0]['INTERNATIONAL_CODE'],
      "INSURED_ADDRESS": result['p_per_info'][0][0]['INSURED_ADDRESS'],
      "MARITAL_STATUS": result['p_per_info'][0][0]['MARITAL_STATUS'],
      "REGDATE": null, /// not found
      "REGRATE": null, /// not found
      "LAST_SALARY": null, /// not found
      "LAST_STODATE": result['p_per_info'][0][0]['LAST_STODATE'],
      "ACTUAL_STODATE": result['p_per_info'][0][0]['ACTUAL_STODATE'],
      "GENDER": result['p_per_info'][0][0]['GENDER'],
      "CIVIL_WORK_DOC": result['p_per_info'][0][0]['CIVIL_WORK_DOC'],
      "MILITARY_WORK_DOC": result['p_per_info'][0][0]['MILITARY_WORK_DOC'],
      "CIV_MIL_RETIRED_DOC": result['p_per_info'][0][0]['CIV_MIL_RETIRED_DOC'],
      "PEN_START_DATE": result['p_per_info'][0][0]['PEN_START_DATE'],
      "GOVERNORATE": result['p_per_info'][0][0]['GOVERNORATE'],
      "DETAILED_ADDRESS": null, /// not found
      "PASS_NO": null, /// not found
      "RESIDENCY_NO": null, /// not found
      "DOB": result['p_per_info'][0][0]['DOB'],
      "JOB_NO": null, /// not found
      "JOB_DESC": result['p_per_info'][0][0]['JOB_DESC'],
      "ENAME1": null, /// not found
      "ENAME2": null, /// not found
      "ENAME3": null, /// not found
      "ENAME4": null, /// not found
      "LAST_EST_NO": result['p_per_info'][0][0]['LAST_EST_NO'],
      "FAM_NO": null, /// not found
      "nextVaild": null, /// not found
      "wantAddFamily": null, /// not found
      "GENDER_DESC": result['p_per_info'][0][0]['GENDER_DESC'],
      "PI_EPAY": null, /// not found
      "INSURED": null, /// not found
      "APPLICANT_ID": result['p_per_info'][0][0]['NAT_NO'],
      "APPLICANT_NO": result['p_per_info'][0][0]['NAT_NO'],
      "SERVICE_TYPE": serviceType,
      "IS_DEFENSE": result['p_per_info'][0][0]['IS_DEFENSE'],
      "APP_STATUS_EXTERNAL": 2,
      "OTHER_DEPENDANTS": result['p_per_info'][0][0]['OTHER_DEPENDANTS'],
      "ID": result['p_per_info'][0][0]['ID'],
      "LEAVE_START_DATE": result['p_per_info'][0][0]['LEAVE_START_DATE'],
      "LEAVE_END_DATE": result['p_per_info'][0][0]['LEAVE_END_DATE'],
      "BIRTH_DATE": result['p_per_info'][0][0]['BIRTH_DATE'],
    };
    var data = {
      "params": {
        "XML": jsonEncode(
          {
            "row": row,
            "doc": docs,
            "dep": (result["P_DEP_INFO"].isNotEmpty || result["P_Dep"].isNotEmpty) ? (result["P_DEP_INFO"][0] ?? result["P_Dep"][0]) : [],
            "INHERITORS": [], // value always [] in early retirement
            "isWebsite": false
          }
        )
      }
    };

    var response = await HTTPClientContract.instance.postHTTP(
        '/website/set_application', data
    );
    if (kDebugMode) {
      print(response);
    }
    if (response != null && response.statusCode == 200) {
      return jsonDecode(response.data);
    }
    return '';
  }

  // {"params":{"Obj":"{\"row\":{\"NAT\":\"111\",\"GENDER\":\"1\"},\"dep\":[]}"}}
  Future checkDocumentDependentService(List dependents) async {
    // for (int i=0 ; i<dependents.length ; i++) {
    //   dependents[i] = {
    //   "FULL_NAME": dependents[i]["FULL_NAME"] ?? dependents[i]['NAME'],
    //   "RELATION": dependents[i]["RELATION"] ?? dependents[i]["RELATIVETYPE"],
    //   "IS_ALIVE": dependents[i]["IS_ALIVE"],
    //   "WORK_STATUS": dependents[i]["RELATION"],
    //   "IS_RETIRED": dependents[i]["IS_RETIRED"],
    //   "DISABILITY": dependents[i]["DISABILITY"],
    //   "GENDER": dependents[i]["GENDER"],
    //   "ID": dependents[i]["ID"],
    //   "SOURCE_FLAG": dependents[i]["SOURCE_FLAG"],
    //   "NATIONAL_NO": dependents[i]["NATIONAL_NO"],
    //   "NATIONALITY": dependents[i]["NATIONALITY"],
    //   "BIRTHDATE": dependents[i]["BIRTHDATE"],
    //   "AGE": dependents[i]["AGE"],
    //   "WORK_STATUS_A": dependents[i]["WORK_STATUS_A"] ?? dependents[i]["IS_WORK"],
    //   "IS_ALIVE_A": dependents[i]["IS_ALIVE_A"],
    //   "IS_RETIRED_A": dependents[i]["IS_RETIRED_A"],
    //   "LAST_EVENT_DATE": dependents[i]["LAST_EVENT_DATE"],
    //   "WANT_HEALTH_INSURANCE": "",
    //   "PreLoad": 0,
    //   "Added": 1,
    //   "doc_dep": [],
    //   "DEP_CODE": dependents[i]["DEP_CODE"],
    //   "IS_STOP": ""
    // };
    // }
    if (kDebugMode) {
      print({"params": {
      "Obj": jsonEncode({
        "row": {
          "NAT": "111",
          "GENDER": "2"
        },
        "dep": dependents
      })
    }});
    }
    var response = await HTTPClientContract.instance.postHTTP(
        '/website/check_doc_dep', {"params": {
            "Obj": jsonEncode({
              "row": {
                "NAT": "111",
                "GENDER": "2"
              },
              "dep": dependents
            })
          }
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

/// **************************************************************EARLY RETIREMENT - END************************************************************************

/// **************************************************************DECEASED RETIREMENT - END*********************************************************************

  Future setDeceasedRetirementApplicationService(result, docs, deadPersonInfo, int deathPlace) async {

    var row = {
      ...deadPersonInfo['cur_getdata'][0][0],
      "REGDATE": null,
      "PERSONAL_SECNO": result['p_per_info'][0][0]['SECNO'],
      "PERSONAL_NAT_DESC": result['p_per_info'][0][0]['NAT_DESC'],
      "PERSONAL_NAT": result['p_per_info'][0][0]['NATIONALITY_NO'],
      "PERSONAL_NAT_NO": result['p_per_info'][0][0]['NAT_NO'],
      "PERSONAL_FULL_NAME": result['p_per_info'][0][0]['FULL_NAME_AR'],
      "PERSONAL_INTERNATIONAL_CODE": result['p_per_info'][0][0]['INTERNATIONAL_CODE'],
      "PERSONAL_RELATIVE_TYPE": deadPersonInfo['cur_getdata'][0][0]['RELATIVE_TYPE'],
      "PERSONAL_PERS_NO": result['p_per_info'][0][0]['PERS_NO'],
      "PERSONAL_MOBILE": result['p_per_info'][0][0]['MOBILE'],
      "NAT_NO_DEATH": deadPersonInfo['cur_getdata'][0][0]['NAT_NO'].toString(),
      "TRANSACTION_TYPE": 4, /// ***
      "RELATION": deadPersonInfo['cur_getdata'][0][0]['RELATIVE_TYPE'],
      "PLACE_OF_DEATH": deathPlace,
      "DEATH_BIRTH_DATE": null,
      "IS_DEATH": 1, /// ***
      "NAT_DEATH": deadPersonInfo['cur_getdata'][0][0]['NAT'],
      "FULL_NAME": deadPersonInfo['cur_getdata'][0][0]['FULL_NAME_AR'],
      "MOBILE": result['p_per_info'][0][0]['MOBILE'],
      "dateChoice": deadPersonInfo['cur_getdata'][0][0]['NAT'] == "111" ? 1 : 2,
      "INS_NO_DEATH": deadPersonInfo['cur_getdata'][0][0]['SECNO'],
      "PEN_NEWTYPE_DEATH": deadPersonInfo['cur_getdata'][0][0]['PEN_NEWTYPE'],
      "INTERNATIONALCODE_DEATH": "+${result['p_per_info'][0][0]['INTERNATIONAL_CODE']}",
      "ACCEPTED": 1,
      "APPLICANT_ID": result['p_per_info'][0][0]['NAT_NO'].toString(),
      "APPLICANT_NO": result['p_per_info'][0][0]['NAT_NO'].toString(),
      "SERVICE_TYPE": 11,
      "IS_DEFENSE": null, /// ***
      "APP_STATUS_EXTERNAL": 2, /// ***
      "OTHER_DEPENDANTS": null, /// ***
      "ID": "",
      "LEAVE_START_DATE": null, /// ***
      "LEAVE_END_DATE": null, /// ***
      "BIRTH_DATE": null,
      "AGREE_TERMS": 1,
      "IBAN_CONFIG": "1"
    };
    row.remove('NAT_NO');
    row.remove('NAT');
    row.remove('RELATIVE_TYPE');
    row['DEATH_DATE'] = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'", 'en_US').format(DateTime.parse(deadPersonInfo['cur_getdata'][0][0]['DEATH_DATE'].replaceAll('/', '-').split('-').reversed.join()).toUtc()).toString();
    var data = {
      "params": {
        "XML": jsonEncode(
            {
              "row": row,
              "doc": docs,
              "dep": [], // value always [] in deceased retirement
              "INHERITORS": deadPersonInfo['cur_getdata2'].isNotEmpty ? deadPersonInfo['cur_getdata2'][0] : [],
              "isWebsite": false
            }
        )
      }
    };

    var response = await HTTPClientContract.instance.postHTTP(
        '/website/set_application', data
    );
    if (kDebugMode) {
      print(response);
    }
    if (response != null && response.statusCode == 200) {
      return jsonDecode(response.data);
    }
    return '';
  }

  Future penDeathLookup() async {
    var response = await HTTPClientContract.instance.getHTTP('/individuals/PEN_DEATH_Lookup');
    if (kDebugMode) {
      print(response);
    }
    if (response != null && response.statusCode == 200) {
      return jsonDecode(response.toString());
    }
    return null;
  }

  Future deadPersonGetDetailsService(Map<String, dynamic> data) async {
    var response = await HTTPClientContract.instance.getHTTP('/individuals/PEN_DEATH_GetDetail?DEATH_NAT_NO=${data['natId']}&DEATH_NAT=${data['nationality']}&PEN_TYPE=${data['penType']}&nat_date_of_birth=${data['birthDate']}&death_date=${data['deathDate']}');
    if (kDebugMode) {
      print(response);
    }
    if (response != null && response.statusCode == 200) {
      return jsonDecode(response.toString());
    }
    return null;
  }

  Future guardianGetDetailsService(String natNo, int nationality, String cardNo, String dateOfBirth) async {
    var response = await HTTPClientContract.instance.getHTTP('/individuals/Nat_Pers_match_GetDetail?NAT_NO=$natNo&nationality=$nationality&national_card_id=$cardNo&pi_DOB=$dateOfBirth');
    if (kDebugMode) {
      print(response);
    }
    if (response != null && response.statusCode == 200) {
      return jsonDecode(response.toString());
    }
    return null;
  }

  Future getHeirsInfoService(String heirsNatNo, String deathNatNo) async { // get heirs details when adding new heirs from the national ID
    var response = await HTTPClientContract.instance.getHTTP('/individuals/heris_GetDetail?deathNatNo=$deathNatNo&heirsNatNo=$heirsNatNo&natType=1');
    if (kDebugMode) {
      print(response);
    }
    if (response != null && response.statusCode == 200) {
      return jsonDecode(response.toString());
    }
    return null;
  }

/// **************************************************************DECEASED RETIREMENT - END*********************************************************************

/// **************************************************************RETIREMENT LOAN - START***********************************************************************

  Future loanCalculationService(int piFlag, double payNet, double payTot, double currentFinancialCommitment, double currentLoanValue, currentNumberOfInstallments, String loanType) async {
    var response = await HTTPClientContract.instance.postHTTP(
        '/individuals/loan_calc', {"PI_FLG":"$piFlag","p_penpay_tot":"$payTot","p_penpay_net":"$payNet","p_out_debt":currentFinancialCommitment,"p_loan_amt":currentLoanValue,"p_duration":currentNumberOfInstallments,"p_loan_typ":loanType,"prev_bal":""}
    );
    if (kDebugMode) {
      print(response);
    }
    if (response != null && response.statusCode == 200) {
      return jsonDecode(response.data);
    }
    return '';
  }

  Future setRetirementLoanApplicationService(result, docs, paymentInfo, typeOfAdvance, loanType, loanResultInfo, currentLoanValue, currentNumberOfInstallments, currentFinancialCommitment) async {

    var row = {
      /// payment info
      "PAYMENT_METHOD": paymentInfo['PAYMENT_METHOD'],
      "BANK_LOCATION": paymentInfo['BANK_LOCATION'],
      "BRANCH_ID": paymentInfo['BRANCH_ID'],
      "BRANCH_NAME": paymentInfo['BRANCH_NAME'],
      "BANK_ID": paymentInfo['BANK_ID'],
      "BANK_NAME": paymentInfo['BANK_NAME'],
      "ACCOUNT_NAME": paymentInfo['ACCOUNT_NAME'],
      "PAYMENT_COUNTRY": paymentInfo['PAYMENT_COUNTRY'],
      "PAYMENT_COUNTRY_CODE": paymentInfo['PAYMENT_COUNTRY_CODE'],
      "PAYMENT_PHONE": paymentInfo['PAYMENT_PHONE'],
      "SWIFT_CODE": paymentInfo['SWIFT_CODE'],
      "BANK_DETAILS": paymentInfo['BANK_DETAILS'],
      "IBAN": paymentInfo['IBAN'] ?? "",
      "CASH_BANK_ID": paymentInfo['CASH_BANK_ID'],
      "REP_NATIONALITY": paymentInfo['REP_NATIONALITY'],
      "REP_NATIONAL_NO": paymentInfo['REP_NATIONAL_NO'],
      "REP_NAME": paymentInfo['REP_NAME'],
      "WALLET_TYPE": paymentInfo['WALLET_TYPE'],
      "WALLET_OTP_VERIVIED": paymentInfo['WALLET_OTP_VERIVIED'],
      "WALLET_OTP": paymentInfo['WALLET_OTP'],
      "WALLET_PHONE": paymentInfo['WALLET_PHONE'],
      "WALLET_PHONE_VERIVIED": paymentInfo['WALLET_PHONE_VERIVIED'],
      "WALLET_PASSPORT_NUMBER": paymentInfo['WALLET_PASSPORT_NUMBER'],
      "PEN_IBAN": paymentInfo['PEN_IBAN'],
      "IBAN_CONFIG": "1",
      /// ***
      "IFSC": "",
      "AGREE_TERMS": 1,
      "SECNO": result['p_per_info'][0][0]['SECNO'],
      "NAT_DESC": result['p_per_info'][0][0]['NAT_DESC'],
      "NAT": result['p_per_info'][0][0]['NAT'],
      "NAT_NO": result['p_per_info'][0][0]['NAT_NO'],
      "PERS_NO": result['p_per_info'][0][0]['PERS_NO'],
      "LAST_EST_NAME": null,
      "NAME1": result['p_per_info'][0][0]['NAME1'],
      "NAME2": result['p_per_info'][0][0]['NAME2'],
      "NAME3": result['p_per_info'][0][0]['NAME3'],
      "NAME4": result['p_per_info'][0][0]['NAME4'],
      "FULL_NAME_EN": result['p_per_info'][0][0]['FULL_NAME_EN'],
      "EMAIL": result['p_per_info'][0][0]['EMAIL'],
      "MOBILE": result['p_per_info'][0][0]['MOBILE'],
      "INTERNATIONAL_CODE": result['p_per_info'][0][0]['INTERNATIONAL_CODE'],
      "INSURED_ADDRESS": "",
      "MARITAL_STATUS": null,
      "REGDATE": null,
      "REGRATE": null,
      "LAST_SALARY": null,
      "LAST_STODATE": null,
      "ACTUAL_STODATE": null,
      "GENDER": result['p_per_info'][0][0]['GENDER'],
      "CIVIL_WORK_DOC": null,
      "MILITARY_WORK_DOC": null,
      "CIV_MIL_RETIRED_DOC": null,
      "PEN_START_DATE": null,
      "GOVERNORATE": null, /// city address
      "DETAILED_ADDRESS": null,
      "PASS_NO": null,
      "RESIDENCY_NO": null,
      "DOB": result['p_per_info'][0][0]['DOB'],
      "JOB_NO": null,
      "JOB_DESC": null,
      "ENAME1": null,
      "ENAME2": null,
      "ENAME3": null,
      "ENAME4": null,
      "LAST_EST_NO": null,
      "FAM_NO": null,
      "nextVaild": null,
      "wantAddFamily": null,
      "GENDER_DESC": result['p_per_info'][0][0]['GENDER_DESC'],
      "PI_EPAY": null,
      "INSURED": null,
      "SECNO_DEAD": "",
      "CARDNO": "",
      "NAT_NO_DEAD": "",
      "FULL_NAME_DEAD": "",
      "NET_PAY": result['p_per_info'][0][0]['NET_PAY'],
      "TYPE_OF_ADVANCE": '$typeOfAdvance',
      "OFFNO": result['p_per_info'][0][0]['OFFNO'],
      "DURATION": currentNumberOfInstallments,
      "TOT_PAY": result['p_per_info'][0][0]['TOT_PAY'],
      "OUT_DEBT": currentFinancialCommitment,
      "LOAN_AMT": currentLoanValue,
      "LAON_TYPE": "$loanType",
      "STARTDT": loanResultInfo['PO_STARTDT'],
      "MONTHLY_PAY_AMT": loanResultInfo['po_monthly_pay_amt'],
      "LOAN_PAID_AMT": loanResultInfo['po_loan_paid_amt'],
      "TOT_LOAN_AMT": loanResultInfo['po_loan_amt'],
      "nextValid": true,
      "DOC_FLG": result['p_per_info'][0][0]['DOC_FLG'],
      "PENCODE": result['p_per_info'][0][0]['PENCODE'],
      "PENSTART": result['p_per_info'][0][0]['PENSTARTnet'],
      "DUAL_FLG": result['p_per_info'][0][0]['DUAL_FLG'],
      "MAX_AMT": result['p_per_info'][0][0]['MAX_AMT'],
      "MAX_DUR": result['p_per_info'][0][0]['MAX_DUR'],
      "PREV_BAL": "",
      "LAST_PDATE": "",
      "RELAT": result['p_per_info'][0][0]['RELAT'],
      "RELAT_DESC": result['p_per_info'][0][0]['RELAT_DESC'],
      "BANK_DOC_FLG": loanResultInfo['po_bank_doc_flg'],
      "APPLICANT_ID": result['p_per_info'][0][0]['NAT_NO'],
      "APPLICANT_NO": result['p_per_info'][0][0]['NAT_NO'],
      "SERVICE_TYPE": 10,
      "IS_DEFENSE": null,
      "APP_STATUS_EXTERNAL": 2,
      "OTHER_DEPENDANTS": null,
      "ID": "",
      "LEAVE_START_DATE": null,
      "LEAVE_END_DATE": null,
      "BIRTH_DATE": null,
    };
    var data = {
      "params": {
        "XML": jsonEncode(
            {
              "row": row,
              "doc": docs,
              "dep": [], // value always [] in retirement loan
              "INHERITORS": [], // value always [] in retirement loan
              "isWebsite": false
            }
        )
      }
    };

    var response = await HTTPClientContract.instance.postHTTP(
        '/website/set_application', data
    );
    if (kDebugMode) {
      print(response);
    }
    if (response != null && response.statusCode == 200) {
      return jsonDecode(response.data);
    }
    return '';
  }
/// **************************************************************RETIREMENT LOAN  - END************************************************************************

}