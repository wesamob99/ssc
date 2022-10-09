// To parse this JSON data, do
//
//     final userData = userDataFromJson(jsonString);

// ignore_for_file: file_names

import 'dart:convert';

UserData userDataFromJson(String str) => UserData.fromJson(json.decode(str));

String userDataToJson(UserData data) => json.encode(data.toJson());

class UserData {
  UserData({
    this.data,
    this.token,
    this.poStatusDescEn,
    this.poStatusDescAr
  });
// ['PO_STATUS_DESC_EN']
  final Data data;
  final String token;
  final String poStatusDescEn;
  final String poStatusDescAr;

  factory UserData.fromJson(Map<String, dynamic> json) => UserData(
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
    token: json["token"],
    poStatusDescEn: json["PO_STATUS_DESC_EN"],
    poStatusDescAr: json["PO_STATUS_DESC_AR"],
  );

  Map<String, dynamic> toJson() => {
    // ignore: prefer_null_aware_operators
    "data": data == null ? null : data.toJson(),
    "token": token,
    "PO_STATUS_DESC_EN": poStatusDescEn,
    "PO_STATUS_DESC_AR": poStatusDescAr,
  };
}

class Data {
  Data({
    this.poUserGroup,
    this.poName,
    this.poInternalKey,
    this.poUserName,
    this.poStatus,
    this.poStatusDescAr,
    this.poStatusDescEn,
    this.curGetdata,
  });

  final String poUserGroup;
  final String poName;
  final dynamic poInternalKey;
  final String poUserName;
  final int poStatus;
  final dynamic poStatusDescAr;
  final dynamic poStatusDescEn;
  final List<List<CurGetdatum>> curGetdata;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    poUserGroup: json["PO_USER_GROUP"],
    poName: json["PO_NAME"],
    poInternalKey: json["PO_INTERNAL_KEY"],
    poUserName: json["PO_USER_NAME"],
    poStatus: json["PO_STATUS"],
    poStatusDescAr: json["PO_STATUS_DESC_AR"],
    poStatusDescEn: json["PO_STATUS_DESC_EN"],
    curGetdata: json["cur_getdata"] == null ? null : List<List<CurGetdatum>>.from(json["cur_getdata"].map((x) => List<CurGetdatum>.from(x.map((x) => CurGetdatum.fromJson(x))))),
  );

  Map<String, dynamic> toJson() => {
    "PO_USER_GROUP": poUserGroup,
    "PO_NAME": poName,
    "PO_INTERNAL_KEY": poInternalKey,
    "PO_USER_NAME": poUserName,
    "PO_STATUS": poStatus,
    "PO_STATUS_DESC_AR": poStatusDescAr,
    "PO_STATUS_DESC_EN": poStatusDescEn,
    "cur_getdata": curGetdata == null ? null : List<dynamic>.from(curGetdata.map((x) => List<dynamic>.from(x.map((x) => x.toJson())))),
  };
}

class CurGetdatum {
  CurGetdatum({
    this.email,
    this.internationalcode,
    this.mobileno,
    this.token,
    this.nationality,
    this.timeTo,
  });

  final String email;
  final dynamic internationalcode;
  final dynamic mobileno;
  final dynamic token;
  final int nationality;
  final dynamic timeTo;

  factory CurGetdatum.fromJson(Map<String, dynamic> json) => CurGetdatum(
    email: json["EMAIL"],
    internationalcode: json["INTERNATIONALCODE"],
    mobileno: json["MOBILENO"],
    token: json["TOKEN"],
    nationality: json["NATIONALITY"],
    timeTo: json["TIME_TO"],
  );

  Map<String, dynamic> toJson() => {
    "EMAIL": email,
    "INTERNATIONALCODE": internationalcode,
    "MOBILENO": mobileno,
    "TOKEN": token,
    "NATIONALITY": nationality,
    "TIME_TO": timeTo,
  };
}
