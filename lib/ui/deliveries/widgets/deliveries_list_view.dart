import 'package:delivery_m/core/enums/delivery_status.dart';
import 'package:delivery_m/core/models/subscription.dart';
import 'package:delivery_m/ui/deliveries/utils/generate.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'delivery_card.dart';

class DeliveriesListView extends ConsumerWidget {
  const DeliveriesListView(
      {Key? key, required this.date, required this.subscriptions})
      : super(key: key);
  final DateTime date;
  final List<Subscription> subscriptions;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TabBarView(
      children: [
        DeliveryStatus.pending,
        DeliveryStatus.delivered,
        DeliveryStatus.canceled
      ].map(
        (e) {
          final generate =
              Generate(date: date, subscriptions: subscriptions, status: e);
          return ListView(
            children: generate.stats
                .map(
                  (e) => DeliveryCard(deliveryStat: e),
                )
                .toList(),
          );
        },
      ).toList(),
    );
  }
}
