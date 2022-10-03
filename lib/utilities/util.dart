import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;
import 'language/appLocalizations.dart';

String getExtension(String url) {
  String reversed = url.split('').toList().reversed.join();
  String extension = reversed.substring(0, reversed.indexOf('.'));
  return extension.split('').toList().reversed.join();
}

double width(double value, BuildContext context) {
  return MediaQuery.of(context).size.width * value;
}

double height(double value, BuildContext context) {
  return MediaQuery.of(context).size.height * value;
}

navigator(BuildContext context, Widget screen) {
  Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (BuildContext context) => screen),
      ModalRoute.withName(''));
}

navigatorWithBack(BuildContext context, Widget screen) {
  return Navigator.push(
      context, MaterialPageRoute(builder: (context) => screen));
}

translate(String key, BuildContext context) {
  return AppLocalizations.of(context)?.translate(key) ?? "No Translate";
}

bool isHTML(String text) {
  return text.contains('!DOCTYPE html');
}

bool checkTextLanguage(String text) {
  List<String> items = [
    'a',
    'b',
    'c',
    'd',
    'e',
    'f',
    'g',
    'h',
    'i',
    'j',
    'k',
    'l',
    'm',
    'n',
    'o',
    'p',
    'q',
    'r',
    's',
    't',
    'u',
    'v',
    'w',
    'x',
    'y',
    'z',
    'A',
    'B',
    'C',
    'D',
    'E',
    'F',
    'G',
    'H',
    'I',
    'J',
    'K',
    'L',
    'M',
    'N'
    'O',
    'P',
    'Q',
    'R',
    'S',
    'T',
    'U',
    'V',
    'W',
    'X',
    'Y',
    'Z'
  ];
  bool found = false;
  for (var element in items) {
    if (text.contains(element)) {
      found = true;
    }
  }
  return found;
}

String? emailValidation(String value, BuildContext context) {
  return (value.isEmpty)
      ? AppLocalizations.of(context)?.translate('empty_email')
      : (!isEmail(value))
      ? AppLocalizations.of(context)?.translate('invalid_email')
      : null;
}

String? passwordValidation(String value, BuildContext context) {
  return (value.isEmpty)
      ? AppLocalizations.of(context)?.translate('Cant_leave_pass_empty')
      : (!isValidPassword(value))
      ? AppLocalizations.of(context)?.translate('invalid_password')
      : null;
}

bool isStringIsEmptyOrNull(String value) {
  return value.isEmpty ? true : false;
}

String? textValidation(String value, BuildContext context) {
  return (value.isEmpty)
      ? AppLocalizations.of(context)?.translate('text_empty')
      : null;
}

String progressValidation(String value, BuildContext context) {
  String progressValid = int.parse(value) < 0
      ? translate('progressLessThan0', context)
      : int.parse(value) > 100
      ? translate('progressGreaterThan100', context)
      : null;

  return progressValid;
}

bool isEmail(String email) {
  bool emailValid = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9\-]+\.[a-zA-Z]+")
      .hasMatch(email);
  return emailValid;
}

bool isValidPassword(String password) {
  bool passValid =
  RegExp(r"^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*#?&])[A-Za-z\d@$!%*#?&]{8,}$")
      .hasMatch(password);
  return passValid;
}

String joinPaths(String path1, String path2) {
  if (path2.startsWith('/')) {
    path2 = path2.substring(1);
    if (!path1.endsWith('/')) {
      path1 = '$path1/';
    }
  }
  return path.join(path1, path2);
}

String getCurrentTimeInMilliSeconds() {
  return DateTime.now().millisecondsSinceEpoch.toString();
}

bool isProbablyArabic(String s) {
  for (int i = 0; i < s.length;) {
    int c = s.codeUnitAt(i);
    if (c >= 0x0600 && c <= 0x06E0) return true;
    i += c.toString().runes.length;
  }
  return false;
}