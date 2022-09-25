import 'package:flutter/material.dart';
import 'package:ssc/utilities/theme/themes.dart';

import '../../infrastructure/userConfig.dart';
import '../hexColor.dart';

class AppTheme {
  get darkTheme => ThemeData(
    brightness: Brightness.dark,
    primarySwatch: Colors.red,
    //accentColor: Colors.amber,
    appBarTheme: AppBarTheme(
      color: HexColor('#013220'),
      centerTitle: true,
      elevation: 0
    ),
    scaffoldBackgroundColor: HexColor('#212121'),
    backgroundColor: HexColor('#212121'),
    primaryTextTheme: const TextTheme(
      headline6: TextStyle(
        color: Colors.white,
      ),
      bodyText2: TextStyle(
        color: Colors.white,
      ),
      bodyText1: TextStyle(
        color: Colors.white,
      ),
      headline1: TextStyle(
        color: Colors.white,
      ),
      headline2: TextStyle(
        color: Colors.white,
      ),
      headline3: TextStyle(
        color: Colors.white,
      ),
      headline4: TextStyle(
        color: Colors.white,
      ),
      headline5: TextStyle(
        color: Colors.white,
      ),
      subtitle1: TextStyle(
        color: Colors.white,
      ),
      subtitle2: TextStyle(
        color: Colors.white,
      ),
    ),
    fontFamily:
    UserConfig.instance.checkLanguage() ? 'nunito' : 'sans_full',
  );

  get lightTheme => ThemeData(
      brightness: Brightness.light,
      primaryColor: materialWhite,
      inputDecorationTheme: const InputDecorationTheme(
        labelStyle: TextStyle(color: Colors.grey),
        hintStyle: TextStyle(color: Colors.grey),
      ),
      appBarTheme: AppBarTheme(
          color: HexColor('#445740'),
          centerTitle: true,
          elevation: 0,
          actionsIconTheme: const IconThemeData(color: Colors.black),
          iconTheme: const IconThemeData(color: Colors.black),
          titleTextStyle: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18,
              fontFamily: UserConfig.instance.checkLanguage() ? 'nunito' : 'sans_full'
          )
      ),
      primaryTextTheme: const TextTheme(
        headline6: TextStyle(
          color: Colors.black,
        ),
        bodyText2: TextStyle(
          color: Colors.black,
        ),
        bodyText1: TextStyle(
          color: Colors.black,
        ),
        headline1: TextStyle(
          color: Colors.black,
        ),
        headline2: TextStyle(
          color: Colors.black,
        ),
        headline3: TextStyle(
          color: Colors.black,
        ),
        headline4: TextStyle(
          color: Colors.black,
        ),
        headline5: TextStyle(
          color: Colors.black,
        ),
        subtitle1: TextStyle(
          color: Colors.black,
        ),
        subtitle2: TextStyle(
          color: Colors.black,
        ),
      ),
      fontFamily: UserConfig.instance.checkLanguage() ? 'nunito' : 'sans_full',
      scaffoldBackgroundColor: HexColor('#ffffff'),
      backgroundColor: HexColor('#ffffff'),
      highlightColor: primaryColor,
      colorScheme:
      ColorScheme.fromSwatch().copyWith(secondary: orangeColorDark));
}
