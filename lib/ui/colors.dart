import 'package:delivery_m/core/enums/delivery_status.dart';
import 'package:flutter/material.dart';

class AppColors {
  static Color statusColor(String status) {
    switch (status) {
      case DeliveryStatus.canceled:
        return Colors.red;
      case DeliveryStatus.delivered:
        return Colors.green;
      default:
        return Colors.amber;
    }
  }
}

class Palette {
  static const Color secondary = Color(0xFFC5FDED);
  static const Color background = Color(0xFFF3F6F8);
    static const Color primaryDark = Color(0xFF1B2A51);

  static const MaterialColor swatch = MaterialColor(
    0xff273969,
    <int, Color>{
      50: Color(0xffA6B5DE),
      100: Color(0xff6A83C8),
      200: Color(0xff4260B3),
      300: Color(0xff324886),
      400: Color(0xff273969),
      500: Color(0xff213059),
      600: Color(0xff1B2A51),
      700: Color(0xff14203D),
      800: Color(0xff0A101F),
      900: Color(0xff0A101F),
    },
  );
}
