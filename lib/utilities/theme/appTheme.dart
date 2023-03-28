// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:ssc/utilities/theme/themes.dart';

import '../../infrastructure/userConfig.dart';
import '../hexColor.dart';

class AppTheme {
  TextTheme textTheme(String theme) => TextTheme(
    titleLarge: TextStyle(
      color: theme == 'dark' ? Colors.white : HexColor('#363636'),
      height: 1.1,
    ),
    bodyMedium: TextStyle(
      color: theme == 'dark' ? Colors.white : HexColor('#363636'),
      height: 1.1,
    ),
    bodyLarge: TextStyle(
      color: theme == 'dark' ? Colors.white : HexColor('#363636'),
      height: 1.1,
    ),
    displayLarge: TextStyle(
      color: theme == 'dark' ? Colors.white : HexColor('#363636'),
      height: 1.1,
    ),
    displayMedium: TextStyle(
      color: theme == 'dark' ? Colors.white : HexColor('#363636'),
      height: 1.1,
    ),
    displaySmall: TextStyle(
      color: theme == 'dark' ? Colors.white : HexColor('#363636'),
      height: 1.1,
    ),
    headlineMedium: TextStyle(
      color: theme == 'dark' ? Colors.white : HexColor('#363636'),
      height: 1.1,
    ),
    headlineSmall: TextStyle(
      color: theme == 'dark' ? Colors.white : HexColor('#363636'),
      height: 1.1,
    ),
    titleMedium: TextStyle(
      color: theme == 'dark' ? Colors.white : HexColor('#363636'),
      height: 1.1,
    ),
    titleSmall: TextStyle(
      color: theme == 'dark' ? Colors.white : HexColor('#363636'),
      height: 1.1,
    ),
  );
  get darkTheme => ThemeData(
    //accentColor: Colors.amber,
    appBarTheme: AppBarTheme(
      color: HexColor('#1c2e19'),
      centerTitle: true,
      elevation: 0,
      titleTextStyle: TextStyle(
        fontFamily: UserConfig.instance.isLanguageEnglish() ? 'literata' : 'Noor',
      )
    ),
    scaffoldBackgroundColor: HexColor('#212121'),
    fontFamily: UserConfig.instance.isLanguageEnglish() ? 'literata' : 'Noor',
    highlightColor: primaryColorDark,
    textTheme: textTheme('dark'),
    colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.red, brightness: Brightness.dark).copyWith(background: HexColor('#212121'))
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
            fontFamily: UserConfig.instance.isLanguageEnglish() ? 'literata' : 'Noor',
          )
      ),
      fontFamily: UserConfig.instance.isLanguageEnglish() ? 'literata' : 'Noor',
      scaffoldBackgroundColor: const Color.fromRGBO(250, 250, 250, 1.0),
      highlightColor: primaryColor,
      textTheme: textTheme('light'),
      colorScheme: ColorScheme.fromSwatch(brightness: Brightness.light).copyWith(secondary: orangeColorDark, background: HexColor('#ffffff')));
}
