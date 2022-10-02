import 'dart:convert';

UserData userDataFromJson(String str) => UserData.fromJson(json.decode(str));

String userDataToJson(UserData data) => json.encode(data.toJson());

class UserData {
  UserData({
    required this.data,
    required this.token,
  });

  Data data;
  String token;

  factory UserData.fromJson(Map<String, dynamic> json) => UserData(
    data: Data.fromJson(json["data"]),
    token: json["token"],
  );

  Map<String, dynamic> toJson() => {
    "data": data.toJson(),
    "token": token,
  };
}

class Data {
  Data({
    required this.poUserGroup,
    required this.poName,
    required this.poInternalKey,
    required this.poUserName,
    required this.poStatus,
    this.poStatusDescAr,
    this.poStatusDescEn,
    required this.curGetdata,
  });

  String poUserGroup;
  String poName;
  String poInternalKey;
  String poUserName;
  int poStatus;
  dynamic poStatusDescAr;
  dynamic poStatusDescEn;
  List<List<CurGetdatum>> curGetdata;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    poUserGroup: json["PO_USER_GROUP"],
    poName: json["PO_NAME"],
    poInternalKey: json["PO_INTERNAL_KEY"],
    poUserName: json["PO_USER_NAME"],
    poStatus: json["PO_STATUS"],
    poStatusDescAr: json["PO_STATUS_DESC_AR"],
    poStatusDescEn: json["PO_STATUS_DESC_EN"],
    curGetdata: List<List<CurGetdatum>>.from(json["cur_getdata"].map((x) => List<CurGetdatum>.from(x.map((x) => CurGetdatum.fromJson(x))))),
  );

  Map<String, dynamic> toJson() => {
    "PO_USER_GROUP": poUserGroup,
    "PO_NAME": poName,
    "PO_INTERNAL_KEY": poInternalKey,
    "PO_USER_NAME": poUserName,
    "PO_STATUS": poStatus,
    "PO_STATUS_DESC_AR": poStatusDescAr,
    "PO_STATUS_DESC_EN": poStatusDescEn,
    "cur_getdata": List<dynamic>.from(curGetdata.map((x) => List<dynamic>.from(x.map((x) => x.toJson())))),
  };
}

class CurGetdatum {
  CurGetdatum({
    required this.email,
    this.internationalcode,
    this.mobileno,
    this.token,
    required this.nationality,
    this.timeTo,
  });

  String email;
  dynamic internationalcode;
  dynamic mobileno;
  dynamic token;
  int nationality;
  dynamic timeTo;

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
