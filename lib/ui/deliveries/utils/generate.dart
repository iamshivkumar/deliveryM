import 'package:equatable/equatable.dart';
import '../../../core/models/subscription.dart';

class DeliveryStat extends Equatable {
  final String cId;
  final DateTime date;
  final List<Subscription> subscriptions;
  const DeliveryStat({
    required this.cId,
    required this.subscriptions,
    required this.date,
  });

  @override
  List<Object?> get props => [cId];

  // List<Subscription> get pendingSubscriptions => subscriptions
  //     .where((element) =>
  //         element.getDelivery(date).status == DeliveryStatus.pending)
  //     .toList();

  // List<Subscription> get deliveredSubscriptions => subscriptions
  //     .where((element) =>
  //         element.getDelivery(date).status == DeliveryStatus.delivered)
  //     .toList();

  //   List<Subscription> get canceledSubscriptions => subscriptions
  //     .where((element) =>
  //         element.getDelivery(date).status == DeliveryStatus.canceled)
  //     .toList();

  // List<Delivery> get deliveries => subscriptions.map((e) => e.getDelivery(date)).toList();

  // DeliveryStat copyWith({
  //   String? cId,
  //   List<Subscription>? subscriptions,
  // }) {
  //   return DeliveryStat(
  //     cId: cId ?? this.cId,
  //     subscriptions: subscriptions ?? this.subscriptions,
  //   );
  // }
}

class Generate {
  final DateTime date;
  final List<Subscription> subscriptions;
  final String status;

  Generate({
    required this.date,
    required this.subscriptions,
    required this.status,
  });

  List<DeliveryStat> get stats {
    List<DeliveryStat> list = [];

    for (var subscription in subscriptions
        .where((element) => element.getDelivery(date).status == status)) {
      final filtered =
          list.where((element) => element.cId == subscription.customerId);
      if (filtered.isNotEmpty) {
        list[list.indexOf(filtered.first)].subscriptions.add(subscription);
      } else {
        list.add(
          DeliveryStat(
            cId: subscription.customerId,
            subscriptions: [subscription],
            date: date,
          ),
        );
      }
    }
    list.sort(
      (a, b) => a.subscriptions.first.key.compareTo(b.subscriptions.first.key),
    );
    return list;
  }

  // List<DeliveryStat> get pendingStats => stats
  //     .where(
  //       (element) => element.subscriptions
  //           .map((e) => e.getDelivery(date))
  //           .where((element) => element.status == DeliveryStatus.pending)
  //           .isNotEmpty,
  //     )
  //     .toList();

  // List<DeliveryStat> get deliveredStats => stats
  //     .where(
  //       (element) => element.subscriptions
  //           .map((e) => e.getDelivery(date))
  //           .where((element) => element.status == DeliveryStatus.delivered)
  //           .isNotEmpty,
  //     )
  //     .toList();

  // List<DeliveryStat> get canceledStats => stats
  //     .where(
  //       (element) => element.subscriptions
  //           .map((e) => e.getDelivery(date))
  //           .where((element) => element.status == DeliveryStatus.canceled)
  //           .isNotEmpty,
  //     ).map((e) => e.)
  //     .toList();
}
