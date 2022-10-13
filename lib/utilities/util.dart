import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:path/path.dart' as path;
import 'package:provider/provider.dart';
import 'package:ssc/src/viewModel/utilities/theme/themeProvider.dart';
import 'package:ssc/utilities/theme/themes.dart';
import '../src/view/login/forgotPasswordScreen.dart';
import 'hexColor.dart';
import 'language/appLocalizations.dart';
import 'dart:ui' as ui;

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

String emailValidation(String value, BuildContext context) {
  return (value.isEmpty)
      ? AppLocalizations.of(context)?.translate('empty_email')
      : (!isEmail(value))
      ? AppLocalizations.of(context)?.translate('invalid_email')
      : null;
}

String passwordValidation(String value, BuildContext context) {
  return (value.isEmpty)
      ? AppLocalizations.of(context)?.translate('Cant_leave_pass_empty')
      : (!isValidPassword(value))
      ? AppLocalizations.of(context)?.translate('invalid_password')
      : null;
}

bool isStringIsEmptyOrNull(String value) {
  return value.isEmpty ? true : false;
}

String textValidation(String value, BuildContext context) {
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

Widget somethingWrongWidget(BuildContext context, String title, String desc){
  ThemeNotifier themeNotifier = context.read<ThemeNotifier>();
  return Container(
    // height: height(0.25, context),
    alignment: Alignment.center,
    child: Card(
      color: getPrimaryColor(context, themeNotifier).withOpacity(0.4),
      elevation: 8.0,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: width(0.05, context),
          vertical: height(0.035, context)
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: height(0.01, context),
            ),
            Center(
              child: SvgPicture.asset(
                'assets/icons/loginError.svg',
                height: width(0.18, context),
              ),
            ),
            SizedBox(
              height: height(0.01, context),
            ),
            Text(
              translate(title, context),
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: width(0.04, context)
              ),
            ),
            SizedBox(
              height: height(0.01, context),
            ),
            Text(
              translate(desc, context),
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: width(0.04, context)
              ),
            )
          ],
        ),
      ),
    ),
  );
}

Future<void> showMyDialog(
    BuildContext context,
    String title,
    String body,
    String buttonText,
    ThemeNotifier themeNotifier,
    {exceedAttempts = false,
    titleColor = '#ED3124',
    icon = 'assets/icons/loginError.svg'}
    ) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: true,
    barrierColor: Colors.white24,
    builder: (BuildContext context) {
      return BackdropFilter(
        filter: ui.ImageFilter.blur(
          sigmaX: 7.0,
          sigmaY: 7.0,
        ),
        child: AlertDialog(
          elevation: 20,
          alignment: Alignment.center,
          actionsAlignment: MainAxisAlignment.center,
          iconPadding: EdgeInsets.symmetric(vertical: height(0.035, context)),
          contentPadding: EdgeInsets.symmetric(
            horizontal: width(0.07, context),
            vertical: height(0.025, context),
          ),
          actionsPadding: EdgeInsets.symmetric(
              vertical: height(0.03, context),
              horizontal: width(0.07, context)
          ).copyWith(top: 0),
          icon: SvgPicture.asset(icon, height: height(0.1, context),),
          title: Padding(
            padding: EdgeInsets.symmetric(horizontal: width(0.03, context)),
            child: Text(
              translate(title, context),
              style: TextStyle(
                  color: HexColor(titleColor),
                  fontWeight: FontWeight.bold
              ),
            ),
          ),
          content: body != ''
              ? SingleChildScrollView(
              child: Container(
                alignment: Alignment.center,
                child: Text(
                  body,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: HexColor('#5F5F5F'),
                      fontWeight: FontWeight.w500
                  ),
                ),
              )
          ) : const SizedBox.shrink(),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                if(exceedAttempts){
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context)=> const ForgotPasswordScreen()),
                  );
                }else{
                  Navigator.of(context).pop();
                }
              },
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                    getPrimaryColor(context, themeNotifier),
                  ),
                  foregroundColor:  MaterialStateProperty.all<Color>(
                      Colors.white
                  ),
                  fixedSize:  MaterialStateProperty.all<Size>(
                    Size(width(1, context), height(0.05, context)),
                  ),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)
                      )
                  )
              ),
              child: Text(translate(buttonText, context)),
            ),
          ],
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
          ),
        ),
      );
    },
  );
}
