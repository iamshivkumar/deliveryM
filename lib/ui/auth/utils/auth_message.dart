import 'package:flutter/material.dart';

class AuthMessage {
  String text;
  Color color;
  AuthMessage({
    required this.text,
    required this.color,
  });

  factory AuthMessage.empty() => AuthMessage(
        text: '',
        color: Colors.indigo,
      );
  factory AuthMessage.otpResent() => AuthMessage(
        text: 'OTP Resent',
        color: Colors.green,
      );
  factory AuthMessage.incorrectOtp() => AuthMessage(
        text: 'Incorrect OTP',
        color: Colors.red,
      );
}
