import 'package:cloud_firestore/cloud_firestore.dart';

class Address {
  final String number;
  final String area;
  final String city;
  final GeoPoint point;
  final String formated;

  Address({
    required this.number,
    required this.area,
    required this.city,
    required this.point,
    required this.formated,
  });

  Address copyWith({
    String? number,
    String? area,
    String? city,
    GeoPoint? point,
    String? formated,
  }) {
    return Address(
      number: number ?? this.number,
      area: area ?? this.area,
      city: city ?? this.city,
      point: point ?? this.point,
      formated: formated ?? this.formated,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'number': number,
      'area': area,
      'city': city,
      'point': point,
    };
  }

  factory Address.fromMap(Map<String, dynamic> map) {
    return Address(
      number: map['number'],
      area: map['area'],
      city: map['city'],
      point: map['point'],
      formated: "${map['number']}, ${map["area"]}, ${map['city']}",
    );
  }

  bool get isEmpty => area.isEmpty && city.isEmpty && number.isEmpty;

  static Address empty() => Address(
      area: '',
      city: '',
      number: '',
      point: const GeoPoint(0, 0),
      formated: '');
}
