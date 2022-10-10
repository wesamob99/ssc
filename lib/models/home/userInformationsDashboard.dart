// To parse this JSON data, do
//
//     final userInformation = userInformationFromJson(jsonString);

// ignore_for_file: file_names

import 'dart:convert';

UserInformation userInformationFromJson(String str) => UserInformation.fromJson(json.decode(str));

String userInformationToJson(UserInformation data) => json.encode(data.toJson());

class UserInformation {
  UserInformation({
    this.curGetdata,
    this.poMonthsCount,
    this.poIdleBalance,
    this.poSalary,
    this.poRegPer,
    this.poRegAmt,
    this.success,
  });

  final List<dynamic> curGetdata;
  final int poMonthsCount;
  final dynamic poIdleBalance;
  final dynamic poSalary;
  final dynamic poRegPer;
  final dynamic poRegAmt;
  final bool success;

  factory UserInformation.fromJson(Map<String, dynamic> json) => UserInformation(
    curGetdata: json["cur_getdata"] == null ? null : List<dynamic>.from(json["cur_getdata"].map((x) => x)),
    poMonthsCount: json["po_months_count"],
    poIdleBalance: json["po_idle_balance"],
    poSalary: json["po_salary"],
    poRegPer: json["po_reg_per"],
    poRegAmt: json["po_reg_amt"],
    success: json["success"],
  );

  Map<String, dynamic> toJson() => {
    "cur_getdata": curGetdata == null ? null : List<dynamic>.from(curGetdata.map((x) => x)),
    "po_months_count": poMonthsCount,
    "po_idle_balance": poIdleBalance,
    "po_salary": poSalary,
    "po_reg_per": poRegPer,
    "po_reg_amt": poRegAmt,
    "success": success,
  };
}
