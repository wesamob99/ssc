// ignore_for_file: file_names

import 'dart:ui';

class HexColor extends Color {
  static int getColorFromHex(String hexColor) {
    if (hexColor.isEmpty) {
      hexColor = '#FFFFFF';
    }
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF$hexColor";
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(getColorFromHex(hexColor));
}
