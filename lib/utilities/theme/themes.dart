import 'package:flutter/material.dart';
import 'package:ssc/src/viewModel/utilities/theme/themeProvider.dart';

import '../hexColor.dart';
import 'package:provider/provider.dart';

Color primaryColor = HexColor('#445740');
Color primaryColorDark = HexColor('#013220');
Color headerColor = HexColor('#1379AA');
Color whiteColor = HexColor('#FFFFFF');
Color screenDefaultBackgroundColor = HexColor('#FFFFFF');
Color greyTransaction = HexColor('#00000029');
Color orangeColorLight = HexColor('#EABC29');
Color orangeColorDark = HexColor('#EA6924');
Color redColor = HexColor('#BA1515');
Color redColorTag = HexColor('#b51212');
Color greenColor = HexColor('#319F56');
Color borderGrey = HexColor('#CACACA');
Color blueColorLight = HexColor('#F6FCFF');
Color gray86 = HexColor('#DBDBDB');
Color spaceGray = HexColor('#F6F6F6');
Color lightBlue = HexColor('#909090');
Color borderSearch = HexColor('#E7E7E7');
Color grayForNote = HexColor('#DADADA');
Color testColor = HexColor('#4186E005');
Color cappuccinoColor = HexColor('#FFFAF9');

const MaterialColor materialWhite = MaterialColor(
  0xFFFFFFFF,
  <int, Color>{
    50: Color(0xFFFFFFFF),
    100: Color(0xFFFFFFFF),
    200: Color(0xFFFFFFFF),
    300: Color(0xFFFFFFFF),
    400: Color(0xFFFFFFFF),
    500: Color(0xFFFFFFFF),
    600: Color(0xFFFFFFFF),
    700: Color(0xFFFFFFFF),
    800: Color(0xFFFFFFFF),
    900: Color(0xFFFFFFFF),
  },
);

Color getPrimaryColor(BuildContext context, ThemeNotifier themeNotifier){
  return themeNotifier.isLight() ? primaryColor : primaryColorDark;
}

Color getRedColor(BuildContext context) {
  return context.read<ThemeNotifier>().isLight()
      ? HexColor('#BA1515')
      : Colors.white;
}

Color getOrangeDark(BuildContext context) {
  return context.read<ThemeNotifier>().isLight()
      ? HexColor('#EA6924')
      : Colors.white;
}

Color getOrangeLight(BuildContext context) {
  return context.read<ThemeNotifier>().isLight()
      ? HexColor('#EABC29')
      : Colors.white;
}

Color getBlueColorLight(BuildContext context) {
  return context.read<ThemeNotifier>().isLight()
      ? HexColor('#F6FCFF')
      : HexColor('#505050');
}

Color getGoodGray(BuildContext context) {
  return context.read<ThemeNotifier>().isLight()
      ? HexColor('#707070')
      : Colors.white;
}

Color getTextColor(BuildContext context) {
  return context.read<ThemeNotifier>().isLight() ? Colors.black : Colors.white;
}

Color getHeaderColor(BuildContext context) {
  return context.read<ThemeNotifier>().isLight()
      ? HexColor('#1379AA')
      : HexColor('#505050');
}

Color getDividerColor(BuildContext context) {
  return context.read<ThemeNotifier>().isLight()
      ? Colors.white
      : Colors.black12.withOpacity(0);
}

Color getBoardColor(BuildContext context) {
  return context.read<ThemeNotifier>().isLight()
      ? HexColor('#264250')
      : Colors.white;
}

Color getGrey1Color(BuildContext context) {
  return context.read<ThemeNotifier>().isLight()
      ? HexColor('#EFEFEF')
      : Colors.white;
}

Color getGrey2Color(BuildContext context) {
  return context.read<ThemeNotifier>().isLight()
      ? HexColor('#CCCCCC')
      : Colors.white;
}

Color getGrey3Color(BuildContext context) {
  return context.read<ThemeNotifier>().isLight()
      ? HexColor('#979797')
      : Colors.white;
}

Color getGrey4Color(BuildContext context) {
  return context.read<ThemeNotifier>().isLight()
      ? HexColor('#9C9C9C')
      : Colors.white;
}

Color getGrey5Color(BuildContext context) {
  return context.read<ThemeNotifier>().isLight()
      ? HexColor('#676767')
      : Colors.white;
}

Color getGrey6Color(BuildContext context) {
  return context.read<ThemeNotifier>().isLight()
      ? HexColor('#B7B7B7')
      : Colors.white;
}

Color getShadowColor(BuildContext context) {
  return context.read<ThemeNotifier>().isLight()
      ? HexColor('#121212')
      : Colors.black12;
}

Color getCardColor(BuildContext context) {
  return context.read<ThemeNotifier>().isLight()
      ? HexColor('#121212')
      : Colors.black12;
}

Color getContainerColor(BuildContext context) {
  return context.read<ThemeNotifier>().isLight()
      ? Colors.white
      : HexColor('#505050');
}

Color getContainerColorLevel2(BuildContext context) {
  return context.read<ThemeNotifier>().isLight()
      ? Colors.white
      : HexColor('#505050');
}

Color getGrayForNote(BuildContext context) {
  return context.read<ThemeNotifier>().isLight()
      ? HexColor('#DADADA')
      : Colors.white;
}

Color getGreenColor(BuildContext context) {
  return context.read<ThemeNotifier>().isLight()
      ? HexColor('#3bbf86')
      : HexColor('#3bbf86');
}

Color contactHeaderColor(BuildContext context) {
  return context.read<ThemeNotifier>().isLight()
      ? Colors.white
      : getContainerColorLevel2(context);
}

Color borderColorForSearch(BuildContext context) {
  return context.read<ThemeNotifier>().isLight() ? borderSearch : Colors.white;
}
