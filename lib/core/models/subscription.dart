import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import 'package:delivery_m/core/models/delivery.dart';

class Subscription {
  final String id;
  final String eId;
  final String customerId;
  final bool recure;
  final bool active;

  final String name;
  final String image;
  final double price;

  final DateTime startDate;
  final DateTime endDate;
  final List<Delivery> deliveries;

  Subscription({
    required this.id,
    required this.eId,
    required this.customerId,
    required this.recure,
    required this.active,
    required this.name,
    required this.image,
    required this.price,
    required this.startDate,
    required this.endDate,
    required this.deliveries,
  });

  Subscription copyWith({
    String? id,
    String? eId,
    String? customerId,
    bool? recure,
    bool? active,
    String? name,
    String? image,
    double? price,
    DateTime? startDate,
    DateTime? endDate,
    List<Delivery>? deliveries,
  }) {
    return Subscription(
      id: id ?? this.id,
      eId: eId ?? this.eId,
      customerId: customerId ?? this.customerId,
      recure: recure ?? this.recure,
      active: active ?? this.active,
      name: name ?? this.name,
      image: image ?? this.image,
      price: price ?? this.price,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      deliveries: deliveries ?? this.deliveries,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'eId': eId,
      'customerId': customerId,
      'recure': recure,
      'active': active,
      'name': name,
      'image': image,
      'price': price,
      'startDate': Timestamp.fromDate(startDate),
      'endDate': Timestamp.fromDate(endDate),
      'deliveries': deliveries.map((x) => x.toMap()).toList(),
    };
  }

  factory Subscription.fromMap(DocumentSnapshot doc) {
    final Map<String, dynamic> map = doc.data() as Map<String, dynamic>;
    return Subscription(
      id: doc.id,
      eId: map['eId'],
      customerId: map['customerId'],
      recure: map['recure'],
      active: map['active'],
      name: map['name'],
      image: map['image'],
      price: map['price'].toDouble(),
      startDate: map['startDate'].toDate(),
      endDate: map['endDate'].toDate(),
      deliveries: List<Delivery>.from(
          map['deliveries'].map((x) => Delivery.fromMap(x))),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Subscription &&
        other.id == id &&
        other.eId == eId &&
        other.customerId == customerId &&
        other.recure == recure &&
        other.active == active &&
        other.name == name &&
        other.image == image &&
        other.price == price &&
        other.startDate == startDate &&
        other.endDate == endDate &&
        listEquals(other.deliveries, deliveries);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        eId.hashCode ^
        customerId.hashCode ^
        recure.hashCode ^
        active.hashCode ^
        name.hashCode ^
        image.hashCode ^
        price.hashCode ^
        startDate.hashCode ^
        endDate.hashCode ^
        deliveries.hashCode;
  }
}
