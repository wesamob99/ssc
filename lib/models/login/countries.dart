// To parse this JSON data, do
//
//     final countries = countriesFromJson(jsonString);

import 'dart:convert';

List<Countries> countriesFromJson(String str) => List<Countries>.from(json.decode(str).map((x) => Countries.fromJson(x)));

String countriesToJson(List<Countries> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Countries {
  Countries({
    this.country,
    this.countryEn,
    this.callingCode,
    this.paymethodType,
    this.ibanLength,
    this.ibanStartWith,
    this.natcode,
  });

  final String country;
  final String countryEn;
  final String callingCode;
  final int paymethodType;
  final int ibanLength;
  final String ibanStartWith;
  final int natcode;

  factory Countries.fromJson(Map<String, dynamic> json) => Countries(
    country: json["country"],
    countryEn: json["country_en"],
    callingCode: json["calling_code"],
    paymethodType: json["PAYMETHOD_TYPE"],
    ibanLength: json["IBAN_LENGTH"],
    ibanStartWith: json["IBAN_START_WITH"],
    natcode: json["NATCODE"],
  );

  Map<String, dynamic> toJson() => {
    "country": country,
    "country_en": countryEn,
    "calling_code": callingCode,
    "PAYMETHOD_TYPE": paymethodType,
    "IBAN_LENGTH": ibanLength,
    "IBAN_START_WITH": ibanStartWith,
    "NATCODE": natcode,
  };
}
