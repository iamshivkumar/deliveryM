import 'package:delivery_m/models/address.dart';
import 'package:delivery_m/models/delivery.dart';

class Subscription {
  final String id;
  final String eId;
  final String customerId;
  final String status;
  final String productId;
  final String price;
  final DateTime startDate;
  final DateTime endDate;
  final List<Delivery> deliveries;


  Subscription({
    required this.id,
    required this.eId,
    required this.customerId,
    required this.status,
    required this.productId,
    required this.price,
    required this.startDate,
    required this.endDate,
    required this.deliveries,
  });
}
