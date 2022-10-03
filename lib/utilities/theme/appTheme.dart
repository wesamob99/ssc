import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ssc/utilities/theme/themes.dart';

import '../../infrastructure/userConfig.dart';
import '../hexColor.dart';

class AppTheme {
  TextTheme textTheme = const TextTheme(
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
  );
  get darkTheme => ThemeData(
    brightness: Brightness.dark,
    primarySwatch: Colors.red,
    //accentColor: Colors.amber,
    appBarTheme: AppBarTheme(
      color: HexColor('#013220'),
      centerTitle: true,
      elevation: 0,
      titleTextStyle: UserConfig.instance.checkLanguage()
          ? GoogleFonts.mukta()
          : GoogleFonts.tajawal(),
    ),
    scaffoldBackgroundColor: HexColor('#212121'),
    backgroundColor: HexColor('#212121'),
    fontFamily:
    UserConfig.instance.checkLanguage() ? 'nunito' : 'sans_full',
    textTheme: UserConfig.instance.checkLanguage()
        ? GoogleFonts.muktaTextTheme().merge(textTheme)
        : GoogleFonts.tajawalTextTheme().merge(textTheme),
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
          titleTextStyle: UserConfig.instance.checkLanguage()
              ? GoogleFonts.mukta()
              : GoogleFonts.tajawal(),
      ),
      fontFamily: UserConfig.instance.checkLanguage() ? 'nunito' : 'sans_full',
      scaffoldBackgroundColor: Colors.grey.shade100,
      backgroundColor: HexColor('#ffffff'),
      highlightColor: primaryColor,
      textTheme: UserConfig.instance.checkLanguage()
          ? GoogleFonts.muktaTextTheme()
          : GoogleFonts.tajawalTextTheme(),
      colorScheme:
      ColorScheme.fromSwatch().copyWith(secondary: orangeColorDark));
}
