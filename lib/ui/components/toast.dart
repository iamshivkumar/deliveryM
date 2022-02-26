import 'package:delivery_m/ui/colors.dart';
import 'package:flutter/material.dart';

class Toast {
  static show(ScaffoldMessengerState state, String message) {
    state.showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Palette.primaryDark,
        behavior: SnackBarBehavior.floating,
      ),
    );
    // Fluttertoast.showToast(
    //   msg: message,
    //   backgroundColor: Palette.primaryDark,
    //   textColor: Colors.white,
    // );
  }

  static showWhite(ScaffoldMessengerState state, String message) {
    state.showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(
            color: Palette.primaryDark,
          ),
        ),
        backgroundColor: Colors.white,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
