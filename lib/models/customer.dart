import 'package:delivery_m/models/address.dart';
import 'package:flutter/material.dart';

class Customer {
  final String id;
  final String eId;
  final String name;
  final String mobile;
  final Address address;

  Customer({
    required this.id,
    required this.eId,
    required this.name,
    required this.mobile,
    required this.address,
  });
}
