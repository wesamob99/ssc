// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:ssc/utilities/theme/themes.dart';

import '../../infrastructure/userConfig.dart';
import '../hexColor.dart';

class AppTheme {
  TextTheme textTheme(String theme) => TextTheme(
    headline6: TextStyle(
      color: theme == 'dark' ? Colors.white : HexColor('#363636'),
    ),
    bodyText2: TextStyle(
      color: theme == 'dark' ? Colors.white : HexColor('#363636'),
    ),
    bodyText1: TextStyle(
      color: theme == 'dark' ? Colors.white : HexColor('#363636'),
    ),
    headline1: TextStyle(
      color: theme == 'dark' ? Colors.white : HexColor('#363636'),
    ),
    headline2: TextStyle(
      color: theme == 'dark' ? Colors.white : HexColor('#363636'),
    ),
    headline3: TextStyle(
      color: theme == 'dark' ? Colors.white : HexColor('#363636'),
    ),
    headline4: TextStyle(
      color: theme == 'dark' ? Colors.white : HexColor('#363636'),
    ),
    headline5: TextStyle(
      color: theme == 'dark' ? Colors.white : HexColor('#363636'),
    ),
    subtitle1: TextStyle(
      color: theme == 'dark' ? Colors.white : HexColor('#363636'),
    ),
    subtitle2: TextStyle(
      color: theme == 'dark' ? Colors.white : HexColor('#363636'),
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
      titleTextStyle: TextStyle(
        fontFamily: UserConfig.instance.checkLanguage() ? 'Noor' : 'Noor',
      )
      // titleTextStyle: UserConfig.instance.checkLanguage()
      //     ? GoogleFonts.mukta()
      //     : GoogleFonts.tajawal(),
    ),
    scaffoldBackgroundColor: HexColor('#212121'),
    backgroundColor: HexColor('#212121'),
    fontFamily: UserConfig.instance.checkLanguage() ? 'Noor' : 'Noor',

    textTheme: textTheme('dark')
    // textTheme: UserConfig.instance.checkLanguage()
    //     ? GoogleFonts.muktaTextTheme().merge(textTheme)
    //     : GoogleFonts.tajawalTextTheme().merge(textTheme),
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
          iconTheme: const IconThemeData(color: Colors.white),
          titleTextStyle: TextStyle(
            fontFamily: UserConfig.instance.checkLanguage() ? 'Noor' : 'Noor',
          )
          // titleTextStyle: UserConfig.instance.checkLanguage()
          //     ? GoogleFonts.mukta()
          //     : GoogleFonts.tajawal(),
      ),
      fontFamily: UserConfig.instance.checkLanguage() ? 'Noor' : 'Noor',
      scaffoldBackgroundColor: const Color.fromRGBO(253, 253, 253, 1.0),
      backgroundColor: HexColor('#ffffff'),
      highlightColor: primaryColor,
      textTheme: textTheme('light'),
      // textTheme: UserConfig.instance.checkLanguage()
      //     ? GoogleFonts.muktaTextTheme()
      //     : GoogleFonts.tajawalTextTheme(),
      colorScheme:
      ColorScheme.fromSwatch().copyWith(secondary: orangeColorDark));
}
