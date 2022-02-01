import 'package:delivery_m/core/enums/delivery_status.dart';
import 'package:flutter/material.dart';

class AppColors {
  

  static Color statusColor(String status){
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