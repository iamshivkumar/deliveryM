import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery_m/core/models/product.dart';

import 'delivery.dart';
import '../../utils/formats.dart';

class Subscription {
  // final int version;
  final String id;
  final String eId;
  final String customerId;
  final bool recure;
  final bool active;

  final int quantity;

  final Product product;
  final int? returnKitsQt;
  final DateTime startDate;
  final DateTime endDate;
  final List<Delivery> deliveries;
  final List<String> dates;
  final String type;
  final String dId;
  final String key;

  Subscription({
    required this.id,
    required this.eId,
    required this.customerId,
    required this.recure,
    required this.active,
    required this.startDate,
    required this.endDate,
    required this.deliveries,
    required this.dates,
    required this.dId,
    required this.type,
    required this.quantity,
    required this.product,
    required this.key,
    // required this.version,
    this.returnKitsQt,
  });

  Subscription copyWith({
    String? id,
    String? eId,
    String? customerId,
    bool? recure,
    bool? active,
    DateTime? startDate,
    DateTime? endDate,
    List<Delivery>? deliveries,
    List<String>? dates,
    String? dId,
    int? returnKitsQt,
    String? type,
    int? quantity,
    Product? product,
  }) {
    return Subscription(
      id: id ?? this.id,
      eId: eId ?? this.eId,
      customerId: customerId ?? this.customerId,
      recure: recure ?? this.recure,
      active: active ?? this.active,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      deliveries: deliveries ?? this.deliveries,
      dates: dates ?? this.dates,
      dId: dId ?? this.dId,
      returnKitsQt: returnKitsQt,
      type: type ?? this.type,
      quantity: quantity ?? this.quantity,
      product: product ?? this.product,
      key: key,
      // version: version
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'eId': eId,
      'customerId': customerId,
      'recure': recure,
      'active': active,
      'product': product.toMap(),
      'startDate': Timestamp.fromDate(startDate),
      'endDate': Timestamp.fromDate(endDate),
      'deliveries': deliveries.map((x) => x.toMap()).toList(),
      'dates': dates,
      'dId': dId,
      'returnKitsQt': returnKitsQt,
      'type': type,
      'quantity': quantity,
      'key':key,
    };
  }

  factory Subscription.fromFirestore(DocumentSnapshot doc) {
    final Map<String, dynamic> map = doc.data() as Map<String, dynamic>;
    return Subscription(
      id: doc.id,
      eId: map['eId'],
      customerId: map['customerId'],
      recure: map['recure'],
      active: map['active'],
      product: Product.fromMap(map['product']),
      startDate: map['startDate'].toDate(),
      endDate: map['endDate'].toDate(),
      deliveries: List<Delivery>.from(
        map['deliveries'].map(
          (x) => Delivery.fromMap(x),
        ),
      ),
      dates: List<String>.from(map['dates'].map((e) => e as String)),
      dId: map['dId'],
      returnKitsQt: map['returnKitsQt'],
      type: map['type']??DeliveryType.getName(map['diff']),
      quantity: map['quantity'],
      key: map['key'],
    );
  }

  Delivery getDelivery(DateTime date) =>
      deliveries.where((element) => element.date == Formats.date(date)).first;
}
