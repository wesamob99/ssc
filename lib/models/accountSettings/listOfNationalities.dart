// To parse this JSON data, do
//
//     final listOfNationalities = listOfNationalitiesFromJson(jsonString);

// ignore_for_file: file_names

import 'dart:convert';

List<List<ListOfNationalities>> listOfNationalitiesFromJson(String str) => List<List<ListOfNationalities>>.from(json.decode(str).map((x) => List<ListOfNationalities>.from(x.map((x) => ListOfNationalities.fromJson(x)))));

String listOfNationalitiesToJson(List<List<ListOfNationalities>> data) => json.encode(List<dynamic>.from(data.map((x) => List<dynamic>.from(x.map((x) => x.toJson())))));

class ListOfNationalities {
  ListOfNationalities({
    this.natcode,
    this.natdesc,
    this.natdescEn,
    this.mandatoryPhone,
  });

  int natcode;
  String natdesc;
  String natdescEn;
  int mandatoryPhone;

  factory ListOfNationalities.fromJson(Map<String, dynamic> json) => ListOfNationalities(
    natcode: json["NATCODE"],
    natdesc: json["NATDESC"],
    natdescEn: json["NATDESC_EN"],
    mandatoryPhone: json["MANDATORY_PHONE"],
  );

  Map<String, dynamic> toJson() => {
    "NATCODE": natcode,
    "NATDESC": natdesc,
    "NATDESC_EN": natdescEn,
    "MANDATORY_PHONE": mandatoryPhone,
  };
}
