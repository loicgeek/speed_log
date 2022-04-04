// ignore_for_file: avoid_function_literals_in_foreach_calls

import 'package:flutter/material.dart';

class AppColors {
  static const Color black = Color(0xFF020202);
  static const Color primary = Colors.pinkAccent; //285bd4
  //Color.fromRGBO(58, 133, 252, 1);
  static const Color primaryText = Color(0xFF404040);
  static const Color grayScale = Color(0xFF9099A6);
  static const Color primaryGrayText = Color.fromRGBO(51, 51, 51, 1);

  static MaterialColor createMaterialColor(Color color) {
    List strengths = <double>[.05];
    Map<int, Color> swatch = <int, Color>{};
    final int r = color.red, g = color.green, b = color.blue;

    for (int i = 1; i < 10; i++) {
      strengths.add(0.1 * i);
    }
    strengths.forEach((strength) {
      final double ds = 0.5 - strength;
      swatch[(strength * 1000).round()] = Color.fromRGBO(
        r + ((ds < 0 ? r : (255 - r)) * ds).round(),
        g + ((ds < 0 ? g : (255 - g)) * ds).round(),
        b + ((ds < 0 ? b : (255 - b)) * ds).round(),
        1,
      );
    });
    return MaterialColor(color.value, swatch);
  }

  static hexToColor(String hexString) {
    var hexColor = hexString.replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    if (hexColor.length == 8) {
      return Color(int.parse("0x$hexColor"));
    }
  }
}
