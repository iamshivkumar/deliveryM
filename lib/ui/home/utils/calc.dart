import 'package:delivery_m/core/enums/delivery_status.dart';
import 'package:delivery_m/core/models/subscription.dart';
import 'package:delivery_m/utils/formats.dart';

class Calc {
  final List<Subscription> list;
  final DateTime date;

  Calc({required this.list, required this.date});

  int delivered(String pId) {
    final counts = list
        .where((element) => element.productId == pId)
        .map((e) => e.deliveries
            .where((element) => element.date == Formats.date(date))
            .first)
        .where((element) => element.status == DeliveryStatus.delivered)
        .map((e) => e.quantity);
    return counts.isEmpty
        ? 0
        : counts.reduce((value, element) => value + element);
  }

  int estimated(String pId) {
    final counts = list
        .where((element) => element.productId == pId)
        .map((e) => e.deliveries
            .where((element) => element.date == Formats.date(date))
            .first)
        .where((element) => element.status == DeliveryStatus.pending||element.status == DeliveryStatus.delivered)
        .map((e) => e.quantity);
    return counts.isEmpty
        ? 0
        : counts.reduce((value, element) => value + element);
  }


    int estimatedByD(String pId, String dId) {
    final counts = list
        .where((element) => element.productId == pId)
        .where((element) => element.dId == dId)
        .map((e) => e.deliveries
            .where((element) => element.date == Formats.date(date))
            .first)
        .where((element) => element.status == DeliveryStatus.pending||element.status == DeliveryStatus.delivered)
        .map((e) => e.quantity);
    return counts.isEmpty
        ? 0
        : counts.reduce((value, element) => value + element);
  }

    int pendingByD(String pId, String dId) {
    final counts = list
        .where((element) => element.productId == pId)
        .where((element) => element.dId == dId)
        .map((e) => e.deliveries
            .where((element) => element.date == Formats.date(date))
            .first)
        .where((element) => element.status == DeliveryStatus.pending)
        .map((e) => e.quantity);
    return counts.isEmpty
        ? 0
        : counts.reduce((value, element) => value + element);
  }

    int deliveredByD(String pId, String dId) {
    final counts = list
        .where((element) => element.productId == pId)
        .where((element) => element.dId == dId)
        .map((e) => e.deliveries
            .where((element) => element.date == Formats.date(date))
            .first)
        .where((element) => element.status == DeliveryStatus.delivered)
        .map((e) => e.quantity);
    return counts.isEmpty
        ? 0
        : counts.reduce((value, element) => value + element);
  }
}
