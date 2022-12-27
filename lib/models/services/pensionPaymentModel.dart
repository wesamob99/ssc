// To parse this JSON data, do
//
//     final pensionPaymentModel = pensionPaymentModelFromJson(jsonString);

// ignore_for_file: file_names

import 'dart:convert';

PensionPaymentModel pensionPaymentModelFromJson(String str) => PensionPaymentModel.fromJson(json.decode(str));

String pensionPaymentModelToJson(PensionPaymentModel data) => json.encode(data.toJson());

class PensionPaymentModel {
  PensionPaymentModel({
    this.curGetdata,
    this.curGetdata1,
  });

  List<List<CurGetdatum>> curGetdata;
  List<List<CurGetdata1>> curGetdata1;

  factory PensionPaymentModel.fromJson(Map<String, dynamic> json) => PensionPaymentModel(
    curGetdata: List<List<CurGetdatum>>.from(json["cur_getdata"].map((x) => List<CurGetdatum>.from(x.map((x) => CurGetdatum.fromJson(x))))),
    curGetdata1: List<List<CurGetdata1>>.from(json["cur_getdata1"].map((x) => List<CurGetdata1>.from(x.map((x) => CurGetdata1.fromJson(x))))),
  );

  Map<String, dynamic> toJson() => {
    "cur_getdata": List<dynamic>.from(curGetdata.map((x) => List<dynamic>.from(x.map((x) => x.toJson())))),
    "cur_getdata1": List<dynamic>.from(curGetdata1.map((x) => List<dynamic>.from(x.map((x) => x.toJson())))),
  };
}

class CurGetdatum {
  CurGetdatum({
    this.secno,
    this.name1,
    this.name2,
    this.name3,
    this.name4,
    this.stardt,
    this.sal,
  });

  int secno;
  String name1;
  String name2;
  String name3;
  String name4;
  String stardt;
  dynamic sal;

  factory CurGetdatum.fromJson(Map<String, dynamic> json) => CurGetdatum(
    secno: json["SECNO"],
    name1: json["NAME1"],
    name2: json["NAME2"],
    name3: json["NAME3"],
    name4: json["NAME4"],
    stardt: json["STARDT"],
    sal: json["sal"],
  );

  Map<String, dynamic> toJson() => {
    "SECNO": secno,
    "NAME1": name1,
    "NAME2": name2,
    "NAME3": name3,
    "NAME4": name4,
    "STARDT": stardt,
    "sal": sal,
  };
}

class CurGetdata1 {
  CurGetdata1({
    this.cod,
    this.penType,
    this.mth,
    this.monthno,
    this.paymethod,
    this.netpay1,
  });

  String cod;
  int penType;
  String mth;
  int monthno;
  String paymethod;
  String netpay1;

  factory CurGetdata1.fromJson(Map<String, dynamic> json) => CurGetdata1(
    cod: json["COD"],
    penType: json["PEN_TYPE"],
    mth: json["MTH"],
    monthno: json["MONTHNO"],
    paymethod: json["PAYMETHOD"],
    netpay1: json["NETPAY1"],
  );

  Map<String, dynamic> toJson() => {
    "COD": cod,
    "PEN_TYPE": penType,
    "MTH": mth,
    "MONTHNO": monthno,
    "PAYMETHOD": paymethod,
    "NETPAY1": netpay1,
  };
}
