// To parse this JSON data, do
//
//     final userProfileData = userProfileDataFromJson(jsonString);

// ignore_for_file: file_names

import 'dart:convert';

UserProfileData userProfileDataFromJson(String str) => UserProfileData.fromJson(json.decode(str));

String userProfileDataToJson(UserProfileData data) => json.encode(data.toJson());

class UserProfileData {
  UserProfileData({
    this.curGetdata,
  });

  final List<List<CurGetdatum>> curGetdata;

  factory UserProfileData.fromJson(Map<String, dynamic> json) => UserProfileData(
    curGetdata: json["CUR_getdata"] == null ? null : List<List<CurGetdatum>>.from(json["CUR_getdata"].map((x) => List<CurGetdatum>.from(x.map((x) => CurGetdatum.fromJson(x))))),
  );

  Map<String, dynamic> toJson() => {
    "CUR_getdata": curGetdata == null ? null : List<dynamic>.from(curGetdata.map((x) => List<dynamic>.from(x.map((x) => x.toJson())))),
  };
}

class CurGetdatum {
  CurGetdatum({
    this.userName,
    this.insuranceno,
    this.firstname,
    this.fathername,
    this.grandfathername,
    this.familyname,
    this.nationality,
    this.nationalid,
    this.personalnumber,
    this.dateofbirth,
    this.gender,
    this.livecontry,
    this.internationalcode,
    this.mobilenumber,
    this.internationalcode2,
    this.mobilenumber2,
    this.nationalityCode,
    this.email,
    this.activateddate,
    this.registereddate,
    this.iban,
    this.academiclevel,
    this.bankNo,
    this.bankbranchCode,
    this.ename1,
    this.ename2,
    this.ename3,
    this.ename4,
  });

  final String userName;
  final dynamic insuranceno;
  final String firstname;
  final String fathername;
  final String grandfathername;
  final String familyname;
  final int nationality;
  final int nationalid;
  final dynamic personalnumber;
  final String dateofbirth;
  final String gender;
  final int livecontry;
  final int internationalcode;
  final int mobilenumber;
  final dynamic internationalcode2;
  final dynamic mobilenumber2;
  final int nationalityCode;
  final String email;
  final String activateddate;
  final String registereddate;
  final String iban;
  final int academiclevel;
  final int bankNo;
  final String bankbranchCode;
  final String ename1;
  final String ename2;
  final String ename3;
  final String ename4;

  factory CurGetdatum.fromJson(Map<String, dynamic> json) => CurGetdatum(
    userName: json["USER_NAME"],
    insuranceno: json["INSURANCENO"],
    firstname: json["FIRSTNAME"],
    fathername: json["FATHERNAME"],
    grandfathername: json["GRANDFATHERNAME"],
    familyname: json["FAMILYNAME"],
    nationality: json["NATIONALITY"],
    nationalid: json["NATIONALID"],
    personalnumber: json["PERSONALNUMBER"],
    dateofbirth: json["DATEOFBIRTH"],
    gender: json["GENDER"],
    livecontry: json["LIVECONTRY"],
    internationalcode: json["INTERNATIONALCODE"],
    mobilenumber: json["MOBILENUMBER"],
    internationalcode2: json["INTERNATIONALCODE2"],
    mobilenumber2: json["MOBILENUMBER2"],
    nationalityCode: json["NATIONALITY_CODE"],
    email: json["EMAIL"],
    activateddate: json["ACTIVATEDDATE"],
    registereddate: json["REGISTEREDDATE"],
    iban: json["IBAN"],
    academiclevel: json["ACADEMICLEVEL"],
    bankNo: json["BANK_NO"],
    bankbranchCode: json["BANKBRANCH_CODE"],
    ename1: json["ENAME1"],
    ename2: json["ENAME2"],
    ename3: json["ENAME3"],
    ename4: json["ENAME4"],
  );

  Map<String, dynamic> toJson() => {
    "USER_NAME": userName,
    "INSURANCENO": insuranceno,
    "FIRSTNAME": firstname,
    "FATHERNAME": fathername,
    "GRANDFATHERNAME": grandfathername,
    "FAMILYNAME": familyname,
    "NATIONALITY": nationality,
    "NATIONALID": nationalid,
    "PERSONALNUMBER": personalnumber,
    "DATEOFBIRTH": dateofbirth,
    "GENDER": gender,
    "LIVECONTRY": livecontry,
    "INTERNATIONALCODE": internationalcode,
    "MOBILENUMBER": mobilenumber,
    "INTERNATIONALCODE2": internationalcode2,
    "MOBILENUMBER2": mobilenumber2,
    "NATIONALITY_CODE": nationalityCode,
    "EMAIL": email,
    "ACTIVATEDDATE": activateddate,
    "REGISTEREDDATE": registereddate,
    "IBAN": iban,
    "ACADEMICLEVEL": academiclevel,
    "BANK_NO": bankNo,
    "BANKBRANCH_CODE": bankbranchCode,
    "ENAME1": ename1,
    "ENAME2": ename2,
    "ENAME3": ename3,
    "ENAME4": ename4,
  };
}
