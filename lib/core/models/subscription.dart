import 'package:cloud_firestore/cloud_firestore.dart';

import 'delivery.dart';
import '../../utils/formats.dart';

class Subscription {
  final String id;
  final String eId;
  final String customerId;
  final bool recure;
  final bool active;

  final int quantity;
  final String productId;
  final String productName;
  final String productImage;
  final double price;
  final int? returnKitsQt;
  final DateTime startDate;
  final DateTime endDate;
  final List<Delivery> deliveries;
  final List<String> dates;
  final int diff;
  final String dId;

 

  Subscription({
    required this.productName,
    required this.id,
    required this.eId,
    required this.customerId,
    required this.recure,
    required this.active,
    required this.productId,
    required this.price,
    required this.startDate,
    required this.endDate,
    required this.deliveries,
    required this.dates,
    required this.dId,
    required this.diff,
    required this.productImage,
    required this.quantity,
    this.returnKitsQt,
  });

  Subscription copyWith({
    String? id,
    String? eId,
    String? customerId,
    bool? recure,
    bool? active,
    String? productId,
    String? image,
    double? price,
    DateTime? startDate,
    DateTime? endDate,
    List<Delivery>? deliveries,
    List<String>? dates,
    String? dId,
    int? returnKitsQt,
    int? diff,
    String? productName,
    String? productImage,
    int? quantity,
  }) {
    return Subscription(
      id: id ?? this.id,
      eId: eId ?? this.eId,
      customerId: customerId ?? this.customerId,
      recure: recure ?? this.recure,
      active: active ?? this.active,
      productId: productId ?? this.productId,
      price: price ?? this.price,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      deliveries: deliveries ?? this.deliveries,
      dates: dates ?? this.dates,
      dId: dId ?? this.dId,
      returnKitsQt: returnKitsQt,
      diff: diff ?? this.diff,
      productImage: productImage ?? this.productImage,
      productName: productName ?? this.productName,
      quantity: quantity ?? this.quantity,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'eId': eId,
      'customerId': customerId,
      'recure': recure,
      'active': active,
      'productId': productId,
      'price': price,
      'productImage': productImage,
      'productName': productName,
      'startDate': Timestamp.fromDate(startDate),
      'endDate': Timestamp.fromDate(endDate),
      'deliveries': deliveries.map((x) => x.toMap()).toList(),
      'dates': dates,
      'dId': dId,
      'returnKitsQt': returnKitsQt,
      'diff': diff,
      'quantity': quantity,
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
      productId: map['productId'],
      price: map['price'].toDouble(),
      productImage: map['productImage'],
      productName: map['productName'],
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
      diff: map['diff'],
      quantity: map['quantity'],
    );
  }

  Delivery getDelivery(DateTime date) =>
      deliveries.where((element) => element.date == Formats.date(date)).first;
}
