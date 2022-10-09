// To parse this JSON data, do
//
//     final userProfileData = userProfileDataFromJson(jsonString);

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
    userName: json["USER_NAME"] == null ? null : json["USER_NAME"],
    insuranceno: json["INSURANCENO"],
    firstname: json["FIRSTNAME"] == null ? null : json["FIRSTNAME"],
    fathername: json["FATHERNAME"] == null ? null : json["FATHERNAME"],
    grandfathername: json["GRANDFATHERNAME"] == null ? null : json["GRANDFATHERNAME"],
    familyname: json["FAMILYNAME"] == null ? null : json["FAMILYNAME"],
    nationality: json["NATIONALITY"] == null ? null : json["NATIONALITY"],
    nationalid: json["NATIONALID"] == null ? null : json["NATIONALID"],
    personalnumber: json["PERSONALNUMBER"],
    dateofbirth: json["DATEOFBIRTH"] == null ? null : json["DATEOFBIRTH"],
    gender: json["GENDER"] == null ? null : json["GENDER"],
    livecontry: json["LIVECONTRY"] == null ? null : json["LIVECONTRY"],
    internationalcode: json["INTERNATIONALCODE"] == null ? null : json["INTERNATIONALCODE"],
    mobilenumber: json["MOBILENUMBER"] == null ? null : json["MOBILENUMBER"],
    internationalcode2: json["INTERNATIONALCODE2"],
    mobilenumber2: json["MOBILENUMBER2"],
    nationalityCode: json["NATIONALITY_CODE"] == null ? null : json["NATIONALITY_CODE"],
    email: json["EMAIL"] == null ? null : json["EMAIL"],
    activateddate: json["ACTIVATEDDATE"] == null ? null : json["ACTIVATEDDATE"],
    registereddate: json["REGISTEREDDATE"] == null ? null : json["REGISTEREDDATE"],
    iban: json["IBAN"] == null ? null : json["IBAN"],
    academiclevel: json["ACADEMICLEVEL"] == null ? null : json["ACADEMICLEVEL"],
    bankNo: json["BANK_NO"] == null ? null : json["BANK_NO"],
    bankbranchCode: json["BANKBRANCH_CODE"] == null ? null : json["BANKBRANCH_CODE"],
    ename1: json["ENAME1"] == null ? null : json["ENAME1"],
    ename2: json["ENAME2"] == null ? null : json["ENAME2"],
    ename3: json["ENAME3"] == null ? null : json["ENAME3"],
    ename4: json["ENAME4"] == null ? null : json["ENAME4"],
  );

  Map<String, dynamic> toJson() => {
    "USER_NAME": userName == null ? null : userName,
    "INSURANCENO": insuranceno,
    "FIRSTNAME": firstname == null ? null : firstname,
    "FATHERNAME": fathername == null ? null : fathername,
    "GRANDFATHERNAME": grandfathername == null ? null : grandfathername,
    "FAMILYNAME": familyname == null ? null : familyname,
    "NATIONALITY": nationality == null ? null : nationality,
    "NATIONALID": nationalid == null ? null : nationalid,
    "PERSONALNUMBER": personalnumber,
    "DATEOFBIRTH": dateofbirth == null ? null : dateofbirth,
    "GENDER": gender == null ? null : gender,
    "LIVECONTRY": livecontry == null ? null : livecontry,
    "INTERNATIONALCODE": internationalcode == null ? null : internationalcode,
    "MOBILENUMBER": mobilenumber == null ? null : mobilenumber,
    "INTERNATIONALCODE2": internationalcode2,
    "MOBILENUMBER2": mobilenumber2,
    "NATIONALITY_CODE": nationalityCode == null ? null : nationalityCode,
    "EMAIL": email == null ? null : email,
    "ACTIVATEDDATE": activateddate == null ? null : activateddate,
    "REGISTEREDDATE": registereddate == null ? null : registereddate,
    "IBAN": iban == null ? null : iban,
    "ACADEMICLEVEL": academiclevel == null ? null : academiclevel,
    "BANK_NO": bankNo == null ? null : bankNo,
    "BANKBRANCH_CODE": bankbranchCode == null ? null : bankbranchCode,
    "ENAME1": ename1 == null ? null : ename1,
    "ENAME2": ename2 == null ? null : ename2,
    "ENAME3": ename3 == null ? null : ename3,
    "ENAME4": ename4 == null ? null : ename4,
  };
}
